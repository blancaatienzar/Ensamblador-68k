; ==============================================================================
; SYSTEM
; ==============================================================================
            
; ------------------------------------------------------------------------------
SYSINIT
; INICIALIZACION DEL SYSTEMA.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            JSR     SCRINIT
            JSR     KBDINIT
            JSR     DMMINIT

            MOVE.W  #SCRHEIGH-2*TILHEIGH, (NWFLOOR)
            MOVE.W  #310, (NWJUMP)          
            MOVE.L  #SCRPLOT,($80)
            MOVE.L  #KBDUPD,($84)
            
            MOVE.W  SR,-(A7)
            ANDI.W  #$D8FF,(A7)
            RTE

            
; ------------------------------------------------------------------------------
SCRINIT
; INICIALIZACION DE LA PANTALLA. RESOLUCION, MODO VENTANA, LIMPIAR PANTALLA.
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1,-(A7)

            ; COLOCAR LA RESOLUCION DE LA PANTALLA
            MOVE.B  #33,D0
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1
            TRAP    #15
            
            ; COLOCAR EL MODO VENTANA
            MOVE.L  #1,D1
            TRAP    #15
            
            ; LIMPIAR PANTALLA
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            ; HABILITAR EL DOBLE BUFFER
            MOVE.B  #92,D0
            MOVE.B  #17,D1
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1
            
            RTS


; ------------------------------------------------------------------------------
SCRPLOT
; ACTUALIZACION DEL DOBLE BUFFER
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D1,-(A7)
            
            ; CAMBIAR BÚFERS
            MOVE.B  #94,D0
            TRAP    #15
            
            ; BORRAR BUFFER OCULTO
            MOVE.B  #11,D0
            MOVE.W  #$FF00,D1
            TRAP    #15
            
            MOVEM.W (A7)+,D0-D1
            RTE


; ------------------------------------------------------------------------------
KBDINIT
; INIT KEYBOARD
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.B   (KBDVAL)
            CLR.B   (KBDEDGE)
            RTS

; ------------------------------------------------------------------------------
KBDUPD
; UPDATE KEYBOARD INFO.  
; 1 -> UP
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D3,-(A7)

            ; READ FIRST PART
            MOVE.B  #19,D0
            MOVE.L  #KBDPAUSE<<24|KBDFIRE3<<16|KBDFIRE2<<8|KBDFIRE1,D1
            TRAP    #15
            
            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK

            ; READ SECOND PART
            MOVE.L  #KBDDOWN<<24|KBDRIGHT<<16|KBDUP<<8|KBDLEFT,D1
            TRAP    #15

            ; CONVERT TO DESIRED FORMAT
            JSR     .PACK
            
            ; COMPUTE KBDEDGE
            MOVE.B  (KBDVAL),D0
            NOT.B   D0
            AND.B   D2,D0
            MOVE.B  D0,(KBDEDGE)
            
            ; STORE KBDVAL
            MOVE.B  D2,(KBDVAL)
            
            MOVEM.L (A7)+,D0-D3

            RTE
            
.PACK       MOVE.W  #3,D3
.LOOP       LSL.L   #8,D1
            ROXL.B  #1,D2
            DBRA.W  D3,.LOOP
            RTS




*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
