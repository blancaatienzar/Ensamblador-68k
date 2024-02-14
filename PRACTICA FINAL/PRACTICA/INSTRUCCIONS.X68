; ==============================================================================
; INSTRUCTIONS SCREEN
; ==============================================================================

; ------------------------------------------------------------------------------
INSINIT
; INSTRUCCIONES DE INICIO DE PANTALLA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            CLR.W   (INSTIMER)
            RTS

; ------------------------------------------------------------------------------
INSUPD
; INSTRUCCIONES DE ACTUALIZACION DE PANTALLA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            BTST.B  #4,(KBDEDGE)
            BEQ     .CONT
            CLR.W   (STANEXT)
.CONT       ADDQ.W  #1,(INSTIMER)
            CMP.W   #INSMAXTM,(INSTIMER)
            BLT     .DONE
            CLR.W   (STANEXT)
.DONE       RTS

; ------------------------------------------------------------------------------
INSPLOT
; INSTRUCCIONES DE 'PLOT' DE PANTALLA
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D1/A0-A1,-(A7)
            CLR.L   D1
            MOVE.B  #81,D0
            TRAP    #15
            MOVE.B  #11,D0
            LEA     .TXTLST,A1
.LOOP       MOVE.L  (A1)+,D1
            BEQ     .DONE
            MOVE.L  D1,A0
            JSR     UTLPRINT
            BRA     .LOOP
.DONE       MOVEM.L (A7)+,D0-D1/A0-A1
            RTS
.TXT1       DC.B    'BIENVENIDOS AL MUNDO DEL GEOMETRY DASH 68000!',0
.TXT2       DC.B    'TU OBJETIVO ES RECORRER TODO EL MAPA SIN CHOCARTE CON LOS OBSTACULOS',0
.TXT3       DC.B    'PARA EVITAR LOS OBSTACULOS TIENES QUE HACER SALTAR AL PERSONAJE',0
.TXT4       DC.B    'Y COMO SE PUEDE HACER?',0
.TXT5       DC.B    'MUY FACIL: PULSA LA BARRA DE ESPACIO PARA SALTAR',0
.TXT6       DC.B    'SOLO SE PUEDE USAR LA BARRA DE ESPACIO?',0
.TXT7       DC.B    'SI, CON ESA UNICA TECLA PUEDES DISFRUTAR DEL JUEGO',0
            DS.W    0
.TXTLST     DC.L    .TXT1,.TXT2,.TXT3,.TXT4,.TXT5,.TXT6,.TXT7,0






*~Font name~Courier New~
*~Font size~14~
*~Tab type~1~
*~Tab size~4~
