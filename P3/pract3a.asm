  ;******************************************************************************* 
; CALCULA EL PRODUCTO DEL FACTORIAL DE DOS NUMEROS QUE SE 
; ENCUENTRAN EN LAS POSICIONES DE MEMORIA 0 Y 1 DEL SEGMENTO DE 
; DATOS. EL VALOR DE CADA NUMERO DEBE SER INFERIOR A 9. EL RESULTADO 
; SE ALMACENA EN DOS PALABRAS DEL SEGMENTO EXTRA, EN LA PRIMERA 
; PALABRA EL MENOS SIGNIFICATIVO Y EN LA SEGUNDA EL MAS 
; SIGNIFICATIVO. SE UTILIZA UNA RUTINA PARA CALCULAR EL FACTORIAL. 
;*******************************************************************************

; DEFINICION DEL SEGMENTO DE DATOS 

DATOS SEGMENT 

DATO_1  DB     2
DATO_2  DB     3

DATOS ENDS 


; DEFINICION DEL SEGMENTO DE PILA 

PILA    SEGMENT STACK "STACK" 
    DB   40H DUP (0) 
PILA ENDS 


; DEFINICION DEL SEGMENTO EXTRA 

EXTRA     SEGMENT 
    RESULT    DW 0,0                 ; 2 PALABRAS ( 4 BYTES ) 
EXTRA ENDS 


; DEFINICION DEL SEGMENTO DE CODIGO 

CODE    SEGMENT 
    ASSUME CS:CODE, DS:DATOS, ES: EXTRA, SS:PILA 

FACT_DATO_1  DW       0 

; COMIENZO DEL PROCEDIMIENTO PRINCIPAL 

START PROC 
    ;INICIALIZA LOS REGISTROS DE SEGMENTO CON SUS VALORES 
    MOV AX, DATOS 
    MOV DS, AX 

    MOV AX, PILA 
    MOV SS, AX 

    MOV AX, EXTRA 
    MOV ES, AX 

    ; CARGA EL PUNTERO DE PILA CON EL VALOR MAS ALTO 
    MOV SP, 64 

    ; FIN DE LAS INICIALIZACIONES 

    ;COMIENZO DEL PROGRAMA 
   

    ; FIN DEL PROGRAMA 
    MOV AX, 4C00H 
    INT 21H 

START ENDP 
;_______________________________________________________________ 
; SUBRUTINA PARA CALCULAR EL FACTORIAL DE UN NUMERO 
; ENTRADA CL=NUMERO 
; SALIDA AX=RESULTADO, DX=0 YA QUE CL<=9 
;_______________________________________________________________ 
_imparPositivo PROC FAR
	push bp
	mov bp, sp
	
	mov DX, [BP +6] ;; METEMOS EN DX NUM
	CMP DX, 0 ;; VEMOS SI NUM ES POSITIVO
	JL NoImparPos
	and DX, 1 ;; HACEMOS UN AND CON 1 PARA VER EL VALOR DE ULTIMO BIT
	CMP DX, 1 ;; SI EL RESULTADO ES 1 NUM ES IMPAR
	JNE NoImparPos
	;; METEMOS EN AX EL RESULTADO
	ImparPos:
		mov AX, 1
		JMP RETURN
	NoImparPos:
		mov AX, 0
	RETURN:	
		ret
_imparPositivo ENDP


_calculaDigito PROC FAR
	push bp
	mov bp, sp
	
	mov AX, [BP + 6] ;; METEMOS EN DX NUM
	MOV CX, [BP + 8] ;; METEMOS EN BX POS
	EXTRAERDIGITO:
		MOV BX, 10 ;; DIVIDIMOS POR 10 PARA IR SACANDO LAS UNIDADES
		DIV BX	   ;; RESOLVEMOS LA DIVISION
		SUB CX, 1  ;; RESTAMOS A LA POSICION 1 PARA SABER SI ES EL NUMERO QUE QUERIAMOS EXTRAER
		CMP CX, 0  ;; SI LA POSICION ES 0 SIGNIFICA QUE YA HEMOS LLEGADO A LA POSICION PEDIDA
		JNE EXTRAERDIGITO
	MOV AX, DX
	ret
_calculaDigito ENDP

-pruebaPrimo PROC FAR
	push bp
	mov bp, sp
	mov BX, [BP + 6] ;; Cargamos el numero
	VerProxPrimo: ;; Miramos todos los siguientes numeros a ver si es primo o no
		mov AX, BX
		add AX, 1
		Call CompruebaPrimo
		cmp AX, 0 ;; Vemos si es primo o no, si AX da 0 entonces N es primo
		jne VerProxPrimo
	mov AX, BX
	ret
_pruebaPrimo ENDP

CompruebaPrimo PROC FAR	
	
	mov CX, AX ;; Copiamos el valor en un registro auxiliar
	COMPROBARPRIMO:
		sub CX, 1 ;; Vamos a probar todos los numeros menores a ver si dividen a nuestro numero
		cmp CX, 1 ;; Si hemos llegado a dividir por 1 entonces es primo
		JE ESPRIMO
		DIV CX ;; DIVIDIMOS
		CMP DX , 0 ;; Vemos si es primo ( Resto = 0 )
		JNE COMPROBAR
	;; CX contiene el primer numero que divide a NUM
	MOV AX, CX ;; Ponemos en AX el valor del numero primo mas cercano
	ret
	ESPRIMO:
		MOV AX, 0
		ret
CompruebaPrimo ENDP		
	

; FIN DEL SEGMENTO DE CODIGO 
CODE ENDS 
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION 
END START 

