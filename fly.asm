// move flies
move_flies equ *

          lda #3
          sta $92

          ldx flies1_posx
          ldy flies1_dir
          jsr move_flies_posx
          sty flies1_dir
          stx flies1_posx

          ldx flies2_posx
          ldy flies2_dir
          jsr move_flies_posx
          sty flies2_dir
          stx flies2_posx

          ldx flies3_posx
          ldy flies3_dir
          jsr move_flies_posx
          sty flies3_dir
          stx flies3_posx

          lda #<(flies_row_1)
          sta $93
          lda #>(flies_row_1)
          sta $94
          lda flies1_posx
          sta $95
          jsr move_flies_row

          lda #<(flies_row_2)
          sta $93
          lda #>(flies_row_2)
          sta $94
          lda flies2_posx
          sta $95
          jsr move_flies_row

          lda #<(flies_row_3)
          sta $93
          lda #>(flies_row_3)
          sta $94
          lda flies3_posx
          sta $95
          jsr move_flies_row
          rts

// x - posx
// y - direction
move_flies_posx equ *
          tya
          beq move_flies_right
          jmp move_flies_left

move_flies_right equ *
          inx
          txa
          cmp #(scr_maxx-2*5-2)*4-2
          seq
          rts
          dex
          ldy #1
          rts

move_flies_left equ *
          dex
          txa
          cmp #scr_minx*4
          seq
          rts
          inx
          ldy #0
          rts

// $92 - how many
// $93,$94 - start of array pointing flies
// $95 - pixel position of the row
// $96 (tmp) - current fly
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
          jsr move_fly
          inc $96
          jmp flies_loop
          rts

// (x,y) - fly address
// $95 - pixel position
// $96 - current fly (c)
// $97 - (tmp) char position
move_fly  stx $80
          sty $81
          ldy #0
          lda $95
          lsr
          lsr
          sta $97
          
          lda $96 // c*5 = c*4+c
          asl
          asl
          clc
          adc $96
          clc
          adc $97
          sta ($80),y

          rts