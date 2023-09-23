*-----------------------------------------------------------
* Titulo     : P1 (2022-2023) - Caesar Cipher
* Autores    : Blanca Atienzar y Weiyu Chen
*-----------------------------------------------------------
            ORG     $1000
DISP:       EQU     3
DICT_SIZE:  EQU     5
DICT_IN:    DC.B    'ABCDE'   
DICT_OUT:   DS.B    DICT_SIZE 
TEXT_SIZE:  EQU     26
TEXT_IN:    DC.B    'ESTRUCTURA DE COMPUTADORES'
TEXT_OUT:   DS.B    TEXT_SIZE
NCHANGES:   DS.W    1
            DS.W    0    
*-----------------------------------------------------------

START:          *iniciar DICT_OUT
                     
            LEA.L       DICT_IN, A0         
            MOVEA.L     #0,A1               
            ADDA.L      #DISP, A1           
                    
LOOP_INTRO1_DICT_OUT:            
                *introducimos en orden las primeras letra de DICT_IN
                *segun el desplazamiento
            MOVE.B      (A0)+,DICT_OUT(A1)  
            ADDA.L      #1,A1  

            CMPA.L      #DICT_SIZE,A1
            BLO         LOOP_INTRO1_DICT_OUT
            
                *introducimos letra restantes de DICT_IN, 
                *a las letras por cubrir de DICT_OUT

            MOVEA.L     #0, A1              
  
LOOP_INTRO2_DICT_OUT:
            MOVE.B      (A0)+,DICT_OUT(A1)
            ADDA.L      #1,A1  

            CMPA.L      #DISP,A1            
            BLO         LOOP_INTRO2_DICT_OUT
            
*-----------------------------------------------------------

                *Obtener TEXT_OUT
                *Inicialización LOOP2
            CLR         NCHANGES
            MOVEA.L     #0,A0
            
            MOVE.W      #TEXT_SIZE,D0
            SUBQ.B      #1,D0
            
LOOP_TEXT_OUT:          
                *inicialización LOOP2_1
            MOVE.W      #DICT_SIZE,D1
            MOVE.B      TEXT_IN(A0),D2
            SUBQ.B      #1,D1
            MOVEA.L     #0, A1
            
                *ver si la letra existe en DICT_IN
            
LOOP_VER_LETRA: 
            MOVE.B      DICT_IN(A1),D3
            CMP         D3,D2
            BEQ         IN_TEXT_OUT
            
            ADDA.L      #1,A1
            DBRA        D1,LOOP_VER_LETRA
            
                *Si sale del bucle es que no existe entonces
                *vamos a introducir la letra directamente en 
                *text_out
            MOVE.B      TEXT_IN(A0),TEXT_OUT(A0)
            BRA         SALIDA
            
IN_TEXT_OUT:
                *introduce al TEXT_OUT la letra del DICT_OUT ya 
                *que vio que la letra del TEXT_IN existe en DICT_IN
            MOVE.B      DICT_OUT(A1),TEXT_OUT(A0)
            ADDQ.W      #1, NCHANGES            
SALIDA:     
            ADDA.L      #1,A0
            
            DBRA        D0,LOOP_TEXT_OUT
            
    SIMHALT             ; halt simulator

* Put variables and constants here

    END    START        ; last line of source











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
