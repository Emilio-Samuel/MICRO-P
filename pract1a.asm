;**************************************************************************
; SBM 2017. ESTRUCTURA BÁSICA DE UN PROGRAMA EN ENSAMBLADOR
;**************************************************************************
; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
;;;EJ 2
TIEMPO DB ?
BEBA DW 0CAFEH
TABLA[100] DB 100 dup(?)
ERROR1 DB  “**ERROR** - Entrada de datos incorrecta.”
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
MOV AX, 1AH ;No encontramos ningun problema a la hora de ejecutar ni compilar ni comprobando su resultado
MOV BX, 0BAh ;Debido a que las etiquetas comienzan por letras, hemos decidido ponerle un 0 a la izquierda
		     ; para no modificar su valor numerico y que lo reconozca adecuadamente
MOV CX, 3412H;De la misma forma que el primero no encontramos ningun problema
MOV AX, 5400H;Debido a que DS es un registro al que no podemos acceder directamente lo volcamos a AX
MOV DS, AX;Ahora lo pasamos a DS
MOV BH, DS:[326H];Le sumamos el offset y tadaaa miramos la parte alta de bx que cambia
MOV BL, DS:[327H]
MOV AX, 7000H
MOV DS, AX
MOV CH, DS:[007H]
MOV AX, SI
MOV BX, [BP+10H]



; -- rellenar con las instrucciones solicitadas
; FIN DEL PROGRAMA
MOV AX, 4C00H
INT 21H
INICIO ENDP
; FIN DEL SEGMENTO DE CODIGO
CODE ENDS
; FIN DEL PROGRAMA INDICANDO DONDE COMIENZA LA EJECUCION
END INICIO 