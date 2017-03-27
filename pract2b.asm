;**************************************************************************
; SBM 2017. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
FILA1 DB 4,3,1,2 ;; Primera fila de la matriz
FILA2 DB 1,2,4,3 ;; Segunda fila de la matriz
FILA3 DB 3,1,2,4 ;; Tercera fila de la matriz
FILA4 DB 2,4,3,1 ;; Cuarta fila de la matriz
CONVERSION DB ?
MENSAJE1 DB  "Filas válidas [SI].",10,'$'
MENSAJE2 DB  "Columnas válidas [NO]",10,'$'
MENSAJE3 DB  "Filas válidas [NO].",10,'$'
MENSAJE4 DB  "Filas válidas [NO]. Columnas válidas [NO]",10,'$'
;-- rellenar con los datos solicitados
DATOS ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE PILA
PILA SEGMENT STACK "STACK"
DB 40H DUP (0) ;ejemplo de inicialización, 64 bytes inicializados a 0
PILA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO EXTRA
EXTRA SEGMENT
RESULT DW 0,0 ;ejemplo de inicialización. 2 PALABRAS (4 BYTES)
EXTRA ENDS
;**************************************************************************
; DEFINICION DEL SEGMENTO DE CODIGO
CODE SEGMENT
ASSUME CS: CODE, DS: DATOS, ES: EXTRA, SS: PILA
; COMIENZO DEL PROCEDIMIENTO PRINCIPAL
INICIO PROC
; INICIALIZA LOS REGISTROS DE SEGMENTO CON SU VALOR
MOV AX, DATOS
MOV DS, AX
MOV AX, PILA
MOV SS, AX
MOV AX, EXTRA
MOV ES, AX
MOV SP, 64 ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO
; FIN DE LAS INICIALIZACIONES
; COMIENZO DEL PROGRAMA
MOV CX, 0
PROCESO:
	ADD CX, 4 ;;INICIAMOS CX EN EL SIGUIENTE VECTOR 
	;;;;;;;IMPRIMIMOS LOS CORCHETES;;;;;;;;;;;;;;;;;;;
	mov AH, 2 ; Número de función = 2
	mov DL, '|' ; Se desea imprimir la letra A
	int 21h ; Interrupción software al sistema operativo 
	MOV DI, CX ;;INICIALIZAMOS DI INDICE DEL VECTOR A 0 (RESPECTO AL VECTOR QUE MIRAMOS)
	SUB DI, 4
	;;;;;;;IMPRIMIMOS EL VECTOR;;;;;;;;;;;;;;;;;;;
	COMIENZO:;;COMIENZO DEL BUCLE		
		MOV AH, DS:FILA1[DI];; COMO ES SOLO 1B COGEMOS LA PARTE ALTA DEL CODIGO
		CALL TOASCII ;; LLAMAMOS A LA RUTINA
		MOV AH, 2
		MOV DL, [BX];;
		INT 21H
		ADD DI, 1
		CMP DI, CX
		JNE COMIENZO
	;;;;;;;IMPRIMIMOS LOS CORCHETES;;;;;;;;;;;;;;;;;;;
	mov AH, 2 ; Número de función = 2
	mov DL, '|' ; Se desea imprimir la letra A
	int 21h ; Interrupción software al sistema operativo
	;;;;;;;COMPROBAMOS E IMPRIMIMOS EL MENSAJE DEBIDO;;;;;;;;;;;;;;;;;;;
	
	;;CALL DUPLICADOS
	CMP CX, 16
	JNE PROCESO

;;PASAMOS A IMPRIMIR EL MENSAJE ESPECIFICO

; -- rellenar con las instrucciones solicitadas
; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
	
;_______________________________________________________________ 
; SUBRUTINA PARA CALCULAR EL VALOR ASCII DE UN NUMERO 
; ENTRADA CL=NUMERO, EN AX SUPONEMOS SE ENCUENTRA
; SALIDA DX:BX=RESULTADO
;_______________________________________________________________ 
TOASCII PROC NEAR 
    ADD AH, 30H;;PASAMOS EL NUMERO A ASCII
	MOV CONVERSION, AH
	MOV BX, SEG CONVERSION
	MOV DX, BX
	MOV BX, OFFSET CONVERSION
    RET 
TOASCII ENDP 
;_______________________________________________________________ 
; SUBRUTINA PARA SABER SI HAY DUPLICADOS EN UN VECTOR
; ENTRADA 
;_______________________________________________________________ 
DUPLICADOS PROC 
	INI:
		MOV SI, DI
		SUB SI, 4
		MOV AH, DS:FILA1[SI];; COMO ES SOLO 1B COGEMOS LA PARTE ALTA DEL CODIGO
		CMP AH, 4			  ;; COMPARAMOS SI ES MAYOR QUE 4
		JG ERRGT5  
		CMP AH, 1			  ;; COMPROBAMOS SI ES MENOR QUE 1
		JL ERRGT5
		ADD SI, 1
		MOV AL, DS:FILA1[SI];;CARGAMOS EL SIGUIENTE NUMERO
		CMP AL, 4			 ;;COMPARAMOS SI ES MAYOR QUE 4
		JG ERRGT5
		CMP AL, 1			 ;; COMPROBAMOS SI ES MENOR QUE 1
		JL ERRGT5
		CMP AH, AL			 ;;COMPARAMOS SI SON IGUALES
		JE ERR1
		ADD SI, 1
		MOV BH, DS:FILA1[SI];;CARGAMOS EL SIGUIENTE NUMERO
		CMP BH, 4	         ;;COMPARAMOS SI ES MAYOR QUE 4
		JG ERRGT5
		CMP BH, 1  			 ;; COMPROBAMOS SI ES MENOR QUE 1
		JL ERRGT5
		CMP AH, BH			 ;;COMPROBAMOS IGUALDADES
		JE ERR1
		CMP AL, BH			 
		JE ERR1
		ADD SI, 1
		MOV BL, DS:FILA1[SI];;CARGAMOS EL SIGUIENTE NUMERO
		CMP BL, 4		     ;;COMPROBAMOS SI ES MAYOR QUE 4
		JG ERRGT5
		CMP BL, 1			;; COMPROBAMOS SI ES MENOR QUE 1
		JL ERRGT5
		CMP AH, BL			 ;;COMPROBAMOS IGUALDADES
		JE ERR1
		CMP AL, BL
		JE ERR1
		CMP BH, BL
		JNE OK
		
	ERR1:
		MOV AH, 9
		MOV DX, OFFSET DS:ERROR1
		INT 21H
		RET
	ERRGT5:
		MOV AH, 9
		MOV DX, OFFSET DS:ERROR2
		INT 21H
		RET
	OK:
		MOV AH, 9
		MOV DX, OFFSET DS:CORRECTO
		INT 21H
		RET
DUPLICADOS ENDP	

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 