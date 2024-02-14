; ==============================================================================
; GESTION MARCADOR DE PUNTOS
; ==============================================================================
            
; ------------------------------------------------------------------------------
SCOINIT
; INICIALIZACION DEL MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.W   (SCOIN)
            CLR.W   (SCOOUT)
            MOVE.W  #SCOLINE,(SCOPOSX)
            RTS
            
; ------------------------------------------------------------------------------
SCOUPD
; 'PLOT' DEL MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0,-(A7)            
            
            ; ACTUALIZACION DE LAS COORDENADAS
            MOVE.W  (SCOPOSX),D0
            SUB.W   #1,D0
            
            ; GUARDAR LA POSICION
            MOVE.W  D0,(SCOPOSX)
            
            MOVEM.W (A7)+,D0

            RTS

; ------------------------------------------------------------------------------
SCOPLOT
; 'PLOT' DEL MARCADOR.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A1,-(A7)

            ; COLOCAR EL COLOR DE FONDO
            MOVE.B  #81,D0
            MOVE.L  #SCOFCOL,D1
            TRAP    #15
            
            ; COLOCAR LA PRIMERA LINIA (POSICION)
            MOVE.B  #11,D0
            MOVE.W  #REALINE,D1
            TRAP    #15

            ; ESCRIBIR LA PRIMERA LINIA
            LEA     .TXTREAL,A1
            CLR.L   D1
            MOVE.L  (FPSREAL),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            ; COLOCAR LA PRIMERA TERCERA (POSICION)
            MOVE.B  #11,D0
            MOVE.W  #GOALINE,D1
            TRAP    #15

            ; ESCRIBIR LA TERCERA LINIA
            LEA     .TXTGOAL,A1
            CLR.L   D1
            MOVE.W  #FPSGOAL,D1
            MOVE.B  #17,D0
            TRAP    #15

            ; COLOCAR LA SEGUNDA LINIA (POSICION)
            MOVE.B  #11,D0
            MOVE.W  #SCOLINE,D1
            TRAP    #15

            ; ESCRIBIR LA SEGUNDA LINIA
            LEA     .TXT,A1
            CLR.L   D1
            MOVE.W  (SCOOUT),D1
            MOVE.B  #17,D0
            TRAP    #15
            
            MOVEM.L (A7)+,D0-D1/A1
            
            RTS
            
.TXTREAL    DC.W    ' - FPSREAL:',0     *FPSREAL
.TXTGOAL    DC.B    'FPSGOAL:',0     *FPSGOAL
            DS.W    0

.TXT       DC.B    'INTENTOS ',0     *VECES QUE A FALLADO     
            DS.W    0









*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
