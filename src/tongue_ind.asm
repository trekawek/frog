draw_tongue_ind equ *
          lda scr_buf // copy screen buffer address $88,$89
          clc
          adc #$47
          sta $88
          clc
          lda scr_buf+1
          adc #3
          sta $89

          ldy tongues
draw_tongue_loop equ *
          sne
          rts
          lda #$20
          sta ($88),y
          dey
          jmp draw_tongue_loop

