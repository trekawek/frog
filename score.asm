print_score     equ *
          lda score_dirty
          sne
          rts

          lda scr_buf // copy screen buffer address $88,$89
          clc
          adc #$98
          sta $88
          clc
          lda scr_buf+1
          adc #3
          sta $89

          ldy #0
          lda tongues_bcd
          jsr print_2digits

          tya
          clc
          adc #14
          tay

          lda score+1
          jsr print_2digits
          lda score
          jsr print_2digits

          rts

print_2digits equ * 
          pha
          lsr
          lsr
          lsr
          lsr
          clc
          adc #$10
          sta ($88),y
          iny

          pla
          and #%1111
          adc #$10
          sta ($88),y
          iny
          rts