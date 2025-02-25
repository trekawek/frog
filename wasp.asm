
// move wasp
move_wasp dec wsp_del
          seq
          rts
          lda #6
          sta wsp_del

          lda wasp_obj
          cmp frog_obj
          sne
          rts

          lda #<wasp_obj
          sta $80
          lda #>wasp_obj
          sta $81

          bcs move_wasp_l
          inc wasp_obj
          lda #<wasp_r
          sta wasp_obj+4
          lda #>wasp_r
          sta wasp_obj+5
          jmp wasp_end

move_wasp_l dec wasp_obj
          lda #<wasp_l
          sta wasp_obj+4
          lda #>wasp_l
          sta wasp_obj+5

wasp_end  lda wasp_obj
          cmp #scr_maxx-2
          sne
          dec wasp_obj
          jsr avoid_tng
