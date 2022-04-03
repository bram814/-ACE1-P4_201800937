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


; ************** [PATH][CREATE] **************
GetCreateFile macro buffer,handler
    MOV AX,@data
    MOV DS,AX
    MOV AH,3ch
    MOV CX,00h
    LEA DX,buffer
    INT 21h
    ;jc Error4
    MOV handler, AX
endm
; ************** [PATH][WRITE] **************
GetWriteFile macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX
    ; MOV AH,40h
    ; MOV BX,handler
    ; MOV CX, SIZEOF buffer 

    XOR BX, BX
    XOR AX, AX 
    ciclo_Ini:
      MOV AL, buffer[ BX ]
      CMP AL, '$'
      JE ciclo_Fin

      INC BX 
      JMP ciclo_Ini
    ciclo_Fin:
    XOR AX, AX

    MOV contadorBuffer, BX
    XOR BX, BX
    
    MOV AH,40h
    MOV BX,handler
    MOV CX, contadorBuffer
    LEA DX, buffer
    INT 21h
endm

GetWriteFileN macro handler, buffer
    LOCAL ciclo_Ini, ciclo_Fin
    MOV AX,@data
    MOV DS,AX

    MOV AH,40h
    MOV BX, handler
    MOV CX, SIZEOF buffer 
    LEA DX, buffer
    INT 21h
endm

; ************** [DATE][WRITE] **************
GetWriteDate macro handler, digito1, digito2

  MOV AH, 2AH 
  INT 21H 
  MOV digito1, 0
  MOV digito2, 0
  MOV AL, DL 

	; FECHA
  GetWriteFile handler, _Reporte8S
  ; DIA ---- 9
  GuardarDigitos digito1, digito2

	GetWriteFile handler, _Reporte9S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto
  ; WriteFile handler, diagonal

  ; MES ---- 10
  MOV AH, 2AH 
  INT 21H 
  MOV digito1, 0 
  MOV digito2, 0
  MOV AL, DH 

  GuardarDigitos digito1, digito2

  GetWriteFile handler, _Reporte10S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto

  ; AÑO --- 11
  MOV AH, 2AH 
  INT 21H
  MOV digito1, 0
  MOV digito2, 0
  ADD CX, 0F830h
  MOV AX, CX 

  GuardarDigitos digito1, digito2 
  
  GetWriteFile handler, _Reporte11S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _salto

  
  GetWriteFile handler, _Reporte12S

  ; HORA
  GetWriteFile handler, _Reporte13S
  MOV AH, 2Ch
  INT 21H 

  ; HORA -------- 14 
  MOV AL, CH 
  GuardarDigitos digito1, digito2
  
  GetWriteFile handler, _Reporte14S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto

  ; MINUTOS	------- 15
  MOV AH, 2Ch
  INT 21h
  MOV digito1, 0
  MOV digito2, 0
  MOV AL, CL 

  GuardarDigitos digito1, digito2
  
  GetWriteFile handler, _Reporte15S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _Reporte31S
  GetWriteFile handler, _salto

  ; SEGUNDOS -------- 16
  MOV AH, 2Ch
  INT 21H
  MOV digito1, 0
  MOV digito2, 0
  MOV AL, DH 

  GuardarDigitos digito1, digito2
  
  GetWriteFile handler, _Reporte16S
  GetWriteFileN handler, digito1
  GetWriteFileN handler, digito2 
  GetWriteFile handler, _salto


  GetWriteFile handler, _Reporte17S
endm

GuardarDigitos MACRO _digito1, _digito2
  AAM
  MOV BX, AX
  ADD BX, 3030h

  MOV _digito1, BH
  MOV _digito2, BL
endm

; *************** [CALCULADORA] **************************

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
	GetPrintCommand cadenaNumero
	;cmp cadenaNumero,'d7h'  ; Codigo ASCCI [END -> Hexadecimal] salir del programa
	;je Lmenu
	
	; Convertimos la cadena a numero es guardado en AX
	String_Int cadenaNumero
	mov numeroConvertido, ax 		; Guardar en el "int"
	GetImparPar
	GetPrimo numeroConvertido
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
		GetAnalizador _bufferInfo


		
		jmp _Lout
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 

endm




GetAnalizador macro text
	local _Lout, _Lerror, _Linput, _Linput2, _LcalculosL, _L0, Lllavea,_calculo1, _calculo2, _calculo3, _calculo4, _calculo5, _calculo6, _calculo7, _calculo8, _calculo9, _calculo10, _calculo11
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
	; GetPrint text
	Lllavea:

		cmp text[SI],7bh  ; Codigo ASCCI [{ -> Hexadecimal]
		je _Linput
		INC SI
		jmp Lllavea

	_Linput:

		inc SI
		cmp text[SI],22h ;Codigo ASCCI [" -> Hexadecimal]
		je _Linput2
		jmp _Linput

	_Linput2:

		inc SI

		cmp text[SI],63h	 ; Codigo ASCCI [c -> Hexadecimal]
		je _calculo1
		jmp _Lout

	_calculo1:
		inc SI

		cmp text[SI],61h	 ; Codigo ASCCI [a -> Hexadecimal]
		je _calculo2
		jmp _Lout

	_calculo2:
		inc SI

		cmp text[SI],6ch	 ; Codigo ASCCI [l -> Hexadecimal]
		je _calculo3
		jmp _Lout

	_calculo3:

		inc SI
		cmp text[SI],63h	 ; Codigo ASCCI [c -> Hexadecimal]
		je _calculo4
		jmp _Lout

	_calculo4:
		inc SI
		cmp text[SI],75h	 ; Codigo ASCCI [u -> Hexadecimal]
		je _calculo5
		jmp _Lout

	_calculo5:
		inc SI
		cmp text[SI],6ch	 ; Codigo ASCCI [l -> Hexadecimal]
		je _calculo6
		jmp _Lout

	_calculo6:
		inc SI
		cmp text[SI],6fh	 ; Codigo ASCCI [o -> Hexadecimal]
		je _calculo7
		jmp _Lout

	_calculo7:
		inc SI
		cmp text[SI],73h	 ; Codigo ASCCI [s -> Hexadecimal]
		je _calculo8
		jmp _Lout

	_calculo8:
		inc SI
		cmp text[SI],22h	 ; Codigo ASCCI [" -> Hexadecimal]
		je _calculo9
		jmp _Lout


	_calculo9:
		inc SI
		cmp text[SI],3ah	 ; Codigo ASCCI [: -> Hexadecimal]
		je _calculo10
		jmp _calculo9

	_calculo10:
		inc SI
		cmp text[SI],3ah	 ; Codigo ASCCI [: -> Hexadecimal]
		je _calculo11
		jmp _calculo10

	_calculo11:
		inc SI
		cmp text[SI],5bh	 ; Codigo ASCCI [: -> Hexadecimal]
		je _LcalculosL
		jmp _calculo11

	_LcalculosL:
		
		inc SI

		GetPrint _resultado
		jmp _Lout

	_L0:
		; inc SI

		mov _indice0, SI
		GetOperacion text
		jmp _Lout

	_Lerror:
		GetPrint _error6
		jmp _Lout
	_Lout:
			push ax
	  	push cx
	  	push bx
	  	push dx 

endm



GetOperacion macro text
	LOCAL L0, Lin, Lout, Lcompare
	push ax
  push cx
  push bx
  push dx
	xor BX, BX ; contador para posiciones

	L0:
		INC SI
	  mov SI,_indice0

		cmp text[SI], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je Lin
		jmp L0

	Lin:
		INC SI
		XOR AX, AX
		mov al,text[SI]
		cmp text[SI], 22h ; Codigo ASCCI [" -> Hexadecimal]
		je Lout

		mov _OPERASCompare[BX],al 
		jmp Lin



	Lcompare:
			GetPrint _OPERAS 
			GetPrint _salto
			GetPrint _OPERASCompare
			GetPrint _salto
			jmp Lout

	Lout:

		push ax
	  push cx
	  push bx
	  push dx


endm


GetCleanConsole macro
	mov ah, 00
	mov al, 03h
	int 10h

endm



GetImparPar macro
	local par, impar, salir

	mov bl,2
	div bl
	;compara
	cmp ah,0
	jp par
	jnp impar

	par:
		; GetPrint _PAR
		mov dx, _numeroPar
    add dx, 1
    mov _numeroPar, dx
    mov ax, _numeroPar
    Int_String _numeroParS
    ; GetPrint _numeroParS
    ; GetPrint _salto
		jmp salir
	
	
	impar:
		; GetPrint _IMPAR
		mov dx, _numeroImpar
    add dx, 1
    mov _numeroImpar, dx
    mov ax, _numeroImpar
    Int_String _numeroImparS
    ; GetPrint _numeroImparS
    ; GetPrint _salto
		jmp salir
	
	salir: 
	
	
endm

GetPrimo macro num
	local ciclo, primo, noPrimo, salir, isPrimo, notPrimo
 	mov _contPrimo,0
 	mov BX,1

    ciclo:
 
      cmp BX,num
      jg salir
      xor ax,ax
       mov ax,num
      div bl
      ; ;compara

      cmp ah,0
      je primo
      jne noPrimo


      primo:
         inc _contPrimo
         inc BX
         jmp ciclo
      
      noPrimo:
          inc BX
          jmp ciclo

    salir: 


    cmp _contPrimo,2
    jz isPrimo
    jnz notPrimo


    isPrimo:
    	mov dx, _numeroPrimo
	    add dx, 1
	    mov _numeroPrimo, dx
	    mov ax, _numeroPrimo
	    Int_String _numeroPrimoS
        
    notPrimo:

        
endm


GetPrintCommand macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5,_Lout, _Lout2, _Lconca
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
	cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 52h ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 49h ; Codigo ASCCI [I -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 4eh ; Codigo ASCCI [N -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 54h ; Codigo ASCCI [T -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend5
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		GetPrintPar _cadenaParImpar
		GetPrintImpar _cadenaParImpar	
		GetPrintPrimo	_cadenaParImpar
		jmp _Lout

	_Lout:
		push ax
	  push cx
	  push bx
	  push dx

endm


GetPrintPar macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5, _Lout, _Lout2, _Lconca
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
	cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 41h ; Codigo ASCCI [A -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 52h ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 45h ; Codigo ASCCI [E -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 53h ; Codigo ASCCI [T -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend5
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		
		GetPrint _salto
		GetPrint _PAR
		GetPrint _numeroParS
		GetPrint _salto
		
		
	  jmp Lmenu
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 
endm

GetPrintImpar macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5, _Lend6, _Lend7, _Lout, _Lout2, _Lconca
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
	cmp palabra[SI], 49h ; Codigo ASCCI [I -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 4dh ; Codigo ASCCI [M -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 41H ; Codigo ASCCI [A -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 52H ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		Cmp palabra[SI], 45H ; Codigo ASCCI [E -> Hexadecimal]
		je _Lend6
		jmp _Lout

	_Lend6:
		INC SI
		Cmp palabra[SI], 53H ; Codigo ASCCI [S -> Hexadecimal]
		je _Lend7
		jmp _Lout

	_Lend7:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend7
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		
		GetPrint _salto
		GetPrint _IMPAR
		GetPrint _numeroImparS
		GetPrint _salto
		
		
	  jmp Lmenu
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 
endm


GetPrintPrimo macro palabra
LOCAL _Lend1, _Lend2, _Lend3, _Lend4, _Lend5,  _Lend6, _Lout, _Lout2, _Lconca
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
	cmp palabra[SI], 50h ; Codigo ASCCI [P -> Hexadecimal]
	je _Lend1	
	jmp _Lout

	_Lend1:
		INC SI
		cmp palabra[SI], 52h ; Codigo ASCCI [R -> Hexadecimal]
		je _Lend2
		jmp _Lout

	_Lend2:
		INC SI
		Cmp palabra[SI], 49h ; Codigo ASCCI [I -> Hexadecimal]
		je _Lend3
		jmp _Lout

	_Lend3:
		INC SI
		Cmp palabra[SI], 4dh ; Codigo ASCCI [M -> Hexadecimal]
		je _Lend4
		jmp _Lout

	_Lend4:
		INC SI
		Cmp palabra[SI], 4fh ; Codigo ASCCI [O -> Hexadecimal]
		je _Lend5
		jmp _Lout

	_Lend5:
		INC SI
		Cmp palabra[SI], 53h ; Codigo ASCCI [S -> Hexadecimal]
		je _Lend6
		jmp _Lout

	_Lend6:
		INC SI
		cmp palabra[SI], 20h ; Codigo ASCCI [space -> Hexadecimal]
		je _Lend6
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout
		
	

		XOR AX, AX
		mov al,palabra[SI]
		mov _cadenaParImpar[BX], AL
		INC BX
		
		jmp _Lconca

	_Lconca:
		INC SI
		XOR AX, AX
		mov al,palabra[SI]
		
		cmp palabra[SI], 24h ; Codigo ASCCI [$ -> Hexadecimal]
		je _Lout2

		mov _cadenaParImpar[BX], AL
		INC BX
		jmp _Lconca
	_Lout2:
		
		
		GetPrint _salto
		GetPrint _PRIMO
		GetPrint _numeroPrimoS
		GetPrint _salto
		
		
	  jmp Lmenu
	_Lout:
		push ax
	  push cx
	  push bx
	  push dx 
endm