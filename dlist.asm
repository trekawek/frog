
dlist_start equ *
          dta b($f0)    // 3*8=24 empty lines
          dta b($70)    // 03
          dta b($70)    // 07

          dta b($44)    // 03 antic 4 + LMS
dlist_lms_1 dta a(scr_buf_1+0)
          dta b($04)    // 07
          dta b($04)    // 1b
          dta b($04)    // 1f
          dta b($04)    // 23 antic 4 + DLI
          dta b($04)    // 27
          dta b($84)    // 2b
          dta b($04)    // 2f
          dta b($54)    // 33 - wasp
dlist_lms_2 dta a(scr_buf_1+$013c)
          dta b($54)    // 37 - wasp
dlist_lms_3 dta a(scr_buf_1+$0164)
          dta b($54)    // 3b - wasp
dlist_lms_4 dta a(scr_buf_1+$018c)
          dta b($44)    // 3f
dlist_lms_5 dta a(scr_buf_1+$01b8)
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