; -------------------------------------------------------------------------------
* Title      : PRACTICA FINAL ESTRUCTURA DE COMPUTADORS II
* Written by : Blanca Atienzar Martinez y Hai Zi Bibiloni Trobat
* Date       : 30/01/2024
* Description: Simplificacion del videojuego Gemotry Dash
*-------------------------------------------------------------------------------
; ==============================================================================

            ORG     $1000
            
            INCLUDE "CONST.X68"
            INCLUDE "SYSCONST.X68"
            INCLUDE "LIB/DMMCONST.X68"
            INCLUDE "LIB/DMMCODE.X68"
            INCLUDE "SYSTEM.X68"
            INCLUDE "RECTA.X68"
            INCLUDE "TRIANGULO.X68"
            INCLUDE "MAP.X68"
            INCLUDE "DATA/PICTURE.X68"
            INCLUDE "USUARIO.X68"
            INCLUDE "SCORE.X68"
            INCLUDE "PLATAFORMA.X68"
            INCLUDE "STATES.X68"
            INCLUDE "LIB/UTLCONST.X68"
            INCLUDE "LIB/UTLCODE.X68"
            INCLUDE "INTRO.X68"
            INCLUDE "GAME.X68"
            INCLUDE "INSTRUCCIONS.X68"
            INCLUDE "WIN.X68"

           
START

; --- INICIALIZACION -----------------------------------------------------------

            ORI.W   #$0700,SR
            
            JSR     SYSINIT            
            JSR     STAINIT
            JSR     UTLINIT            
            
            ; INICIALIZAMOS FRAMES POR SEGUNDO
            CLR.L   (FPSCOUNT)
            MOVE.L  #FPSGOAL,(FPSREAL)
            
            ; OBTENEMOS TIEMPO
            MOVE.B  #8,D0                   
            TRAP    #15
            MOVE.L  D1,(TIME)
           
.LOOP

; --- ACTUALIZACION -------------------------------------------------------------------

; LEER DISPOSITIVOS DE ENTRADA
            TRAP    #1

; ACTUALIZACION LOGICA DEL JUEGO
            
            JSR     STAUPD

; --- SYNC ---------------------------------------------------------------------

            ; ESTRATEGIA DE SINCRONIZACIÓN 
            MOVE.B  #23,D0
            MOVE.L  #1,D1
            TRAP    #15
           
; --- PLOT ---------------------------------------------------------------------
            
            JSR     STAPLOT                       
            TRAP    #0

            ; OBTENEMOS TIEMPO
            MOVE.B  #8,D0                   
            TRAP    #15
            SUB.L   (TIME),D1              
            
            ADDQ.L  #1,(FPSCOUNT)           
            
            ; VEMOS SI HA PASADO 1 SEGUNDO
            CMP.L   #100,D1                 
            BLO     .FRAME
                        
            ; EN ESE CASO ACTUALIZAMOS FPS
            MOVE.L  (FPSCOUNT),(FPSREAL) 

            ; RESETEAMOS CONTADOR   
            CLR.L   (FPSCOUNT)              

            ; RESETEAMOS TIEMPO
            MOVE.B  #8,D0                   
            TRAP    #15
            MOVE.L  D1,(TIME)
      
                        
.FRAME      BRA     .LOOP

            SIMHALT
            
            INCLUDE "VARS.X68"
            INCLUDE "SYSVARS.X68"
            INCLUDE "LIB/UTLVARS.X68"
            INCLUDE "LIB/DMMVARS.X68"

            END     START















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
