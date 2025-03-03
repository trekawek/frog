
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
          jmp wasp_end

move_wasp_l dec wsp_posx
          lda #<wasp_l
          sta wasp_obj+4
          lda #>wasp_l
          sta wasp_obj+5

wasp_end  equ *
          lda wsp_posx
          lsr
          lsr
          sta wasp_obj

          jmp avoid_tng
