
// move frog
move_frog dec frg_del
          seq
          rts
          lda #2
          sta frg_del

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

stick_l   lda frog_obj
          cmp #scr_minx
          seq
          dec frog_obj
          ldx #$10
          ldy #$5
          jsr play_sound
          jmp update_frog_posx

stick_r   lda frog_obj
          cmp #scr_maxx-3
          seq
          inc frog_obj
          ldx #$10
          ldy #$5
          jsr play_sound
          jmp update_frog_posx

update_frog_posx equ *
          lda frog_obj
          asl
          asl
          sta frog_posx
          rts
