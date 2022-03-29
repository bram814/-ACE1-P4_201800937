; Teclado español con keyb la
; Teclado ingeles con keyb us

; **************************** [SEGMENTO][LIBS] ****************************
include Macros.asm

.model small

; **************************** [SEGMENTO][STACK] ****************************
.stack

; **************************** [SEGMENTO][DATA] ****************************
.data 

; ************************* DECLARACION DE VARIABLES ************************* 
; ************** [IDENTIFICADOR] **************
_salto          db 0ah,0dh,               "$"
_opcion         db 0ah,0dh,               "> Ingrese Opcion: $"
_regresar       db 0ah,0dh,               "1. regresar$"
; ************** [ERRORES] **************
_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
_error4         db 0ah,0dh,               "> Error al Crear el Archivo",         "$"
; ************** [IDENTIFICADOR] **************
_cadena1        db 0ah,0dh,               "Universidad de San Carlos de Guatemala$"
_cadena2        db 0ah,0dh,               "Facultad de Ingenieria$"
_cadena3        db 0ah,0dh,               "Escuela de Ciencias y Sistemas$"
_cadena4        db 0ah,0dh,               "Arquitectura de Compiladores y ensambladores 1$"
_cadena5        db 0ah,0dh,               "Seccion <A>$"
_cadena6        db 0ah,0dh,               "<Jose Abraham Solorzano Herrera>$"
_cadena7        db 0ah,0dh,               "<201800937>$"
; ************** [MENU] **************
_cadena8        db 0ah,0dh,               "1. Calculadora$"
_cadena9        db 0ah,0dh,               "2. Archivo$"
_cadena10       db 0ah,0dh,               "3. Salir$"
; ************** [OPERACION] **************
_cadena11       db 0ah,0dh,               "+ Suma$"
_cadena12       db 0ah,0dh,               "- Resta$"
_cadena13       db 0ah,0dh,               "x Multiplicacion$"
_cadena14       db 0ah,0dh,               "/ Division$"
_cadena15       db 0ah,0dh,               "^ Potencia$"
; ************** [ARCHIVO] **************
_cadena16       db 0ah,0dh,               "> Ingrese la Ruta del Archivo: ", "$"
_bufferInput    db 50 dup('$')
_handleInput    dw ? 

; ************************************* [PROCS] *************************************

; **************************** [IDENTIFICADOR] **************************** 
identificador proc far
    GetPrint _salto
    GetPrint _cadena1
    GetPrint _cadena2
    GetPrint _cadena3
    GetPrint _cadena4
    GetPrint _cadena5
    GetPrint _cadena6
    GetPrint _cadena7
    ret
identificador endp

; **************************** [MENU] **************************** 
funcMenu proc far
    GetPrint _salto
    GetPrint _cadena8
    GetPrint _cadena9
    GetPrint _cadena10
    GetPrint _opcion
    ret
funcMenu endp

; **************************** [OPERACION] **************************** 
funcOperation proc far
    GetPrint _salto
    GetPrint _cadena11
    GetPrint _cadena12
    GetPrint _cadena13
    GetPrint _cadena14
    GetPrint _cadena15
    GetPrint _regresar
    GetPrint _opcion
    ret
funcOperation endp



.code

main proc

    Linicio:
        ; LLamamos identificador 
        call identificador

        GetInput
        cmp al,0Dh ; Codigo ASCCI [Enter -> Hexadecimal]
        je Lmenu
        jmp Linicio
;                        [MENU]

    Lmenu:
        ; LLamamos menu 
        call funcMenu

        ; Obtenemos el Caracter
        GetInput

        cmp al,31H ; Codigo ASCCI [1 -> Hexadecimal]
        je Loperacion
        cmp al,32H ; Codigo ASCCI [2 -> Hexadecimal]
        je Lfile
        cmp al,33H ; Codigo ASCCI [3 -> Hexadecimal]
        je Lsalir 
        jmp Lmenu

    Lfile:
        GetPrint    _cadena16                      ; Ingreso de Path
        GetRoot     _bufferInput                    ; Capturar Path
        GetOpenFile _bufferInput, _handleInput  ; Abrir file


        jmp Lmenu

    Loperacion:
        ; LLamamos operaciones 
        call funcOperation
        ; Obtenemos el Caracter
        GetInput

        cmp al,2BH ; Codigo ASCCI [+ -> Hexadecimal]
        je Loperacion
        cmp al,2DH ; Codigo ASCCI [- -> Hexadecimal]
        je Loperacion
        cmp al,78H ; Codigo ASCCI [x -> Hexadecimal]
        je Loperacion
        cmp al,2FH ; Codigo ASCCI [/ -> Hexadecimal]
        je Loperacion
        cmp al,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Loperacion
        cmp al,31H ; Codigo ASCCI [1 -> Hexadecimal]
        je Lmenu
        jmp Loperacion

    Lerror1:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu
    Lerror2:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu
    Lerror3:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu
    Lerrro4:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu

    Lsalir:
        mov ax,4c00h
        int 21h

main endp
end main