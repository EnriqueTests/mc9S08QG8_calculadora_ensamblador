;*******************************************************************
;* This stationery serves as the framework for a user application. *
;* For a more comprehensive program that demonstrates the more     *
;* advanced functionality of this processor, please see the        *
;* demonstration applications, located in the examples             *
;* subdirectory of the "Freescale CodeWarrior for HC08" program    *
;* directory.                                                      *
;*******************************************************************

; Include derivative-specific definitions
            INCLUDE 'derivative.inc'
            
;
; export symbols
;
            XDEF _Startup
            ABSENTRY _Startup

;
; variable/data section
;
            ORG    $60         	; Insert your data definition here
; Suma
M60: DS.B   1
M61: DS.B   1

; Resultado de suma
M62: DS.B   1

; Resta
M63: DS.B   1
M64: DS.B   1

; Resultado de resta
M65: DS.B   1

; Multiplicacion
M66: DS.B   1
M67: DS.B   1

; Resultado de multiplicacion (byte menos significativo)
M68: DS.B   1

; Resultado de multiplicacion (byte mas significativo)
M69: DS.B   1

; Division (detectar 0/0 y x/0)
M6A: DS.B   1
M6B: DS.B   1

; Resultado de division
M6C: DS.B   1

; Residuo de division
M6D: DS.B   1

;
; code section
;
            ORG    ROMStart
            

_Startup:
			LDA	   	#$12			; Inmediato A=$12 hexa, quitar el WATCHDOG
			STA		SOPT1			; Directo, guardar A en SOPT1
			
			; Suma
			MOV		#$01,M60		; Mover a la direccion 60 el valor inmediato 01 en hexadecimal
			MOV		#$19,M61		; Mover a la direccion 61 el valor inmediato 19 en hexadecimal
			LDA		M60				; Cargar en el acumulador el valor de la direccion 60
			ADD		M61				; Sumar el acumulador con el valor de la direccion 61
			STA		M62				; Guardar en la direccion 62 el valor del acumulador
			
			; Resta
			MOV		#$03,M63		; Mover a la direccion 63 el valor inmediato 00 en hexadecimal
			MOV		#$04,M64		; Mover a la direccion 64 el valor inmediato 01 en hexadecimal
			LDA		M63				; Cargar en el acumulador el valor de la direccion 63
			SUB		M64				; Restar el acumulador con el valor de la direccion 64
			STA		M65				; Guardar en la direccion 65 el valor del acumulador
			
			; Multiplicacion
			MOV		#$06,M66		; Mover a la direccion 66 el valor inmediato 06 en hexadecimal
			MOV		#$1F,M67		; Mover a la direccion 67 el valor inmediato 1F en hexadecimal
			LDA		M66				; Cargar en el acumulador el valor de la direccion 66
			LDX 	M67				; Cargar registro X con el valor de la direccion 67
			MUL						; Multiplicacion de A por X, el byte menos significativo se guarda en el acumulador
			STA		M68				; Guardar en la direccion 68 el valor del acumulador
			STX		M69				; Guardar en la direccion 69 el valor del registro X
			
			; Division
			MOV		#$00,M6A		; Mover a la direccion 6A el valor inmediato 0
			MOV		#$00,M6B		; Mover a la direccion 6B el valor inmediato 0
division:							
			LDA		M6A				; Cargar en el acumulador el valor de la direccion 6A
			CBEQ	M6B,iguales		; Compara si son iguales y brinca si lo son
			CBEQA	#$00,num_0		; numerador = 0
			LDX 	M6B				; Cargar registro X con el valor de la direccion 6B	
			CBEQX 	#$00,deno_0		; denominador = 0
operacion:
			DIV						; Multiplicacion de A por X, el byte menos significativo se guarda en el acumulador
			STA		M6C				; Guardar en la direccion 6C el valor del acumulador
			STHX	M6D				; Guardar en la direccion 6D el valor del registro X
			BRA		division		; brincar a etiqueta division
iguales:
			BEQ		division		; 0 / 0
			BRA		operacion		; Realizar la operacion
num_0:
			MOV		#$00,M6C		; Mover a la direccion 6A el valor inmediato 0 (resultado de la division)
			MOV		#$00,M6D		; Mover a la direccion 6B el valor inmediato 0 (residuo de la division)
			BRA		division		; brincar a etiqueta division
deno_0:
			MOV		#$FF,M6C		; Mover a la direccion 6A el valor inmediato 0 (resultado de la division)
			MOV		#$FF,M6D		; Mover a la direccion 6B el valor inmediato 0 (residuo de la division)
			BRA		division		; brincar a etiqueta division
mainLoop:
            ; Insert your code here
            BRA    	mainLoop
			
;**************************************************************
;* spurious - Spurious Interrupt Service Routine.             *
;*             (unwanted interrupt)                           *
;**************************************************************

spurious:				; placed here so that security value
			NOP			; does not change all the time.
			RTI

;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************

            ORG	$FFFA

			DC.W  spurious			;
			DC.W  spurious			; SWI
			DC.W  _Startup			; Reset
