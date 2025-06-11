
// move wasp
move_wasp equ *

          lda #<wasp_obj
          sta $80
          lda #>wasp_obj
          sta $81

          jsr update_wasp_tiles
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

          bcs move_wasp_l
          inc wsp_posx

          lda #0
          sta wsp_dir
          jmp waps_avoid_tng

move_wasp_l dec wsp_posx
          lda #1
          sta wsp_dir

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
          adc #4
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

update_wasp_tiles equ *
          lda random
          ldx #%0100
          and #%1111
          cmp #%0001
          sne
          jsr flip_flag
          
          lda #<wasp_l
          sta $a0
          lda #>wasp_l
          sta $a1

          lda wsp_dir
          bne _update_wasp_anim
          lda #18
          clc
          adc $a0
          sta $a0
          scc
          inc $a1

_update_wasp_anim equ *
          jsr get_flag
          bne _write_wasp_tiles
          lda #9
          clc
          adc $a0
          sta $a0
          scc
          inc $a1

_write_wasp_tiles equ *
          lda $a0
          sta wasp_obj+4
          lda $a1
          sta wasp_obj+5
          rts
