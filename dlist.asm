_dli     equ %10000000
_lms     equ %01000000
_vscroll equ %00100000
_hscroll equ %00010000
_jmp     equ %00000001
_jvb     equ %01000001

_blank7  equ $70
_blank6  equ $60
_blank5  equ $50
_blank4  equ $40
_blank3  equ $30
_blank2  equ $20
_blank1  equ $10

dlist_start equ *
            dta b(_blank7 + _dli)    // 3*8=24 empty lines
            dta b(_blank7)    // 03
            dta b(_blank7)    // 07

            dta b($04 + _lms)    // 03 antic 4 + LMS
dlist_lms_1 dta a(scr_buf_1+0)
            dta b($04)           // 07
            dta b($04)           // 1b
            dta b($04)           // 1f
            dta b($04)           // 23
            dta b($04)           // 27
            dta b($04 + _dli)    // 2b
            dta b($04)           // 2f
            dta b($04 + _hscroll + _lms)    // 33 - wasp 1
dlist_lms_2 dta a(scr_buf_1+$013c)
            dta b($04 + _hscroll + _lms)    // 37 - wasp 2
dlist_lms_3 dta a(scr_buf_1+$0164)
            dta b($04 + _hscroll + _lms)    // 3b - wasp 3
dlist_lms_4 dta a(scr_buf_1+$018c)
            dta b($04 + _lms)    // 3f
dlist_lms_5 dta a(scr_buf_1+$01b8)
            dta b($04 + _dli)    // 43 antic 4 + DLI
            dta b($04)           // 47
            dta b($04)           // 4b
            dta b($04)           // 4f
            dta b($04)           // 53
            dta b($04 + _hscroll + _lms)    // 57 - frog 1
dlist_lms_6 dta a(scr_buf_1+$02a4) // 2a8
            dta b($04 + _hscroll + _lms)    // 5b - frog 2
dlist_lms_7 dta a(scr_buf_1+$02cc) // 2d0
            dta b($04 + _hscroll + _lms)    // 5f - frog 3
dlist_lms_8 dta a(scr_buf_1+$02f4) // 2f8
            dta b($04 + _dli + _lms)  // 63
dlist_lms_9 dta a(scr_buf_1+$0320) // 320
            dta b($04 + _dli)         // 67
            dta b($04)        // 6b
            dta b($07)        // 6b
            dta b(_blank7)    // 73
            dta b(_blank7)    // 73
            dta b(_blank7)    // 77
            dta b(_blank7)    // 7b
            dta b(_blank7)    // 7f

            dta b(_jvb),a(dlist_start)