# Experimental!
I ~ "git: https://github.com/marcos-cat/iris"
R ~ "git: https://github.com/uiua-lang/rayua"

~ {
  Glyphs
  Score ← 0
  α ← ∞
  ω ← ∞
  N ← 30
}

┌─╴C
  W ← ÷₂₅₅ [255 255 255]
  G ← ÷₂₅₅ [149 208 105]
  B ← ÷₂₅₅ [84 175 252]
  Y ← ÷₂₅₅ [238 194 110]
  P ← ÷₂₅₅ [203 106 231]
  O ← ÷₂₅₅ [220 120 82]
  C ← ÷₂₅₅ [32 249 252]
└─╴

Gs ← " ⊞∧⊃⊡↻▽⧻⍉⊓⊙π@"
Cs ← C![W Y Y P B B B G G P Y O C]

GridSize  ← 8_12
Factor    ← 100
LH        ← 4/5
GlyphSize ← △layout LineHeight: LH Factor@◌
WorldSize ← ×GridSize GlyphSize

┌─╴Text
  Size ← 40
  Char ← 23_40
  Pos  ← 30_30

  BB ↚ ⊟⊃(R~MeasureText|×+₁⧻⊚=@\n) ⊙Size

  DrawShade ↚ I~Draw~Rect I~Color~Hex "#2F2F2F7F" +12_6 BB ⊙(-6_3 Pos)

  D ↚ ⊃(
    I~Draw~Text⊙Size⊙Pos
  | ⋅DrawShade
  )

  α ← $ Welcome to Uiua Bejeweled
      $ Press space to start,
      $ reach 10000 points to win!

  DrawWelcome ← D Orange α

  λ₁ ← $$ You lost :( You got _/10000
       $$ points, but have no swaps
       $$ left! Press space to restart
       $$ or escape to exit.

  λ₂ ← $$ You lost :( You got _/10000
       $$ points! There are no valid
       $$ moves left. Press space to
       $$ restart or escape to exit.

  DrawGameOver ← D I~Color~Hex "#FFFFFF" ⨬λ₁ λ₂ >₀

  ω ← $$ You won! :) You got _ points!
      $$ You had _ moves left!
      $$ Press space to restart
      $$ or escape to exit.

  DrawWin ← D Green ω

  Stats ← (
    $"Score: _\nSwaps: _" ⊃Score N
    D I~Color~Hex "#FFFFFF"
  )
└─╴

Gen ← ⌊⍜-₁×⧻Gs gen GridSize

κ ← ×3e2⊓⧻□⊃⊚▽×∊A₂⊸≡(⊃⊢/≍⧈-⍆)⧅₃>
σ ← :⊓/◇+(⍜⊡≡⋅0◴/⊂/◇⊂)⊜κ⊸°˜⊡
S ← ⍜Score+ ⍜Glyphs σ

δ ↚ ⍥(⍜⊜□⍚⇌⊸⦷[¤W¤0])∞
G ← ⍜Glyphs δ

φ ↚ +×Gen⚂⊸=₀
F ← ⍜Glyphs φ

Fall ← ⍜Glyphs(⍜⊜□⍚⇌⊸⦷[¤W¤0])
Fill ← ⍜Glyphs⍜⊢(+×⌊⍜-₁×⧻Gs gen⊣GridSize⚂⊸=₀)

Valid ← (
  Glyphs
  ⟜⇌2_1°⊡
  ∩/⊂∩⌟⧈∘
  ⊂⊙⤸⊙0_2
  ≡⌟⍜⊡⇌
  /∨⋅≠₀≡σ
)

Slot ← ⨬⍜ω◌⍜α◌≍∞⊸α : ⌊÷GlyphSize ⊟°˜ℂ

I~Open ⇌WorldSize "Bejeweled"
°I~Screen~FPS 10

Render ← ⍥₂/≡⊂ ≡≡(layout Color: LineHeight: LH)⊙Factor ∩⌞⊏⊙Cs⊙Gs Glyphs

𝓣 ← I~Texture~LoadImage ↯⊂WorldSize 4 0

DrawGlyphs ← I~Texture~DrawScreen °⊸I~Texture~Image Render ⊙𝓣

DrawSelected ← ⊃(
  I~Draw~Rect ⊂⊙0.2 Blue ∩⇌⟜×GlyphSize α
| I~Draw~Rect ⊂⊙0.2 Orange ∩⇌⟜×GlyphSize ω
)

┌─╴State
  |Begin
  |Waiting
  |Swapping
  |Scoring
  |GameOver
  |Winning
  |Falling
  |Filling
└─╴

ρ ← (
  (⍢⋅^0(¬Valid) ^0)!(⍥(F ⊓G◌ ⍜Glyphs σ)∞ New Gen⚂)
)

Restart! ← ⨬^0(State~Waiting⋅ρ) I~Key~Pressed @\s

Step ← ⨬(
  # START
  ⨬State~Begin State~Waiting ∊⊙@\s I~Key~Typed

  Text~DrawWelcome
| # WAIT
  I~Mouse!Pressed‼Left Slot
  ⨬State~Waiting State~Swapping ×∩(¬≍∞)⊸⊃α ω

  ⊙⊸DrawGlyphs
  ⊙⊸DrawSelected
  ⊙⊸Text~Stats
| # SWAP
  ⨬(State~Waiting ◌
  | ⤚≍⊸S⊸(⍜⊙Glyphs⍜⊡⇌)
    ⨬(State~Falling ⍜N-₁
    | State~Waiting ⋅∘
    )
  )∊A₂⊃-⊟⊃(α|ω|⍜ω⋅∞⍜α⋅∞)

  ⊙⊸DrawGlyphs
  ⊙⊸Text~Stats
| # SCORE
  ⨬(State~Winning
  | ⨬(State~GameOver
    | ⨬(State~Falling
      | State~Waiting
      )⤚≍⊸S
    )×⊸⊃(>₀N|Valid)
  )<1e4⊸Score

  ⊙⊸DrawGlyphs
  ⊙⊸Text~Stats
| # LOSE
  Restart!State~GameOver

  ⊙⊸DrawGlyphs
  ⊙⊸⊃N Score
  ⊙Text~DrawGameOver
| # WIN
  Restart!State~Winning

  ⊙⊸DrawGlyphs
  ⊙⊸⊃Score N
  ⊙Text~DrawWin
| # FALLING
  ⨬(State~Scoring ∘
  | State~Filling Fall
  )/∨♭=₀⊸Glyphs

  ⊙⊸DrawGlyphs
  ⊙⊸Text~Stats
| # FILLING
  State~Falling Fill

  ⊙⊸DrawGlyphs
  ⊙⊸Text~Stats
)

State~Begin ρ
◌◌I~Loop!(Step I~Draw~Background I~Color~Clear)
