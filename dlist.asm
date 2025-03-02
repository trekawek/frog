
dlist_start equ *
          dta b($f0)    // 3*8=24 empty lines
          dta b($70)    // 03
          dta b($70)    // 07

          dta b($44)    // 03 antic 4 + LMS
dlist_lms dta a(scr_buf_1)
          dta b($04)    // 07
          dta b($04)    // 1b
          dta b($04)    // 1f
          dta b($84)    // 23 antic 4 + DLI
          dta b($04)    // 27
          dta b($04)    // 2b
          dta b($04)    // 2f
          dta b($04)    // 33
          dta b($04)    // 37
          dta b($04)    // 3b
          dta b($04)    // 3f
          dta b($84)    // 43 antic 4 + DLI
          dta b($04)    // 47
          dta b($04)    // 4b
          dta b($04)    // 4f
          dta b($04)    // 53
          dta b($04)    // 57
          dta b($04)    // 5b
          dta b($04)    // 5f
          dta b($84)    // 63
          dta b($84)    // 67 antic 4 + DLI
          dta b($04)    // 6b
          dta b($07)    // 6b
          dta b($70)    // 73
          dta b($70)    // 73
          dta b($70)    // 77
          dta b($70)    // 7b
          dta b($70)    // 7f

          dta b($41),a(dlist_start) // JVB