
// $80 - object
// flag = flag | x
set_flag  ldy #$6
          lda ($80),y
          stx *+4
          ora #$ff
          sta ($80),y
          rts

// $80 - object
// flag = flag | x
flip_flag ldy #$6
          lda ($80),y
          stx *+4
          eor #$ff
          sta ($80),y
          rts

// $80 - object
// z = flag & x
get_flag  ldy #$6
          lda ($80),y
          stx *+4
          and #$ff
          rts

// draw object in the screen memory
//
// input:
//   x,y - object address
// temp:
//   $80, $81 - object address
//   $82, $83 - position on screen
//   $84, $85 - width, height
//   $86, $87 - tiles
//   $88, $89 - target
draw      stx $80
          sty $81

          ldx #2       // skip hidden objects
          jsr get_flag
          seq
          rts

          ldy #6 // copy object attributes to zero page
_draw_lp  lda ($80),y
          sta $82,y
          dey
          bpl _draw_lp

          lda scr_buf // copy screen buffer address to target
          sta $88
          lda scr_buf+1
          sta $89

          lda $82 // add X to target
          clc
          adc $88
          sta $88
          scc
          inc $89

_draw_mlt ldx $83 // add y*40 to target
          beq _draw_mlt_f
          lda #40
          clc
          adc $88
          sta $88
          scc
          inc $89
          dec $83
          jmp _draw_mlt
_draw_mlt_f equ *
          
          // copy tiles to target
          ldx #0 // counter of the pixel in a line
          ldy #0 // tile counter
_draw_cpy_l lda ($86),y // copy ($86),y -> ($88),x
          sta $90       // store A temporarily
          sty $91       // keep Y
          txa           // x->y
          tay
          lda $90       // restore A
          sta ($88),y
          ldy $91       // restore Y
          inx
          iny
          txa
          cmp $84
          bne _draw_cpy_l
          
          dec $85 // decrease height
          beq _draw_finished // height = 0 -> it's over
          ldx #0  // reset x counter
          lda #40 // add 40 to target
          clc
          adc $88
          sta $88
          scc
          inc $89
          jmp _draw_cpy_l

_draw_finished rts

// check if object with ($80) address collides with missile
//   $80, $81 - obj address
//   $82, $83 - position on screen
//   $84, $85 - width, height
//   $90 - missile height
is_obj_collision equ *
          ldx #2       // skip hidden objects
          jsr get_flag
          bne rts_false

          ldy #4 // copy object attributes to zero page
_obj_coll_lp lda ($80),y
          sta $82,y
          dey
          bpl _obj_coll_lp

          ldx frog_obj // check x position of the missile == frog+1
          inx
          txa
          cmp $82  // missle < obj -> return
          spl
          jmp rts_false

          sec
          sbc $84  // missle > obj + width <=> missile - width > obj -> return
          cmp $82
          smi
          jmp rts_false

          lda tngue_char_pos // check y position of the missile
          cmp $83  // missile < obj
          spl
          jmp rts_false

          sbc $85
          cmp $83
          smi
          jmp rts_false

rts_true  lda #0
          rts

rts_false lda #1
          rts
