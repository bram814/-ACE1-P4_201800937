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
_num            db                        "> ", "$"
_resultado      db 0ah,0dh,               "> resultado es ", "$"
_reporte        db 50 dup('$')
; ************** [ERRORES] **************
_error1         db 0ah,0dh,               "> Error al Abrir Archivo, no Existe ",   "$"
_error2         db 0ah,0dh,               "> Error al Cerrar Archivo",              "$"
_error3         db 0ah,0dh,               "> Error al Escribir el Archivo",         "$"
_error4         db 0ah,0dh,               "> Error al Crear el Archivo",            "$"
_error5         db 0ah,0dh,               "> Error al Leer al Archivo",             "$"
_error6         db 0ah,0dh,               "> Error en el Archivo",                  "$"
_error7         db 0ah,0dh,               "> Error al crear el Archivo",                  "$"
; ************** [IDENTIFICADOR] **************
_cadena1        db 0ah,0dh,               "Universidad de San Carlos de Guatemala$"
_cadena2        db 0ah,0dh,               "Facultad de Ingenieria$"
_cadena3        db 0ah,0dh,               "Escuela de Ciencias y Sistemas$"
_cadena4        db 0ah,0dh,               "Arquitectura de Compiladores y ensambladores 1$"
_cadena5        db 0ah,0dh,               "Seccion A$"
_cadena6        db 0ah,0dh,               "Jose Abraham Solorzano Herrera$"
_cadena7        db 0ah,0dh,               "201800937$"
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
_cadena17       db 0ah,0dh,               "1. Cargar Archivo ",     "$"
_cadena18       db 0ah,0dh,               "2. Cerrar Archivo ",     "$"
_cadena19       db 0ah,0dh,               "3. Mostrar Contenido",   "$"
_cadena20       db 0ah,0dh,               "4. Regresar",            "$"
; ************** [CALCULADORA] **************
_PAR            db 0ah,0dh, "Cantidad de Numeros Pares Reconocidos: $"
_IMPAR          db 0ah,0dh, "Cantidad de Numeros Impares Reconocidos: $"
_cadena21       db 0ah,0dh,               "Calculadora",            "$"
_cadena22       db 0ah,0dh,               "==============================",  "$"
_resultS        db 10 dup(' '), "$" ; Sirve para almacenar el result en String
_numero1S       db 10 dup(' '), "$" ; Sirve para almacenar el numero 1 en String
_numero2S       db 10 dup(' '), "$" ; Sirve para almacenar el numero 2 en String
_numero3S       db 10 dup(' '), "$" ; Sirve para almacenar el numero 3 en String
_numeroParS     db 10 dup(' '), "$" ; Sirve para almacenar el numero 3 en String
_numeroImparS   db 10 dup(' '), "$" ; Sirve para almacenar el numero 3 en String
_OPERAS         db 50 dup(' '), "$" ; Sirve para almacenar el numero 3 en String
_OPERASCompare  db 50 dup(' '), "$" ; Sirve para almacenar el numero 3 en String
_cadenaParImpar db 50 dup(' '), "$" ; Sirve para almacenar el numero 3 en String
_indice0        dw 0
_indicef        dw 0
_numero1        dw 0                ; Sirve para almacenar el numero 1 en int
_numero2        dw 0                ; Sirve para almacenar el numero 2 en int
_numero3        dw 0                ; Sirve para almacenar el numero 2 en int
_numeroPar      dw 0                ; Sirve para almacenar el numero 2 en int
_numeroImpar    dw 0                ; Sirve para almacenar el numero 2 en int
_numeroTemp     dw 0                ; Sirve para almacenar el numero 2 en int
_calcuResultado dw 0                ; Sirve para almacenar el Resultado

_createFile     db 'reporte.jso' ; variable para crear archivo
_reporteHandle  dw ?
_Reporte0S      db 0ah,0dh,               "{",'$'
_Reporte1S      db 0ah,0dh,               '     "reporte":[ $'
_Reporte2S      db 0ah,0dh,               '         "Datos":{ $'
_Reporte3S      db 0ah,0dh,               '             "nombre":"Jose Abraham Solorzano Herrera",$'
_Reporte4S      db 0ah,0dh,               '             "carnet":"201800937",$'
_Reporte5S      db 0ah,0dh,               '             "curso":"Arquitectura de compiladores y ensambladores 1",$'
_Reporte6S      db 0ah,0dh,               '             "seccion":"A"$'
_Reporte7S      db 0ah,0dh,               '         }, $'
_Reporte8S      db 0ah,0dh,               '         "Fecha":{ $'
_Reporte9S      db 0ah,0dh,               '             "Dia":$'
_Reporte10S     db 0ah,0dh,               '             "Mes":$'
_Reporte11S     db 0ah,0dh,               '             "Año":$'
_Reporte12S     db 0ah,0dh,               '         }, $'
_Reporte13S     db 0ah,0dh,               '         "Hora":{ $'
_Reporte14S     db 0ah,0dh,               '             "hora":$'
_Reporte15S     db 0ah,0dh,               '             "minuto":$'
_Reporte16S     db 0ah,0dh,               '             "segundo":$'
_Reporte17S     db 0ah,0dh,               '         }, $'
_Reporte18S     db 0ah,0dh,               '         "Estadísticos":{ $'
_Reporte19S     db 0ah,0dh,               '             "media":"",$'
_Reporte20S     db 0ah,0dh,               '             "mediana":"",$'
_Reporte21S     db 0ah,0dh,               '             "moda":"",$'
_Reporte22S     db 0ah,0dh,               '             "impares":$'
_Reporte23S     db 0ah,0dh,               '             "pares":$'
_Reporte24S     db 0ah,0dh,               '             "primos":""$'
_Reporte25S     db 0ah,0dh,               '         }, $'
_Reporte26S     db 0ah,0dh,               '         "Operaciones":[ $'
_Reporte27S     db 0ah,0dh,               '         ]$'
_Reporte28S     db 0ah,0dh,               '    ]$'
_Reporte29S     db 0ah,0dh,               '}$'
_Reporte30S     db                        '"$'
_Reporte31S     db                        ',$'



_bufferInput    db 50 dup('$')
_handleInput    dw ? 
_bufferInfo     db 2000 dup('$')
contadorBuffer dw 0 ; Contador para todos los WRITE FILE, para escribir sin que se vean los $
; ************************************ [DATE] ************************************
_digito1 db 0
_digito2 db 0

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
; **************************** [PATH] **************************** 
funcPath proc far 
    GetPrint _salto
    GetPrint _cadena17
    GetPrint _cadena18
    GetPrint _cadena19
    GetPrint _cadena20
    GetPrint _opcion
    ret
funcPath endp
; **************************** [CALCULADORA] **************************** 
funcCalculadora proc far 
    GetPrint _salto
    GetPrint _cadena21
    GetPrint _cadena22
    GetPrint _salto
    ret
funcCalculadora endp


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
        ; LLamamos path 
        call funcPath
        GetInput
        cmp al,31H ; Codigo ASCCI [1 -> Hexadecimal]
        je LreadFile
        cmp al,32H ; Codigo ASCCI [2 -> Hexadecimal]
        je LcloseFile
        cmp al,33H ; Codigo ASCCI [3 -> Hexadecimal]
        je LmostrarFile 
        cmp al,34H ; Codigo ASCCI [4 -> Hexadecimal]
        je Lmenu 
        jmp Lmenu
        

    LreadFile:
        GetPrint    _salto
        GetPrint    _cadena16                                           ; Ingreso de Path
        ; GetInput
        GetRoot     _bufferInput                                        ; Capturar Path
        GetOpenFile _bufferInput,_handleInput                          ; Abrir file
        GetReadFile _handleInput,_bufferInfo,SIZEOF _bufferInfo       ; Guardar Contenido
        GetInput
        jmp Lfile

    LmostrarFile:
        GetPrint _salto
        GetPrint _bufferInfo
        GetPrint _salto
        GetInput

        jmp Lfile

    LcloseFile:
        GetCloseFile _handleInput
        GetInput
        jmp Lfile

    Loperacion:
        call funcCalculadora ; LLamamos calculadora 
        GetClean _numero1,_numero1,_calcuResultado
        GetPrint _num ; Obtenemos el primer número
        Solicitar_Numero _numero1S, _numero1
        
        
        GetPrint _num ; Obtenemos el segundo número
        Solicitar_Numero _numero2S, _numero2
     
        GetPrint _num
        GetInputMax _resultS
        GetAC _resultS
        GetEND _resultS
        GetPrintCommand _resultS

        cmp _resultS,2BH ; Codigo ASCCI [+ -> Hexadecimal]
        je Lsuma
        cmp _resultS,2DH ; Codigo ASCCI [- -> Hexadecimal]
        je Lresta
        cmp _resultS,78H ; Codigo ASCCI [x -> Hexadecimal]
        je Lmultiplicacion
        cmp _resultS,2FH ; Codigo ASCCI [/ -> Hexadecimal]
        je Ldivision
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia
        cmp _resultS,65h  ; Codigo ASCCI [e -> Hexadecimal] salir del programa
        je Lmenu

        String_Int _resultS
        mov _numero3,ax

        GetPrint _num
        GetInputMax _resultS
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia2

        jmp Loperacion


    Loperacion2:
        call funcCalculadora ; LLamamos calculadora 
        
        GetPrint _num ; Obtenemos el primer número
        GetPrint _numero1S
        GetPrint _salto
        String_Int _numero1S
        mov _numero1, ax
        GetImparPar
        
        
        GetPrint _num ; Obtenemos el segundo número
        Solicitar_Numero _numero2S, _numero2
    
        GetPrint _num
        GetInputMax _resultS

        cmp _resultS,2BH ; Codigo ASCCI [+ -> Hexadecimal]
        je Lsuma
        cmp _resultS,2DH ; Codigo ASCCI [- -> Hexadecimal]
        je Lresta
        cmp _resultS,78H ; Codigo ASCCI [x -> Hexadecimal]
        je Lmultiplicacion
        cmp _resultS,2FH ; Codigo ASCCI [/ -> Hexadecimal]
        je Ldivision
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia
        cmp _resultS,65h  ; Codigo ASCCI [e -> Hexadecimal] salir del programa
        je Lmenu


        String_Int _resultS
        mov _numero3,ax

        GetPrint _num
        GetInputMax _resultS
        GetAC _resultS
        GetEND _resultS
        GetPrintCommand _resultS
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia2

        jmp Loperacion

    Loperacion3:
        call funcCalculadora ; LLamamos calculadora 
        
        GetPrint _num ; Obtenemos el primer número
        GetPrint _numero1S
        String_Int _numero1S
        mov _numero1, ax
        GetImparPar
        GetPrint _salto
        GetPrint _num ; Obtenemos el primer número
        GetPrint _numero2S
        String_Int _numero2S
        mov _numero2, ax
        GetImparPar
        GetPrint _salto

    
        GetPrint _num
        GetInputMax _resultS


        cmp _resultS,2BH ; Codigo ASCCI [+ -> Hexadecimal]
        je Lsuma
        cmp _resultS,2DH ; Codigo ASCCI [- -> Hexadecimal]
        je Lresta
        cmp _resultS,78H ; Codigo ASCCI [x -> Hexadecimal]
        je Lmultiplicacion
        cmp _resultS,2FH ; Codigo ASCCI [/ -> Hexadecimal]
        je Ldivision
        cmp _resultS,5EH ; Codigo ASCCI [^ -> Hexadecimal]
        je Lpotencia
        cmp _resultS,65h  ; Codigo ASCCI [e -> Hexadecimal] salir del programa
        je Lmenu

        jmp Loperacion2

    Lsuma: ; operación suma
    
        mov dx, _numero1
        add dx, _numero2
        mov _calcuResultado, dx
        mov ax, _calcuResultado
        Int_String _numero1S ; convierte el numero guardado en ax
        GetPrint _resultado
        GetPrint _numero1S

        ;GetClean _numero1,_numero1,_calcuResultado
           
        jmp Loperacion2


    Lresta: ; operación resta

        mov dx, _numero1
        sub dx, _numero2
        mov _calcuResultado, dx
        mov ax, _calcuResultado
        Int_String _numero1S ; convierte el numero guardado en ax
        GetPrint _resultado
        GetPrint _numero1S
           
        jmp Loperacion2

    Lmultiplicacion: ; operacion multiplicacion

        mov ax, _numero1
        mov bx, _numero2
        imul bx
        mov _calcuResultado,ax
        mov ax,_calcuResultado
        Int_String _numero1S ; convierte el numero guardado en ax
        GetPrint _resultado
        GetPrint _numero1S

           
        jmp Loperacion2

    Ldivision:

        mov ax,_numero1    
        cwd                 ; Convertimos a dobleword
        mov bx,_numero2    
        idiv bx             ; ax/bx ax = Resultado

        mov _calcuResultado,ax  ; guardamos en calcuIN1
        Int_String _numero1S ; convierte el numero guardado en ax
        GetPrint _resultado
        GetPrint _numero1S
        jmp Loperacion2

    Lpotencia:
        
        GetPotencia _calcuResultado, _numero1S, _numero1, _numero2, _numeroTemp
        jmp Loperacion2

    Lpotencia2:


        GetPotencia _calcuResultado, _numero2S, _numero2, _numero3, _numeroTemp

        jmp Loperacion3
    


    Lerror1:
        GetPrint _salto
        GetPrint _error1
        jmp Lmenu
    Lerror2:
        GetPrint _salto
        GetPrint _error2
        jmp Lmenu
    Lerror3:
        GetPrint _salto
        GetPrint _error3
        jmp Lmenu
    Lerror4:
        GetPrint _salto
        GetPrint _error4
        jmp Lmenu
    Lerror5:
        GetPrint _salto
        GetPrint _error5
        jmp Lmenu
    Lerror7:
        GetPrint _salto
        GetPrint _error7
        jmp Lsalir
    Lsalir:


        mov _reporteHandle,0
        GetCreateFile _createFile, _reporteHandle

        ; 8 13 18 26

        ; DATOS 
        GetWriteFile _reporteHandle, _Reporte0S
        GetWriteFile _reporteHandle, _Reporte1S
        GetWriteFile _reporteHandle, _Reporte2S
        GetWriteFile _reporteHandle, _Reporte3S
        GetWriteFile _reporteHandle, _Reporte4S
        GetWriteFile _reporteHandle, _Reporte5S
        GetWriteFile _reporteHandle, _Reporte6S
        GetWriteFile _reporteHandle, _Reporte7S
        GetWriteDate _reporteHandle, _digito1, _digito2
        
        ; GetWriteFile _reporteHandle, _Reporte8S
        ; GetWriteFile _reporteHandle, _Reporte9S
        ; GetWriteFile _reporteHandle, _Reporte10S
        ; GetWriteFile _reporteHandle, _Reporte11S
        ; GetWriteFile _reporteHandle, _Reporte12S
        ; ; HORA
        ; GetWriteFile _reporteHandle, _Reporte13S
        ; GetWriteFile _reporteHandle, _Reporte14S
        ; GetWriteFile _reporteHandle, _Reporte15S
        ; GetWriteFile _reporteHandle, _Reporte16S
        ; GetWriteFile _reporteHandle, _Reporte17S
        ; ESTADISTICOS
        GetWriteFile _reporteHandle, _Reporte18S
        GetWriteFile _reporteHandle, _Reporte19S
        GetWriteFile _reporteHandle, _Reporte20S
        GetWriteFile _reporteHandle, _Reporte21S
        ; IMPAR
        GetWriteFile _reporteHandle, _Reporte22S
        GetWriteFile _reporteHandle, _numeroImparS
        GetWriteFile _reporteHandle, _Reporte31S
        
        ; PAR
        GetWriteFile _reporteHandle, _Reporte23S
        GetWriteFile _reporteHandle, _numeroParS
        GetWriteFile _reporteHandle, _Reporte31S

        GetWriteFile _reporteHandle, _Reporte24S
        GetWriteFile _reporteHandle, _Reporte25S
        ; OPERACIONES
        GetWriteFile _reporteHandle, _Reporte26S
        GetWriteFile _reporteHandle, _Reporte27S
        GetWriteFile _reporteHandle, _Reporte28S
        GetWriteFile _reporteHandle, _Reporte29S


        

        mov ax,4c00h
        int 21h

main endp
end main