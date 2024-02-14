; ==============================================================================
; GESTION DEL TRIANGULO(OBSTACULO)
; ==============================================================================
         
; ------------------------------------------------------------------------------
TRIUPD
; ACTUALIZACIONES DEL OBSTACULO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D3,-(A7)

            ; DETECCION COLISION HORIZONTAL
            MOVE.W  (TRIPOSX),D0
            MOVE.W  (USUPOSX),D2
            ADD.W   #TILWIDTH,D2 
            CMP.W   D0,D2
            BLT     .DONE
            
            MOVE.W  (USUPOSX),D2
            MOVE.W  D0,D1
            ADD.W   #TILWIDTH,D1
            CMP.W   D1,D2
            BGT     .DONE
            
            ;COLISIONES VERTICALES
            MOVE.W  (USUPOSY),D2
            MOVE.W  (TRIPOSY),D1
            MOVE.W  D1,D3
            SUB.W   #TILHEIGH,D3
            CMP.W   D3,D2
            BLT     .DONE

            SUB.W   #TILHEIGH,D2
            CMP.W   D1,D2
            BGT     .DONE
            
.COLIS      ; SE HA DETECTADO COLISION
            ADDQ.W  #1,(SCOOUT)
            JSR     USUINIT
            JSR     PLATINIT
            JSR     MAPINIT

            
.DONE       MOVEM.W (A7)+,D0-D3

            RTS
            
; ------------------------------------------------------------------------------
TRIPLOT
; 'PLOT' DEL OBSTACULO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D6/A0,-(A7)
            LEA     KILLDRAW,A0
            
            ; INICIAMOS LAS COORDENADAS
            MOVE.W  (TRIPOSX),D1
            MOVE.W  D1,D3
            ADD.W   #1,D3
            
            ; BUCLE QUE RECORRE EL MAPA LARGO
            MOVE.W  #31,D6       
     
.CLOOP      ; INICIAMOS LAS COORDENADAS    
            MOVE.W  (TRIPOSY),D4
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
            
            MOVE.W  D3,D1
            ADD.W   #1,D3
            
            DBRA.W  D6,.CLOOP


            MOVEM.L (A7)+,D0-D6/A0
            RTS



















*~Font name~Fixedsys~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
