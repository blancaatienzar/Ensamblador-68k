*-----------------------------------------------------------
* Title      : PRAFIN23
* Written by : Weiyu Chen y Blanca Atienzar
* Date       : 19/05/2023
* Description: Emulador de la HAL9000
*-----------------------------------------------------------
    ORG $1000
EMEM:   DC.W $E082,$E09B,$E0B4,$E01D,$2020,$C006,$2031,$C017,$F160
        DC.W $F170,$CE70,$3040,$EFFD,$501E,$4008,$8000,$0001
        DC.W $0001,$0001,$0001,$0001,$0001,$0000,$0000,$0000
EIR:    DC.W 0 ;eregistro de instruccion
EPC:    DC.W 0 ;econtador de programa
ET0:    DC.W 0 ;eregistro T0
ET1:    DC.W 0 ;eregistro T1
EX2:    DC.W 0 ;eregistro X2
EX3:    DC.W 0 ;eregistro X3
EX4:    DC.W 0 ;eregistro X4
EX5:    DC.W 0 ;eregistro X5
EX6:    DC.W 0 ;eregistro X6
EX7:    DC.W 0 ;eregistro X7
ESR:    DC.W 0 ;eregistro de estado (00000000 00000CNZ)

START:
    CLR.W EPC

FETCH:
    ;--- IFETCH: INICIO FETCH
        ;*** En esta seccion debeis introducir el codigo necesario para cargar
        ;*** en el EIR la siguiente instruccion a ejecutar, indicada por el EPC,
	    ;*** y dejar listo el EPC para que apunte a la siguiente instruccion
	
	        ; ESCRIBID VUESTRO CODIGO AQUI	
	        
	    MOVEA.W  EPC,A0 *Guardar la posición instrucción a ejecutar
        ADDA.W   A0,A0  *Obtener la posición en memoria
        MOVE.W   EMEM(A0),EIR *Guardar instrucción en EIR
        ADDQ.W   #1,EPC

            
    ;--- FFETCH: FIN FETCH
    
    
    
    ;--- IBRDECOD: INICIO SALTO A DECOD
        ;*** En esta seccion debeis preparar la pila para llamar a la subrutina
        ;*** DECOD, llamar a la subrutina, y vaciar la pila correctamente,
        ;*** almacenando el resultado de la decodificacion en D1

    	    ; ESCRIBID VUESTRO CODIGO AQUI    	    
    	    
        SUB.W   #2,SP 
        MOVE.W  EIR,-(SP) *Poner EIR en pila(parametro de entrada)
        JSR DECOD
        ADDQ.W  #2,SP
        MOVE.W  (SP)+,D1 *Sacar el resultado de la pila	    
                
        MOVE.W EIR,D0 *Introducir en D0 la instrucción
            
    ;--- FBRDECOD: FIN SALTO A DECOD
    
    
    
    
    ;--- IBREXEC: INICIO SALTO A FASE DE EJECUCION
        ;*** Esta seccion se usa para saltar a la fase de ejecucion
        ;*** NO HACE FALTA MODIFICARLA
    MULU #6,D1
    MOVEA.L D1,A1
    JMP JMPLIST(A1)
JMPLIST:
    JMP ELOA
    JMP ESTO
    JMP ELOIP
    JMP ESTIP
    JMP EGOI
    JMP EGOZ
    JMP EGON
    JMP EEXIT
    JMP ECOPY
    JMP EADD
    JMP ESUB
    JMP EAND
    JMP ESET
    JMP EADQ
    JMP ELSH
    ;--- FBREXEC: FIN SALTO A FASE DE EJECUCION
    
    
    
    ;--- IEXEC: INICIO EJECUCION
        ;*** En esta seccion debeis implementar la ejecucion de cada einstr.
	
	; ESCRIBID EN CADA ETIQUETA LA FASE DE EJECUCION DE CADA INSTRUCCION
ELOA:
            *Acción:            Ti <-- [M]
            *Codificación:      0000 xxx mmmm mmmm i
            *Flags a cambiar:   Z y N

            *Obtener dirección M
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerM
            MOVE.W (SP)+,D1 *Resultado de la pila: posición de M
            MULU.W #2,D1 *Obtener dirección efectiva
            MOVEA.L D1,A0 
            
            *Obtener dato de la dirección M
            *desde la dirección del EMEM
            MOVE.W EMEM(A0),D1 *D1 contiene el dato a introducir en Ti
            
            *Ver que eregistro T introducir el dato
            BTST #0,D0 
            BEQ esET0_1
            BNE esET1_1
    esET0_1:
            MOVE.W D1,ET0 *Introducir dato en ET0
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ 
            JMP SALIR1 
    esET1_1:
            MOVE.W D1,ET1 *Introducir dato en ET1
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ 
    SALIR1:
            *Actualizar los flags del HAL9000
            MOVE.W (SP)+,ESR 
                
            JMP FETCH
            
ESTO:
            *Acción:            M <-- [Ti]
            *Codificación:      0001 xxx mmmm mmmm i
            *Flags a cambiar:   Ninguna
            
            *Obtener dato de la dirección M
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerM
            MOVE.W (SP)+,D1 *Resultado de la pila: posición de M
            MULU.W #2,D1 *Obtener dirección efectiva a buscar el dato

            MOVEA.W D1,A0 *dirección M en 'A0' para indexado básico
            
            *Ver cual es el Eregistro T proviene el dato y introducir
            BTST #0,D0 
            BEQ esET0_2
            BNE esET1_2
    esET0_2:
            MOVE.W ET0,EMEM(A0) *A0 contiene la direccion efectiva de M
            JMP SALIR2 
    esET1_2:
            MOVE.W ET1,EMEM(A0) *A0 contiene la direccion efectiva de M
    SALIR2:
            JMP FETCH
            
ELOIP:
            *Acción1:           Ti <-- [[Xb]]
            *Acción2:           Xb <-- [Xb] + 1
            *Codificación:      0010 xxxxx bbb xxx i
            *Flags a cambiar:   Z y N
            
            *Acción1
            *Calcular el Eregistro Xb
            SUBQ.L #2,SP 
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
                
            *Obtener la dirección efectiva del contenido de Rb
            MOVE.W (A0),D1
            MULU.W #2,D1
            MOVEA.W D1,A1
            
            *Ver que eregistro T introducir el dato
            BTST #0,D0 
            BEQ esET0_3
            BNE esET1_3
    esET0_3:
            MOVE.W EMEM(A1),ET0 *Introducir dato en ET0
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ
            JMP SALIR3 
    esET1_3:
            MOVE.W EMEM(A1),ET1 *Introducir dato en ET1
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ
    SALIR3: 
            *Actualizar los flags del HAL9000
            MOVE.W (SP)+,ESR 
            
            *Acción2
            *Incrementar contenido de Eregistro
            ADDQ.W #1,(A0) *A0 es la dirección del Eregistro
    
            JMP FETCH
            
ESTIP:
            *Acción1:           [Xb] <-- [Ti]
            *Acción2:           Xb <-- [Xb] + 1
            *Codificación:      0011 xxxxx bbb xxx i
            *Flags a cambiar:   Ninguna
            
            *Acción1
            *Calcular el Eregistro Rb
            SUBQ.L #2,SP 
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
            
            *Obtener la dirección de el contenido de Rb
            MOVE.W (A0),D1
            MULU #2,D1
            MOVEA.W D1,A1
            
            *Ver que eregistro T introducir el dato
            BTST #0,D0
            BEQ esET0_4
            BNE esET1_4
    esET0_4:
            MOVE.W ET0,EMEM(A1) *Realizar [A0] <- [ET0]
            JMP SALIR4
    esET1_4:
            MOVE.W ET1,EMEM(A1) *Realizar [A0] <- [ET1]
    SALIR4:
            *Acción2
            *Incrementar Eregistro Xb
            ADDQ.W #1,(A0) *A0 es la dirección del Eregistro

            JMP FETCH
            
EGOI:
            *Acción:            PC <-- M
            *Codificación:      0100 xxx mmmm mmmm i
            *Flags a cambiar:   Ninguna
            
            *Obtener dirección M
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerM
            MOVE.W (SP)+,D1 *Poner la dirección M en 'D1'
            
            MOVE.W D1,EPC
            
            JMP FETCH
            
EGOZ:
            *Acción:            Si Z = 1, PC <-- M
            *Codificación:      0101 xxx mmmm mmmm i
            *Flags a cambiar:   Ninguna
            
            MOVE.W ESR,D1 *Para que el BTST trabaje en modo long
            
            BTST #0,D1 *Test flag Z
            BEQ SALIR5
            
            *Obtener dirección M
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerM
            MOVE.W (SP)+,D1 *Poner la dirección M en 'D1'
            
            MOVE.W D1,EPC
    SALIR5:
            JMP FETCH
            
EGON:
            *Acción:            Si N = 1, PC <-- M
            *Codificación:      0101 xxx mmmm mmmm i
            *Flags a cambiar:   Ninguna
            
            MOVE.W ESR,D1 *Para que el BTST trabaje en modo long
            
            BTST #1,D1  *Test flag N
            BEQ SALIR6
            
            *Obtener dirección M
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerM
            MOVE.W (SP)+,D1 *Poner la dirección M en 'D1'
            
            MOVE.W D1,EPC
    SALIR6:
            JMP FETCH
            
EEXIT:
            SIMHALT             ; halt simulator
            
ECOPY:
            *Acción:            Rc <-- [Rb]
            *Codificación:      11000 xxxx bbb x ccc
            *Flags a cambiar:   Z y N
            
            *Calcular el Eregistro Rb
            SUBQ.L #2,SP 
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rc
            SUBQ.L #2,SP
            MOVE.W #0,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A1 *Obtener direción del eregistro
            
            MOVE.W (A0),(A1) *Introducir dato en Rc
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ 
            MOVE.W (SP)+,ESR *Actualizar flags HAL9000

            JMP FETCH
            
EADD:
            *Acción:            Rc <-- [Rb] + [Ra]
            *Codificación:      11001 aaa x bbb x ccc
            *Flags a cambiar:   C, N y Z
            
            *Calcular el Eregistro Ra
            SUBQ.L #2,SP 
            MOVE.W #8,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rb
            SUBQ.L #2,SP 
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A1 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rc
            SUBQ.L #2,SP 
            MOVE.W #0,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A2 *Obtener direción del eregistro
            
            *Sumar valores
            MOVE.W (A0),D1 *D1 contiene, valor del eregistro Ra
            MOVE.W (A1),D2 *D2 contiene, valor del eregistro Rb
            ADD.W D1,D2
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagCNZ 
            MOVE.W (SP)+,ESR *Actualizar flags HAL9000
            
            MOVE.W D2,(A2) *Introducir el valor sumado a Rc
            
            JMP FETCH
            
ESUB:
            *Acción:            Rc <-- [Rb] - [Ra]
            *Codificación:      11010 aaa x bbb x ccc
            *Flags a cambiar:   C, N y Z
            
            *Calcular el Eregistro Ra
            SUBQ.L #2,SP 
            MOVE.W #8,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rb
            SUBQ.L #2,SP
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A1 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rc
            SUBQ.L #2,SP 
            MOVE.W #0,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A2 *Obtener direción del eregistro
            
            *Sumar valores
            MOVE.W (A0),D1 *D1 contiene, valor del eregistro Ra
            MOVE.W (A1),D2 *D2 contiene, valor del eregistro Rb
            
            *Restar valores == A - B = A + (B' + 1)
                *Paso 1 de la resta, negar Ra
            NOT.W D1
            
                *Paso 2 Incrementar 1 el Ra
            ADDQ.W #1,D1
            
                *Paso 3 sumar los valores
            ADD.W D1,D2
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagCNZ 
            MOVE.W (SP)+,ESR *Actualizar flags HAL9000
            
            MOVE.W D2,(A2) *Introducir el valor restado a Rc
            
            JMP FETCH
            
EAND:
            *Acción:            Rc <-- [Rb] and [Ra]
            *Codificación:      11011 aaa x bbb x ccc
            *Flags a cambiar:   C, N y Z
            
            *Calcular el Eregistro Ra
            SUBQ.L #2,SP 
            MOVE.W #8,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rb
            SUBQ.L #2,SP 
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A1 *Obtener direción del eregistro
                
            *Calcular el Eregistro Rc
            SUBQ.L #2,SP 
            MOVE.W #0,-(SP) *Introducir parametro 2 de subrutina verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A2 *Obtener direción del eregistro
            
            *Sumar valores
            MOVE.W (A0),D1 *D1 contiene, valor del eregistro Ra
            MOVE.W (A1),D2 *D2 contiene, valor del eregistro Rb
            
            AND D1,D2
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ 
            MOVE.W (SP)+,ESR *Actualizar flags HAL9000
         
            MOVE.W D2,(A2) *Introducir el valor restado a Rc

            JMP FETCH
            
ESET:
            *Acción:            Rc <-- k (Ext. signo)
            *Codificación:      11100 kkkk kkkk ccc
            *Flags a cambiar:   N y Z
            
            *Calcular el Eregistro Rc
            SUBQ.L #2,SP 
            MOVE.W #0,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
            
            *Obtener dato k
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerK
            MOVE.W (SP)+,D1 *Poner valor de k en 'D1'
            EXT D1 
            
            MOVE.W D1,(A0) *Introducir datos al Eregistro
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagNZ 
            MOVE.W (SP)+,ESR *Actualizar flag HAL9000

            JMP FETCH
            
EADQ:
            *Acción:            Rc <-- [Rc] + k (Ext. signo)
            *Codificación:      11101 kkkk kkkk ccc
            *Flags a cambiar:   C, N y Z
            
            *Calcular el Eregistro Rc
            SUBQ.L #2,SP 
            MOVE.W #0,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
            
            MOVE.W (A0),D1 *Obtener dato de Rc
            
            *Obtener dato k
            MOVE.W D0,-(SP) *Introducir instrucción en la pila
            JSR obtenerK
            MOVE.W (SP)+,D2 *Poner valor de k en 'D2'
            EXT D2 
            
            ADD.W D2,D1 *Sumar los valores k y Rc
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagCNZ 
            MOVE.W (SP)+,ESR *Actualizar flags HAL9000
             
            MOVE.W D1,(A0) *Introducir valor calculado a Rc

            JMP FETCH
            
ELSH:
            *Acción:            Rc <-- [Rc] + k (Ext. signo)
            *Codificación:      11110 ppp x bbb xxx n
            *Flags a cambiar:   C, N y Z
            
            *Calcular el P
            MOVE.W D0,D1 *Realizar copia de la instrucción
            AND.W #$0700,D1 *Realizar una mascara
            LSR.W #8,D1 *Mover los datos a los menos significativos
 
            *Calcular el Eregistro Rb
            SUBQ.L #2,SP
            MOVE.W #4,-(SP) *Introducir parametro 2 de verEregistro
            JSR verEregistro
            MOVEA.L (SP)+,A0 *Obtener direción del eregistro
            MOVE.W (A0),D2 *Obtener dato de Rb

            *D0 contiene la instruccion
            BTST #0,D0
            BEQ nes0
            BNE nes1
            
    nes0:
            LSL.W D1,D2
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagCNZ 
            JMP SALIR7
    nes1:
            LSR.W D1,D2
            
            MOVE.W SR,-(SP) *Introducir flags del 68k a la pila
            JSR cambioFlagCNZ 
    SALIR7:
            MOVE.W (SP)+,ESR *Actualizar flags HAL9000
            
            MOVE.W D2,(A0) *Introducir el valor Rb a Rb
            
            JMP FETCH
            
    ;--- FEXEC: FIN EJECUCION
    
    

    ;--- ISUBR: INICIO SUBRUTINAS
        ;*** Aqui debeis incluir las subrutinas que necesite vuestra solucion
        ;*** SALVO DECOD, que va en la siguiente seccion

	        ; ESCRIBID VUESTRO CODIGO AQUI
obtenerM:
            *Subrutina para obtener M de las instruciones
            *se debe introducir la instrucción los 8 pimeros bits de la pila
            
            MOVE.W D0,-(SP)
            
            MOVE.W 6(SP),D0 *Isntrucción en D0
            AND.W #$01FE,D0 
            LSR.W #1,D0 
            MOVE.W D0,6(SP) *Obtenido dirección M

            MOVE.W (SP)+,D0
            
            RTS
            
obtenerK:
            *Subrutina para obtener K de las instruciones
            
            *se debe introducir la instrucción los 8 pimeros bits de la pila

            MOVE.W D0,-(SP)
            
            MOVE.W 6(SP),D0 *Isntrucción en D0
            AND.W #$07F8,D0 
            LSR.W #3,D0 
            MOVE.W D0,6(SP) *Obtenido dirección K
            
            MOVE.W (SP)+,D0
            
            RTS
            
cambioFlagNZ:
            *Subrutina para cambio de flag N y Z
            *se debe introducir el SR en los 8 primeros bits
            
            MOVE.W D0,-(SP)
            MOVE.W D1,-(SP)
            MOVE.W D2,-(SP)
            CLR D1 *limpiar el contenido de D1
            

            MOVE.W 10(SP),D0 *Obtener el flag de 68K de la pila
            MOVE.W ESR,D2 * Para que el BTST trabaje en tipo long
            
            BTST #2,D2
            BEQ Ces0_1 *Saltar si anteriormente C = 0
            BSET #2,D1
    Ces0_1: 
            BTST #3,D0 *ver el flag N del 68K
            BEQ Nes0_1 *Saltar si N = 0
            BSET #1,D1
    Nes0_1: 
            BTST #2,D0 *Ver el flag Z del 68K
            BEQ Zes0_1 *Saltar si Z = 0
            BSET #0,D1
    Zes0_1:
            *Introducir valor del flag calculado
            MOVE.W D1,10(SP)
            
            MOVE.W (SP)+,D2
            MOVE.W (SP)+,D1
            MOVE.W (SP)+,D0
            
            RTS
            
cambioFlagCNZ:
            *Subrutina para cambio de flag C, N y Z
            
            *se debe introducir el SR en los 8 primeros bits
            
            MOVE.W D0,-(SP)
            MOVE.W D1,-(SP)
            CLR D1 *limpiar el contenido de D1

            MOVE.W 8(SP),D0 *Obtener el flag de 68K de la pila
            
            BTST #0,D0 *Ver el flag C del 68K
            BEQ Ces0_2 *Saltar si C = 0
            BSET #2,D1
    Ces0_2: 
            BTST #3,D0 *ver el flag N del 68K
            BEQ Nes0_2 *Saltar si N = 0
            BSET #1,D1
    Nes0_2:
            BTST #2,D0 *Ver el flag Z del 68K
            BEQ Zes0_2 *Saltar si Z = 0
            BSET #0,D1
    Zes0_2:
            *Introducir valor del flag calculado
            MOVE.W D1,8(SP)
            
            MOVE.W (SP)+,D1
            MOVE.W (SP)+,D0
            
            RTS
            
verEregistro:
            *Subrutina para ver el eregistro
            *1 Reservar tamaño word
            *2 Introducir tipo de eregistro, a(8),b(4),c(0) a la pila
            
            MOVE.W D0,-(SP)
            MOVE.W D1,-(SP)
            MOVE.W D2,-(SP)
            
            MOVE.W 10(SP),D1 *Tipo de registro en la instrucción
            CLR D2
            
            *Calcular el eregistro
            BTST D1,D0 *Ver el bit 1
            BEQ bit1Es0 
            BSET #0,D2 *set bit 0 si es 1
    bit1Es0:
            ADDQ.B #1,D1 *Para ir al siguiente bit en el BTST
    
            BTST D1,D0 *Ver el bit 2
            BEQ bit2Es0 
            BSET #1,D2 *set bit 1 si es 1
    bit2Es0:
            ADDQ.B #1,D1 *Para ir al siguiente bit en el BTST
    
            BTST D1,D0 *Ver el bit 3
            BEQ bit3Es0 
            BSET #2,D2 *set bit 2 si es 1
    bit3Es0:            
            *Ver tipo de eregistro
            CMP.W #0,D2
            BEQ esET0
            
            CMP.W #1,D2
            BEQ esET1
            
            CMP.W #2,D2
            BEQ esEX2
            
            CMP.W #3,D2
            BEQ esEX3
            
            CMP.W #4,D2
            BEQ esEX4
            
            CMP.W #5,D2
            BEQ esEX5
            
            CMP.W #6,D2
            BEQ esEX6
            
            CMP.W #7,D2
            BEQ esEX7
            
            *Obtener la dirección del eregistro
                *La instrucción PEA introduce la dirección de
                *etiqueta a la pila
    esET0:  
            PEA ET0
            BRA SALIR8
            
    esET1:  
            PEA ET1
            BRA SALIR8
            
    esEX2:    
            PEA EX2
            BRA SALIR8
    
    esEX3:    
            PEA EX3
            BRA SALIR8
    
    esEX4:    
            PEA EX4
            BRA SALIR8

    esEX5:    
            PEA EX5
            BRA SALIR8
    
    esEX6:    
            PEA EX6
            BRA SALIR8
    
    esEX7:    
            PEA EX7
            
    SALIR8:
            MOVE.L (SP)+,D1
            MOVE.L D1,10(SP)
            
            *Recuperar valor de registro
            MOVE.W (SP)+,D2
            MOVE.W (SP)+,D1
            MOVE.W (SP)+,D0
            
            RTS
        
    ;--- FSUBR: FIN SUBRUTINAS
    
    

    ;--- IDECOD: INICIO DECOD
        ;*** Tras la etiqueta DECOD, debeis implementar la subrutina de 
        ;*** decodificacion, que debera ser de libreria, siguiendo la interfaz
        ;*** especificada en el enunciado
DECOD:
        ; ESCRIBID VUESTRO CODIGO AQUI    
        
        MOVE.W  D0,-(SP)
        MOVE.W  D1,-(SP)
        SUBQ.W  #2,SP
        CLR.W   (SP)
        
        MOVE.W  10(SP),D0 *D0 contiene la einstruccion
        
        *Comprobacion bit a bit, desde el mas significativo
        BTST.L  #15,D0
        BEQ E0
       
        E1:         
                BTST.L  #14,D0
                BEQ E10 
        E11: 
                BTST.L  #13,D0
                BEQ E110
        E111:   
                BTST.L  #12,D0
                BEQ E1110
        E1111:  *ELSH
                MOVE.W  #14,D1
                BRA FIN
        E1110: 
                BTST.L  #11,D0
                BEQ E11100
        E11101: *EADQ
                MOVE.W  #13,D1
                BRA FIN
        E11100: *ESET
                MOVE.W  #12,D1
                BRA FIN
        E110: 
                BTST.L  #12,D0
                BEQ E1100
        E1101: 
                BTST.L  #11,D0
                BEQ E11010
        E11011: *EAND
                MOVE.W  #11,D1
                BRA FIN
        E11010: *ESUB
                MOVE.W  #10,D1
                BRA FIN
        E1100: 
                BTST.L  #11,D0
                BEQ E11000
        E11001: *EADD
                MOVE.W  #9,D1
                BRA FIN
        E11000: *ECOPY
                MOVE.W  #8,D1
                BRA FIN
        E10:    *EEXIT
                MOVE.W  #7,D1
                BRA FIN
        E0: 
                BTST.L  #14,D0
                BEQ E00
        E01: 
                BTST.L  #13,D0
                BEQ E010
        E011:   *EGON
                MOVE.W  #6,D1
                BRA FIN
        E010: 
                BTST.L  #12,D0
                BEQ E0100
        E0101:  *EGONZ
                MOVE.W  #5,D1
                BRA FIN
        E0100:  *EGOI
                MOVE.W  #4,D1
                BRA FIN
        E00:    
                BTST.L  #13,D0
                BEQ E000
        E001: 
                BTST.L  #12,D0
                BEQ E0010 
        E0011:  *ESTIP
                MOVE.W  #3,D1
                BRA FIN
        E0010:  *ELOIP
                MOVE.W  #2,D1
                BRA FIN
        E000: 
                BTST.L  #12,D0
                BEQ E0000
        E0001:  *ESTO
                MOVE.W  #1,D1
                BRA FIN
        E0000:  *ELOA
                MOVE.W  #0,D1
                BRA FIN    
        FIN:
                ADD.W  D1,(SP) *D1 contiene el id de la instruccion
                MOVE.W  (SP),12(SP) *Pasamos el id al parametro de salida
                ADDQ.W  #2,SP
                MOVE.W  (SP)+,D1
                MOVE.W  (SP)+,D0
                RTS

    ;--- FDECOD: FIN DECOD
    END    START















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
