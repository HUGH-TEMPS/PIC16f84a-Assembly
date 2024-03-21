list p=16f84a
    org 0x00

    STATUS  equ 0x03
    TRISA   equ 0x85
    TRISB   equ 0x86
    PORTA   equ 0x05
    PORTB   equ 0x06
	myCount equ 0ch
	myCount1 equ 0dh
start
    bsf STATUS, 5      
    movlw 0x00         
    movwf TRISB
    movlw 0x1F         
    movwf TRISA
    bcf STATUS, 5
	
main
    btfsc PORTA,0     
    call Delay1       
    call Delay1
    call Delay1
    btfsc PORTA,0      
    goto main         
    goto zero

zero:
    movlw b'00111111' ;0
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto one
    

one:
    btfss PORTA, 0
    goto one
    movlw b'00000110' ;1
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto two
    

two:
    btfss PORTA, 0
    goto two
    movlw b'01011011' ;2
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto three
    

three:
    btfss PORTA, 0
    goto three
    movlw b'01001111' ;3
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto four
    

four:
    btfss PORTA, 0
    goto four
    movlw b'01100110' ;4
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto five
    

five: 
    btfss PORTA, 0
    goto five
    movlw b'01101101' ;5
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto six
    

six:
    btfss PORTA, 0
    goto six
    movlw b'01111101' ;6
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto seven
    

seven:
    btfss PORTA, 0
    goto seven
    movlw b'00000111' ;7
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto eight
    

eight:
    btfss PORTA, 0
    goto eight
    movlw b'01111111' ;8
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1
    btfsc PORTA, 0
    goto nine
    

nine:
    btfss PORTA, 0
    goto nine
    movlw b'01101111' ;9
    movwf PORTB
    call Delay1       
    call Delay1
    call Delay1
	call Delay1       
    btfsc PORTA, 0
    goto zero
		
Delay1
	NOP
	NOP
	NOP
	NOP

DelayLoop:
    decfsz myCount, 1 
    goto DelayLoop
		decfsz myCount1, 1
	goto DelayLoop
    return

end
