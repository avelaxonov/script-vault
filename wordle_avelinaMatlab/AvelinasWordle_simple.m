clear
clc

% Avelina Axonov
% December 12, 2024 (updated)
% EGR 216 Final Project
% Wordle-ish Game with Multiplayer Mode — expanded word list

wordList = { ...
    % ── ORIGINAL LIST ────────────────────────────────────────────────────
    'APPLE', 'GRAPE', 'CHAIR', 'MANGO', 'FAITH', 'HORSE', ...
    'JUICE', 'LUCKY', 'NORTH', 'OCEAN', 'SHARE', 'VAPOR', ...
    'WHEEL', 'ZEBRA', 'CRANE', 'FLAME', 'GUESS', 'HAPPY', ...
    'KNIFE', 'MUSIC', 'QUIET', 'RHYME', 'STORM', 'UNITY', ...
    'WORMS', 'YEAST', 'ZONES', 'CANDY', 'BERRY', 'FRUIT', ...
    'STOCK', 'HOUSE', 'PLANE', 'GREEN', 'BLACK', 'WHITE', ...
    'CLOUD', 'FLOOR', 'LEVEL', 'BRAVE', 'GLASS', 'HONEY', ...
    'IMAGE', 'MERIT', 'NIGHT', 'OPERA', 'PEACH', 'QUILT', ...
    'RIVER', 'SHINE', 'TABLE', 'UNCLE', 'WATER', 'YOUTH', ...
    'ANGEL', 'BEACH', 'CRISP', 'DRIFT', 'EAGER', 'FLARE', ...
    'GRASP', 'HUMOR', 'INBOX', 'JUDGE', 'LEMON', 'MOODY', ...
    'NAIVE', 'OPTIC', 'PRISM', 'QUERY', 'SHARP', 'VITAL', ...
    'WHOLE', 'BRICK', 'CLAMP', 'DEBUT', 'FANCY', 'GIANT', ...
    'HABIT', 'INPUT', 'LARGE', 'NEVER', 'OUTER', 'PRIDE', ...
    'RAISE', 'THORN', 'VOWEL', 'BASIL', 'EMBER', 'NOBLE', ...
    'SPARK', 'BIRCH', 'FROST', 'CLOSE', 'EARTH', 'BLOOM', ...
    'GLORY', 'SHORE', 'PENNY', 'TREND', 'CORAL', 'DEPTH', ...
    'FINCH', 'GRAZE', 'HAVEN', 'JOUST', 'KNEEL', 'WALTZ', ...
    'LLAMA', 'MARCH', 'NOTCH', 'OXIDE', 'PLUMB', 'CRAVE', ...
    'RANCH', 'SCALP', 'TAXON', 'URBAN', 'VIOLA', 'IRONY', ...
    'XYLEM', 'YEARN', 'ZONAL', 'AMBER', 'BOUND', 'ULTRA', ...
    'DITCH', 'EPOCH', 'FERAL', 'GLOOM', 'HEIST', 'ZONED', ...
    'KNACK', 'LODGE', 'NICHE', 'OLIVE', 'QUAIL', 'ROACH', ...
    'PIXEL', 'QUOTA', 'ROVER', 'TAUNT', 'VALVE', 'ALLOY', ...
    'VALID', 'EXPEL', 'YIELD', 'ALIBI', 'LASER', 'PULSE', ...
    'BLUNT', 'CRYPT', 'ENVOY', 'FJORD', 'CEDAR', 'ALGAE', ...
    'HATCH', 'INFER', 'JOKER', 'LATCH', 'MOTIF', 'NAIAD', ...
    'NERVE', 'OCTET', 'PARCH', 'QUIRK', 'PLAID', 'OTTER', ...
    'TORSO', 'USURP', 'VERGE', 'WOKEN', 'EXERT', 'LARVA', ...
    'ABODE', 'BLISS', 'CACHE', 'DELTA', 'EVOKE', 'FLOSS', ...
    'HOIST', 'KNAVE', 'LYRIC', 'PLAIN', 'RIDGE', 'SHOAL', ...
    'NYMPH', 'ONSET', 'PLAZA', 'INLET', 'MARSH', 'OASIS', ...
    'SMELT', 'TROUT', 'VENOM', 'WEAVE', 'XEROX', 'TOWEL', ...
    'ELDER', 'FABLE', 'GROAN', 'DRONE', 'ETHER', 'HERON', ...
    'PIXIE', 'QUELL', 'RAVEN', 'SNARE', 'VIPER', 'COBRA', ...
    'ATOLL', 'CLEFT', 'DUNES', 'FLINT', 'GORGE', 'ABBOT', ...
    'BREAD', 'CHESS', 'CHILL', 'CREAM', 'EAGLE', 'EXACT', ...
    'FEAST', 'FRESH', 'KARMA', 'MAPLE', 'MATCH', 'MIGHT', ...
    'PROUD', 'REALM', 'SAUCE', 'SCOUT', 'SKILL', 'SWAMP', ...
    'SWORD', 'TEETH', 'TULIP', 'VAULT', 'WEARY', 'WITCH', ...
    'WRATH', 'PEARL', 'SQUID', 'SCUBA', 'TIDAL', 'SPAWN', ...
    'SLOTH', 'MOOSE', 'DAISY', 'DIODE', 'PROBE', 'RELAY', ...
    'YACHT', 'ABUSE', 'DECAY', 'DELAY', 'HAUNT', 'MAJOR', ...
     };

% Remove duplicates just in case
wordList = unique(wordList);

% Initialize leaderboard variables
leaderboard = [];
gameResults = [];

% Display Welcome Message
disp(' ')
disp('<strong>╔════════════════════════════════╗</strong>')
disp('<strong>            Welcome to Avelina''s Wordle Game!   </strong>')
disp('<strong>╚════════════════════════════════╝</strong>')
disp('<strong>Feedback Legend:</strong>')
disp('<strong>+</strong> : Correct letter, correct position.')
disp('<strong>*</strong> : Correct letter, wrong position.')
disp('<strong>-</strong> : Letter not in the word.')
disp(' ')

playAgain = true;

while playAgain
    disp('Select Game Mode:')
    disp('<strong>1</strong>: Single Player (Random word)')
    disp('<strong>2</strong>: Multiplayer (Player sets the word)')
    mode = input('Enter your choice (1 or 2): ');

    if mode == 1
        secretWord = wordList{randi(length(wordList))};
    elseif mode == 2
        secretWord = input('<strong>Player 1</strong>, enter a 5-letter secret word: ', 's');
        secretWord = upper(secretWord);
        while length(secretWord) ~= 5
            disp('<strong>Error: Word must be exactly 5 letters.</strong>')
            secretWord = input('<strong>Player 1</strong>, enter a valid 5-letter word: ', 's');
            secretWord = upper(secretWord);
        end
        clc
        disp('<strong>Player 2, it''s your turn to guess!</strong>');
    else
        disp('<strong>Invalid choice — starting Single Player mode.</strong>');
        secretWord = wordList{randi(length(wordList))};
    end

    maxAttempts = 6;
    attempts    = 0;
    correct     = false;
    hintUsed    = false;
    guessedLetters = '';

    while attempts < maxAttempts && ~correct
        attempts = attempts + 1;
        fprintf('\n<strong>Attempt %d of %d:</strong>\n', attempts, maxAttempts);

        if ~isempty(guessedLetters)
            fprintf('<strong>Letters guessed:</strong> %s\n', guessedLetters);
        end

        guess = input('Enter a 5-letter word (or type HINT or QUIT): ', 's');
        guess = upper(guess);

        switch guess
            case 'HINT'
                if hintUsed
                    disp('<strong>You already used your hint!</strong>');
                    attempts = attempts - 1;
                else
                    hintUsed = true;
                    hint = provideHint(secretWord, guessedLetters);
                    fprintf('<strong>Hint:</strong> The word contains the letter "%s".\n', hint);
                    attempts = attempts - 1;
                end
                continue
            case 'QUIT'
                disp('<strong>You quit the game.</strong>');
                displayLeaderboard(leaderboard, gameResults);
                return
        end

        if length(guess) ~= 5
            disp('<strong>Error: Word must be exactly 5 letters.</strong>');
            attempts = attempts - 1;
            continue;
        end

        guessedLetters = unique([guessedLetters, guess]);
        feedback = generateFeedback(guess, secretWord);
        fprintf('<strong>Feedback:</strong> %s\n', feedback);

        if strcmp(guess, secretWord)
            correct = true;
            disp('<strong>You guessed the word!</strong>');
        end
    end

    if ~correct
        fprintf('<strong>Game Over.</strong> The word was: %s\n', secretWord);
    end

    leaderboard = [leaderboard, attempts];
    if correct
        if hintUsed
            gameResults = [gameResults, 2];
        else
            gameResults = [gameResults, 1];
        end
    else
        gameResults = [gameResults, 3];
    end

    displayLeaderboard(leaderboard, gameResults);

    disp(' ');
    replay = input('Play again? (yes/no): ', 's');
    if strcmp(lower(replay), 'no')
        playAgain = false;
        disp('<strong>Thanks for playing!</strong>');
    end
end

%% ── FUNCTIONS ────────────────────────────────────────────────────────────

function feedback = generateFeedback(guess, secretWord)
    feedback   = repmat('-', 1, 5);
    usedSecret = false(1, 5);
    for i = 1:5
        if guess(i) == secretWord(i)
            feedback(i)   = '+';
            usedSecret(i) = true;
        end
    end
    for i = 1:5
        if feedback(i) == '+', continue; end
        idx = find(secretWord == guess(i) & ~usedSecret, 1);
        if ~isempty(idx)
            feedback(i)    = '*';
            usedSecret(idx) = true;
        end
    end
end

function hint = provideHint(secretWord, guessedLetters)
    remaining = setdiff(secretWord, guessedLetters);
    if isempty(remaining)
        hint = '?';
        disp('No hints left!');
    else
        hint = remaining(randi(length(remaining)));
    end
end

function displayLeaderboard(leaderboard, gameResults)
    figure(1);
    b = bar(leaderboard);
    b.FaceColor = 'flat';
    for i = 1:length(gameResults)
        switch gameResults(i)
            case 1, b.CData(i,:) = [0.20 0.70 0.30]; % green
            case 2, b.CData(i,:) = [0.95 0.80 0.10]; % yellow
            case 3, b.CData(i,:) = [0.80 0.20 0.20]; % red
        end
    end
    title('Game Leaderboard','FontSize',13);
    xlabel('Game Number');
    ylabel('Attempts Used');
    xticks(1:length(leaderboard));
    ylim([0 7]);
    disp(' ')
    disp('<strong>Leaderboard — Green: guessed clean · Yellow: used hint · Red: did not guess</strong>');
end
