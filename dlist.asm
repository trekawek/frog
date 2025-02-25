
dlist_start equ *
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

          dta b($41),a(dlist_start) // JVB