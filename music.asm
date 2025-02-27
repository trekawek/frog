init_music   equ *
             ldx #<song
             ldy #>song
             lda #$70
             jsr player+3
             ldx #0
             txa
             jsr player+3
             rts

play_music   equ *
             jsr player+6
             rts

play_sound   equ *
             lda #$22
             jsr player+3
             rts