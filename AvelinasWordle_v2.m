function AvelinasWordleV2()
% AVELINA'S WORDLE v2 — GUI Edition
% ─────────────────────────────────────────────────────────────────────────
% Avelina Axonov | Wake Forest University | 2026
%
% Type letters on your keyboard (or click the on-screen keys).
% Enter to submit a guess. Backspace to delete a letter.
% Use the buttons at the bottom for Hint, New Game, Multiplayer, and Stats.
%
% Feedback colours:
%   GREEN  — correct letter, correct position
%   AMBER  — correct letter, wrong position
%   GRAY   — letter not in the word
% ─────────────────────────────────────────────────────────────────────────

    clc;

    % ── WORD LIST ─────────────────────────────────────────────────────────
    words = { ...
        ... % ── COMMON EVERYDAY ─────────────────────────────────────────
        'ABOUT','ABOVE','AFTER','AGAIN','ALLOW','ALONE','ALONG','ANGER', ...
        'APART','APPLY','ARGUE','AVOID','AWAKE','AWARE','AWFUL', ...
        'BADLY','BEGAN','BEGIN','BEING','BELOW','BENCH','BIRTH','BLADE', ...
        'BLAME','BLANK','BLAST','BLAZE','BLIND','BLOCK','BLOOD','BOARD', ...
        'BONUS','BOOST','BORED','BRACE','BRAND','BREAK','BREED','BRIEF', ...
        'BRING','BROAD','BROKE','BRUSH','BUILD', ...
        'CARRY','CATCH','CAUSE','CHARM','CHASE','CHEAP','CHEAT','CHECK', ...
        'CHEER','CHEST','CIVIC','CLAIM','CLASH','CLASS','CLEAN','CLEAR', ...
        'CLICK','CLIMB','COACH','COUNT','COULD','COVER','CRACK','CRAFT', ...
        'CRASH','CRIME','CROSS','CROWD','CROWN','CRUSH','CURVE', ...
        'DAILY','DANCE','DECAY','DELAY','DENSE','DIRTY','DODGE','DOUBT', ...
        'DRAFT','DRAIN','DRAMA','DROWN', ...
        'EARLY','EMAIL','ENEMY','ENJOY','ENTER','EQUAL','EXIST','EXTRA', ...
        'FAINT','FAIRY','FALSE','FATAL','FENCE','FEVER','FIBER','FIELD', ...
        'FIGHT','FINAL','FIRST','FIXED','FLASH','FLESH','FLOAT','FLOOD', ...
        'FOCUS','FORCE','FORGE','FOUND','FRAME','FRANK','FRONT','FUNNY', ...
        'GHOST','GIVEN','GLIDE','GRACE','GRADE','GRAIN','GRAND','GRANT', ...
        'GRATE','GRAVE','GREAT','GREED','GREET','GRILL','GROSS','GROUP', ...
        'GROWN','GUARD','GUIDE','GUILT', ...
        'HARSH','HASTY','HAUNT','HEAVY','HELLO','HERBS','HINGE','HUMAN','HURRY', ...
        'JELLY','JOLLY','JUICY','KNOCK','KNOWN', ...
        'LATER','LAUGH','LAYER','LEAPT','LEARN','LEAVE','LIGHT','LIMIT', ...
        'LIVER','LOCAL','LOGIC','LOOSE','LOUSY','LOVER','LOWER', ...
        'MAGIC','MAJOR','MAKER','MARRY','MAYOR','MEANS','MESSY','METAL', ...
        'MINOR','MIXED','MODEL','MONEY','MONTH','MORAL','MOUNT','MOUSE', ...
        'MOUTH','MOVED', ...
        'NAMED','NASTY','NEWLY','NOISY','NOVEL', ...
        'OCCUR','OFFER','OFTEN','ORDER','OTHER','OWNER', ...
        'PANIC','PAPER','PARTY','PASTE','PAUSE','PHASE','PHONE','PHOTO', ...
        'PIANO','PIECE','PILOT','PITCH','PLACE','PLANK','PLATE','PLEAD', ...
        'POINT','POUND','POWER','PRESS','PRICE','PRINT','PROOF','PROVE', ...
        'PUNCH','QUEEN','QUEST','QUAKE', ...
        'RAINY','RALLY','RANGE','RAPID','REACH','REACT','READY','REBEL', ...
        'REPLY','RIGHT','ROCKY','ROUGH','ROUND','ROYAL', ...
        'SADLY','SAINT','SALTY','SANDY','SCENE','SCORE','SEIZE','SERVE', ...
        'SEVEN','SHAME','SHAPE','SHELF','SHELL','SHIFT','SHIRT','SHOCK', ...
        'SHOOT','SHORT','SHOUT','SIGHT','SILLY','SINCE','SIXTH','SLEEP', ...
        'SLIDE','SLOPE','SMALL','SMART','SMELL','SMILE','SMOKE','SNAKE', ...
        'SOLID','SOLVE','SORRY','SOUTH','SPACE','SPEAK','SPELL','SPEND', ...
        'SPITE','SPLIT','SPORT','SPRAY','STAIR','STAKE','STAND','START', ...
        'STATE','STEAL','STEEL','STEEP','STICK','STILL','STOOD','STORE', ...
        'STORY','STRAP','STRIP','STUDY','STUFF','SUGAR','SUNNY','SUPER', ...
        'SWEAR','SWEET','SWIFT','SWING', ...
        'TASTE','TEACH','TENSE','TERMS','THINK','THREE','TIGER','TIGHT', ...
        'TIRED','TOAST','TOKEN','TOUCH','TOUGH','TRACE','TRACK','TRADE', ...
        'TRAIL','TRAIN','TRASH','TREAT','TRIAL','TRICK','TROOP','TRULY', ...
        'TRUST','TRUTH','TWIST','UNITE','UPSET','UTTER', ...
        'VISIT','VOICE','VOTER','WAGER','WAGON','WASTE','WATCH','WEIRD', ...
        'WHILE','WORTH', ...
        ... % ── CURATED ORIGINAL LIST ────────────────────────────────────
        'APPLE','GRAPE','CHAIR','MANGO','FAITH','HORSE','JUICE','LUCKY', ...
        'NORTH','OCEAN','SHARE','VAPOR','WHEEL','ZEBRA','CRANE','FLAME', ...
        'GUESS','HAPPY','KNIFE','MUSIC','QUIET','RHYME','STORM','UNITY', ...
        'WORMS','YEAST','CANDY','BERRY','FRUIT','STOCK','HOUSE','PLANE', ...
        'GREEN','BLACK','WHITE','CLOUD','FLOOR','LEVEL','BRAVE','GLASS', ...
        'HONEY','IMAGE','MERIT','NIGHT','OPERA','PEACH','QUILT','RIVER', ...
        'SHINE','UNCLE','WATER','YOUTH','ANGEL','BEACH','CRISP','DRIFT', ...
        'EAGER','FLARE','GRASP','HUMOR','JUDGE','LEMON','MOODY','NAIVE', ...
        'OPTIC','PRISM','QUERY','SHARP','VITAL','WHOLE','BRICK','CLAMP', ...
        'DEBUT','FANCY','GIANT','HABIT','INPUT','LARGE','NEVER','OUTER', ...
        'PRIDE','RAISE','THORN','VOWEL','BASIL','EMBER','NOBLE','SPARK', ...
        'BIRCH','FROST','CLOSE','EARTH','BLOOM','GLORY','SHORE','PENNY', ...
        'TREND','DEPTH','GRAZE','JOUST','MARCH','NOTCH','OXIDE', ...
        'RANCH','SCALP','TAXON','URBAN','VIOLA','WALTZ','XYLEM','YEARN', ...
        'ZONAL','AMBER','BOUND','CRAVE','DITCH','EPOCH','FERAL','GLOOM', ...
        'HEIST','IRONY','KNACK','LODGE','NICHE','OLIVE','PIXEL', ...
        'QUOTA','ROVER','TAUNT','ULTRA','VALID','EXPEL', ...
        'YIELD','ALIBI','BLUNT','CRYPT','ENVOY','FJORD', ...
        'HATCH','INFER','JOKER','LATCH','MOTIF','NERVE','OCTET', ...
        'PARCH','QUIRK','TORSO','USURP','VERGE','WOKEN','EXERT', ...
        'ABODE','BLISS','CACHE','DELTA','EVOKE','FLOSS','HOIST','KNAVE', ...
        'LYRIC','NYMPH','ONSET','PLAZA','SMELT','TROUT','VENOM','WEAVE', ...
        'YACHT','ABBOT','COBRA','TOWEL','ELDER','FABLE','GROAN', ...
        'PIXIE','QUELL','RAVEN','SNARE','VIPER','ZONED','ALGAE','CEDAR', ...
        'DRONE','ETHER','HERON','LARVA','NAIAD','OTTER','PLAID', ...
        'QUAIL','ROACH','ATOLL','CLEFT','DUNES','FLINT','GORGE', ...
        'INLET','MARSH','OASIS','PLAIN','RIDGE','SHOAL', ...
        ... % ── APPROVED NEW ADDITIONS ───────────────────────────────────
        'BREAD','CHESS','CHILL','CREAM','EAGLE','EXACT','FEAST','FRESH', ...
        'KARMA','MAPLE','MATCH','MIGHT','PROUD','REALM','SAUCE','SCOUT', ...
        'SKILL','SWAMP','SWORD','TEETH','TULIP','VAULT','WEARY','WITCH', ...
        'WRATH','PEARL','SQUID','SCUBA','TIDAL','SPAWN','SLOTH','MOOSE', ...
        'DAISY','DIODE','PROBE','RELAY','VALVE','ALLOY','LASER','PULSE', ...
        ... % ── GOOD EXTRAS ──────────────────────────────────────────────
        'BLOND','BLUSH','CHAMP','CHURN','CLOWN','DECAL','DIZZY','DWARF', ...
        'ELBOW','FELON','FLANK','FLASK','FREAK','FROTH','FROZE','GECKO', ...
        'GLARE','GRIPE','HAZEL','HIPPO','HITCH','HOWDY','JAUNT','KOALA', ...
        'LAPSE','LEECH','LLAMA','MEATY','MELEE','MOLAR','MOLDY','MOSSY', ...
        'MUDDY','MURKY','MUSTY','NIFTY','OAKEN','PARKA','PERKY','PLUCK', ...
        'PLUME','POLKA','PRUDE','PUDGY','PUFFY','PUPPY','PURSE','RADAR', ...
        'RETRO','RIDER','RINSE','ROWDY','RUGBY','RUSTY','SAVVY','SCARY', ...
        'SLANT','SNARL','SOGGY','SPECK','SPICY','SPINE','SPIRE','SPOOK', ...
        'STALK','STAMP','STOUT','STRAW','STRAY','STUCK','STUMP','STUNG', ...
        'SUAVE','SURLY','SWATH','SWEEP','SWEPT','TABBY','TARDY','TAWNY', ...
        'TEPID','TERSE','THEFT','THIGH','THUMB','TIPSY','TOPAZ','TOXIC', ...
        'TRAMP','TROVE','TRUNK','TUMMY','TUNIC','TUTOR','TWANG','TWEED', ...
        'TWERP','VAGUE','VIGOR','VIXEN','VOGUE','WISPY','WRACK','WREAK', ...
        'WRUNG','STOIC','STONY','MANLY','LUMPY','HANDY','JUMBO' ...
    };

    % Clean list: uppercase, exactly 5 letters, no duplicates
    words = upper(words);
    words = words(cellfun(@numel, words) == 5);
    words = unique(words);

    % ── LAYOUT CONSTANTS ──────────────────────────────────────────────────
    ROWS = 6;  COLS = 5;
    TS   = 62; TG = 5;           % tile size, tile gap
    KW   = 36; KH = 48; KG = 4;  % key width, height, gap

    % ── COLOUR PALETTE ────────────────────────────────────────────────────
    C.bg      = [0.10 0.10 0.12];
    C.empty   = [0.17 0.17 0.21];
    C.border  = [0.32 0.32 0.37];
    C.filled  = [0.22 0.22 0.28];   % letter typed, not yet submitted
    C.correct = [0.24 0.63 0.35];   % green  — right letter, right spot
    C.present = [0.73 0.57 0.12];   % amber  — right letter, wrong spot
    C.absent  = [0.17 0.17 0.19];   % gray   — not in word (dark, clearly used)
    C.key_def = [0.40 0.40 0.48];   % default key (noticeably lighter = unused)
    C.txt     = [0.95 0.95 0.95];
    C.teal    = [0.50 0.79 0.75];   % sea glass accent

    % ── FIGURE ────────────────────────────────────────────────────────────
    FW = COLS*TS + (COLS-1)*TG + 80;   % ~415
    FH = 820;

    fig = uifigure('Name', "Avelina's Wordle v2", ...
        'Position', [200 60 FW FH], ...
        'Color', C.bg, ...
        'Resize', 'off', ...
        'KeyPressFcn', @(~,e) on_key(e));

    % ── TITLE ─────────────────────────────────────────────────────────────
    uilabel(fig, ...
        'Text', "AVELINA'S WORDLE", ...
        'Position', [0 FH-50 FW 40], ...
        'FontColor', C.teal, 'FontSize', 22, 'FontWeight', 'bold', ...
        'HorizontalAlignment', 'center', ...
        'BackgroundColor', C.bg);

    uipanel(fig, 'Position', [20 FH-54 FW-40 1], ...
        'BackgroundColor', C.border, 'BorderType', 'none');

    % ── MESSAGE LABEL ─────────────────────────────────────────────────────
    h_msg = uilabel(fig, ...
        'Text', 'Type a word and press Enter.', ...
        'Position', [0 FH-76 FW 20], ...
        'FontColor', [0.62 0.62 0.68], 'FontSize', 12, ...
        'HorizontalAlignment', 'center', ...
        'BackgroundColor', C.bg);

    % ── TILE GRID ─────────────────────────────────────────────────────────
    gw   = COLS*TS + (COLS-1)*TG;
    gx   = floor((FW - gw)/2);
    gtop = FH - 86;

    h_tp = gobjects(ROWS, COLS);
    h_tl = gobjects(ROWS, COLS);

    for r = 1:ROWS
        for c = 1:COLS
            tx = gx + (c-1)*(TS+TG);
            ty = gtop - r*(TS+TG);
            p = uipanel(fig, ...
                'Position', [tx ty TS TS], ...
                'BackgroundColor', C.empty, ...
                'BorderType', 'line', ...
                'BorderColor', C.border, ...
                'BorderWidth', 2);
            l = uilabel(p, ...
                'Text', '', ...
                'Position', [0 0 TS TS], ...
                'FontColor', C.txt, ...
                'FontSize', 26, 'FontWeight', 'bold', ...
                'HorizontalAlignment', 'center', ...
                'VerticalAlignment', 'center', ...
                'BackgroundColor', C.empty);
            h_tp(r,c) = p;
            h_tl(r,c) = l;
        end
    end

    % ── VIRTUAL KEYBOARD ──────────────────────────────────────────────────
    kb = {{'Q','W','E','R','T','Y','U','I','O','P'}, ...
          {'A','S','D','F','G','H','J','K','L'}, ...
          {'ENTER','Z','X','C','V','B','N','M','⌫'}};

    kb_y0  = gtop - ROWS*(TS+TG) - KH - 10;
    h_keys = struct();

    for kr = 1:3
        row  = kb{kr};
        n    = numel(row);
        kws  = repmat(KW, 1, n);
        for ki = 1:n
            if ismember(row{ki}, {'ENTER','⌫'}), kws(ki) = round(KW*1.7); end
        end
        rw  = sum(kws) + (n-1)*KG;
        rx  = floor((FW - rw)/2);
        ry  = kb_y0 - (kr-1)*(KH+KG);
        cx  = rx;
        for ki = 1:n
            letter = row{ki};
            kw_i   = kws(ki);
            fs     = 10; if numel(letter)==1, fs=12; end
            btn = uibutton(fig, 'Text', letter, ...
                'Position', [cx ry kw_i KH], ...
                'BackgroundColor', C.key_def, ...
                'FontColor', C.txt, ...
                'FontSize', fs, 'FontWeight', 'bold', ...
                'ButtonPushedFcn', @(~,~) on_kb(letter));
            if numel(letter)==1 && letter >= 'A' && letter <= 'Z'
                h_keys.(letter) = btn;
            end
            cx = cx + kw_i + KG;
        end
    end

    % ── BOTTOM BUTTONS ────────────────────────────────────────────────────
    by = 8; bh = 30; bw = 76;
    bx = floor((FW - (5*bw + 4*5))/2);

    uibutton(fig,'Text','🔄 New', ...
        'Position',[bx by bw bh], ...
        'BackgroundColor',[0.14 0.34 0.52],'FontColor','w','FontWeight','bold', ...
        'ButtonPushedFcn',@(~,~) new_game());
    uibutton(fig,'Text','💡 Hint', ...
        'Position',[bx+81 by bw bh], ...
        'BackgroundColor',[0.40 0.28 0.06],'FontColor','w','FontWeight','bold', ...
        'ButtonPushedFcn',@(~,~) use_hint());
    uibutton(fig,'Text','👥 Multi', ...
        'Position',[bx+162 by bw bh], ...
        'BackgroundColor',[0.26 0.16 0.42],'FontColor','w','FontWeight','bold', ...
        'ButtonPushedFcn',@(~,~) set_multi());
    uibutton(fig,'Text','📊 Stats', ...
        'Position',[bx+243 by bw bh], ...
        'BackgroundColor',[0.14 0.30 0.16],'FontColor','w','FontWeight','bold', ...
        'ButtonPushedFcn',@(~,~) show_stats());
    uibutton(fig,'Text','✕ Close', ...
        'Position',[bx+324 by bw bh], ...
        'BackgroundColor',[0.38 0.12 0.12],'FontColor','w','FontWeight','bold', ...
        'ButtonPushedFcn',@(~,~) delete(fig));

    % ── INITIAL STATE ─────────────────────────────────────────────────────
    S0.secret    = pick_word();
    S0.cur_row   = 1;
    S0.cur_in    = '';
    S0.game_over = false;
    S0.hint_used = false;
    S0.guesses   = {};
    S0.stat_played = 0;
    S0.stat_won    = 0;
    S0.stat_dist   = zeros(1,7);   % indices 1-6 = win on attempt N; 7 = loss
    fig.UserData = S0;

    % ======================================================================
    %  EVENT HANDLERS
    % ======================================================================
    function on_key(evt)
        S = fig.UserData;
        if S.game_over, return; end
        k = upper(evt.Key);
        if numel(k)==1 && k>='A' && k<='Z'
            type_letter(k);
        elseif strcmp(evt.Key,'backspace')
            del_letter();
        elseif strcmp(evt.Key,'return')
            submit();
        end
    end

    function on_kb(letter)
        S = fig.UserData;
        if S.game_over, return; end
        switch letter
            case 'ENTER', submit();
            case '⌫',    del_letter();
            otherwise,   type_letter(letter);
        end
    end

    % ── TYPING ────────────────────────────────────────────────────────────
    function type_letter(letter)
        S = fig.UserData;
        if numel(S.cur_in) >= 5, return; end
        S.cur_in = [S.cur_in letter];
        c = numel(S.cur_in);
        h_tl(S.cur_row, c).Text = letter;
        set_tile(S.cur_row, c, C.filled);
        h_tp(S.cur_row, c).BorderColor = [0.55 0.55 0.60];
        fig.UserData = S;
        set_msg('', [0.62 0.62 0.68]);
    end

    function del_letter()
        S = fig.UserData;
        if isempty(S.cur_in), return; end
        c = numel(S.cur_in);
        h_tl(S.cur_row, c).Text = '';
        set_tile(S.cur_row, c, C.empty);
        h_tp(S.cur_row, c).BorderColor = C.border;
        S.cur_in = S.cur_in(1:end-1);
        fig.UserData = S;
    end

    % ── SUBMIT ────────────────────────────────────────────────────────────
    function submit()
        S = fig.UserData;
        if numel(S.cur_in) < 5
            set_msg('Not enough letters!', [0.82 0.30 0.30]);
            return;
        end
        guess = S.cur_in;
        fb    = get_feedback(guess, S.secret);

        % colour tiles
        for c = 1:5
            switch fb(c)
                case '+', clr = C.correct;
                case '*', clr = C.present;
                otherwise, clr = C.absent;
            end
            set_tile(S.cur_row, c, clr);
            h_tp(S.cur_row, c).BorderColor = clr;
        end

        % update keyboard colours (never downgrade green → amber/gray)
        for c = 1:5
            lt = guess(c);
            if ~isfield(h_keys, lt), continue; end
            btn = h_keys.(lt);
            cur = btn.BackgroundColor;
            switch fb(c)
                case '+'
                    btn.BackgroundColor = C.correct;
                case '*'
                    if ~isequal(cur, C.correct)
                        btn.BackgroundColor = C.present;
                    end
                otherwise
                    if isequal(cur, C.key_def)
                        btn.BackgroundColor = C.absent;
                    end
            end
        end

        S.guesses{end+1} = guess;
        S.cur_in = '';

        if strcmp(guess, S.secret)
            S.stat_played = S.stat_played + 1;
            S.stat_won    = S.stat_won + 1;
            S.stat_dist(S.cur_row) = S.stat_dist(S.cur_row) + 1;
            S.game_over = true;
            msgs = {'Genius!','Magnificent!','Splendid!','Impressive!','Great!','Phew!'};
            set_msg(msgs{S.cur_row}, C.correct);
        elseif S.cur_row >= ROWS
            S.stat_played = S.stat_played + 1;
            S.stat_dist(7) = S.stat_dist(7) + 1;
            S.game_over = true;
            set_msg(['The word was: ' S.secret], [0.82 0.30 0.30]);
        else
            S.cur_row = S.cur_row + 1;
        end
        fig.UserData = S;
    end

    % ── HINT ──────────────────────────────────────────────────────────────
    function use_hint()
        S = fig.UserData;
        if S.game_over, return; end
        if S.hint_used
            set_msg('Hint already used this round.', [0.75 0.57 0.14]);
            return;
        end
        guessed_letters = strjoin(S.guesses,'');
        remaining = setdiff(S.secret, guessed_letters);
        if isempty(remaining)
            set_msg('No new letters to hint.', [0.75 0.57 0.14]);
            return;
        end
        h = remaining(randi(numel(remaining)));
        S.hint_used = true;
        fig.UserData = S;
        set_msg(['Hint: the word contains "' h '"'], [0.80 0.62 0.18]);
    end

    % ── NEW GAME ──────────────────────────────────────────────────────────
    function new_game()
        S = fig.UserData;
        S.secret    = pick_word();
        S.cur_row   = 1;
        S.cur_in    = '';
        S.game_over = false;
        S.hint_used = false;
        S.guesses   = {};
        fig.UserData = S;
        clear_board();
        reset_keys();
        set_msg('New game!', [0.62 0.62 0.68]);
    end

    % ── MULTIPLAYER ───────────────────────────────────────────────────────
    function set_multi()
        dlg = inputdlg('Player 1 — enter a 5-letter word:', 'Multiplayer', 1, {''});
        if isempty(dlg) || isempty(strtrim(dlg{1})), return; end
        w = upper(strtrim(dlg{1}));
        if numel(w) ~= 5
            uialert(fig,'Must be exactly 5 letters.','Invalid'); return;
        end
        S = fig.UserData;
        S.secret    = w;
        S.cur_row   = 1;
        S.cur_in    = '';
        S.game_over = false;
        S.hint_used = false;
        S.guesses   = {};
        fig.UserData = S;
        clear_board();
        reset_keys();
        set_msg('Player 2 — go!', [0.62 0.62 0.68]);
    end

    % ── STATS ─────────────────────────────────────────────────────────────
    function show_stats()
        S = fig.UserData;
        if S.stat_played == 0
            uialert(fig,'No games played yet.','Stats','Icon','info'); return;
        end
        pct = round(100 * S.stat_won / S.stat_played);
        msg = sprintf('Played: %d   Won: %d (%d%%)\n\nAttempts to win:\n', ...
            S.stat_played, S.stat_won, pct);
        for i = 1:6
            bar_len = min(20, S.stat_dist(i));
            msg = [msg sprintf('  %d │%s %d\n', i, repmat('█',1,bar_len), S.stat_dist(i))]; %#ok
        end
        msg = [msg sprintf('  ✗ │%s %d\n', repmat('█',1,min(20,S.stat_dist(7))), S.stat_dist(7))];
        uialert(fig, msg, 'Stats', 'Icon', 'info');
    end

    % ======================================================================
    %  HELPERS
    % ======================================================================
    function clear_board()
        for r = 1:ROWS
            for c = 1:COLS
                h_tl(r,c).Text = '';
                set_tile(r, c, C.empty);
                h_tp(r,c).BorderColor = C.border;
            end
        end
    end

    function reset_keys()
        fn = fieldnames(h_keys);
        for i = 1:numel(fn)
            h_keys.(fn{i}).BackgroundColor = C.key_def;
        end
    end

    function set_tile(r, c, clr)
        h_tp(r,c).BackgroundColor = clr;
        h_tl(r,c).BackgroundColor = clr;
    end

    function set_msg(txt, clr)
        h_msg.Text      = txt;
        h_msg.FontColor = clr;
    end

    function w = pick_word()
        w = words{randi(numel(words))};
    end

    function fb = get_feedback(guess, secret)
        fb   = repmat('-', 1, 5);
        used = false(1, 5);
        for i = 1:5
            if guess(i) == secret(i)
                fb(i)   = '+';
                used(i) = true;
            end
        end
        for i = 1:5
            if fb(i) == '+', continue; end
            idx = find(secret == guess(i) & ~used, 1);
            if ~isempty(idx)
                fb(i)    = '*';
                used(idx) = true;
            end
        end
    end

end
