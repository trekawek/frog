init_level equ *

          lda level
          cmp #11
          bpl _high_level

_low_level   lda #20
             sec
             sbc level
             jmp _set_tng

_high_level  lda #9
             jmp _set_tng

_set_tng  sta tongues
          lda #flies_c
          sta remaining_flies
          
          lda #scr_minx
          sta fly_1_obj
          sta frog_obj
          sta wasp_obj

          lda #scr_minx*4
          sta frog_posx
          sta wsp_posx

          lda #[scr_minx+0]*4
          sta flies1_posx

          lda #[scr_minx+5]*4
          sta flies2_posx

          lda #[scr_minx+10]*4
          sta flies3_posx

          lda #0
          sta fly_1_obj+6
          sta fly_2_obj+6
          sta fly_3_obj+6
          sta fly_4_obj+6
          sta fly_5_obj+6
          sta fly_6_obj+6
          sta fly_7_obj+6
          sta fly_8_obj+6
          sta fly_9_obj+6
          sta frog_obj+6
          sta wasp_obj+6
          sta flies1_dir
          sta flies2_dir
          sta flies3_dir
          rts

is_next_level equ *
          lda tngue_act
          seq
          rts
          lda remaining_flies
          seq
          rts

          lda tongues // 20 extra points for every remaining tongue or every level
          clc
          adc level
          tax
          sed
_tongue_score_loop beq _finish_tongues_score
          lda #$20
          clc
          adc score
          sta score
          lda #0
          adc score+1
          sta score+1
          dex
          jmp _tongue_score_loop

_finish_tongues_score equ *
          cld
          ldx #1
          stx score_dirty
          jsr play_song

          inc level

          sed
          lda level_bcd
          clc
          adc #$01
          sta level_bcd
          cld

          jmp init_level

is_game_over equ *
          lda game_state
          and #$01
          seq
          rts

          lda tngue_act
          seq
          rts
          lda tongues
          seq
          rts
          
          ldx #2
          jsr play_song
          lda #$01
          sta game_state
          rts

start_game equ *
          lda game_state
          and #$01
          sne
          rts

          lda trig0
          seq
          rts

          lda trig0
          beq *-3

          ldx #1
          stx level_bcd
          dex
          stx level
          stx score
          stx score+1
          stx game_state
          jsr play_song

          jmp init_level
