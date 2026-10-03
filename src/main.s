.section .data 
    ArregloBubble: 
        .quad 10,5,8,12,6,4,9,23,56,1          // reservamos 64 bits para cada elemento
    ArregloBubble_fin:

    .equ longitud, (ArregloBubble_fin-ArregloBubble)/8    // definimos longitud con el valor constante de la longitud del arreglo (10)

    ArregloSelection:
        .quad 10,5,8,12,6,4,9,23,56,1          // segundo arreglo para probar Selection Sort

    msg_bubble_antes:
        .ascii "Bubble Sort - Antes:\n"          // mensaje antes de ordenar con Bubble Sort
    msg_bubble_antes_fin:
    .equ msg_bubble_antes_len, (msg_bubble_antes_fin-msg_bubble_antes)

    msg_bubble_despues:
        .ascii "Bubble Sort - Despues:\n"        // mensaje despues de ordenar con Bubble Sort
    msg_bubble_despues_fin:
    .equ msg_bubble_despues_len, (msg_bubble_despues_fin-msg_bubble_despues)

    msg_selection_antes:
        .ascii "Selection Sort - Antes:\n"       // mensaje antes de ordenar con Selection Sort
    msg_selection_antes_fin:
    .equ msg_selection_antes_len, (msg_selection_antes_fin-msg_selection_antes)

    msg_selection_despues:
        .ascii "Selection Sort - Despues:\n"     // mensaje despues de ordenar con Selection Sort
    msg_selection_despues_fin:
    .equ msg_selection_despues_len, (msg_selection_despues_fin-msg_selection_despues)

    espacio:
        .ascii " "                               // espacio entre cada numero

    salto:
        .ascii "\n"                              // salto de linea


.section .bss
    buffer:                                      // espacio temporal para guardar digitos
        .skip 32                                 // reservamos 32 bytes


.section .text
.global _start                                   // indicamos al ensamblador que _start es un simbolo visible como punto de entrada


_start:

    mov x0, #1                                   // x0 = stdout salida estandar/terminal
    adr x1, msg_bubble_antes                     // x1 = direccion del mensaje
    mov x2, #msg_bubble_antes_len                // x2 = cantidad de bytes del mensaje
    mov x8, #64                                  // seleccionamos syscall write
    svc #0                                       // ejecutamos syscall

    adr x0, ArregloBubble                        // x0 = direccion base del arreglo
    mov x1, #longitud                            // x1 = cantidad de elementos
    bl print_array                               // mostramos arreglo antes de Bubble Sort

    adr x0, ArregloBubble                        // x0 = direccion base del arreglo
    mov x1, #longitud                            // x1 = cantidad de elementos
    bl bubble_sort                               // llamamos a Bubble Sort

    mov x0, #1                                   // x0 = stdout
    adr x1, msg_bubble_despues                   // x1 = direccion del mensaje
    mov x2, #msg_bubble_despues_len              // x2 = cantidad de bytes del mensaje
    mov x8, #64                                  // seleccionamos syscall write
    svc #0                                       // ejecutamos syscall

    adr x0, ArregloBubble                        // x0 = direccion del arreglo ya ordenado
    mov x1, #longitud                            // x1 = cantidad de elementos
    bl print_array                               // mostramos arreglo despues de Bubble Sort

    mov x0, #1                                   // x0 = stdout
    adr x1, msg_selection_antes                  // x1 = direccion del mensaje
    mov x2, #msg_selection_antes_len             // x2 = cantidad de bytes del mensaje
    mov x8, #64                                  // seleccionamos syscall write
    svc #0                                       // ejecutamos syscall

    adr x0, ArregloSelection                     // x0 = direccion base del segundo arreglo
    mov x1, #longitud                            // x1 = cantidad de elementos
    bl print_array                               // mostramos arreglo antes de Selection Sort

    adr x0, ArregloSelection                     // x0 = direccion base del arreglo
    mov x1, #longitud                            // x1 = cantidad de elementos
    bl selection_sort                            // llamamos a Selection Sort

    mov x0, #1                                   // x0 = stdout
    adr x1, msg_selection_despues                // x1 = direccion del mensaje
    mov x2, #msg_selection_despues_len           // x2 = cantidad de bytes del mensaje
    mov x8, #64                                  // seleccionamos syscall write
    svc #0                                       // ejecutamos syscall

    adr x0, ArregloSelection                     // x0 = direccion del arreglo ya ordenado
    mov x1, #longitud                            // x1 = cantidad de elementos
    bl print_array                               // mostramos arreglo despues de Selection Sort

    mov x0, #0                                   // codigo de salida
    mov x8, #93                                  // syscall exit
    svc #0                                       // ejecutamos syscall


print_array:
    stp x29, x30, [sp, #-48]!                    // reservamos 48 bytes y guardamos FP y LR
    mov x29, sp                                  // x29 sera el frame pointer de esta funcion
    stp x19, x20, [sp, #16]                     // guardamos x19 y x20
    stp x21, x22, [sp, #32]                     // guardamos x21 y x22

    mov x19, x0                                  // x19 = direccion base del arreglo
    mov x20, x1                                  // x20 = longitud del arreglo
    mov x21, #0                                  // x21 = indice i empieza en 0

print_loop:
    cmp x21, x20                                 // comparamos i con longitud
    b.ge print_fin                               // si i >= longitud terminamos

    ldr x22, [x19, x21, lsl #3]                 // cargamos Arreglo[i], multiplicando i por 8
    mov x0, x22                                  // x0 = numero que queremos imprimir
    bl print_number                              // convertimos el numero a ASCII y lo imprimimos

    mov x0, #1                                   // x0 = stdout
    adr x1, espacio                              // x1 = direccion del caracter espacio
    mov x2, #1                                   // imprimimos 1 byte
    mov x8, #64                                  // syscall write
    svc #0                                       // ejecutamos syscall

    add x21, x21, #1                             // incrementamos i
    b print_loop                                 // regresamos al inicio del ciclo

print_fin:
    mov x0, #1                                   // x0 = stdout
    adr x1, salto                                // x1 = direccion del salto de linea
    mov x2, #1                                   // imprimimos 1 byte
    mov x8, #64                                  // syscall write
    svc #0                                       // ejecutamos syscall

    ldp x21, x22, [sp, #32]                     // restauramos x21 y x22
    ldp x19, x20, [sp, #16]                     // restauramos x19 y x20
    ldp x29, x30, [sp], #48                     // restauramos FP y LR y liberamos 48 bytes
    ret                                          // regresamos a quien llamo print_array


print_number:
    stp x29, x30, [sp, #-16]!                   // guardamos FP y LR en el stack
    mov x29, sp                                  // creamos el stack frame

    adr x1, buffer                               // x1 = direccion inicial del buffer
    add x1, x1, #32                             // x1 = final del buffer
    mov x2, #0                                   // contador de caracteres empieza en 0
    mov x3, #10                                  // x3 = divisor decimal 10

    cmp x0, #0                                   // comparamos el numero con cero
    b.ne conversion_loop                         // si no es cero hacemos la conversion

    mov w4, #'0'                                 // w4 = caracter ASCII '0'
    sub x1, x1, #1                               // retrocedemos un byte en el buffer
    strb w4, [x1]                                // guardamos el caracter '0'
    mov x2, #1                                   // tenemos un caracter para imprimir
    b imprimir_numero                            // saltamos a imprimir el numero

conversion_loop:
    udiv x4, x0, x3                              // x4 = numero / 10
    msub x5, x4, x3, x0                         // x5 = numero - (cociente * 10), obtenemos residuo
    add x5, x5, #'0'                             // convertimos el residuo a ASCII

    sub x1, x1, #1                               // retrocedemos una posicion en el buffer
    strb w5, [x1]                                // guardamos el caracter
    add x2, x2, #1                               // aumentamos la cantidad de caracteres

    mov x0, x4                                   // continuamos trabajando con el cociente
    cbnz x0, conversion_loop                     // repetimos mientras el cociente sea distinto de cero

imprimir_numero:
    mov x0, #1                                   // x0 = stdout
    mov x8, #64                                  // syscall write
    svc #0                                       // imprimimos x2 bytes desde la direccion x1

    ldp x29, x30, [sp], #16                     // restauramos FP y LR y liberamos el stack
    ret                                          // regresamos a print_array


bubble_sort:
    stp x29, x30, [sp, #-32]!                   // reservamos 32 bytes y guardamos FP y LR
    mov x29, sp                                  // creamos el stack frame
    stp x19, x20, [sp, #16]                     // preservamos los registros x19 y x20

    mov x19, x0                                  // x19 = direccion base del arreglo
    mov x20, x1                                  // x20 = longitud del arreglo

    cmp x20, #1                                  // verificamos si hay mas de un elemento
    b.le bubble_fin                              // si longitud <= 1 el arreglo ya esta ordenado

    mov x4, x20                                  // x4 = cantidad de elementos restantes

ciclo_externo:
    mov x5, x19                                  // x5 vuelve al inicio del arreglo
    sub x6, x4, #1                               // x6 = cantidad de comparaciones de esta pasada

ciclo_interno:
    ldr x2, [x5]                                 // x2 = elemento actual
    ldr x3, [x5, #8]                             // x3 = elemento siguiente

    cmp x2, x3                                   // comparamos elemento actual con el siguiente
    b.ls no_cambiar                              // si actual <= siguiente no intercambiamos

    str x3, [x5]                                 // guardamos el menor en la posicion actual
    str x2, [x5, #8]                             // guardamos el mayor en la posicion siguiente

no_cambiar:
    add x5, x5, #8                               // avanzamos al siguiente entero de 64 bits
    sub x6, x6, #1                               // reducimos el contador de comparaciones
    cbnz x6, ciclo_interno                       // repetimos mientras queden comparaciones

    sub x4, x4, #1                               // reducimos la parte del arreglo sin ordenar
    cmp x4, #1                                   // verificamos si queda mas de un elemento
    b.gt ciclo_externo                           // realizamos otra pasada si es necesario

bubble_fin:
    ldp x19, x20, [sp, #16]                     // restauramos x19 y x20
    ldp x29, x30, [sp], #32                     // restauramos FP y LR y liberamos el stack
    ret                                          // regresamos a _start


selection_sort:
    stp x29, x30, [sp, #-32]!                   // reservamos 32 bytes y guardamos FP y LR
    mov x29, sp                                  // creamos el stack frame
    stp x19, x20, [sp, #16]                     // preservamos x19 y x20

    mov x19, x0                                  // x19 = direccion base del arreglo
    mov x20, x1                                  // x20 = longitud del arreglo
    mov x9, #0                                   // x9 = indice i empieza en 0

    cmp x20, #1                                  // verificamos si existe mas de un elemento
    b.le selection_fin                           // si longitud <= 1 ya esta ordenado

selection_externo:
    sub x2, x20, #1                              // x2 = longitud - 1
    cmp x9, x2                                   // comparamos i con longitud - 1
    b.ge selection_fin                           // si i >= longitud - 1 terminamos

    mov x11, x9                                  // min_index = i
    add x10, x9, #1                              // j = i + 1

selection_interno:
    cmp x10, x20                                 // comparamos j con longitud
    b.ge selection_intercambio                   // si j >= longitud terminamos de buscar el minimo

    ldr x12, [x19, x10, lsl #3]                 // x12 = Arreglo[j]
    ldr x13, [x19, x11, lsl #3]                 // x13 = Arreglo[min_index]

    cmp x12, x13                                 // comparamos Arreglo[j] con el minimo actual
    b.hs selection_no_nuevo_minimo               // si Arreglo[j] >= minimo no cambiamos min_index

    mov x11, x10                                 // encontramos un nuevo minimo, min_index = j

selection_no_nuevo_minimo:
    add x10, x10, #1                             // incrementamos j
    b selection_interno                          // continuamos buscando el menor

selection_intercambio:
    cmp x11, x9                                  // comparamos min_index con i
    b.eq selection_siguiente                     // si son iguales no necesitamos intercambio

    ldr x12, [x19, x9, lsl #3]                  // x12 = Arreglo[i]
    ldr x13, [x19, x11, lsl #3]                 // x13 = Arreglo[min_index]

    str x13, [x19, x9, lsl #3]                  // Arreglo[i] = Arreglo[min_index]
    str x12, [x19, x11, lsl #3]                 // Arreglo[min_index] = antiguo Arreglo[i]

selection_siguiente:
    add x9, x9, #1                               // incrementamos i
    b selection_externo                          // repetimos el ciclo externo

selection_fin:
    ldp x19, x20, [sp, #16]                     // restauramos x19 y x20
    ldp x29, x30, [sp], #32                     // restauramos FP y LR y liberamos el stack
    ret                                          // regresamos a _start