
dli       php
          pha
          txa
          pha
          lda vcount
          sta wsync

          cmp #$07
          bne dlicol2
          lda #<colors1
          ldx #>colors1
          jmp setcolors

dlicol2   cmp #$23 // one antic line = 4
          bne dlicol3
          lda #<colors2
          ldx #>colors2
          jmp setcolors

dlicol3   cmp #$5f // one antic line = 4
          bne enddli
          lda #<colors3
          ldx #>colors3
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
