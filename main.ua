# Experimental!
I ~ "git: https://github.com/marcos-cat/iris"
  Hx ← I~Color~Hex
R ~ "git: https://github.com/uiua-lang/rayua"

┌─╴C
  W ← ÷₂₅₅ [255 255 255]
  G ← ÷₂₅₅ [149 208 105]
  B ← ÷₂₅₅ [84 175 252]
  Y ← ÷₂₅₅ [238 194 110]
  P ← ÷₂₅₅ [203 106 231]
  O ← ÷₂₅₅ [220 120 82]
  C ← ÷₂₅₅ [32 249 252]
└─╴

GridSize  ← 8_12
Factor    ← 100
LH        ← 4/5
GlyphSize ← △layout!(°⊸LineHeight LH) Factor@◌
WorldSize ← ×GridSize GlyphSize

┌─╴Text
  Size ← 40
  Pos  ← 30_30

  α ← $ Welcome to Uiua Bejeweled
      $ Press space to start,
      $ reach 10000 points to win!

  λ₁ ← $$ You lost :( You got _/10000
       $$ points, but have no swaps
       $$ left! Press space to restart
       $$ or escape to exit.

  λ₂ ← $$ You lost :( You got _/10000
       $$ points! There are no valid
       $$ moves left. Press space to
       $$ restart or escape to exit.

  ω ← $$ You won! :) You got _ points!
      $$ You had _ moves left!
      $$ Press space to restart
      $$ or escape to exit.
└─╴

Cs ← C![W G B Y P O C]
Gs ← {" " "⍉⧻△" "÷⊡⊗" "◇⧅⊕" "⊃⊓" "ηπτ∞" "@$"}

~ {
  Glyphs
  𝒮 ← 0
  α ← ∞
  ω ← ∞
  N ← 30
}

Gen ← ⍜°˜+⤚(
  ⍜×⌊ ≡₀◇⧻⊏⊙Gs
)⍜-₁×⧻Cs gen

Split ← : ≡₀◇(⊏⁅×⊙⊸⧻) ⊙⊙(∩⌞⊏|Gs Cs) °+

κ ← ⊃(□◴/⊂▽|×3e2⧻⊚)×∊A₂⊸≡(⊃⊢/≍⧈-⍆)⧅₃>
σ ← ⊃∪(⍜⊡×₀/◇⊂)⋅/+⊜κ⊃⌊°⊡

Score ← ⍜𝒮 + ⍜Glyphs σ
Fall  ← ⍜Glyphs(⍜⊜□⍚⇌⊸⦷[¤W¤0])
Fill  ← ⍜Glyphs⍜⊢(+×Gen⊙⚂⊸⊃⧻=₀)

Valid ← (
  ⟜⇌2_1°⊡ Glyphs
  ⊂⊙⤸⊙0_2 ∩/⊂∩⌟⧈∘
  /∨⋅≠₀≡σ ≡⌟⍜⊡⇌
)

Slot ← ⨬⍜ω◌⍜α◌≍∞⊸α : ⌊÷GlyphSize ⊟°˜ℂ

Render ← ⍥₂/≡⊂ ≡≡layout!(°⊸LineHeight LH °⊸Color) ⊙Factor Split Glyphs

I~Open ⇌WorldSize "Bejeweled"
°I~Window~FPS 10

𝓣 ← I~Texture~LoadImage ↯⊂WorldSize 4 0

┌─╴Draw
  BB ← ⊟⊃(R~MeasureText|×+₁⧻⊚=@\n)

  Glyphs ← I~Draw~Background °⊸I~Texture~Image Render ⊙𝓣

  Selected ← ⊃(
    I~Draw~Rect ⊂⊙0.2 Blue ∩⇌⟜×GlyphSize α
  | I~Draw~Rect ⊂⊙0.2 Orange ∩⇌⟜×GlyphSize ω
  )

  Shade ← I~Draw~Rect Hx "#2F2F2F7F" +16_8 ⊃∪˜BB(-⋅8_4)

  TextBx ← ⊃I~Draw~Text⋅Shade ⊙Text!(Size Pos)

  Start ← TextBx Hx "#aed7a3" Text~α

  Stats ← TextBx Hx "#FFFFFF" $"Score: _\nSwaps: _" ⊃𝒮 N

  GameOver ← TextBx Hx "#FFFFFF" Text!⨬λ₁ λ₂ >₀ ⊃N 𝒮

  Win ← TextBx Green Text~ω ⊃𝒮 N
└─╴

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
  (⍢⋅^0(¬Valid) ^0)!(⍥(Fall ⊓Fill◌ ⍜Glyphs σ)∞ New Gen GridSize ⚂)
)

Restart! ← ⨬^0(State~Waiting⋅ρ) I~Key~Pressed @\s

Step ← ⨬(
  # START
  ⨬State~Begin State~Waiting ∊⊙@\s I~Key~Typed

  Draw~Start
| # WAIT
  I~Mouse!Pressed‼Left Slot
  ⨬State~Waiting State~Swapping ×∩(¬≍∞)⊸⊃α ω

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~Selected
  ⊙⊸Draw~Stats
| # SWAP
  ⨬(State~Waiting ◌
  | ⨬(State~Falling ⍜N-₁
    | State~Waiting ⋅∘
    )⤚≍⊸Score⊸⍜⊙Glyphs⍜⊡⇌
  )∊A₂⊃-⊟⊃(α|ω|⍜ω⋅∞⍜α⋅∞)

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~Stats
| # SCORE
  ⨬(State~Winning
  | ⨬(State~GameOver
    | ⨬(State~Falling
      | State~Waiting
      )⤚≍⊸Score
    )×⊸⊃(>₀N|Valid)
  )<1e4⊸𝒮

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~Stats
| # LOSE
  Restart!State~GameOver

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~GameOver
| # WIN
  Restart!State~Winning

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~Win
| # FALLING
  ⨬(State~Scoring ∘
  | State~Filling Fall
  )/∨♭=₀⊸Glyphs

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~Stats
| # FILLING
  State~Falling Fill

  ⊙⊸Draw~Glyphs
  ⊙⊸Draw~Stats
)

State~Begin ρ
◌◌I~Loop!(Step I~Draw~Background I~Color~Clear)
