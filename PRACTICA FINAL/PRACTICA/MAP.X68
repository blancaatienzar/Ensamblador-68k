; ------------------------------------------------------------------------------
MAPINIT
; INICIALIZACION DEL MAPA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.W  D0-D2/A1,-(A7)
            
            
            MOVE.W  #0,(MAPPOSX)
            MOVE.W  #MAPSPEED,(MAPVELX)
            
            
            MOVE.B #50,D0                  
            TRAP   #15                        
            
            
            LEA    FNAME,A1     

            ; ABRIMOS EL FICHERO SOLO PARA LEER            
            MOVE.B #51,D0    
            TRAP   #15             

            ; LEERMOS EL FICHERO
            LEA    MAPDATA,A1                  
            MOVE.L #MAP_SIZE,D2  
            MOVE.B #53,D0          
            TRAP   #15             
            
            MOVE.B #56,D0  
            TRAP   #15              

            MOVEM.W  (A7)+,D0-D2/A1
            RTS
                       
            
; ------------------------------------------------------------------------------
MAPUPD
; ACTUALIZACIONES DEL MAPA.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVEM.W  D0,-(A7)
            
            ; CUANDO EL USURIO NO SE MUEVA
            MOVE.W   (USUPOSX),D1
            CMP.W    #3*TILWIDTH,D1
            BLE      .FIN
            
            ; INDICA QUE EL MAPA ACABA
            CLR.W    D1
            SUB.W    #NTILWIDT-2*TILWIDTH+SCRWIDTH,D1
            CMP.W    (MAPPOSX),D1
            BGE      .FIN

            ; EL MAPA VA AVANZANDO
            MOVE.W  (MAPPOSX),D0
            SUB.W   (MAPVELX),D0
            MOVE.W  D0,(MAPPOSX)
            
.FIN        MOVEM.W  (A7)+,D0
            RTS

;------------------------------------------------------------------------------
MAPPLOT
; PLOTS THE MAP
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.L D0-D6/A0,-(A7)
            
            LEA     MAPDATA,A0
            
            ; INICIAMOS LAS COORDENADAS
            MOVE.W  (MAPPOSX),D1
            MOVE.W  D1,D3
            ADD.W   #TILWIDTH,D3
            
            ; BUCLE QUE RECORRE EL MAPA LARGO
            MOVE.W  #NTILWIDT-1,D6       
     
.CLOOP      ; INICIAMOS LAS COORDENADAS    
            MOVE.W  #0,D2
            MOVE.W  #32,D4

            ; BUCLE QUE RECORRE EL MAPA ANCHO
            MOVE.W  #NTILHEIG-1,D5
            
.RLOOP      ; INICIALIZAR OBJETOS
            JSR MAPOBJETOS
            
            ; SIGUIENTE POSICION DEL MAPA
            ADD.L   #1,A0

            MOVE.W  D4,D2
            ADD.W   #TILHEIGH,D4
            DBRA.W  D5,.RLOOP
            
            MOVE.W  D3,D1
            ADD.W   #TILWIDTH,D3
            
            DBRA.W  D6,.CLOOP

            MOVEM.L (A7)+,D0-D6/A0

            RTS

; ------------------------------------------------------------------------------
MAPOBJETOS
; APLICAR OBJETOS EN EL RECUADRO
; INPUT    : NONE
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D6/A1,-(A7)
            
            MOVE.W  D1,D5

            MOVE.B  (A0),D6
            CMP.B   #1,D6
            BEQ     .ISFLOOR
            CMP.B   #2,D6
            BEQ     .ISKILL
            
            ; COLOCAR COLOR DEL CONTORNO
            MOVE.B  #80,D0
            MOVE.L  $00000000,D1
            TRAP    #15
            
            ; RELLENAR CON EL COLOR
            MOVE.B  #81,D0
            MOVE.L  $00000000,D1
            TRAP    #15
            BRA     .FI
            
            ; INICIALIZAMOS OBJETO (PARED)
.ISFLOOR    MOVE.W  D5,(RECPOSX)
            MOVE.W  D4,(RECPOSY)
            JSR     RECPLOT
            BRA     .FI

            ; INICIALIZAMOS OBJETO (OBSTACULO)
.ISKILL     MOVE.W  D5,(TRIPOSX)
            MOVE.W  D4,(TRIPOSY)
            JSR     TRIUPD 
            JSR     TRIPLOT
                      
.FI         MOVEM.L (A7)+,D0-D6/A1
            RTS





 








*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
