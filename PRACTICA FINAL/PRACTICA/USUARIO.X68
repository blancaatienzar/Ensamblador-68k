; ==============================================================================
; GESTION DE USUARIO
; ==============================================================================
            
; ------------------------------------------------------------------------------
USUINIT
; INICIALIZACION DEL USUARIO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVE.W  #SCRHEIGH-2*TILHEIGH,(USUPOSY)
            MOVE.W  #TILWIDTH,(USUPOSX)
            MOVE.W  #USUSPEED,(USUVELY)
            RTS
            
; ------------------------------------------------------------------------------
USUUPD
; ACTUALIZACION DEL USUARIO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            
            MOVEM.W  D0-D1,-(A7)
            
            ; CUADRADO EMPIEZA MOVIENDOSE
            MOVE.W   (USUPOSX),D1
            CMP.W    #3*TILWIDTH,D1
            BLE      .MOVERX
            
            ; CUADRADO NO SE MUEVE EN EL EJE X
            CLR.W    D1
            SUB.W    #NTILWIDT-2*TILWIDTH+SCRWIDTH,D1
            CMP.W    (MAPPOSX),D1
            BLT      .NEXT    
            
            ; CUADRADO ACABA MOVIENDOSE
            MOVE.W   #SCRWIDTH-2*TILWIDTH-2,D1
            CMP.W    (USUPOSX),D1
            BLT      .NEXT
            
            ; COMPROBAMOS SI ES NEGATIVO LA VELOCIDAD
            MOVE.W   #0,D1
            CMP.W    (USUVELY),D1
            BLE      .TAMBX      
            NEG.W    (USUVELY)     
            
.TAMBX      MOVE.W  (USUPOSX),D0
            ADD.W   (USUVELY),D0
            MOVE.W  D0,(USUPOSX)
            
            ; ACTUALIZACION CORRDENADAS
.NEXT       MOVE.W  (USUPOSY),D0
            
            ; COMPROBAMOS LA PLATAFORMA O SUELO
            JSR USUFLOOR
            
            BTST.B  #1,(KBDEDGE)
            BNE     .COLTOP
            CMP.W   (NWFLOOR),D0
            BGE     .TOUCH  
            BRA     .CHECK
          
.COLTOP     ; TECLA FIRE1 PULSADA
            CMP.W   (NWFLOOR),D0
            BLT     .CHECK
            ADD.W   #1,(SCOIN)    ;CONTADOR NºSALTOS
            
            ;REALIZA UN SALTO
            SUB.W   #3,D0
            NEG.W   (USUVELY)
            BRA     .DONE           
            
            
.CHECK      ; ESTA REALIZANDO UN SALTO
            CMP.W   (NWJUMP),D0
            BGE     .COLBOT
            NEG.W   (USUVELY)            
            
.COLBOT     ADD.W   (USUVELY),D0
            BRA     .DONE            

.TOUCH      MOVE.W  (NWFLOOR),D0
            
            ; UPDATE VARIABLE
.DONE       MOVE.W   D0,(USUPOSY)
            BRA      .FIN

.MOVERX     MOVE.W  (USUPOSX),D0
            ADD.W   (USUVELY),D0
            MOVE.W  D0,(USUPOSX)
            
            
.FIN        MOVEM.W  (A7)+,D0-D1
            
            RTS

; ------------------------------------------------------------------------------
USUPLOT
; 'PLOT' DEL USUARIO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------
            MOVEM.L D0-D6/A0,-(A7)

            LEA     USERDRAW,A0
            
            ; INICIAMOS LAS COORDENADAS
            MOVE.W  (USUPOSX),D1
            MOVE.W  D1,D3
            ADD.W   #1,D3
            
            ; BUCLE QUE RECORRE EL MAPA LARGO
            MOVE.W  #31,D6       
     
.CLOOP      ; INICIAMOS LAS COORDENADAS    
            MOVE.W  (USUPOSY),D4
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

; ------------------------------------------------------------------------------
USUFLOOR
; ACTUALIZAZION PLATAFORMA DEL USUARIO.
; INPUT    : NONE 
; OUTPUT   : NONE
; MODIFIES : NONE
; ------------------------------------------------------------------------------

            MOVEM.W  D0-D1,-(A7)
            
            ;ACTUALIZACION COORDENADAS SUELO
            MOVE.W  (USUPOSX),D1
            MOVE.W  (PLATPOSX),D0
            ADD.W   #PLATWIDTH,D0
            CMP.W   D0,D1
            BGE     .NEXT
            
            MOVE.W  (USUPOSX),D1
            ADD.W   #TILWIDTH,D1
            MOVE.W  (PLATPOSX),D0
            CMP.W   D0,D1
            BLT     .NEXT
            
            MOVE.W  (USUPOSY),D0
            MOVE.W  (PLATPOSY),D1
            SUB.W   #TILHEIGH+3,D1
            CMP.W   D1,D0
            BLT     .NEXT 

            MOVE.W  D1,(NWFLOOR)
            MOVE.W  #240,(NWJUMP)

            BRA .FIN               
            
.NEXT      ; COORDENADAS PRINCIPALES
            MOVE.W  #SCRHEIGH-2*TILHEIGH,(NWFLOOR)
            MOVE.W  (NWFLOOR),(USUPOSY)
            MOVE.W  #310,(NWJUMP)


.FIN        MOVEM.W (A7)+,D0-D1

            RTS













*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
