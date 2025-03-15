
// move frog
move_frog equ *

          lda game_state
          and #$04
          sne
          rts

          lda tngue_act
          seq
          rts

          lda porta
          and #$0f
          eor #$ff
          tay
          and #$04
          bne stick_l

          tya
          and #$08
          bne stick_r
          rts

stick_l   lda frog_posx
          cmp #scr_minx*4
          beq update_frog_posx
          dec frog_posx
          dec frog_posx
          jmp update_frog_posx

stick_r   lda frog_posx
          cmp #scr_maxx*4-12
          beq update_frog_posx
          inc frog_posx
          inc frog_posx
          jmp update_frog_posx

update_frog_posx equ *
          lda frog_posx
          lsr
          lsr
          sta frog_obj
          rts
