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
          lda score+1
          jsr print_2digits
          lda score
          jsr print_2digits

          lda $88
          clc
          adc #10
          sta $88

          lda #<msg_press_fire
          sta $90
          lda #>msg_press_fire
          sta $91
          jsr print_message

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

print_message equ *
          ldy #0
print_msg_loop lda ($90),y
          cmp #$ff
          sne
          rts
          sta ($88),y
          iny
          jmp print_msg_loop

msg_press_fire dta d'PRESS FIRE',b($ff)

