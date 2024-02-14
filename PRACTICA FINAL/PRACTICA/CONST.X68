; ==================================================================================
; GAME CONSTANTS
; ==================================================================================

             INCLUDE     "SYSCONST.X68"

; --- CONSTANTES RELATIVAS AL FPS --------------------------------------------------

FPSGOAL      EQU     20
GOALINE      EQU     $3801                   ; COORDENADAS DE LA LINEA GOAL            
REALINE      EQU     $4201                   ; COORDENADAS DE LA LINEA REAL

; --- GAME STATES ------------------------------------------------------------------

STANONE      EQU     -1                      ; PLACEHOLDER TO FORCE CHANGE
ISCMAXTM     EQU     500                     ; INTRO SCREEN WATING CYCLES
INSMAXTM     EQU     500                     ; INSTRUCTIONS SCREEN WAITING CYCLES

; --- CONSTANTE RELATIVA AL USUARIO (CUADRDAO) -------------------------------------

USUSPEED     EQU     25                      ; MAGNITUD SOBRE EL DESPLAZAMIENTO DE Y

; --- CONSTANTE RELATIVA AL PLATAFORMA (RECTANGULO) --------------------------------

PLATWIDTH    EQU     128                     ; ANCHO DE LA PLATAFORMA

; --- CONSTANTE RELATIVAS AL MARCADOR ----------------------------------------------

SCOFCOL      EQU     $00000000               ; COLOR TEXTO DEL MARCADOR (BLANCO)
SCOLINE      EQU     $2502                   ; COORDENADAS DE LA LINEA DE INTENTOS
SCOSPEED     EQU     4                       ; MAGNITUD SOBRE EL DESPLAZAMIENTO DE Y

; --- CONSTANTE RELATIVAS AL MAPA Y SU LECTURA DE FICHERO --------------------------

MAP_SIZE     EQU     2520
MAPDATA      DS.B    MAP_SIZE
             DS.W    0      
FNAME        DC.B    'DATA/MAPDATA.bin',0
             DS.W    0
MAPSPEED     EQU     2                      ; MAGNITUD SOBRE EL DESPLAZAMIENTO DE Y
TILWIDTH     EQU     32                     ; ANCHO DE LOS OBJETOS
TILHEIGH     EQU     32                     ; ALTURA DE LOS OBJETOS
NTILWIDT     EQU     126                     ; NUMERO DE TILE ANCHO
NTILHEIG     EQU     15                     ; NUMERO DE TILE ALTO

; --- CONSTANTE RELATIVAS AL INTRO -------------------------------------------------

INTROSPEED   EQU     5                      ; MAGNITUD SOBRE EL DESPLAZAMIENTO DE Y
























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
