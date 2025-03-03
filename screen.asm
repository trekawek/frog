// init screeen
init_scr  equ *
          lda #<dlist // set dlist address
          sta sdlst
          lda #>dlist
          sta sdlst+1
          lda #<dli   // set dli vector
          sta dliv
          lda #>dli
          sta dliv+1
          lda #$c0    // enable dli
          sta nmien

          lda #$0e    // set background
          sta colbaks

          lda #%00111110 // enable pmg
          sta dmactls
          lda #%00000011
          sta pmctl
          lda #>pm_buf
          sta pmbase

          lda #%00000100 // PF3, PF2, PF1, PF0, PM0, PM1, PM2, PM3, BAK

          lda #50
          sta hposm0
          sta hposp1
          lda #$c8
          sta colpm0s
          lda #$34
          sta colpm1s
          rts

// swap screen buffer
swap_scr  lda #>scr_buf_1 // switch screen buffer
          cmp scr_buf+1
          sne
          lda #>scr_buf_2
          sta scr_buf+1
          rts

// draw objects
draw_obj  lda #objects_c
          sta $92          // all objects
          lda #0
          sta $93          // current object
          lda #<(objects)
          sta $94
          lda #>(objects)
          sta $95
draw_obj_loop lda $93
          cmp $92
          sne
          rts
          rol
          tay
          lda ($94),y
          tax
          iny
          lda ($94),y
          tay
          jsr draw
          inc $93
          jmp draw_obj_loop

// wait for vblank
wait_vblank lda 20 // wait for vblank
          cmp 20
          beq *-2
          ldx scr_buf+1 // update LMS in dlist
          stx dlist_lms_1+1
          inx
          stx dlist_lms_2+1
          stx dlist_lms_3+1
          stx dlist_lms_4+1
          stx dlist_lms_5+1
          inx
          stx dlist_lms_6+1
          stx dlist_lms_7+1
          stx dlist_lms_8+1
          inx
          stx dlist_lms_9+1

          lda wsp_posx
          and #%11
          sta wsp_hscrol

          lda frog_posx
          and #%11
          sta frog_hscrol
          rts

// clean screen
clean     equ *
          lda scr_buf+1
          cmp #>scr_buf_1
          beq clean_1

clean_2   ldx #$00
          txa
clean_2_l equ *
          sta scr_buf_2,x
          sta scr_buf_2+$100,x
          sta scr_buf_2+$200,x
          sta scr_buf_2+$300,x
          inx
          bne clean_2_l
          rts

clean_1   ldx #$00
          txa
clean_1_l equ *
          sta scr_buf_1,x
          sta scr_buf_1+$100,x
          sta scr_buf_1+$200,x
          sta scr_buf_1+$300,x
          inx
          bne clean_1_l
          rts
          end
