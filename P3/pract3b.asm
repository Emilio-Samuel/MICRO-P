PRAC3A SEGMENT BYTE PUBLIC 'CODE'
PUBLIC _encuentraSubcadena
ASSUME CS: PRAC3A
_encuentraSubcadena PROC FAR
	push bp
	mov bp, sp
	push bx si di cx
	mov si, bp[6] ;; Cadena
	mov di, bp[10] ;; Subcadena
	mov cx, 0
	mov ax, 1 ;; Por defecto son iguales
	
continuar: 
	mov bl, [si] ;; cadena
	mov bh, [di] ;; Subadena
	cmp bh, 0 ;; Subcadena[i] termina?
	je final ;; Acaban ambas cadenas
	cmp bl, 0
	je fallo
	cmp bl, bh ;; Comparamos el caracter
	jne reubicamos

	; Pasamos al siguiente carácter
	inc si
	inc di
	jmp continuar	
reubicamos:
	inc cx
	; Reiniciamos las cadenas
	mov si, bp[6] 
	mov di, bp[10]
	add si, cx ;; Probamos desde el caracter i-esimo de la cadena
	jmp continuar
fallo:
	mov ax, -1
final: 
	pop cx di si bx bp
	ret
_encuentraSubcadena ENDP
PRAC3A ENDS ; FIN DEL SEGMENTO DE CODIGO
END ; FIN DE pract3a.asm
	
