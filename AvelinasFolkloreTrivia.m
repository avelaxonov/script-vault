clear
clc

% Avelina Axonov
% Russian & Slavic Folklore Trivia 

disp('═══════════════════════════════════════════')
disp('   Welcome to Avelina''s Russian Folklore Trivia!   ')
disp('═══════════════════════════════════════════')
disp('Answer each question with the letter of your choice.')
disp(' ')

score = 0;
total = 15;

% ── Q1: RUSALKA ─────────────────────────────────────────────────────────
disp('<strong>Question 1. Rusalka</strong>')
disp('In Russian folklore, what kind of person typically transforms')
disp('into a Rusalka — a spirit that haunts rivers, lakes, forests, and roads?')
disp('(A) A drowned maiden')
disp('(B) A child abandoned in the forest')
disp('(C) A witch who drowned during a ritual')
disp('(D) A woman betrayed by her lover')
ans1 = input('Answer: ','s');
disp(' ')
if upper(ans1) == 'A'
    score = score + 1; disp('<strong>Correct!</strong>')
else, disp('<strong>Wrong. The answer is A — a drowned maiden.</strong>')
end
disp(' ')

% ── Q2: KOSCHEI ─────────────────────────────────────────────────────────
disp('<strong>Question 2. Koschei the Deathless</strong>')
disp('Koschei hides his soul in a needle, inside an egg, inside a duck.')
disp('What creature contains the duck?')
disp('(A) A wolf')
disp('(B) A firebird')
disp('(C) A rabbit')
disp('(D) A bear')
ans2 = input('Answer: ','s');
disp(' ')
if upper(ans2) == 'C'
    score = score + 1; disp('<strong>Correct!</strong>')
else, disp('<strong>Wrong. The answer is C — a rabbit.</strong>')
end
disp(' ')

% ── Q3: ZMEY GORYNYCH ───────────────────────────────────────────────────
disp('<strong>Question 3. Zmey Gorynych</strong>')
disp('Besides having three heads, what distinguishes Zmey Gorynych')
disp('from other dragons in Russian folklore?')
disp('(A) He controls the weather')
disp('(B) He can speak human languages')
disp('(C) His heads regrow when cut off')
disp('(D) He breathes both fire and smoke')
ans3 = input('Answer: ','s');
disp(' ')
if upper(ans3) == 'B'
    score = score + 1; disp('<strong>Correct!</strong>')
else, disp('<strong>Wrong. The answer is B — he speaks human languages.</strong>')
end
disp(' ')

% ── Q4: FIREBIRD (moved up — before wish-granting question) ─────────────
disp('<strong>Question 4. The Firebird (Zhar-Ptitsa)</strong>')
disp('What makes a single feather from the Firebird so remarkable?')
disp('(A) It can set anything it touches ablaze')
disp('(B) It continues to glow with brilliant light even after being plucked')
disp('(C) Whoever holds it becomes invisible')
disp('(D) It can summon the Firebird from any distance')
ans4 = input('Answer: ','s');
disp(' ')
if upper(ans4) == 'B'
    score = score + 1; disp('<strong>Correct! A single feather keeps its light forever.</strong>')
else, disp('<strong>Wrong. The answer is B — the feather keeps glowing after being plucked.</strong>')
end
disp(' ')

% ── Q5: ILYA MUROMETS ───────────────────────────────────────────────────
disp('<strong>Question 5. Ilya Muromets</strong>')
disp('Which creature does the warrior Ilya Muromets famously defeat,')
disp('whose very whistle could knock men off their feet?')
disp('(A) Zmey Gorynych')
disp('(B) Koschei the Deathless')
disp('(C) Nightingale the Robber')
disp('(D) A giant stone idol')
ans5 = input('Answer: ','s');
disp(' ')
if upper(ans5) == 'C'
    score = score + 1; disp('<strong>Correct! Nightingale the Robber — Solovei Razboinik.</strong>')
else, disp('<strong>Wrong. The answer is C — Nightingale the Robber.</strong>')
end
disp(' ')

% ── Q6: WISH-GRANTING CREATURES ─────────────────────────────────────────
disp('<strong>Question 6. The Wish-Granting Fish</strong>')
disp('In Pushkin''s tale, a magical golden fish grants wishes to a fisherman.')
disp('In another tale, a lazy hero named Emelya catches a similar wish-granting')
disp('creature while fetching water. What does he catch?')
disp('(A) A crayfish')
disp('(B) A magic eel')
disp('(C) A pike')
disp('(D) A golden carp')
ans6 = input('Answer: ','s');
disp(' ')
if upper(ans6) == 'C'
    score = score + 1;
    disp('<strong>Correct! The pike — shchuka. "Po shchuch''yemu velen''yu..."</strong>')
else, disp('<strong>Wrong. The answer is C — the pike (shchuka).</strong>')
end
disp(' ')

% ── Q7: BABA YAGA'S HUT ─────────────────────────────────────────────────
disp('<strong>Question 7. Baba Yaga''s Hut</strong>')
disp('Baba Yaga''s hut always stands with its back to the visitor.')
disp('What must they say to make it turn and face them?')
disp('(A) "Let the traveler pass through!"')
disp('(B) "Stand with your back to the forest, your front to me!"')
disp('(C) "Open your doors to the one who seeks!"')
disp('(D) "Hut on chicken legs, hear me: turn and face the path!"')
ans7 = input('Answer: ','s');
disp(' ')
if upper(ans7) == 'B'
    score = score + 1;
    disp('<strong>Correct! "Stand with your back to the forest, your front to me!"</strong>')
else
    disp('<strong>Wrong. The answer is B.</strong>')
    disp('<strong>"Stand with your back to the forest, your front to me!"</strong>')
end
disp(' ')

% ── Q8: FROG PRINCESS ───────────────────────────────────────────────────
disp('<strong>Question 8. Tsarevna-the-Frog</strong>')
disp('What causes Tsarevna-the-Frog to remain cursed for longer than intended?')
disp('(A) Ivan Tsarevich burns her frog skin prematurely')
disp('(B) She fails to weave a golden tapestry overnight')
disp('(C) Ivan reveals her secret to the Tsar')
disp('(D) Koschei casts a new spell before the curse expires')
ans8 = input('Answer: ','s');
disp(' ')
if upper(ans8) == 'A'
    score = score + 1; disp('<strong>Correct!</strong>')
else, disp('<strong>Wrong. The answer is A — Ivan burns the frog skin too soon.</strong>')
end
disp(' ')

% ── Q9: DEAD AND LIVING WATER ───────────────────────────────────────────
disp('<strong>Question 9. Dead Water and Living Water</strong>')
disp('In Russian tales, both "dead water" and "living water" are used')
disp('to revive a fallen hero. What is the correct order of their use?')
disp('(A) Living water first to restore life, then dead water to seal wounds')
disp('(B) Dead water first to mend the body together, then living water to restore life')
disp('(C) The order does not matter and either can be used first')
disp('(D) That''s a trick question: you actually have to mix them in a correct ratio')
ans9 = input('Answer: ','s');
disp(' ')
if upper(ans9) == 'B'
    score = score + 1;
    disp('<strong>Correct! Dead water seals and mends, living water restores life.</strong>')
else, disp('<strong>Wrong. The answer is B — dead water first, then living water.</strong>')
end
disp(' ')

% ── Q10: YOUTH-RESTORING APPLES ─────────────────────────────────────────
disp('<strong>Question 10. The Youth-Restoring Apples</strong>')
disp('In tales of the Youth-Restoring Apples, what is always sought')
disp('alongside them to complete the cure?')
disp('(A) Tears of a firebird')
disp('(B) Water of Life (living water)')
disp('(C) Golden milk of a white mare')
disp('(D) A diamond from Koschei''s treasure vault')
ans10 = input('Answer: ','s');
disp(' ')
if upper(ans10) == 'B'
    score = score + 1; disp('<strong>Correct! The Water of Life — paired with the apples.</strong>')
else, disp('<strong>Wrong. The answer is B — the Water of Life.</strong>')
end
disp(' ')

% ── Q11: KONYOK-GORBUNOK ────────────────────────────────────────────────
disp('<strong>Question 11. The Little Humpbacked Horse (Konyok-Gorbunok)</strong>')
disp('The Little Humpbacked Horse is a loyal magical foal who serves the hero Ivan.')
disp('What makes him instantly recognizable in appearance?')
disp('(A) He has golden hooves and is called "humpbacked" because he is always made to carry stuff')
disp('(B) He is tiny, with enormous ears and a humped back')
disp('(C) He has wings that from a distance look like a hump on a back')
disp('(D) He can change his color to match his surroundings')
ans11 = input('Answer: ','s');
disp(' ')
if upper(ans11) == 'B'
    score = score + 1; disp('<strong>Correct! Tiny, enormous ears, and a humped back.</strong>')
else, disp('<strong>Wrong. The answer is B — tiny, huge ears, humped back.</strong>')
end
disp(' ')

% ── Q12: PRINCE GVIDON ──────────────────────────────────────────────────
disp('<strong>Question 12. Knyaz'' (Prince) Gvidon</strong>')
disp('Knyaz'' (Prince) Gvidon from "The Tale of Tsar Saltan" was raised in exile on a remote island.')
disp('To secretly visit his father''s kingdom, Tsarevna-the-Swan transforms him into small creatures.')
disp('Which of the following is NOT one of his transformations?')
disp('(A) A mosquito')
disp('(B) A fly')
disp('(C) A wasp')
disp('(D) A bumblebee')
ans12 = input('Answer: ','s');
disp(' ')
if upper(ans12) == 'C'
    score = score + 1;
    disp('<strong>Correct! Gvidon becomes a mosquito, a fly, and a bumblebee — never a wasp.</strong>')
else, disp('<strong>Wrong. The answer is C — a wasp. He transforms into mosquito, fly, and bumblebee.</strong>')
end
disp(' ')

% ── Q13: DOMOVOI ────────────────────────────────────────────────────────
disp('<strong>Question 13. The Domovoi</strong>')
disp('The Domovoi is a household spirit who watches over the family.')
disp('Where does he typically live?')
disp('(A) In the attic, near the roof')
disp('(B) Near the hearth or stove')
disp('(C) In the kitchen, near the food storage')
disp('(D) Behind the family''s most prized possession')
ans13 = input('Answer: ','s');
disp(' ')
if upper(ans13) == 'B'
    score = score + 1; disp('<strong>Correct! Near the hearth or stove — the warm heart of the house.</strong>')
else, disp('<strong>Wrong. The answer is B — near the hearth or stove.</strong>')
end
disp(' ')

% ── Q14: PRINCESS NESMEYANA ─────────────────────────────────────────────
disp('<strong>Question 14. Tsarevna Nesmeyana (Never-Laughing)</strong>')
disp('Tsarevna Nesmeyana sits in her palace, weeping endlessly.')
disp('The Tsar promises her hand in marriage to whoever can accomplish one thing.')
disp('What is it?')
disp('(A) Solve three impossible riddles before sunrise')
disp('(B) Make her laugh')
disp('(C) Bring her the Youth-Restoring Apples')
disp('(D) Defeat the champion of the royal guard')
ans14 = input('Answer: ','s');
disp(' ')
if upper(ans14) == 'B'
    score = score + 1; disp('<strong>Correct! Make her laugh — Nesmeyana means "the one who does not smile."</strong>')
else, disp('<strong>Wrong. The answer is B — make her laugh.</strong>')
end
disp(' ')

% ── Q15: THE SILVER SAUCER ──────────────────────────────────────────────
disp('<strong>Question 15. The Seeing Device</strong>')
disp('In Western folklore, seers use a crystal ball to see distant places.')
disp('Which of the following is the Russian folklore equivalent?')
disp('(A) A crystal ball that glows when asked a question')
disp('(B) A magic mirror that speaks when spoken to')
disp('(C) A crystal apple rolled around a silver saucer')
disp('(D) A basin of starlit water that shows distant scenes')
ans15 = input('Answer: ','s');
disp(' ')
if upper(ans15) == 'C'
    score = score + 1;
    disp('<strong>Correct! A crystal apple rolled around a silver saucer — a uniquely Russian device.</strong>')
else, disp('<strong>Wrong. The answer is C — crystal apple rolled around a silver saucer.</strong>')
end
disp(' ')

% ── RESULT ──────────────────────────────────────────────────────────────
disp('═══════════════════════════════════════════')
fprintf('<strong>Your final score: %d out of %d</strong>\n', score, total)
if score == total
    disp('Perfect score. You are a true keeper of the tales.')
elseif score >= 13
    disp('Excellent. The firebird would be proud.')
elseif score >= 10
    disp('Strong showing — a few more tales to read by the fire.')
elseif score >= 7
    disp('Not bad. The forest calls you back for more study.')
elseif score >= 4
    disp('Baba Yaga is raising an eyebrow. Keep reading.')
else
    disp('Ivan Tsarevich has had worse starts. He always figures it out eventually.')
end
disp('═══════════════════════════════════════════')
