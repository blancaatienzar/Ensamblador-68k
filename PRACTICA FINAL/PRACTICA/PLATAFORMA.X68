; ==============================================================================
; GESTION DEL PLATAFORMA(OBSTACULO)
; ==============================================================================
            
; ------------------------------------------------------------------------------
PLATINIT
; INICIALIZACION DEL OBSTACULO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #SCRHEIGH-2*TILHEIGH,(PLATPOSY)
            MOVE.W  #33*TILWIDTH,(PLATPOSX)
            MOVE.W  #MAPSPEED,(PLATVELX)
            RTS

            
; ------------------------------------------------------------------------------
PLATUPD
; ACTUALIZACIONES DEL OBSTACULO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W D0-D2,-(A7)
            
            ; CUANDO EL USURIO NO SE MUEVA
            MOVE.W   (USUPOSX),D1
            CMP.W    #3*TILWIDTH,D1
            BLE      .FIN
            
            
            ; ACTUALIZACION DE LAS COORDENADAS
            MOVE.W  (PLATPOSX),D0
            SUB.W   (PLATVELX),D0
            
            ; DETECCION COLISION HORIZONTAL
            MOVE.W  (USUPOSX),D2 
            
            MOVE.W  D0,D1
            ADD.W   #PLATWIDTH,D1
            
            CMP.W   D2,D1
            BLE     .DONE
            
            ADD.W   #TILWIDTH,D2
            CMP.W   D2,D0
            BGE     .DONE
            
            ; DETECCION COLISION VERTICALES
            MOVE.W  (USUPOSY),D2
            MOVE.W  (PLATPOSY),D1
            SUB.W   #TILHEIGH,D1
            
            CMP.W   D2,D1
            BGE     .DONE
            
            ADD.W   #TILHEIGH,D2
            MOVE.W  (PLATPOSY),D1
            
            CMP.W   D2,D1
            BGE     .DONE
            
.CONTI      ADDQ.W  #1,(SCOOUT)
            JSR     USUINIT
            JSR     PLATINIT
            JSR     MAPINIT

            BRA     .FIN


           ; GUARDAR LA POSICION
            
.DONE       MOVE.W  D0,(PLATPOSX)        
.FIN        MOVEM.W (A7)+,D0-D2

            RTS

            
; ------------------------------------------------------------------------------
PLATPLOT
; 'PLOT' DEL OBSTACULO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D6/A0,-(A7)

            LEA     PLATADRAW,A0
            
            ; INICIAMOS LAS COORDENADAS
            MOVE.W  (PLATPOSX),D1
            MOVE.W  D1,D3
            ADD.W   #4,D3
            
            ; BUCLE QUE RECORRE EL MAPA LARGO
            MOVE.W  #31,D6       
     
.CLOOP      ; INICIAMOS LAS COORDENADAS    
            MOVE.W  (PLATPOSY),D4
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
            SUB.W   #4,D1
            
            ; DIBUJAR CUADRADO
            MOVE.B  #87,D0
            TRAP    #15
            
            ; SIGUIENTE POSICION DEL MAPA
            ADD.L   #4,A0

            
            ADD.W   #1,D2
            DBRA.W  D5,.RLOOP
            
            MOVE.W  D3,D1
            ADD.W   #4,D3
            
            DBRA.W  D6,.CLOOP


            MOVEM.L (A7)+,D0-D6/A0
            RTS










*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
