; DEFINICION DEL SEGMENTO DE DATOS
DATOS SEGMENT
VECTOR1 DB 1,2,4,8,5,10,9,7,3,6 ;; Vector de valores a sumar
CONVERSION DB ?
;-- rellenar con los datos solicitados
DATOS ENDS

PRAC3B SEGMENT BYTE PUBLIC 'CODE'
PUBLIC _calculaSegundoDC
ASSUME CS: PRAC3B
_calculaSegundoDC PROC FAR
	push bp
	mov bp, sp
	push ax bx dx si di
	mov si, bp[6] ;; Cadena
	mov di, 0
	
continuar: 
	mov bh, VECTOR1[di]
	mov al, [si] ;; cadena
	cmp al, 0 ;; fin de la cuenta
	je modulo ;; obtenemos el modulo del numero obtenido respecto de 11
	mul bh
	add dx , ax 
	inc si
	inc di
	jmp continuar

caso_especial:
	mov ax, 9
	jmp final
	
modulo:
	cmp dx, 10
	je caso_especial
	mov ax, dx
	div 11
	mov ax, dx

final: 
	pop di si dx bx ax
	ret
_calculaSegundoDC ENDP



PRAC3B ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3a.asm
	