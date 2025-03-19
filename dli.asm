
dli       php
          pha
          txa
          pha
          lda vcount
          sta wsync

          cmp #$07
          bne dlicol1b
          lda #>chrst // set charset
          sta chbase
          lda flies1_hscrol
          sta hscrol
          lda #<colors1
          ldx #>colors1
          jmp setcolors

dlicol1b  cmp #$13
          bne dlicol1c
          lda flies2_hscrol
          sta hscrol
          jmp enddli

dlicol1c  cmp #$1b
          bne dlicol2
          lda flies3_hscrol
          sta hscrol
          jmp enddli

dlicol2   cmp #$2b
          bne dlicol3
          lda wsp_hscrol
          sta hscrol
          lda #<colors2
          ldx #>colors2
          jmp setcolors

dlicol3   cmp #$43
          bne dlicol4
          lda frog_hscrol
          sta hscrol
          lda #<colors3
          ldx #>colors3
          jmp setcolors

dlicol4   cmp #$63
          bne dlicol5
          lda #<colors5
          ldx #>colors5
          jmp setcolors

dlicol5   cmp #$67
          bne dlicol6
          lda #$e0       // set default charset
          sta chbase
          jmp enddli

dlicol6   cmp #$68
          bne enddli
          lda #1
          sta wsync
          lda #<colors4
          ldx #>colors4
          jmp setcolors

setcolors equ *
          sta ldacolors+1
          stx ldacolors+2
          ldx #4

ldacolors lda $ffff,x
          sta colpf0,x
          dex
          bpl ldacolors

enddli    equ *
          pla
          tax
          pla
          plp
          rti

colors1   dta b($00),b($0c),b($0a),b($26),b($0e) // flies
colors2   dta b($1c),b($00),b($76),b($34),b($0e) // wasp
colors3   dta b($b4),b($c8),b($00),b($46),b($0e) // frog
colors4   dta b($ff),b($ff),b($ff),b($ff),b($00) // score
colors5   dta b($34),b($34),b($34),b($34),b($0e) // tongue