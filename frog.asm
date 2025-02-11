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

stick_l   lda obj1
          seq
          dec obj1
          rts

stick_r   lda obj1
          cmp #38
          seq
          inc obj1
          rts

move_wasp dec wsp_del
          seq
          rts
          lda #4
          sta wsp_del

          lda obj2
          cmp obj1
          sne
          rts
          scc
          dec obj2
          scs
          inc obj2

          cmp #37
          sne
          dec obj2
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

          cmp #$0f
          bne dlicol2
          lda #<colors1
          ldx #>colors1
          jmp setcolors

dlicol2   cmp #$67
          bne enddli
          lda #<colors2
          ldx #>colors2
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

colors1   dta b($1c),b($00),b($76),b($34),b($0e)
colors2   dta b($1c),b($00),b($76),b($b4),b($0e)

dlist     dta b($70)     // 3*8=24 empty lines
          dta b($70)
          dta b($f0)     // 8 empty lines + DLI

          dta b($44)     // antic 4 + LMS
dlist_lms dta a(scrm)
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
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($04)
          dta b($84)     // antic 4 + DLI
          dta b($04)
          dta b($04)
          dta b($70)
          dta b($70)
          dta b($70)
          dta b($70)

          dta b($41),a(dlist) // JVB

objects   dta b(2)
          dta a(obj1)
          dta a(obj2)

obj1      dta b(0),b(22)      // x, y position
          dta b(2),b(2)       // width, height
          dta a(frog)         // tiles

obj2      dta b(0),b(10)       // x, y position
          dta b(3),b(3)       // width, height
          dta a(wasp)         // tiles

frog      dta b($81),b($82)
          dta b($83),b($84)
          dta b($80),b($80)

wasp      dta b($05),b($06),b($87)
          dta b($08),b($09),b($0a)
          dta b($0b),b($0c),b($0d)

          org chrst
          dta b(%00000000) // 00
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00110000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)

          dta b(%00000000) // 01
          dta b(%00000011)
          dta b(%00001100)
          dta b(%00001100)
          dta b(%00001100)
          dta b(%00000011)
          dta b(%00000011)
          dta b(%00000011)

          dta b(%00000000) // 02
          dta b(%11000000)
          dta b(%00110000)
          dta b(%00110000)
          dta b(%00110000)
          dta b(%11000000)
          dta b(%00000000)
          dta b(%00000000)

          dta b(%00001111) // 03
          dta b(%00110011)
          dta b(%00000011)
          dta b(%00000011)
          dta b(%00000011)
          dta b(%00001100)
          dta b(%00110000)
          dta b(%11000000)

          dta b(%11000000) // 04
          dta b(%00110000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%11000000)
          dta b(%00110000)
          dta b(%00001100)

          // wasp
          // 00 - white
          // 01 - yellow
          // 10 - black
          // 11 - blue
          // 11 - (inverted) red
          dta b(%10101010) // 05
          dta b(%10111011)
          dta b(%10111011)
          dta b(%10111011)
          dta b(%10101011)
          dta b(%10101011)
          dta b(%00101010)
          dta b(%00101010)
          
          dta b(%10000000) // 06
          dta b(%10000010)
          dta b(%10000010)
          dta b(%10000010)
          dta b(%10000010)
          dta b(%10000010)
          dta b(%10101010)
          dta b(%10100110)

          dta b(%10101000) // 07
          dta b(%01010110)
          dta b(%10011010)
          dta b(%01010110)
          dta b(%11110110)
          dta b(%11110110)
          dta b(%01011000)
          dta b(%01011000)

          dta b(%00001010) // 08
          dta b(%00001010)
          dta b(%00101010)
          dta b(%00100110)
          dta b(%00100110)
          dta b(%10010110)
          dta b(%10010110)
          dta b(%00100110)

          dta b(%01100110) // 09
          dta b(%01100110)
          dta b(%01100110)
          dta b(%01100110)
          dta b(%01100110)
          dta b(%01100110)
          dta b(%01101000)
          dta b(%01100000)

          dta b(%10100000) // 0a
          dta b(%10000000)
          dta b(%10000000)
          dta b(%10000000)
          dta b(%10000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)

          dta b(%00100110) // 0b
          dta b(%00101010)
          dta b(%00100000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)

          dta b(%10100000) // 0c
          dta b(%00100000)
          dta b(%00100000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)

          dta b(%00000000) // 0d
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)
          dta b(%00000000)

          org $2e0
          dta a(init)
