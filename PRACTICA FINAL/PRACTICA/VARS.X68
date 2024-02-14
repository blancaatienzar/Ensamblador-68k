; ==============================================================================
; GAME VARIABLES
; ==============================================================================
   
; --- GAME STATE RELATED VARIABLES --------------------------------------------

STACUR      DS.W    1                       ; ESTADO ACTUAL DEL JUEGP
STANEXT     DS.W    1                       ; SIGUENTE ESTADO DEL JUEGO
     
; --- VARIABLES RELATIVAS AL USUARIO -------------------------------------------

USUPOSY     DS.W    1                       ; POSICION Y USUARIO
USUPOSX     DS.W    1                       ; POSICION X USUARIO
USUVELY     DS.W    1                       ; VELOCIDAD X USUARIO

; --- VARIABLES RELATIBAS AL OBSTACULO -----------------------------------------

TRIPOSX     DS.W    1                       ; POSICION X OBSTACULO 
TRIVELX     DS.W    1                       ; VELOCIDAD X OBSTACULO 
TRIPOSY     DS.W    1                       ; POSICION Y OBSTACULO 

; --- VARIABLES RELATIBAS AL PLATAFORMA-----------------------------------------

PLATPOSX     DS.W    1                      ; POSICION X PLATAFORMA
PLATVELX     DS.W    1                      ; VELOCIDAD X PLATAFORMA
PLATPOSY     DS.W    1                      ; POSICION Y PLATAFORMA

; --- VARIABLES RELATIBAS AL SUELO ---------------------------------------------

RECPOSX     DS.W    1                       ; POSICION X SUELO
RECPOSY     DS.W    1                       ; POSICION Y SUELO

; --- VARIABLES RELATIBAS AL TECLADO -------------------------------------------

SCOIN       DS.W    1                       ; Nº DE SALTOS
SCOOUT      DS.W    1                       ; Nº DE INTENTOS

; --- VARIABLES RELATIBAS AL TECLADO -------------------------------------------

NWFLOOR     DS.W    1                       ; SUELO IMAGINARIO COORDENADAS X
NWJUMP      DS.W    1                       ; TECHO IMAGINARIO COORDENADAS X

; --- VARIABLES RELATIVAS AL PUNTUAJE -------------------------------------------

SCOPOSX     DS.W    1                       ; POSICION Y PUNTUAJE
SCOVELY     DS.W    1                       ; VELOCIDAD Y PUNTUAJE

; --- INTRO STATE RELATED VARIABLES --------------------------------------------

ISCTIMER    DS.W    1                       ; TIEMPO DE LA INTRODUCCION

; --- INSTRUCTIONS STATE RELATED VARIABLES -------------------------------------

INSTIMER    DS.W    1                       ; TIEMPO DE LAS INTRUCCIONES

; --- VARIABLES RELATIVAS AL USUARIO -------------------------------------------

MAPPOSX     DS.W    1                       ; POSICION X MAPA
MAPVELX     DS.W    1                       ; VELOCIDAD X MAPA

; --- VARIABLES RELATIVAS AL USUARIO -------------------------------------------

INTROPOSY     DS.W    1                       ; POSICION X MAPA
INTROVELY     DS.W    1                       ; VELOCIDAD X MAPA

; --- FPS -------------------------------------------------------------
TIME        DS.L      1
FPSREAL     DS.L      1
FPSCOUNT    DS.L      1












*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
