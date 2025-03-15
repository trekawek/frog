// move flies
move_flies equ *

          lda game_state
          and #$02
          sne
          rts

          lda #3
          sta $92

          lda #<(flies_row_1)
          sta $93
          lda #>(flies_row_1)
          sta $94

          jsr find_flies_min_max

          ldx flies1_posx
          ldy flies1_dir
          jsr move_flies_posx
          sty flies1_dir
          stx flies1_posx
          sty $99

          lda flies1_posx
          sta $95
          jsr move_flies_row

          lda #<(flies_row_2)
          sta $93
          lda #>(flies_row_2)
          sta $94

          jsr find_flies_min_max

          ldx flies2_posx
          ldy flies2_dir
          jsr move_flies_posx
          sty flies2_dir
          stx flies2_posx
          sty $99

          lda flies2_posx
          sta $95
          jsr move_flies_row

          lda #<(flies_row_3)
          sta $93
          lda #>(flies_row_3)
          sta $94

          jsr find_flies_min_max

          ldx flies3_posx
          ldy flies3_dir
          jsr move_flies_posx
          sty flies3_dir
          stx flies3_posx
          sty $99

          lda flies3_posx
          sta $95
          jsr move_flies_row
          rts

// x - posx
// y - direction
// $97, $98 (tmp) - min max in char
move_flies_posx equ *
          lda #scr_minx*4
          cmp $97
          scc
          ldy #0

          lda $98
          cmp #scr_maxx*4-12
          scc
          ldy #1

          tya
          cmp #0
          sne
          inx
          cmp #1
          sne
          dex
          rts

// $92 - how many
// $93,$94 - start of array pointing flies
// $95 - pixel position of the row
// $96 (tmp) - current fly
// $99 - direction
move_flies_row equ *
          lda #0
          sta $96
flies_loop lda $96
          cmp $92
          sne
          rts
          asl
          tay
          lda ($93),y
          tax
          iny
          lda ($93),y
          tay
          stx $80
          sty $81
          jsr move_fly
          jsr update_fly_tiles
          inc $96
          jmp flies_loop
          rts

// ($80) - fly address
// $95 - pixel position
// $96 - current fly (c)
// $97 - fly pixel position (tmp)
move_fly  equ *
          ldx #%10
          jsr get_flag
          seq
          rts
          lda $95
          sta $97
          
          lda $96 // c*5*4 = c*20 = c*16+c*4
          asl
          asl
          asl
          asl
          clc
          adc $97
          sta $97

          lda $96
          asl
          asl
          clc
          adc $97
          ldy #7
          sta ($80),y
          lsr
          lsr
          ldy #0
          sta ($80),y

          rts

// ($80) - fly
// ($99) - direction
// ($a0,$a1) - tiles (tmp)
update_fly_tiles equ *
          lda random
          ldx #%0100
          and #%1111
          cmp #%0001
          sne
          jsr flip_flag

          lda #<fly_l_1
          sta $a0
          lda #>fly_l_1
          sta $a1

          lda $99
          bne _update_fly_anim
          lda #6
          clc
          adc $a0
          sta $a0
          scc
          inc $a1

_update_fly_anim equ *
          jsr get_flag
          bne _write_fly_tiles
          lda #3
          clc
          adc $a0
          sta $a0
          scc
          inc $a1

_write_fly_tiles equ *
          ldy #4
          lda $a0
          sta ($80),y
          iny
          lda $a1
          sta ($80),y
          rts

// $92 - how many
// $93,$94 - start of array pointing flies
// $96 (tmp) - current fly
// $97, $98 (tmp) - min max
find_flies_min_max equ *
          lda #0
          sta $96
          lda #$ff
          sta $97
          lda #0
          sta $98
find_flies_min_max_loop lda $96
          cmp $92
          sne
          rts
          asl
          tay
          lda ($93),y
          tax
          iny
          lda ($93),y
          tay
          jsr find_flies_min_max_iteration
          inc $96
          jmp find_flies_min_max_loop

find_flies_min_max_iteration equ *
          stx $80
          sty $81
          ldx #%10
          jsr get_flag
          seq
          rts

          ldy #7
          lda ($80),y
          sta $98
          
          lda $97
          cmp #$ff
          seq
          rts

          lda $98
          sta $97
          rts
