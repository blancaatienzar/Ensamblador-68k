; ==============================================================================
; GESTION DEL JUEGO(GAME)
; ==============================================================================
 
; ------------------------------------------------------------------------------
GAMINIT
; INICIALIZACION DEL JUEGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            JSR     USUINIT
            JSR     PLATINIT 
            JSR     MAPINIT
            
            BRA     SCOINIT

; ------------------------------------------------------------------------------
GAMUPD
; ACTUALIZACION DEL JUEGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0/A1-A3,-(A7)
            MOVE.B  (SCRCYCCT),D0
            AND.B   #%00011111,D0
            BNE     .GOUPD
            MOVE.W  #1,D0            
.GOUPD      
            JSR     USUUPD
            JSR     PLATUPD 
            JSR     MAPUPD
            MOVE.W  #SCRWIDTH-2*TILWIDTH-2,D1
            CMP.W   (USUPOSX),D1
            BLT     .CHKLOSS
            MOVE.W  #2,(STANEXT)
            BRA     .DONE
            
.CHKLOSS    MOVE.W  #3,(STANEXT)            
            
.DONE       MOVEM.L (A7)+,D0/A1-A3
            RTS

; ------------------------------------------------------------------------------
GAMPLOT
; 'PLOT' DEL JUEGO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            JSR     USUPLOT
            JSR     PLATPLOT            
            JSR     MAPPLOT
            
            
            BRA     SCOPLOT
            







*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
