
objects     dta a(frog_obj)
            dta a(wasp_obj)
flies_row_1 dta a(fly_1_obj)
            dta a(fly_2_obj)
            dta a(fly_3_obj)
flies_row_2 dta a(fly_4_obj)
            dta a(fly_5_obj)
            dta a(fly_6_obj)
flies_row_3 dta a(fly_7_obj)
            dta a(fly_8_obj)
            dta a(fly_9_obj)

frog_obj  dta b(scr_minx),b(frog_posy) // x, y position
          dta b(3),b(3)       // width, height
          dta a(frog)         // tiles
          dta b(0)            // flags

wasp_obj  dta b(scr_minx),b(wasp_posy)      // x, y position
          dta b(3),b(3)       // width, height
          dta a(wasp_r)       // tiles
          dta b(0)            // flags

fly_1_obj dta b(scr_minx),b(flies1_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)            // bit 0 - direction, bit 1 - hidden

fly_2_obj dta b(scr_minx+5),b(flies1_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_3_obj dta b(scr_minx+10),b(flies1_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_4_obj dta b(scr_minx+2),b(flies2_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_5_obj dta b(scr_minx+7),b(flies2_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_6_obj dta b(scr_minx+12),b(flies2_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_7_obj dta b(scr_minx+5),b(flies3_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_8_obj dta b(scr_minx+10),b(flies3_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

fly_9_obj dta b(scr_minx+15),b(flies3_posy)
          dta b(3),b(1)
          dta a(fly_l_1)
          dta b(0)

frog      dta b($01),b($02),b($03)
          dta b($04),b($05),b($06)
          dta b($07),b($08),b($09)

wasp_l    dta b($2c),b($2b),b($2a)
          dta b($2f),b($2e),b($2d)
          dta b($00),b($31),b($30)

wasp_r    dta b($0a),b($0b),b($0c)
          dta b($0d),b($0e),b($0f)
          dta b($10),b($11),b($00)

fly_l_1   dta b($15),b($96),b($17) // 14
fly_l_2   dta b($18),b($96),b($19) // 17
fly_r_1   dta b($15),b($9a),b($17) // 14
fly_r_2   dta b($18),b($9a),b($19) // 17

tongue_shape equ *
          dta b(%00011000)
          dta b(%00010000)
          dta b(%00011000)
          dta b(%00001000)
          dta b(%00011000)
          dta b(%00010000)
          dta b(%00011000)
          dta b(%00001000)
