; ==============================================================================
; VICTORY SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
WINUPD
; VICTORY SCREEN UPDATE
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            BTST.B  #1,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
.CONT       RTS

; ------------------------------------------------------------------------------
WINPLOT
; VICTORY SCREEN PLOT
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D1/A0,-(A7)
            
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            
            LEA     .TXT1,A0
            MOVE.B  #10,D0
            JSR     UTLPRINT
            
            BTST.B  #4,(SCRCYCCT)
            BEQ     .DONE
            
            LEA     .TXT2,A0
            MOVE.B  #25,D0
            JSR     UTLPRINT
            
.DONE       MOVEM.L (A7)+,D0-D1/A0

            RTS
.TXT1       DC.B    'YOU WON!',0
.TXT2       DC.B    'PRESS FIRE1 TO CONTINUE',0
            DS.W    0






*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
