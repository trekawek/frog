
init_tng  lda game_state
          and #$04
          sne
          rts

          lda tngue_act
          seq
          rts

          lda trig0
          seq
          rts

          lda tongues
          sne
          rts

          ldx #$10
          ldy #$2
          jsr play_sound

          dec tongues
          sed
          lda tongues_bcd
          sec
          sbc #1
          sta tongues_bcd
          cld
          inc score_dirty

          lda #1
          sta tngue_act
          ldx #(frog_posy+5)*8
          stx tngue_pos
          rts

// draw tongue
draw_tng  equ *
          lda tngue_act
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
          inx
          sta missl_buf,x
          dex
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
          inx
          sta missl_buf,x

          lda frog_posx
          adc #$30
          sta hposp1
          clc
          adc #3
          sta hposm0
          rts

draw_tng_down equ *
          ldx tngue_pos
          lda #0
          sta player1_buf,x
          sta missl_buf,x
          inx
          sta missl_buf,x
          sta player1_buf,x
          inx
          sta player1_buf,x
          inx
          sta player1_buf,x
          inx
          sta player1_buf,x
          stx tngue_pos
          txa
          cmp #(frog_posy+5)*8
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

update_tng_char_pos equ * // 28-35 -> 0, 44-51 -> 2
                          // tngue_char_pos = (tngue_pos - 28) / 8
          lda tngue_act
          sne
          rts
          lda tngue_pos
          sec
          sbc #28
          spl
          rts
          lsr
          lsr
          lsr
          and #%00011111
          sta tngue_char_pos // store missle y-position in chars
          rts

// handle collision with tongue
detect_coll equ *
          lda tngue_act  // skip if there's no tongue
          cmp #1
          seq
          rts

          lda tngue_char_pos
          cmp #wasp_posy+3   // ignore collisions below wasp
          smi
          rts

          lda #<wasp_obj
          sta $80
          lda #>wasp_obj
          sta $81
          jsr is_obj_collision
          beq hit_wasp

          lda #flies_c   // find collision
          sta $92        // all objects
          lda #0
          sta $93        // current object
          lda #<(flies_row_1)
          sta $90
          lda #>(flies_row_1)
          sta $91
detect_fly lda $93
          cmp $92
          sne
          rts
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

found_fly equ *
          ldx #$10
          ldy #$3
          jsr play_sound

          ldx #2
          jsr set_flag
          sed
          clc
          lda score
          adc #$10
          sta score
          lda score+1
          adc #0
          sta score+1
          cld
          inc score_dirty
          dec remaining_flies
          jmp tng_act_down

hit_wasp  equ *
          ldx #$10
          ldy #$4
          jsr play_sound
          jsr tng_act_down
