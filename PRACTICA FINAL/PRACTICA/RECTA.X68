; ==============================================================================
; GESTION DEL RECTANGULO(SUELO)
; ==============================================================================
 
; ------------------------------------------------------------------------------
RECPLOT
; 'PLOT' DEL SUELO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
                       
            MOVEM.L D0-D6/A0,-(A7)

            LEA     FLOORDRAW,A0
            
            ; INICIAMOS LAS COORDENADAS
            MOVE.W  (RECPOSX),D1
            MOVE.W  D1,D3
            ADD.W   #1,D3
            
            ; BUCLE QUE RECORRE EL MAPA LARGO
            MOVE.W  #31,D6       
     
.CLOOP      ; INICIAMOS LAS COORDENADAS    
            MOVE.W  (RECPOSY),D4
            MOVE.W  D4,D2
            SUB.W   #TILHEIGH,D2

            ; BUCLE QUE RECORRE EL MAPA ANCHO
            MOVE.W  #31,D5
            
.RLOOP      
            ; COLOCAR EL COLOR DEL CONTORNO
            MOVE.B  #80,D0
            MOVE.L  (A0),D1
            TRAP    #15
            
            ; RELLENAR CON EL COLOR
            MOVE.B  #81,D0
            MOVE.L  (A0),D1
            TRAP    #15
            
            MOVE.W  D3,D1
            SUB.W   #1,D1
            
            ; DIBUJAR CUADRADO
            MOVE.B  #87,D0
            TRAP    #15
            
            ; SIGUIENTE POSICION DEL MAPA
            ADD.L   #4,A0

            
            ADD.W   #1,D2
            DBRA.W  D5,.RLOOP
            
            MOVE.L  D3,D1
            ADD.W   #1,D3
            
            DBRA.W  D6,.CLOOP


            MOVEM.L (A7)+,D0-D6/A0
            RTS





*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
