; **************************** [MACROS] ****************************
; ************** [IMPRIMIR] **************
GetPrint macro buffer
	MOV AX,@data
	MOV DS,AX
	MOV AH,09H
	MOV DX,OFFSET buffer
	INT 21H
endm
; ************** [CAPTURAR ENTRADA] **************
GetInput macro
	MOV AH,01H
	int 21H
endm

GetInputMax macro _resultS
	mov ah, 3fh 					; int21 para leer fichero o dispositivo
	mov bx, 00 						; handel para leer el teclado
	mov cx, 10 						; bytes a leer (aca las definimos con 10)
	mov dx, offset[_resultS]
	int 21h
endm
; ************** [VARIABLE][GET] **************
GetText macro buffer
	LOCAL Ltext, Lout
	xor si,si  ; Es igual a mov si,0

	Ltext:
		GetInput
		cmp al,0DH ; Codigo ASCCI [\n -> Hexadecimal]
		je Lout
		mov buffer[si],al ; mov destino,fuente
		inc si ; si = si + 1
		jmp Ltext

	Lout:
		mov al,24H ; Codigo ASCCI [$ -> Hexadecimal]
		mov buffer[si],al
endm
; ************** [PATH][GET] **************
GetRoot macro buffer
	LOCAL Ltext, Lout
	xor si,si  ; Es igual a mov si,0

	Ltext:
		GetInput
		cmp al,0DH ; Codigo ASCCI [\n -> Hexadecimal]
		je Lout
		mov buffer[si],al ; mov destino,fuente
		inc si ; si = si + 1
		jmp Ltext

	Lout:
		mov al,00H ; Codigo ASCCI [null -> Hexadecimal]
		mov buffer[si],al
endm
; ************** [PATH][OPEN] **************
GetOpenFile macro buffer,handler
	mov ah,3dh
	mov al,02h
	lea dx,buffer
	int 21h
	jc Lerror1
	mov handler,ax
endm
; ************** [PATH][CLOSE] **************
GetCloseFile macro handler
	mov ah,3eh
	mov bx,handler
	int 21h
	jc Lerror2
endm
; ************** [PATH][READ] **************
GetReadFile macro handler,buffer,numbytes
	mov ah,3fh
	mov bx,handler
	mov cx,numbytes
	lea dx,buffer
	int 21h
	jc Lerror5
endm


; *************** [CALCULADORA] **************************

; =================== METODOS PARA LA CALCULADORA ======================

;convierte un NUMERO a CADENA que esta guardado en AX 
Int_String macro intNum
  local div10, signoN, unDigito, obtenerDePila
  ;Realizando backup de los registros BX, CX, SI
  push ax
  push bx
  push cx
  push dx
  push si
  xor si,si
  xor cx,cx
  xor bx,bx
  xor dx,dx
  mov bx,0ah 				; Divisor: 10
  test ax,1000000000000000 	; veritficar si es numero negativo (16 bits)
  jnz signoN
  unDigito:
      cmp ax, 0009h
      ja div10
      mov intNum[si], 30h 	; Se agrega un CERO para que sea un numero de dos digitos
      inc si
      jmp div10
  signoN:					; Cambiar de Signo el numero 
  	  neg ax 				; Se niega el numero para que sea positivo
  	  mov intNum[si], 2dh 	; Se agrega el signo negativo a la cadena de salida
  	  inc si
  	  jmp unDigito
  div10:
      xor dx, dx 			; Se limpia el registro DX; Este simulará la parte alta del registro
      div bx 				; Se divide entre 10
      inc cx 				; Se incrementa el contador
      push dx 				; Se guarda el residuo DX
      cmp ax,0h 			; Si el cociente es CERO
      je obtenerDePila
	  jmp div10
  obtenerDePila:
      pop dx 				; Obtenemos el top de la pila
      add dl,30h 			; Se le suma '0' en su valor ascii para numero real
      mov intNum[si],dl 	; Metemos el numero al buffer de salida
      inc si
      loop obtenerDePila
      mov ah, '$' 			; Se agrega el fin de cadena
      mov intNum[si],ah
      						; Restaurando registros
      pop si
      pop dx
      pop cx
      pop bx
      pop ax
endm

;convierte una CADENA A NUMERO, este es guardado en AX.
String_Int macro stringNum
  local ciclo, salida, verificarNegativo, negacionRes
  push bx
  push cx
  push dx
  push si
  ;Limpiando los registros AX, BX, CX, SI
  xor ax, ax
  xor bx, bx
  xor dx, dx
  xor si, si
  mov bx, 000Ah						;multiplicador 10
  ciclo:
      mov cl, stringNum[si]
      inc si
      cmp cl, 2Dh 					; compara para ignorar el "-"
      jz ciclo    					; Se ignora el simbolo '-' de la cadena
      cmp cl, 30h 					; Si el caracter es menor a '0', implica que es negativo (verificacion)
      jb verificarNegativo 			; ir para cuando es un negativo 
      cmp cl, 39h 					; Si el caracter es mayor a '9', implica que es negativo (verificacion)
      ja verificarNegativo
  	  sub cl, 30h					; Se le resta el ascii '0' para obtener el número real
  	  mul bx      					; multplicar ax
      mov ch, 00h
   	  add ax, cx  					; sumar para obtener el numero total
  	  jmp ciclo
  negacionRes:
      neg ax 						; negacion por si es negativo el resultado
      jmp salida
  verificarNegativo: 
      cmp stringNum[0], 2Dh 		; Si existe un signo al inicio del numero, negamos el numero
      jz negacionRes
  salida:
      								; Restaurando los registros AX, BX, CX, SI
      pop si
      pop dx
      pop cx
      pop bx
endm

; recibe una cadena y lo convierte en numero
Solicitar_Numero macro cadenaNumero, numeroConvertido
	mov ah, 3fh 					; int21 para leer fichero o dispositivo
	mov bx, 00 						; handel para leer el teclado
	mov cx, 20 						; bytes a leer (aca las definimos con 10)
	mov dx, offset[cadenaNumero]
	int 21h
	GetAC cadenaNumero
	GetEND cadenaNumero
	GetEVAL cadenaNumero,numeroConvertido
	;cmp cadenaNumero,'d7h'  ; Codigo ASCCI [END -> Hexadecimal] salir del programa
	;je Lmenu
	
	; Convertimos la cadena a numero es guardado en AX
	String_Int cadenaNumero
	mov numeroConvertido, ax 		; Guardar en el "int"
endm

;limpiar variables
GetClean macro _numero1, _numero2, _calcuResultado
    mov _numero1, 0
    mov _numero1, ax
    mov _calcuResultado, 0
    mov _numero2, 0
endm



GetAC macro palabra
	LOCAL ac1, ac2
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx 
  
	; 13
	cmp palabra[SI], 41h
	je ac1	
	jmp ac2

	ac1:
		INC SI
		cmp palabra[SI], 43h
		je Loperacion
		jmp ac1

	ac2:
		push ax
  		push cx
  		push bx
  		push dx 

endm




GetAnalizador macro text
	local _Lout, _Lerror, _Linput, _Linput2, _LcalculosL
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx 

	cmp text[SI],7bh
	je _Linput
	jmp _Lout
	_Linput:
		inc SI
		cmp text[SI],22h
		je _Linput2
		jmp _Lout

	_Linput2:
		inc SI
		xor ch,ch
		mov cl,text[SI]
		add bx,cx

		cmp entrada[SI], '$' ; por si hay errore en el archivo
    	je _Lerror

		cmp bx,356h	 ; Codigo ASCCI [calculos -> Hexadecimal]
		je _LcalculosL

		jmp _Linput2

	_LcalculosL:
		; aca ya esta en el perron

	_Lerror:
		GetPrint _error6
		jmp _Lout
	_Lout:
			push ax
	  	push cx
	  	push bx
	  	push dx 

endm


GetPotencia macro _result, _num1S, _num1I, _num2I, _numTemp
	LOCAL _Lout, _L0, _Lpote
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	inc SI ; incremento 1° vez
	inc SI ; incremento 2° vez
	mov ax,_num1I
	mov _numTemp, ax
	cmp _num2I,0
	je _L0
	jmp _Lpote

	_L0:

		mov _num1I,1
		mov _num1S,'1'
		jmp _Lout

	_Lpote:
		mov ax, _numTemp
    mov bx, _num1I
    imul bx
    mov _result,ax
    mov ax,_result
    Int_String _num1S ; convierte el numero guardado en ax
    mov _numTemp,ax
    cmp SI,_num2I
   	je _Lout
   	inc SI
    jmp _Lpote

	_Lout:
		GetPrint _resultado
    GetPrint _num1S
	
endm



GetEND macro palabra
	LOCAL _Lend1, _Lend2, _Lout
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx 
  
	; 13
	cmp palabra[SI], 45h ; Codigo ASCCI [E -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 4eh ; Codigo ASCCI [N -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 44h ; Codigo ASCCI [D -> Hexadecimal]
		je Lmenu
		jmp _Lout

	_Lout:

endm


GetEVAL macro palabra, numeroConvertido
	LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lout, _Lout2, _Lconca
	push ax
  push cx
  push bx
  push dx 
  xor SI, SI ; contador para el contenedor
	xor DI, DI ; contador para posiciones
	xor BX, BX ; contador para posiciones
	xor ax, ax 
	xor cx, cx ; usado
	xor bx, bx ; usado
	xor dx, dx  

	; 13
	cmp palabra[SI], 45h ; Codigo ASCCI [E -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 56h ; Codigo ASCCI [V -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 41h ; Codigo ASCCI [A -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 4ch ; Codigo ASCCI [L -> Hexadecimal]
		je _Lend4
		jmp _Lout


	_Lend4:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend4
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _OPERAS[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2
		mov _OPERAS[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		GetPrint _OPERAS
		GetPrint _salto


		
		jmp _Lout
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 

endm
