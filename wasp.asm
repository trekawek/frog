
// move wasp
move_wasp equ *
          dec wsp_del
          bne do_move_wasp
          lda #4
          sta wsp_del
          rts

do_move_wasp equ *
          lda wsp_posx
          cmp frog_posx
          sne
          rts

          lda #<wasp_obj
          sta $80
          lda #>wasp_obj
          sta $81

          bcs move_wasp_l
          inc wsp_posx
          
          lda #<wasp_r
          sta wasp_obj+4
          lda #>wasp_r
          sta wasp_obj+5
          jmp waps_avoid_tng

move_wasp_l dec wsp_posx
          lda #<wasp_l
          sta wasp_obj+4
          lda #>wasp_l
          sta wasp_obj+5

waps_avoid_tng equ *
          lda tngue_act
          beq wasp_end

          lda tngue_char_pos
          ldy #1
          sec
          sbc wasp_obj+1
          sbc wasp_obj+3
          bpl wasp_end

          lda frog_posx
          clc
          adc #5
          sec
          sbc wsp_posx
          cmp #$0b
          beq wasp_avoid_tng_left
          cmp #$ff // -1
          beq wasp_avoid_tng_right
          jmp wasp_end

wasp_avoid_tng_left equ *
          dec wsp_posx
          jmp wasp_end

wasp_avoid_tng_right equ *
          inc wsp_posx
          jmp wasp_end

wasp_end  equ *
          lda wsp_posx
          lsr
          lsr
          sta wasp_obj
          rts
