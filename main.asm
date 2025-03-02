          opt h+s+

          icl 'const.asm'
          icl 'io.asm'
          icl 'memory.asm'

          org $2e0
          dta a(init)

          org chrst
          ins 'tiles.fnt'

          org dlist
          icl 'dlist.asm'

          org program

// init
init      jsr init_scr
          jsr init_game
          jsr init_music

// main loop
forever   equ *
          jsr swap_scr
          jsr detect_coll
          jsr init_tng
          jsr move_frog
          jsr move_wasp
          jsr move_flies
          jsr clean
          jsr draw_obj
          jsr draw_tng
          jsr print_score
          jsr draw_tongue_ind
          jsr update_tng_char_pos
          jsr is_next_level
          jsr is_game_over
          jsr next_sound
          jsr wait_vblank
          jmp forever

          icl 'data.asm'
          icl 'dli.asm'
          icl 'fly.asm'
          icl 'frog.asm'
          icl 'game.asm'
          icl 'music.asm'
          icl 'object.asm'
          icl 'score.asm'
          icl 'screen.asm'
          icl 'state.asm'
          icl 'tongue.asm'
          icl 'tongue_ind.asm'
          icl 'wasp.asm'

          opt h-
          ins 'frog.cmc'
          ins 'player.obj'
