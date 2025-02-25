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

// main loop
forever   jsr swap_scr
          // FIXME - why is it needed?
          jsr draw_obj
          jsr detect_coll
          jsr init_tng
          jsr move_frog
          jsr move_wasp
          jsr move_flies
          jsr clean
          jsr draw_obj
          jsr draw_tng
          jsr update_tng_char_pos
          jsr wait_vblank
          jmp forever

          icl 'data.asm'
          icl 'dli.asm'
          icl 'frog.asm'
          icl 'object.asm'
          icl 'screen.asm'
          icl 'state.asm'
          icl 'tongue.asm'
          // FIXME - why does it crash if we put these files in different order?
          icl 'wasp.asm'
          icl 'fly.asm'
