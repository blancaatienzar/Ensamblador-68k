*-----------------------------------------------------------
* Title      : Cercle Verd i Vermell
* Written by : Blanca Atienzar
* Date       : 11/10/2023
* Description: Programa on el cercle ha d’esser completament verd si
* no es pitja el boto i completament vermell si es pitja el boto de 
* mes a la dreta de la botonera
*-----------------------------------------------------------

* -----------------------------------------------------------------------------
* CONSTANTES
* -----------------------------------------------------------------------------
SCRWIDTH    EQU     800                    ; DESIRED SCREEN WIDTH
SCRHEIGH    EQU     600                     ; DESIRED SCREEN HEIGHT
CIRCDIAM    EQU     200                     ; DIAMETER OF THE CIRCLE TO DRAW
CIRGCHAN    EQU     128                     ; CIRCLE GREEN CHANNEL VALUE
COLGREEN    EQU     $0000FF00
COLRED      EQU     $000000FF    
ADDR        EQU     %111000000000000000010100

            ORG     $1000

START: 

            JSR     INIT                    ; INITIALIZE SCREEN
            MOVE.W  #SCRWIDTH/2,D1          ; X SCREEN CENTER
            MOVE.W  #SCRHEIGH/2,D2          ; Y SCREEN CENTER
            MOVE.W  #CIRCDIAM,D3            ; CIRCLE DIAMETER
            MOVE.B  #CIRGCHAN,D0            ; CIRCLE GREEN CHANNEL
            MOVE.L  #ADDR,A0                ; PLACE TOGGLE BUTTON ADDR INTO A0
.LOOP       MOVE.L  #COLGREEN,D4            ; SET GREEN COLOR
            BTST.B  #0,(A0)
            BNE     .DOIT
            MOVE.L  #COLRED,D4           ; SET GREEN COLOR
.DOIT       JSR     DRCIRCLE
            BRA     .LOOP

            

            SIMHALT


* -----------------------------------------------------------------------------
INIT
* Mostra la finestra
* -----------------------------------------------------------------------------
            MOVE.L  #SCRWIDTH<<16|SCRHEIGH,D1
            MOVE.B  #33,D0
            TRAP    #15                     ; SET RESOLUTION
            MOVE.L  #1,D1
            TRAP    #15                     ; SET WINDOWED MODE
            RTS

; -----------------------------------------------------------------------------
DRCIRCLE
; Draws a circle with diameter D3.W centered at D1.W, D2.W. The fill color is
; R=0, B=0 and G=D0.B and the border color is white.
; Input    - D0.B - Fill color green channel value.
;            D1.W - Circle center X coordinate.
;            D2.W - Circle center Y coordinate.
;            D3.W - Circle diameter.
; Output   - None
; Modifies - Nothing
; -----------------------------------------------------------------------------
            MOVEM.L D1-D6,-(A7)             ; STORE REGISTERS
            
            MOVE.W  D1,D6                   ; STORE D1
            MOVE.L  D4,D1
*            ROL.W   #8,D1                   ; PUT THE GREEN CHANNEL
*           AND.L   #$COLGREEN,D1           ; MASK IT
            MOVE.B  #81,D0
            TRAP    #15                     ; DEFINE FILL COLOR

*            MOVE.L  #COLGREEN,D1           ; WHITE COLOR
            MOVE.B  #80,D0
            TRAP    #15                     ; DEFINE CONTOUR COLOR
            
            MOVE.W  D6,D1                   ; RESTORE D1
            MOVE.W  D3,D5                   ; COPY THE VALUE TO D5
            LSR.W   #1,D5                   ; COMPUTE HALF THE DIAMETER
            MOVE.W  D1,D3                   ; PREPARE XRIGHT
            MOVE.W  D2,D4                   ; PREPARE YRIGHT
            ADD.W   D5,D3                   ; COMPUTE XRIGHT
            ADD.W   D5,D4                   ; COMPUTE YRIGHT
            NEG.W   D5                      ; CONVERT TO NEGATIVE
            ADD.W   D5,D1                   ; COMPUTE XLEFT
            ADD.W   D5,D2                   ; COMPUTE YLEFT
            MOVE.B  #88,D0                  ; DRAW ELLIPSE TASK NUMBER
            TRAP    #15                     ; DRAW IT
            MOVEM.L (A7)+,D1-D6             ; RESTORE REGISTERS
            RTS
      
    SIMHALT             
    END    START        

*~Font name~Fixedsys~
*~Font size~9~
*~Tab type~1~
*~Tab size~4~
