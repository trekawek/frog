scr_buf   dta a(scr_buf_1)
frg_del   dta b(1)
wsp_del   dta b(1)
fly_del   dta b(1)

tngue_act dta b(0)       // 0 - not active, 1 - going up, 2 - going down
tngue_pos dta b(0)
tngue_char_pos dta b(frog_posy)

score       dta b(0),b(0)
tongues     dta b(0)
tongues_bcd dta b(0)
score_dirty dta b(1)
remaining_flies dta b(0)

wsp_hscrol  dta b(0)