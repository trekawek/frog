          opt h+s+

countr    equ $007e
dliv      equ $0200
sdlst     equ $0230
chbas     equ $02f4
colpf0s   equ $02c4
colpf1s   equ $02c5
colpf2s   equ $02c6
colpf3s   equ $02c7
colbaks   equ $02c8

colpf0    equ $d016
colpf1    equ $d017
colpf2    equ $d018
colpf3    equ $d019
colbak    equ $d01a

porta     equ $d300
wsync     equ $d40a
vcount    equ $d40b
nmien     equ $d40e

scrm      equ $4000
chrst     equ $5000

          org $3800
          jmp init

scr_buf   dta a($4000)
scr_buf_1 dta b($40)
scr_buf_2 dta b($44)

frg_del   dta b(1)
wsp_del   dta b(1)

// init

init      equ *
          lda #<dlist
          sta sdlst
          lda #>dlist
          sta sdlst+1
          lda #<dli
          sta dliv
          lda #>dli
          sta dliv+1
          lda #$c0   // enable dli
          sta nmien

          lda #>chrst
          sta chbas

          lda #$0e
          sta colbaks

// main loop

forever   equ *
          lda scr_buf_1 // switch screen buffer
          cmp scr_buf+1
          sne
          lda scr_buf_2
          sta scr_buf+1

          jsr move_frog
          jsr move_wasp
          jsr clean

          lda objects
          sta $92          // all objects
          lda #0
          sta $93          // current object
          lda #<(objects+1)
          sta $94
          lda #>(objects+1)
          sta $95
          
draw_obj_loop lda $93
          cmp $92
          beq wait_vblank
          rol
          tay
          lda ($94),y
          tax
          iny
          lda ($94),y
          tay
          jsr draw
          inc $93
          jmp draw_obj_loop

wait_vblank lda 20 // wait for vblank
          cmp 20
          beq *-2

          lda scr_buf+1 // update LMS in dlist
          sta dlist_lms+1

          jmp forever

// move frog

move_frog dec frg_del
          seq
          rts
          lda #2
          sta frg_del

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
          seq
          dec frog_obj
          rts

stick_r   lda frog_obj
          cmp #37
          seq
          inc frog_obj
          rts

move_wasp dec wsp_del
          seq
          rts
          lda #4
          sta wsp_del

          lda wasp_obj
          cmp frog_obj
          sne
          rts

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
          cmp #38
          sne
          dec wasp_obj
          rts

// clean screen

clean     lda scr_buf
          sta $80
          lda scr_buf+1
          sta $81
          ldx #0

_clean_l1 lda #0
          ldy #39
_clean_l2 sta ($80),y
          dey
          bpl _clean_l2

          clc
          lda $80
          adc #40
          sta $80
          scc
          inc $81
          inx
          txa
          cmp #24
          bne _clean_l1
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

dli       php
          pha
          txa
          pha
          lda vcount
          sta wsync

          cmp #$07
          bne dlicol2
          lda #<colors1
          ldx #>colors1
          jmp setcolors

dlicol2   cmp #$23 // one antic line = 4
          bne dlicol3
          lda #<colors2
          ldx #>colors2
          jmp setcolors

dlicol3   cmp #$5f // one antic line = 4
          bne enddli
          lda #<colors3
          ldx #>colors3
          jmp setcolors

setcolors sta ldacolors+1
          stx ldacolors+2
          ldx #4
ldacolors lda $ffff,x
          sta colpf0,x
          dex
          bpl ldacolors

enddli    pla
          tax
          pla
          plp
          rti

colors1   dta b($00),b($0c),b($0a),b($26),b($0e)
colors2   dta b($1c),b($00),b($76),b($34),b($0e)
colors3   dta b($b4),b($c8),b($00),b($46),b($0e)

dlist     dta b($f0)     // 3*8=24 empty lines
          dta b($70)
          dta b($70)     // 8 empty lines + DLI

          dta b($44)     // antic 4 + LMS
dlist_lms dta a(scrm)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($84)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($84)    // antic 4 + DLI
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($70)
          dta b($70)
          dta b($70)
          dta b($70)

          dta b($41),a(dlist) // JVB

objects   dta b(8)
          dta a(frog_obj)
          dta a(wasp_obj)
          dta a(fly_1_obj)
          dta a(fly_2_obj)
          dta a(fly_3_obj)
          dta a(fly_4_obj)
          dta a(fly_5_obj)
          dta a(fly_6_obj)

frog_obj  dta b(0),b(21)      // x, y position
          dta b(3),b(3)       // width, height
          dta a(frog)         // tiles

wasp_obj  dta b(0),b(10)      // x, y position
          dta b(3),b(3)       // width, height
          dta a(wasp_r)         // tiles

fly_1_obj dta b(0),b(0)
          dta b(3),b(1)
          dta a(fly_l_1)

fly_2_obj dta b(6),b(0)
          dta b(3),b(1)
          dta a(fly_l_1)

fly_3_obj dta b(12),b(0)
          dta b(3),b(1)
          dta a(fly_l_1)

fly_4_obj dta b(3),b(2)
          dta b(3),b(1)
          dta a(fly_l_1)

fly_5_obj dta b(9),b(2)
          dta b(3),b(1)
          dta a(fly_l_1)

fly_6_obj dta b(15),b(2)
          dta b(3),b(1)
          dta a(fly_l_1)

frog      dta b($01),b($02),b($03)
          dta b($04),b($05),b($06)
          dta b($07),b($08),b($09)

wasp_l    dta b($2c),b($2b),b($2a)
          dta b($2f),b($2e),b($2d)
          dta b($00),b($31),b($30)

wasp_r    dta b($0a),b($0b),b($0c)
          dta b($0d),b($0e),b($0f)
          dta b($10),b($11),b($00)

fly_l_1   dta b($14),b($95),b($16)
fly_l_2   dta b($17),b($95),b($18)
fly_r_1   dta b($14),b($99),b($16)
fly_r_2   dta b($17),b($99),b($18)

          org $2e0
          dta a(init)

          org chrst
          ins "tiles.fnt"
