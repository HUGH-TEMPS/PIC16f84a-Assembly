list p=16F84A
org 0x00
goto Setup
org 0x04
goto ISR

; Define constants and registers
STATUS       equ 03h
TRISA        equ 85h
TRISB        equ 86h
PORTA        equ 05h
PORTB        equ 06h
OPTION_REG   equ 81h
INTCON       equ 0Bh
TMR0         equ 01h
PCL          equ 02h
TENS         equ 0Ch	
UNITS        equ 0Dh
MUX_FLAG     equ 0Fh	;alternate the display
DISPLAY_COUNT equ 10h	;to match frequency and avoid the units to count 1,3,5,7,9

; Setup routine
Setup:
    bsf STATUS, 5          ; Switch to Bank 1
    clrf TRISB             ; Set all PORTB pins as output
    clrf TRISA             ; Set all PORTA pins as output
    movlw b'00000100'      ; Set prescaler to 1:32 (faster than 1:256)
    movwf OPTION_REG
    bcf STATUS, 5          ; Switch back to Bank 0
    movlw d'8'				;timer
    movwf TMR0
    movlw d'20'           ; Initialize DISPLAY_COUNT to control update frequency
    movwf DISPLAY_COUNT
    movlw b'10100000'      ; Enable timer interrupt and global interrupt
    movwf INTCON
    clrf TENS
    clrf UNITS
    clrf PORTA
    clrf MUX_FLAG          ; Clear multiplexing flag


Main:
    goto Main              ; Main loop does nothing, waiting for interrupts

ISR:
    movlw d'8'            ; Reload Timer0 with 1 for 1ms timing
    movwf TMR0
    bcf INTCON, 2          ; Clear Timer0 overflow flag

    goto CheckDisplayCount ; If COUNT is not zero, check display counter

CheckDisplayCount:
    decfsz DISPLAY_COUNT, F; Decrement DISPLAY_COUNT and check if zero
    goto DisplayUpdate     ; If DISPLAY_COUNT is not zero, update display

    movlw d'100'           ; Reset DISPLAY_COUNT to 100
    movwf DISPLAY_COUNT
    call IncrementCounters ; Call the subroutine to increment counters

DisplayUpdate:				;alternate the display on and off
    btfss MUX_FLAG, 0      ; Check the multiplexing flag
    goto DisplayUnits      ; If flag is 0, display units
    goto DisplayTens       ; If flag is 1, display tens

DisplayUnits:
    movf UNITS, W
    call Bcdto7seg
    movwf PORTB
    bsf PORTA, 1           ; Enable units digit (connected to PORTA,1 cathode)
    bcf PORTA, 0           ; Disable tens digit
    bsf MUX_FLAG, 0        ; Set multiplexing flag
    goto ExitISR

DisplayTens:
    movf TENS, W
    call Bcdto7seg
    movwf PORTB
    bsf PORTA, 0           ; Enable tens digit (connected to PORTA,0 cathode)
    bcf PORTA, 1           ; Disable units digit
    bcf MUX_FLAG, 0        ; Clear multiplexing flag
    goto ExitISR

IncrementCounters:
    ; Increment UNITS
    incf UNITS, F
    movf UNITS, W
    sublw 0x0A		;this count 0 to 9 in seconds
    btfss STATUS, 2
    goto EndIncrement
    clrf UNITS
    incf TENS, F
    movf TENS, W
    ;sublw 0x0A		;when TENS reach 0 reset the count to 00
	sublw d'6'		;when tens reach 6 or 60 it will reset also 
    btfss STATUS, 2
    goto EndIncrement
    clrf TENS

EndIncrement:
    return

ExitISR:
    retfie
;lookup table
Bcdto7seg:
    addwf PCL, F
    retlw 0x3F            ; 0
    retlw 0x06            ; 1
    retlw 0x5B            ; 2
    retlw 0x4F            ; 3
    retlw 0x66            ; 4
    retlw 0x6D            ; 5
    retlw 0x7D            ; 6
    retlw 0x07            ; 7
    retlw 0x7F            ; 8
    retlw 0x6F            ; 9

end
