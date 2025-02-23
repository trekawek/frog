          opt h+s+

countr    equ $007e
dliv      equ $0200
dmactls   equ $022f
sdlst     equ $0230
gtiactls  equ $026f
colpm0s   equ $02c0
colpm1s   equ $02c1
colpm2s   equ $02c2
colpm3s   equ $02c3
chbas     equ $02f4
colpf0s   equ $02c4
colpf1s   equ $02c5
colpf2s   equ $02c6
colpf3s   equ $02c7
colbaks   equ $02c8

m0pf      equ $d000
hposp0    equ $d000
hposp1    equ $d001
hposp2    equ $d002
hposp3    equ $d003
hposm0    equ $d004
hposm1    equ $d005
hposm2    equ $d006
hposm3    equ $d007
sizem     equ $d00c
trig0     equ $d010
colpf0    equ $d016
colpf1    equ $d017
colpf2    equ $d018
colpf3    equ $d019
colbak    equ $d01a
pmctl     equ $d01d
hitclr    equ $d01e

porta     equ $d300
pmbase    equ $d407
wsync     equ $d40a
vcount    equ $d40b
nmien     equ $d40e

program   equ $3800
dlist     equ $4000
scr_buf_1 equ $4200
scr_buf_2 equ $4600
pm_buf    equ $8000
chrst     equ $9000

objects_c equ 11
flies_c   equ 9

scr_minx  equ 0
scr_maxx  equ 40

flies1_posy equ 0
flies2_posy equ 2
flies3_posy equ 4
wasp_posy equ 8
frog_posy equ 21

missl_buf equ pm_buf+$300
player0_buf equ pm_buf+$400
player1_buf equ pm_buf+$500

          org program
          jmp init

scr_buf   dta a(scr_buf_1)
frg_del   dta b(1)
wsp_del   dta b(1)
fly_del   dta b(1)

tngue_act dta b(0)       // 0 - not active, 1 - going up, 2 - going down
tngue_pos dta b(0)
tngue_char_pos dta b(0)

// init
init      equ *
          lda #<dlist // set dlist address
          sta sdlst
          lda #>dlist
          sta sdlst+1
          lda #<dli   // set dli vector
          sta dliv
          lda #>dli
          sta dliv+1
          lda #$c0    // enable dli
          sta nmien

          lda #>chrst // set charset
          sta chbas

          lda #$0e    // set background
          sta colbaks

          lda #%00111110 // enable pmg
          sta dmactls
          lda #%00000011
          sta pmctl
          lda #>pm_buf
          sta pmbase

          lda #%00000100 // PF3, PF2, PF1, PF0, PM0, PM1, PM2, PM3, BAK

          lda #50
          sta hposm0
          sta hposp1
          lda #$34
          sta colpm0s
          lda #$34
          sta colpm1s

// main loop
forever   jsr swap_scr
          jsr detect_coll
          jsr init_tng
          jsr move_frog
          jsr move_wasp
          jsr move_flies
          jsr clean
          jsr draw_obj
          jsr draw_tng
          jsr wait_vblank

          jmp forever

// swap screen buffer
swap_scr  lda #>scr_buf_1 // switch screen buffer
          cmp scr_buf+1
          sne
          lda #>scr_buf_2
          sta scr_buf+1

// draw objects
draw_obj  lda #objects_c
          sta $92          // all objects
          lda #0
          sta $93          // current object
          lda #<(objects)
          sta $94
          lda #>(objects)
          sta $95
draw_obj_loop lda $93
          cmp $92
          sne
          rts
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

// wait for vblank
wait_vblank lda 20 // wait for vblank
          cmp 20
          beq *-2
          lda scr_buf+1 // update LMS in dlist
          sta dlist_lms+1
          rts

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
          rts

stick_r   lda frog_obj
          cmp #scr_maxx-3
          seq
          inc frog_obj
          rts

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
          rts

// move flies
move_flies dec fly_del
          seq
          rts
          lda #3
          sta fly_del

          lda #flies_c
          sta $92          // all flies
          lda #0
          sta $93          // current fly
          lda #<(flies)
          sta $94
          lda #>(flies)
          sta $95

flies_loop lda $93
          cmp $92
          sne
          rts
          rol
          tay
          lda ($94),y
          tax
          iny
          lda ($94),y
          tay
          jsr move_fly
          inc $93
          jmp flies_loop
          rts

// (x,y) - fly address
move_fly  stx $80
          sty $81
          ldx #1
          jsr get_flag
          beq move_fly_r

move_fly_l ldy #$0
          lda ($80),y
          tax
          dex
          txa
          sta ($80),y
          cmp #scr_minx
          beq flip_fly
          rts

move_fly_r ldy #$0
          lda ($80),y
          tax
          inx
          txa
          sta ($80),y
          cmp #scr_maxx-3
          beq flip_fly
          rts

flip_fly  ldx #1
          jsr flip_flag
          rts

// clean screen
clean     equ *
          lda scr_buf+1
          cmp #>scr_buf_1
          beq clean_1

clean_2   ldx #$00
          txa
clean_2_l equ *
          sta scr_buf_2,x
          sta scr_buf_2+$100,x
          sta scr_buf_2+$200,x
          sta scr_buf_2+$300,x
          inx
          bne clean_2_l
          rts

clean_1   ldx #$00
          txa
clean_1_l equ *
          sta scr_buf_1,x
          sta scr_buf_1+$100,x
          sta scr_buf_1+$200,x
          sta scr_buf_1+$300,x
          inx
          bne clean_1_l
          rts

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

init_tng  lda tngue_act
          seq
          rts

          lda trig0
          seq
          rts

          lda #1
          sta tngue_act
          ldx #$c8
          stx tngue_pos
          rts

// draw tongue
draw_tng  lda tngue_act
          cmp #1
          beq draw_tng_up
          cmp #2
          beq draw_tng_down
          rts

draw_tng_up equ *
          ldx tngue_pos
          txa
          and #%111     // mod 8
          tay
          lda tongue_shape,y
          sta player1_buf,x
          iny
          dex
          lda tongue_shape,y
          sta player1_buf,x
          iny
          dex
          lda tongue_shape,y
          sta player1_buf,x
          iny
          dex
          lda tongue_shape,y
          sta player1_buf,x

          ldx tngue_pos
          lda #0
          sta missl_buf,x
          dex
          dex
          dex
          dex
          stx tngue_pos
          txa
          cmp #16
          beq tng_act_down
          lda #%00111111
          sta missl_buf,x

          lda frog_obj
          rol
          rol
          clc
          adc #$32
          sta hposm0
          sec
          sbc #2
          sta hposp1
          rts

draw_tng_down equ *
          ldx tngue_pos
          lda #0
          sta player1_buf,x
          sta missl_buf,x
          inx
          sta player1_buf,x
          inx
          sta player1_buf,x
          inx
          sta player1_buf,x
          inx
          sta player1_buf,x
          stx tngue_pos
          txa
          cmp #$c8
          beq tng_act_stop
          lda #%00111111
          sta missl_buf,x
          rts

tng_act_stop lda #0
          sta tngue_act
          rts

tng_act_down  lda #2
          sta tngue_act
          rts

detect_coll equ *
          lda tngue_act  // skip if there's no tongue
          and #1
          sne
          rts
          lda tngue_pos
          cmp #$c8
          smi
          rts
          lda m0pf       // skip if no collision
          sne
          rts

          lda tngue_pos
          lsr
          lsr
          lsr
          lsr
          and #%00001111
          sec
          sbc #2
          asl
          sta tngue_char_pos // store missle y-position in chars

          lda #1
          sta hitclr     // clear hit

          lda #flies_c   // find collision
          sta $92        // all objects
          lda #0
          sta $93        // current object
          lda #<(flies)
          sta $90
          lda #>(flies)
          sta $91
detect_fly lda $93
          cmp $92
          sne
          jmp tng_act_down
          ldy #0
          lda ($90),y
          sta $80
          iny
          lda ($90),y
          sta $81
          jsr is_obj_collision
          beq found_fly

          lda $90
          clc
          adc #2
          sta $90
          scc
          inc $91
          inc $93
          jmp detect_fly

found_fly ldx #2
          jsr set_flag
          jmp tng_act_down

// check if object with ($80) address collides with missile
//   $80, $81 - obj address
//   $82, $83 - position on screen
//   $84, $85 - width, height
//   $90 - missile height
is_obj_collision equ *
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
          rts

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

objects   dta a(frog_obj)
          dta a(wasp_obj)
flies     dta a(fly_1_obj)
          dta a(fly_2_obj)
          dta a(fly_3_obj)
          dta a(fly_4_obj)
          dta a(fly_5_obj)
          dta a(fly_6_obj)
          dta a(fly_7_obj)
          dta a(fly_8_obj)
          dta a(fly_9_obj)

frog_obj  dta b(scr_minx),b(frog_posy) // x, y position
          dta b(3),b(3)       // width, height
          dta a(frog)         // tiles
          dta b(0)            // flags

wasp_obj  dta b(scr_minx),b(wasp_posy)      // x, y position
          dta b(3),b(3)       // width, height
          dta a(wasp_r)       // tiles
          dta b(0)            // flags

fly_1_obj dta b(scr_minx),b(flies1_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)            // bit 0 - direction, bit 1 - hidden

fly_2_obj dta b(scr_minx+5),b(flies1_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_3_obj dta b(scr_minx+10),b(flies1_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_4_obj dta b(scr_minx+2),b(flies2_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_5_obj dta b(scr_minx+7),b(flies2_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_6_obj dta b(scr_minx+12),b(flies2_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_7_obj dta b(scr_minx+5),b(flies3_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_8_obj dta b(scr_minx+10),b(flies3_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_9_obj dta b(scr_minx+15),b(flies3_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

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

tongue_shape equ *
          dta b(%00011000)
          dta b(%00010000)
          dta b(%0001100)
          dta b(%00001000)
          dta b(%00011000)
          dta b(%00010000)
          dta b(%00011000)
          dta b(%00001000)

// display list
          org dlist
          dta b($f0)     // 3*8=24 empty lines
          dta b($70)
          dta b($70)     // 8 empty lines + DLI

          dta b($44)     // antic 4 + LMS
dlist_lms dta a(scr_buf_1)
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

          org $2e0
          dta a(init)

          org chrst
          ins "tiles.fnt"
