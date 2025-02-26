init_game equ *
          lda #20
          sta tongues
          lda #$20
          sta tongues_bcd
          lda #flies_c
          sta remaining_flies
          rts

is_next_level equ *
          lda remaining_flies
          seq
          rts
          jmp init_game

is_game_over equ *
          lda tongues
          seq
          rts
          lda #0
          sta score
          sta score+1
          jmp init_game
