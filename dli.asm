
dli       php
          pha
          txa
          pha
          lda vcount
          sta wsync

          cmp #$07
          bne dlicol2

          lda #>chrst // set charset
          sta chbase

          lda #<colors1
          ldx #>colors1
          jmp setcolors

dlicol2   cmp #$23
          bne dlicol3
          lda #<colors2
          ldx #>colors2
          jmp setcolors

dlicol3   cmp #$43
          bne dlicol4
          lda #<colors3
          ldx #>colors3
          jmp setcolors

dlicol4   cmp #$67
          bne enddli

          lda #$e0       // set default charset
          sta chbase

          lda #<colors4
          ldx #>colors4
          jmp setcolors

setcolors sta ldacolors+1
          stx ldacolors+2
          ldx #4

ldacolors lda $ffff,x
          sta colpf0,x
          dex
          bpl ldacolors

enddli    pla
          tax
          pla
          plp
          rti

colors1   dta b($00),b($0c),b($0a),b($26),b($0e)
colors2   dta b($1c),b($00),b($76),b($34),b($0e)
colors3   dta b($b4),b($c8),b($00),b($46),b($0e)
colors4   dta b($ff),b($ff),b($ff),b($ff),b($00)
