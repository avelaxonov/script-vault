function SpeciesCounter()
% SPECIES COUNT
% -------------------------------------------------------------------------
% Responsive photo-annotation app for species surveys (fish, coral,
% invertebrates, plants, terrestrial — anything you can count in a photo).
%
% BEFORE YOU START! 
%   Folder preparation:
%       The app loads ALL image files (.jpg .jpeg .png .tif .tiff) found
%       directly inside whichever folder you select. 
% 
%       For the cleanest workflow:
%     1. Create a dedicated folder for your survey photos.
%     2. Put only the images you want to annotate in it. No subfolders,
%        no mixed file types you don't intend to count.
%     3. Open that folder from within the app.
%
%   The app writes its output files (CSV, species list, settings) into the
%   same folder, so keeping photos isolated also keeps the data organized &
%   easy to find. Sessions are persistent: re-opening the same folder picks
%   up exactly where you left off.
%
% OUTPUT (written into the photo folder):
%   species_counts.csv       one row per reviewed photo (wide)
%   species_counts_long.csv  tidy format, one row per photo x species (for R)
%   sc_species.txt           species list (used to resume a session)
%   sc_settings.txt          which CSV columns to write (incl. custom columns)
%
% Avelina Axonov — Wake Forest University (Luthy Lab) — June 2026
% -------------------------------------------------------------------------

    clc;
    % ---- layout constants ----
    PANEL_W = 232;   % fixed width of the control panel (px)
    SP_RH   = 50;    % species row height (px)
    SP_W    = 204;   % usable width for a species row's contents (px)

    % ---- caches (shared by reference across nested functions) ----
    dt_cache = containers.Map('KeyType','char','ValueType','char');  % filepath -> datetime

    % ---- initial application state ----
    state0.folder   = '';
    state0.files    = {};
    state0.idx      = 0;
    state0.species  = {};
    state0.counts   = [];
    state0.present  = logical([]);
    state0.flags    = logical([]);
    state0.logged   = {};
    state0.settings = default_settings();
    state0.colors   = lines(30);
    state0.custom   = struct();   % this-photo values for custom columns
    state0.drafts   = struct();   % un-logged per-photo work, kept while browsing

    % ---- figure ----
    fig = uifigure('Name','Species Count', ...
        'Position',[60 60 1040 680], ...
        'Color',[0.11 0.11 0.13], ...
        'CloseRequestFcn',@(~,~)exit_app(), ...
        'KeyPressFcn',@(~,evt)handle_key(evt));

    % ---- top-level grid: [photo | control panel] ----
    main = uigridlayout(fig,[1 2]);
    main.ColumnWidth   = {'1x', PANEL_W};
    main.RowHeight     = {'1x'};
    main.Padding       = [6 6 6 6];
    main.ColumnSpacing = 6;
    main.BackgroundColor = [0.11 0.11 0.13];

    % ===================== PHOTO SIDE =====================
    pg = uigridlayout(main,[2 1]);
    pg.Layout.Row = 1; pg.Layout.Column = 1;
    pg.RowHeight = {24,'1x'};
    pg.ColumnWidth = {'1x'};
    pg.RowSpacing = 4; pg.Padding = [0 0 0 0];
    pg.BackgroundColor = [0.11 0.11 0.13];

    hint = uilabel(pg, ...
        'Text','🔍  Scroll to zoom    ·    drag to pan    ·    ← →  arrow keys to browse', ...
        'FontColor',[0.55 0.80 0.96],'FontSize',10,'FontWeight','bold', ...
        'BackgroundColor',[0.09 0.13 0.20],'HorizontalAlignment','center');
    hint.Layout.Row = 1; hint.Layout.Column = 1;

    ax = uiaxes(pg);
    ax.Layout.Row = 2; ax.Layout.Column = 1;
    ax.XTick = []; ax.YTick = [];
    ax.Color = [0.07 0.07 0.09];
    ax.XColor = 'none'; ax.YColor = 'none';
    title(ax,'Open a folder to begin','Color',[0.5 0.5 0.5],'FontSize',13);
    state0.ax = ax;

    % ===================== CONTROL SIDE =====================
    cg = uigridlayout(main,[10 1]);
    cg.Layout.Row = 1; cg.Layout.Column = 2;
    cg.RowHeight   = {28, 15, 26, 24, 14, '1x', 28, 46, 30, 30};
    cg.ColumnWidth = {'1x'};
    cg.RowSpacing  = 5; cg.Padding = [2 2 2 2];
    cg.BackgroundColor = [0.11 0.11 0.13];

    % row 1 — Open Folder + Help
    g = subgrid(cg,1,{'1x',32},4);
    mkbtn(g,1,'📁 Open Folder',@()open_folder(),[0.15 0.43 0.72],'w',true,'Open a folder of photos');
    mkbtn(g,2,'?',@()show_help(),[0.26 0.26 0.30],[0.8 0.8 0.8],true,'Help — quick guide');

    % row 2 — filename
    state0.lbl_file = uilabel(cg,'Text','No folder loaded', ...
        'FontColor',[0.46 0.46 0.46],'FontSize',8,'WordWrap','off');
    state0.lbl_file.Layout.Row = 2;

    % row 3 — navigation
    g = subgrid(cg,3,{52,'1x',52,24},3);
    mkbtn(g,1,'◀',@()nav(-1),[0.20 0.20 0.24],[0.65 0.65 0.65],false,'Previous photo (does not log) · ← key');
    state0.lbl_nav = uilabel(g,'Text','— / —','HorizontalAlignment','center', ...
        'FontColor',[0.88 0.88 0.88],'FontSize',12,'FontWeight','bold');
    state0.lbl_nav.Layout.Column = 2;
    mkbtn(g,3,'▶',@()nav(+1),[0.20 0.20 0.24],[0.65 0.65 0.65],false,'Next photo (does not log) · → key');
    mkbtn(g,4,'⚙',@()settings_dialog(),[0.22 0.22 0.26],[0.55 0.55 0.55],false,'CSV column settings');

    % row 4 — jump + flag navigation (flag arrows mirror the nav arrows: left & right)
    g = subgrid(cg,4,{34,'1x',30,34},3);
    mkbtn(g,1,'◀⚑',@()jump_flagged(-1),[0.28 0.22 0.08],[0.9 0.65 0.1],false,'Previous flagged photo');
    state0.jump_field = uieditfield(g,'numeric','Limits',[1 Inf],'Value',1, ...
        'BackgroundColor',[0.17 0.17 0.20],'FontColor',[0.88 0.88 0.88], ...
        'Tooltip','Type a photo number, then Go');
    state0.jump_field.Layout.Column = 2;
    mkbtn(g,3,'Go',@()jump_to(),[0.24 0.24 0.28],'w',false,'Jump to photo number');
    mkbtn(g,4,'⚑▶',@()jump_flagged(+1),[0.28 0.22 0.08],[0.9 0.65 0.1],false,'Next flagged photo');

    % row 5 — stats
    state0.lbl_status = uilabel(cg,'Text','Ready.', ...
        'FontColor',[0.40 0.40 0.40],'FontSize',8,'HorizontalAlignment','center');
    state0.lbl_status.Layout.Row = 5;

    % row 6 — species list (scrollable grid)
    state0.sp = uigridlayout(cg,[1 1]);
    state0.sp.Layout.Row = 6;
    state0.sp.ColumnWidth = {'1x'};
    state0.sp.RowHeight = {'1x'};
    state0.sp.Scrollable = 'on';
    state0.sp.Padding = [2 2 2 2];
    state0.sp.RowSpacing = 3;
    state0.sp.BackgroundColor = [0.14 0.14 0.17];

    % row 7 — add species
    b = uibutton(cg,'Text','＋  Add Species / Label', ...
        'ButtonPushedFcn',@(~,~)add_species(), ...
        'BackgroundColor',[0.46 0.24 0.66],'FontColor','w','FontWeight','bold');
    b.Layout.Row = 7;

    % row 8 — notes + custom fields
    g = subgrid(cg,8,{38,'1x',30},4);
    l = uilabel(g,'Text','Notes:','FontColor',[0.40 0.40 0.40],'VerticalAlignment','top');
    l.Layout.Column = 1;
    state0.note_field = uitextarea(g,'BackgroundColor',[0.17 0.17 0.20], ...
        'FontColor',[0.85 0.85 0.85],'FontSize',9);
    state0.note_field.Layout.Column = 2;
    mkbtn(g,3,'✎',@()edit_custom_fields(),[0.22 0.22 0.26],[0.7 0.7 0.7],false,'Enter custom-column values for this photo');

    % row 9 — log + skip (Log is wider via 2x:1x columns)
    g = subgrid(cg,9,{'2x','1x'},4);
    mkbtn(g,1,'✔ Log & Next',@()log_photo(false),[0.76 0.38 0.06],'w',true,'Save counts and advance');
    mkbtn(g,2,'⊘ Skip',@()log_photo(true),[0.22 0.22 0.26],[0.55 0.55 0.55],false,'Log zeros and advance');

    % row 10 — save & exit
    b = uibutton(cg,'Text','💾  Save & Exit', ...
        'ButtonPushedFcn',@(~,~)exit_app(), ...
        'BackgroundColor',[0.16 0.38 0.16],'FontColor','w','FontWeight','bold');
    b.Layout.Row = 10;

    fig.UserData = state0;
    draw_species();

    % ======================================================================
    %  CONSTRUCTION HELPERS
    % ======================================================================
    function g = subgrid(parent, row, colw, cspace)
        g = uigridlayout(parent,[1 numel(colw)]);
        g.Layout.Row = row; g.Layout.Column = 1;
        g.ColumnWidth = colw; g.RowHeight = {'1x'};
        g.Padding = [0 0 0 0]; g.ColumnSpacing = cspace;
        g.BackgroundColor = [0.11 0.11 0.13];
    end

    function mkbtn(parent, col, txt, cb, bg, fc, bold, tip)
        b = uibutton(parent,'Text',txt,'ButtonPushedFcn',@(~,~)cb(), ...
            'BackgroundColor',bg,'FontColor',fc,'Tooltip',tip);
        if bold, b.FontWeight = 'bold'; end
        b.Layout.Column = col;
    end

    % ======================================================================
    %  SETTINGS
    % ======================================================================
    function st = default_settings()
        st.datetime     = true;   % photo date/time from metadata
        st.any_present   = true;   % any organism present (0/1)
        st.total_count   = true;   % sum of all counts
        st.richness      = true;   % number of distinct species present
        st.per_sp_pa     = true;   % per-species presence (0/1)
        st.per_sp_count  = true;   % per-species count
        st.custom_cols   = {};     % user-defined per-photo columns
    end

    function settings_dialog()
        items = { ...
            'Photo date/time (from file metadata)   →  datetime', ...
            'Per-species presence/absence           →  <sp>_present', ...
            'Per-species count                       →  <sp>_count', ...
            'Summary: any organism present           →  any_present', ...
            'Summary: total count                    →  total_count', ...
            'Summary: number of species present      →  species_richness'};
        S = fig.UserData;
        cur = [S.settings.datetime, S.settings.per_sp_pa, S.settings.per_sp_count, ...
               S.settings.any_present, S.settings.total_count, S.settings.richness];
        iv = find(cur); if isempty(iv), iv = 1:6; end
        [sel, ok] = listdlg('ListString',items,'SelectionMode','multiple', ...
            'InitialValue',iv,'Name','CSV Columns', ...
            'PromptString','Select columns to record:', ...
            'ListSize',[460 150],'OKString','Apply','CancelString','Keep Current');
        if ~ok, return; end
        S.settings.datetime     = ismember(1,sel);
        S.settings.per_sp_pa    = ismember(2,sel);
        S.settings.per_sp_count = ismember(3,sel);
        S.settings.any_present  = ismember(4,sel);
        S.settings.total_count  = ismember(5,sel);
        S.settings.richness     = ismember(6,sel);
        fig.UserData = S;
        manage_custom_cols();
        S = fig.UserData;
        if ~isempty(S.folder) && ~isempty(S.species)
            write_csv(); write_settings(); set_status('Settings applied. CSV updated.');
        end
    end

    function manage_custom_cols()
        while true
            S = fig.UserData;
            cc = S.settings.custom_cols;
            if isempty(cc), lst = '(none yet)'; else, lst = strjoin(cc, ', '); end
            ch = questdlg(sprintf(['Custom per-photo columns:\n  %s\n\n' ...
                'These add extra columns you fill in for each photo\n' ...
                '(e.g. transect, depth, substrate). Enter values with\n' ...
                'the ✎ button next to Notes.'], lst), ...
                'Custom Columns','Add','Remove','Done','Done');
            switch ch
                case 'Add'
                    a = inputdlg('New column name:','Add Custom Column',1,{''});
                    if isempty(a) || isempty(strtrim(a{1})), continue; end
                    nm = strtrim(a{1});
                    if any(strcmpi(cc, nm))
                        % Blocking dialog: uialert is non-blocking on uifigures
                        % and would let the next questdlg stack on top of it.
                        uiwait(warndlg(['"' nm '" already exists.'],'Duplicate','modal'));
                        continue;
                    end
                    S.settings.custom_cols{end+1} = nm; fig.UserData = S;
                case 'Remove'
                    if isempty(cc), continue; end
                    [sel, ok] = listdlg('ListString',cc,'SelectionMode','multiple', ...
                        'Name','Remove Columns','PromptString','Columns to remove:', ...
                        'ListSize',[300 150]);
                    if ~ok || isempty(sel), continue; end
                    S.settings.custom_cols(sel) = []; fig.UserData = S;
                otherwise
                    return;
            end
        end
    end

    % ======================================================================
    %  HELP / KEYBOARD
    % ======================================================================
    function show_help()
        uialert(fig, sprintf([ ...
'SPECIES COUNT  —  Quick Reference\n\n' ...
'BROWSING\n' ...
'  ⁃ ◀ / ▶ : Browse photos — does NOT save\n' ...
'  ⁃ ← → arrow keys : Same as ◀ / ▶\n' ...
'  ⁃ number + Go : Jump to a photo by index\n' ...
'  ⁃ ◀⚑ / ⚑▶ : Jump to prev / next flagged photo\n' ...
'  ⁃ Green "n/N ✓" means that photo is logged.\n\n' ...
'COUNTING\n' ...
'  ⁃ Add Species / Label first.\n' ...
'  ⁃ Number keys 1-9 : +1 to that species (Shift = -1)\n' ...
'  ⁃ ● : toggle present / absent (does NOT change count)\n' ...
'  ⁃ + / − : adjust count  (+ also marks present)\n' ...
'  ⁃ ↺ : reset count to 0\n' ...
'  ⁃ ⚑ : flag an uncertain count (CSV flags column)\n' ...
'  ⁃ Click a species name to rename or remove it.\n\n' ...
'LOGGING\n' ...
'  ⁃ Log & Next (or Enter) : save counts and advance\n' ...
'  ⁃ Skip : log zeros and advance\n' ...
'  ⁃ ◀ ▶ : only browse — they NEVER save.\n' ...
'  ⁃ Re-open any logged photo to edit, then Log again.\n\n' ...
'SESSIONS\n' ...
'  ⁃ Save & Exit (or closing the window) saves.\n' ...
'  ⁃ Re-open the same folder to resume.\n' ...
'  ⁃ Only reviewed photos are written to the CSV.\n\n' ...
'ZOOM\n' ...
'  ⁃ Scroll the mouse wheel over the photo to zoom;\n' ...
'  ⁃ click and drag to pan.\n\n' ...
'CSV COLUMNS\n' ...
'  ⁃ Use ⚙ to choose columns and to manage custom\n' ...
'    per-photo fields (transect, depth, ...); fill them in\n' ...
'    with the ✎ button next to Notes.\n' ...
'  ⁃ Two files are written: species_counts.csv (one row\n' ...
'    per photo) and species_counts_long.csv (tidy, one\n' ...
'    row per photo x species -- ready for R).' ...
        ]), 'Species Count — Help','Icon','info');
    end

    function handle_key(evt)
        switch evt.Key
            case 'rightarrow', nav(+1);
            case 'leftarrow',  nav(-1);
            case 'return',     log_photo(false);   % Enter = Log & Next (fast logging)
            otherwise
                k = evt.Key;
                if numel(k) == 1 && k >= '1' && k <= '9'
                    S = fig.UserData;
                    i = double(k) - double('0');
                    if i <= numel(S.species)
                        if any(strcmp(evt.Modifier,'shift')), adj(i,-1); else, adj(i,+1); end
                    end
                end
        end
    end

    % ======================================================================
    %  FOLDER / SESSION
    % ======================================================================
    function open_folder()
        folder = uigetdir('','Select photo folder');
        if isequal(folder,0), return; end
        files = list_images(folder);
        if isempty(files)
            uialert(fig,'No images found in that folder.','Empty folder'); return;
        end

        csv_path = fullfile(folder,'species_counts.csv');
        sp_path  = fullfile(folder,'sc_species.txt');

        if isfile(csv_path) && isfile(sp_path)
            ch = uiconfirm(fig, ...
                sprintf('Found an existing session (%d photos). Resume?',numel(files)), ...
                'Resume','Options',{'Resume','Start Fresh','Cancel'}, ...
                'DefaultOption','Resume');
            if strcmp(ch,'Cancel'), return; end
            if strcmp(ch,'Resume')
                S = fig.UserData;
                S.folder = folder; S.files = files; S.idx = 0; S.logged = {}; S.drafts = struct();
                fig.UserData = S;
                resume_session(csv_path, sp_path);
                return;
            end
        end

        % fresh session
        settings_dialog();
        S = fig.UserData;
        S.folder = folder; S.files = files; S.idx = 0; S.logged = {}; S.drafts = struct();
        if ~isempty(S.species)
            ch2 = uiconfirm(fig,'Keep the current species list?','New Folder', ...
                'Options',{'Keep','Clear'},'DefaultOption','Keep');
            if strcmp(ch2,'Clear')
                S.species = {}; S.counts = []; S.present = logical([]); S.flags = logical([]);
            else
                S.counts  = zeros(1,numel(S.species));
                S.present = false(1,numel(S.species));
                S.flags   = false(1,numel(S.species));
            end
        end
        fig.UserData = S;
        draw_species(); do_nav(1);
    end

    function files = list_images(folder)
        exts = {'*.jpg','*.jpeg','*.png','*.tif','*.tiff', ...
                '*.JPG','*.JPEG','*.PNG','*.TIF','*.TIFF'};
        files = {};
        for e = exts
            d = dir(fullfile(folder,e{1}));
            for k = 1:numel(d), files{end+1} = d(k).name; end %#ok<AGROW>
        end
        files = sort(unique(files));
    end

    function resume_session(csv_path, sp_path)
        S = fig.UserData;

        % species list
        S.species = read_lines(sp_path);
        n = numel(S.species);

        % settings
        set_path = fullfile(S.folder,'sc_settings.txt');
        if isfile(set_path), S.settings = load_settings(set_path); end

        % logged data
        S.logged = {};
        try
            T = readtable(csv_path,'TextType','string');
            cols = T.Properties.VariableNames;
            for r = 1:height(T)
                fv = T.filename(r);
                if ismissing(fv), continue; end
                e.fname   = char(fv);
                e.present = false(1,n);
                e.counts  = zeros(1,n);
                e.flags   = false(1,n);
                e.note    = '';
                for si = 1:n
                    vn = matlab.lang.makeValidName(S.species{si});
                    pc = [vn '_present']; cc = [vn '_count'];
                    if ismember(pc,cols) && ~ismissing(T.(pc)(r)), e.present(si) = T.(pc)(r) > 0; end
                    if ismember(cc,cols) && ~ismissing(T.(cc)(r))
                        e.counts(si) = double(T.(cc)(r));
                    elseif ismember(vn,cols) && ~ismissing(T.(vn)(r))
                        e.counts(si)  = double(T.(vn)(r));
                        e.present(si) = e.counts(si) > 0;
                    end
                end
                if ismember('flags',cols) && ~ismissing(T.flags(r))
                    for p = strsplit(strtrim(char(T.flags(r))),',')
                        fi = find(strcmpi(S.species, strtrim(p{1})));
                        if ~isempty(fi), e.flags(fi) = true; end
                    end
                end
                if ismember('notes',cols) && ~ismissing(T.notes(r))
                    e.note = char(T.notes(r));
                end
                e.custom = struct();
                for ci = 1:numel(S.settings.custom_cols)
                    cfn = matlab.lang.makeValidName(S.settings.custom_cols{ci});
                    if ismember(cfn,cols) && ~ismissing(T.(cfn)(r))
                        e.custom.(cfn) = char(string(T.(cfn)(r)));
                    else
                        e.custom.(cfn) = '';
                    end
                end
                S.logged{end+1} = e; %#ok<AGROW>
            end
        catch err
            uialert(fig,['Could not load CSV: ' err.message],'Warning');
            S.logged = {};
        end

        S.counts = zeros(1,n); S.present = false(1,n); S.flags = false(1,n);
        fig.UserData = S;
        draw_species(); update_stats();

        % resume at first unreviewed photo
        lf = logged_fnames(S);
        target = numel(S.files);
        for fi = 1:numel(S.files)
            if ~any(strcmp(lf, S.files{fi})), target = fi; break; end
        end
        do_nav(target);
    end

    function lines = read_lines(path)
        lines = {};
        fid = fopen(path,'r'); if fid == -1, return; end
        ln = fgetl(fid);
        while ischar(ln)
            ln = strtrim(ln);
            if ~isempty(ln), lines{end+1} = ln; end %#ok<AGROW>
            ln = fgetl(fid);
        end
        fclose(fid);
    end

    function st = load_settings(path)
        st = default_settings();
        for ln = read_lines(path)
            parts = strsplit(ln{1},'=');
            if numel(parts) ~= 2, continue; end
            key = strtrim(parts{1}); rawval = strtrim(parts{2});
            if strcmp(key,'custom_cols')
                st.custom_cols = strsplit(rawval,'|');
                continue;
            end
            val = str2double(rawval) > 0;
            switch key
                case 'datetime',     st.datetime     = val;
                case 'per_sp_pa',    st.per_sp_pa    = val;
                case 'per_sp_count', st.per_sp_count = val;
                case 'any_present',  st.any_present  = val;
                case 'total_count',  st.total_count  = val;
                case 'richness',     st.richness     = val;
            end
        end
    end

    % ======================================================================
    %  NAVIGATION
    % ======================================================================
    function nav(d)
        S = fig.UserData;
        if isempty(S.files), return; end
        ni = S.idx + d;
        if ni < 1 || ni > numel(S.files), return; end
        do_nav(ni);
    end

    function do_nav(ni)
        S = fig.UserData;
        if isempty(S.files) || ni < 1 || ni > numel(S.files), return; end

        % Carry un-logged counts with you (no popup) — matches the web version.
        if S.idx > 0 && S.idx ~= ni
            S = stash_draft(S);
        end

        S.idx = ni;
        n = numel(S.species);
        prev = find(strcmp(logged_fnames(S), S.files{ni}));
        dk = draft_key(S.files{ni});
        if isfield(S.drafts, dk)
            d = S.drafts.(dk);
            S.counts  = pad_to(d.counts,  n, 0);
            S.present = pad_to(d.present, n, false);
            S.flags   = pad_to(d.flags,   n, false);
            note_txt  = d.note; S.custom = d.custom;
            is_logged = ~isempty(prev);
        elseif ~isempty(prev)
            e = S.logged{prev(end)};
            S.counts  = pad_to(e.counts,  n, 0);
            S.present = pad_to(e.present, n, false);
            S.flags   = pad_to(e.flags,   n, false);
            note_txt  = e.note; is_logged = true;
            if isfield(e,'custom'), S.custom = e.custom; else, S.custom = struct(); end
        else
            S.counts = zeros(1,n); S.present = false(1,n); S.flags = false(1,n);
            note_txt = ''; is_logged = false;
            S.custom = struct();
        end
        fig.UserData = S;
        S.note_field.Value = {note_txt};
        load_img(ni, is_logged);
        draw_species();
    end

    function k = draft_key(fname)
        k = matlab.lang.makeValidName(['f_' fname]);
    end

    function S = stash_draft(S)
        % Snapshot the photo being left, so browsing never loses un-logged work.
        if S.idx < 1 || S.idx > numel(S.files), return; end
        nt = '';
        if isfield(S,'note_field') && isvalid(S.note_field)
            v = S.note_field.Value;
            if iscell(v), nt = strjoin(v, newline); else, nt = char(v); end
        end
        d.counts = S.counts; d.present = S.present; d.flags = S.flags;
        d.note = nt; d.custom = S.custom;
        S.drafts.(draft_key(S.files{S.idx})) = d;
    end

    function jump_to()
        S = fig.UserData;
        if isempty(S.files), return; end
        do_nav(max(1, min(round(S.jump_field.Value), numel(S.files))));
    end

    function jump_flagged(direction)
        S = fig.UserData;
        if isempty(S.logged), set_status('No logged photos yet.'); return; end
        lf = logged_fnames(S); nf = numel(S.files);
        for k = 1:nf-1
            idx = mod(S.idx - 1 + direction*k, nf) + 1;
            prev = find(strcmp(lf, S.files{idx}));
            if ~isempty(prev) && any(S.logged{prev(end)}.flags)
                do_nav(idx); return;
            end
        end
        set_status('No flagged photos found.');
    end

    function load_img(ni, is_logged)
        S = fig.UserData;
        try
            img = imread(fullfile(S.folder, S.files{ni}));
            imshow(img,'Parent',S.ax);          % centered, aspect-correct
        catch
            cla(S.ax);
            title(S.ax,['Cannot load: ' S.files{ni}], ...
                'Color',[0.85 0.30 0.30],'FontSize',10,'Interpreter','none');
        end
        S.ax.XTick = []; S.ax.YTick = [];
        title(S.ax, S.files{ni},'Color',[0.76 0.76 0.76], ...
            'FontSize',8.5,'Interpreter','none');

        S.lbl_file.Text = S.files{ni};
        fig.UserData = S;
        update_nav();
        update_stats();
    end

    function update_nav()
        % Photo counter with a 3-state indicator that mirrors the web app:
        %   plain "n/N"        — nothing entered yet
        %   amber "n/N ● unlogged" — counts entered but NOT logged to the CSV
        %   green "n/N ✓ logged"  — committed to the CSV
        S = fig.UserData;
        if isempty(S.files) || S.idx == 0, return; end
        ni = S.idx; N = numel(S.files);
        prev = find(strcmp(logged_fnames(S), S.files{ni}));
        if photo_dirty(S, prev)
            S.lbl_nav.Text      = sprintf('%d/%d %s unlogged', ni, N, char(9679));
            S.lbl_nav.FontColor = [0.92 0.66 0.13];
            S.lbl_nav.FontSize  = 10;
        elseif ~isempty(prev)
            S.lbl_nav.Text      = sprintf('%d/%d %s logged', ni, N, char(10003));
            S.lbl_nav.FontColor = [0.36 0.80 0.36];
            S.lbl_nav.FontSize  = 10;
        else
            S.lbl_nav.Text      = sprintf('%d/%d', ni, N);
            S.lbl_nav.FontColor = [0.88 0.88 0.88];
            S.lbl_nav.FontSize  = 12;
        end
    end

    function d = photo_dirty(S, prev)
        n = numel(S.species);
        has = any(S.counts > 0) || any(S.present) || any(S.flags);
        if ~has
            fn = fieldnames(S.custom);
            for k = 1:numel(fn)
                if ~isempty(strtrim(S.custom.(fn{k}))), has = true; break; end
            end
        end
        if isempty(prev), d = has; return; end
        e = S.logged{prev(end)};
        d = ~isequal(pad_to(e.counts, n, 0), S.counts) || ...
            ~isequal(logical(pad_to(e.present, n, false)), logical(S.present)) || ...
            ~isequal(logical(pad_to(e.flags, n, false)), logical(S.flags));
        if ~d
            for k = 1:numel(S.settings.custom_cols)
                fnm = matlab.lang.makeValidName(S.settings.custom_cols{k});
                ev = ''; if isfield(e,'custom') && isfield(e.custom,fnm), ev = e.custom.(fnm); end
                cv = ''; if isfield(S.custom,fnm), cv = S.custom.(fnm); end
                if ~strcmp(strtrim(ev), strtrim(cv)), d = true; break; end
            end
        end
    end

    % ======================================================================
    %  SPECIES
    % ======================================================================
    function add_species()
        a = inputdlg('Species or label name:','Add',1,{''});
        if isempty(a) || isempty(strtrim(a{1})), return; end
        name = strtrim(a{1});
        S = fig.UserData;
        if any(strcmpi(S.species, name))
            uialert(fig,['"' name '" is already in the list.'],'Duplicate'); return;
        end
        S.species{end+1} = name;
        S.counts(end+1)  = 0;
        S.present(end+1) = false;
        S.flags(end+1)   = false;
        for k = 1:numel(S.logged)
            S.logged{k}.counts(end+1)  = 0;
            S.logged{k}.present(end+1) = false;
            S.logged{k}.flags(end+1)   = false;
        end
        S = resize_drafts(S, 0, 'add');
        fig.UserData = S;
        write_csv(); write_species_list();
        draw_species(); update_stats();
    end

    function rename_or_remove(i)
        S = fig.UserData;
        choice = questdlg(sprintf('"%s"', S.species{i}), ...
            'Species Options','Rename','Remove','Cancel','Rename');
        switch choice
            case 'Rename'
                a = inputdlg('New name:','Rename',1,{S.species{i}});
                if isempty(a) || isempty(strtrim(a{1})), return; end
                nm = strtrim(a{1});
                if any(strcmpi(S.species, nm)) && ~strcmpi(S.species{i}, nm)
                    uialert(fig,['"' nm '" already exists.'],'Duplicate'); return;
                end
                old = S.species{i}; S.species{i} = nm;
                fig.UserData = S;
                write_csv(); write_species_list(); draw_species();
                set_status(['"' old '" → "' nm '"']);
            case 'Remove'
                c2 = questdlg(sprintf(['Remove "%s"?\n\nThis permanently deletes it ' ...
                    'and its data from all logged photos. Cannot be undone.'], S.species{i}), ...
                    'Confirm Remove','Remove permanently','Cancel','Cancel');
                if ~strcmp(c2,'Remove permanently'), return; end
                S.species(i) = []; S.counts(i) = []; S.present(i) = []; S.flags(i) = [];
                for k = 1:numel(S.logged)
                    S.logged{k}.counts(i)  = [];
                    S.logged{k}.present(i) = [];
                    S.logged{k}.flags(i)   = [];
                end
                S = resize_drafts(S, i, 'remove');
                fig.UserData = S;
                draw_species(); write_csv(); write_species_list(); update_stats();
        end
    end

    function draw_species()
        S = fig.UserData;
        delete(S.sp.Children);
        n = numel(S.species);
        if n == 0
            S.sp.RowHeight = {'1x'};
            l = uilabel(S.sp,'Text','No species yet', ...
                'FontColor',[0.40 0.40 0.40],'FontSize',10,'HorizontalAlignment','center');
            l.Layout.Row = 1; l.Layout.Column = 1;
            return;
        end
        S.sp.RowHeight = repmat({SP_RH},1,n);
        for i = 1:n, make_species_row(i); end
        fig.UserData = S;
    end

    function make_species_row(i)
        S = fig.UserData;
        c = S.colors(mod(i-1,30)+1,:);
        rp = uipanel(S.sp,'BorderType','none', ...
            'BackgroundColor',[0.16 0.16 0.19],'AutoResizeChildren','off');
        rp.Layout.Row = i; rp.Layout.Column = 1;
        W = SP_W;

        % colour bar
        uipanel(rp,'Position',[0 2 4 44],'BackgroundColor',c,'BorderType','none');

        % --- top line: present, name, flag ---
        if S.present(i), pbg=[0.15 0.50 0.25]; pt='●'; else, pbg=[0.24 0.24 0.28]; pt='○'; end
        uibutton(rp,'Text',pt,'Position',[8 24 22 22], ...
            'BackgroundColor',pbg,'FontColor','w','FontSize',11, ...
            'Tooltip','Toggle present / absent (count unchanged)', ...
            'ButtonPushedFcn',@(~,~)toggle_present(i));
        uibutton(rp,'Text',S.species{i},'Position',[34 23 W-34-22 24], ...
            'BackgroundColor',[0.19 0.19 0.23],'FontColor','w','FontSize',12, ...
            'HorizontalAlignment','left', ...
            'Tooltip','Click to rename or remove', ...
            'ButtonPushedFcn',@(~,~)rename_or_remove(i));
        if S.flags(i), fbg=[0.68 0.42 0.00]; ft='⚑'; else, fbg=[0.24 0.24 0.24]; ft='⚐'; end
        uibutton(rp,'Text',ft,'Position',[W-20 24 20 22], ...
            'BackgroundColor',fbg,'FontColor','w','FontSize',11, ...
            'Tooltip','Flag uncertain count', ...
            'ButtonPushedFcn',@(~,~)toggle_flag(i));

        % --- bottom line: count, reset, minus, plus ---
        uilabel(rp,'Text',num2str(S.counts(i)),'Position',[8 2 40 20], ...
            'FontColor',[0.96 0.93 0.52],'FontSize',13,'FontWeight','bold', ...
            'HorizontalAlignment','left');
        uibutton(rp,'Text','↺','Position',[W-90 2 24 20], ...
            'BackgroundColor',[0.20 0.20 0.24],'FontColor',[0.55 0.55 0.55],'FontSize',11, ...
            'Tooltip','Reset count to 0','ButtonPushedFcn',@(~,~)reset_count(i));
        uibutton(rp,'Text','−','Position',[W-62 2 28 20], ...
            'BackgroundColor',[0.36 0.13 0.13],'FontColor','w','FontSize',13, ...
            'ButtonPushedFcn',@(~,~)adj(i,-1));
        uibutton(rp,'Text','+','Position',[W-32 2 28 20], ...
            'BackgroundColor',[0.13 0.32 0.13],'FontColor','w','FontSize',13, ...
            'ButtonPushedFcn',@(~,~)adj(i,+1));
    end

    function toggle_present(i)
        S = fig.UserData; S.present(i) = ~S.present(i);
        fig.UserData = S; draw_species(); update_nav();
    end
    function adj(i,d)
        S = fig.UserData; S.counts(i) = max(0, S.counts(i)+d);
        if d > 0, S.present(i) = true; end
        fig.UserData = S; draw_species(); update_nav();
    end
    function reset_count(i)
        S = fig.UserData; S.counts(i) = 0;
        fig.UserData = S; draw_species(); update_nav();
    end
    function toggle_flag(i)
        S = fig.UserData; S.flags(i) = ~S.flags(i);
        fig.UserData = S; draw_species(); update_stats(); update_nav();
    end

    function edit_custom_fields()
        S = fig.UserData;
        cc = S.settings.custom_cols;
        if isempty(cc)
            uialert(fig,['No custom columns defined yet. Add them via ' ...
                char(9881) ' Settings ' char(8594) ' Custom Columns.'], ...
                'Custom Fields','Icon','info');
            return;
        end
        defaults = cell(1,numel(cc));
        for k = 1:numel(cc)
            fn = matlab.lang.makeValidName(cc{k});
            if isfield(S.custom, fn), defaults{k} = S.custom.(fn); else, defaults{k} = ''; end
        end
        a = inputdlg(cc, 'Custom Fields (this photo)', 1, defaults);
        if isempty(a), return; end
        for k = 1:numel(cc)
            fn = matlab.lang.makeValidName(cc{k});
            S.custom.(fn) = strtrim(a{k});
        end
        fig.UserData = S;
        set_status('Custom fields saved for this photo.');
        update_nav();
    end

    % ======================================================================
    %  LOGGING
    % ======================================================================
    function log_current()
        S = fig.UserData;
        if S.idx == 0, return; end
        e.fname   = S.files{S.idx};
        e.note    = strtrim(strjoin(S.note_field.Value,' '));
        e.present = S.present; e.counts = S.counts; e.flags = S.flags;
        e.custom  = S.custom;
        store_entry(e);
    end

    function log_photo(skip)
        S = fig.UserData;
        if S.idx == 0, set_status('Open a folder first.'); return; end
        if skip
            n = numel(S.species);
            e.fname   = S.files{S.idx};
            e.note    = strtrim(strjoin(S.note_field.Value,' '));
            e.present = false(1,n); e.counts = zeros(1,n); e.flags = false(1,n);
            e.custom  = S.custom;
            store_entry(e);
        else
            log_current();
        end
        S = fig.UserData;
        if S.idx < numel(S.files)
            do_nav(S.idx+1);
        else
            uialert(fig,'All photos done! CSV saved.','Complete');
            load_img(S.idx, true);
        end
    end

    function S = resize_drafts(S, i, mode)
        % Keep held (un-logged) work aligned when the species list changes.
        fn = fieldnames(S.drafts);
        for k = 1:numel(fn)
            d = S.drafts.(fn{k});
            if strcmp(mode,'add')
                d.counts(end+1) = 0; d.present(end+1) = false; d.flags(end+1) = false;
            else
                if numel(d.counts)  >= i, d.counts(i)  = []; end
                if numel(d.present) >= i, d.present(i) = []; end
                if numel(d.flags)   >= i, d.flags(i)   = []; end
            end
            S.drafts.(fn{k}) = d;
        end
    end

    function store_entry(e)
        S = fig.UserData;
        prev = find(strcmp(logged_fnames(S), e.fname));
        if ~isempty(prev), S.logged{prev(end)} = e; else, S.logged{end+1} = e; end
        dk = draft_key(e.fname);
        if isfield(S.drafts, dk), S.drafts = rmfield(S.drafts, dk); end
        fig.UserData = S;
        write_csv(); update_stats(); update_nav();
        set_status(['Logged: ' e.fname]);
    end

    % ======================================================================
    %  FILE OUTPUT
    % ======================================================================
    function write_csv()
        S = fig.UserData;
        if isempty(S.folder) || isempty(S.files) || isempty(S.species) || isempty(S.logged)
            return;
        end
        st = S.settings; n = numel(S.species);
        lf = logged_fnames(S);
        rows = {};
        for fi = 1:numel(S.files)
            fn = S.files{fi};
            prev = find(strcmp(lf, fn));
            if isempty(prev), continue; end           % reviewed photos only
            e  = S.logged{prev(end)};
            pr = pad_to(e.present, n, false);
            co = pad_to(e.counts,  n, 0);
            fl = pad_to(e.flags,   n, false);
            row = {fn};
            if st.datetime,    row{end+1} = get_datetime(fullfile(S.folder,fn)); end %#ok<AGROW>
            if st.any_present, row{end+1} = double(any(pr)); end %#ok<AGROW>
            if st.total_count, row{end+1} = sum(co); end %#ok<AGROW>
            if st.richness,    row{end+1} = sum(pr>0); end %#ok<AGROW>
            for si = 1:n
                if st.per_sp_pa,    row{end+1} = double(pr(si)); end %#ok<AGROW>
                if st.per_sp_count, row{end+1} = co(si); end %#ok<AGROW>
            end
            for ci = 1:numel(st.custom_cols)
                cfn = matlab.lang.makeValidName(st.custom_cols{ci});
                if isfield(e,'custom') && isfield(e.custom,cfn), row{end+1} = e.custom.(cfn); else, row{end+1} = ''; end %#ok<AGROW>
            end
            row{end+1} = strjoin(S.species(logical(fl)),', '); %#ok<AGROW>
            row{end+1} = e.note; %#ok<AGROW>
            rows{end+1} = row; %#ok<AGROW>
        end
        if isempty(rows), return; end

        hdrs = {'filename'};
        if st.datetime,    hdrs{end+1} = 'datetime'; end
        if st.any_present, hdrs{end+1} = 'any_present'; end
        if st.total_count, hdrs{end+1} = 'total_count'; end
        if st.richness,    hdrs{end+1} = 'species_richness'; end
        for si = 1:n
            vn = matlab.lang.makeValidName(S.species{si});
            if st.per_sp_pa,    hdrs{end+1} = [vn '_present']; end
            if st.per_sp_count, hdrs{end+1} = [vn '_count']; end
        end
        for ci = 1:numel(st.custom_cols)
            hdrs{end+1} = matlab.lang.makeValidName(st.custom_cols{ci}); %#ok<AGROW>
        end
        hdrs{end+1} = 'flags'; hdrs{end+1} = 'notes';

        try
            T = cell2table(vertcat(rows{:}),'VariableNames',hdrs);
            writetable(T, fullfile(S.folder,'species_counts.csv'));
        catch err
            set_status(['CSV error: ' err.message]);
        end
        write_long_csv();
    end

    function write_long_csv()
        % Tidy format: one row per (photo x species) — ready for R (ggplot/dplyr).
        S = fig.UserData;
        if isempty(S.folder) || isempty(S.files) || isempty(S.species) || isempty(S.logged)
            return;
        end
        st = S.settings; n = numel(S.species);
        lf = logged_fnames(S);
        rows = {};
        for fi = 1:numel(S.files)
            fn = S.files{fi};
            prev = find(strcmp(lf, fn));
            if isempty(prev), continue; end
            e  = S.logged{prev(end)};
            pr = pad_to(e.present, n, false);
            co = pad_to(e.counts,  n, 0);
            fl = pad_to(e.flags,   n, false);
            if st.datetime, dt = get_datetime(fullfile(S.folder,fn)); else, dt = ''; end
            for si = 1:n
                row = {fn};
                if st.datetime, row{end+1} = dt; end %#ok<AGROW>
                row{end+1} = S.species{si}; %#ok<AGROW>
                row{end+1} = double(pr(si)); %#ok<AGROW>
                row{end+1} = co(si); %#ok<AGROW>
                row{end+1} = double(fl(si)); %#ok<AGROW>
                for ci = 1:numel(st.custom_cols)
                    cfn = matlab.lang.makeValidName(st.custom_cols{ci});
                    if isfield(e,'custom') && isfield(e.custom,cfn), row{end+1} = e.custom.(cfn); else, row{end+1} = ''; end %#ok<AGROW>
                end
                row{end+1} = e.note; %#ok<AGROW>
                rows{end+1} = row; %#ok<AGROW>
            end
        end
        if isempty(rows), return; end
        hdrs = {'filename'};
        if st.datetime, hdrs{end+1} = 'datetime'; end
        hdrs = [hdrs, {'species','present','count','flagged'}];
        for ci = 1:numel(st.custom_cols)
            hdrs{end+1} = matlab.lang.makeValidName(st.custom_cols{ci}); %#ok<AGROW>
        end
        hdrs{end+1} = 'notes';
        try
            T = cell2table(vertcat(rows{:}),'VariableNames',hdrs);
            writetable(T, fullfile(S.folder,'species_counts_long.csv'));
        catch err
            set_status(['Long CSV error: ' err.message]);
        end
    end

    function dt = get_datetime(fpath)
        % EXIF capture time if present, else file modification date.
        % Cached per file so each photo's metadata is read only once, and
        % EXIF parser warnings (e.g. ExposureIndex division-by-zero on some
        % action cameras) are suppressed so they never spam the console.
        if isKey(dt_cache, fpath)
            dt = dt_cache(fpath);
            return;
        end
        dt = '';
        oldw = warning('off','all');
        restore = onCleanup(@() warning(oldw)); %#ok<NASGU>  restored on exit
        try
            info = imfinfo(fpath); info = info(1);
            if isfield(info,'DateTime') && ~isempty(info.DateTime)
                dt = info.DateTime;
            elseif isfield(info,'DigitalCamera')
                dc = info.DigitalCamera;
                for f = {'DateTimeOriginal','DateTimeDigitized'}
                    if isfield(dc,f{1}) && ~isempty(dc.(f{1}))
                        dt = dc.(f{1}); break;
                    end
                end
            end
        catch
        end
        if isempty(dt)
            try
                d = dir(fpath);
                if ~isempty(d), dt = datestr(d(1).datenum,'yyyy-mm-dd HH:MM:SS'); end
            catch
            end
        end
        dt_cache(fpath) = dt;
    end

    function write_species_list()
        S = fig.UserData;
        if isempty(S.folder), return; end
        fid = fopen(fullfile(S.folder,'sc_species.txt'),'w');
        if fid == -1, return; end
        for k = 1:numel(S.species), fprintf(fid,'%s\n',S.species{k}); end
        fclose(fid);
    end

    function write_settings()
        S = fig.UserData;
        if isempty(S.folder), return; end
        fid = fopen(fullfile(S.folder,'sc_settings.txt'),'w');
        if fid == -1, return; end
        st = S.settings;
        fprintf(fid,['datetime=%d\nper_sp_pa=%d\nper_sp_count=%d\n' ...
                     'any_present=%d\ntotal_count=%d\nrichness=%d\n'], ...
            st.datetime, st.per_sp_pa, st.per_sp_count, ...
            st.any_present, st.total_count, st.richness);
        if ~isempty(st.custom_cols)
            fprintf(fid,'custom_cols=%s\n', strjoin(st.custom_cols, '|'));
        end
        fclose(fid);
    end

    % ======================================================================
    %  UTILITIES
    % ======================================================================
    function update_stats()
        S = fig.UserData;
        if isempty(S.files), S.lbl_status.Text = 'Ready.'; return; end
        nL = numel(S.logged); nT = numel(S.files);
        nF = sum(cellfun(@(e)any(e.flags), S.logged));
        S.lbl_status.Text = sprintf('logged %d/%d  ·  flagged %d  ·  remaining %d', ...
            nL, nT, nF, nT-nL);
    end

    function names = logged_fnames(S)
        if isempty(S.logged), names = {};
        else, names = cellfun(@(e)e.fname, S.logged,'UniformOutput',false); end
    end

    function v = pad_to(v, n, fill)
        if numel(v) < n, v(end+1:n) = fill; end
        if numel(v) > n, v = v(1:n); end
    end

    function exit_app()
        if isvalid(fig)
            S = fig.UserData;
            if ~isempty(S.folder) && ~isempty(S.species)
                write_csv(); write_species_list(); write_settings();
            end
        end
        delete(fig);
    end

    function set_status(msg)
        S = fig.UserData; S.lbl_status.Text = msg;
    end

end
