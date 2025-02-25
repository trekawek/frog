
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
          jsr avoid_tng
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
