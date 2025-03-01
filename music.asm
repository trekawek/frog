init_music   equ *
             ldx #<song
             ldy #>song
             lda #$70
             jsr player+3
             ldx #0
             jsr play_song
             rts

next_sound   equ *
             jsr player+6
             rts

play_song    equ *
             lda #0
             jsr player+3
             rts

play_sound   equ *
             lda #$22
             jsr player+3
             rts