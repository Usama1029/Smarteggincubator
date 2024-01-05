.include "m328pdef.inc"
.include "delay_Macro.inc"

.cseg
.org 0x0000

SBI DDRB, PB0 ; PB0 set as OUTPUT Pin
CBI PORTB, PB0 ; light off

SBI DDRB, PB1 ; PB1 set as OUTPUT Pin	
CBI PORTB, PB1 ; Buzzer off

SBI DDRB, PB2 ; PB2 set as OUTPUT Pin
CBI PORTB, PB2 ; fan off

; We will use the PORTD for Input
CBI DDRD, PD7 ; PD7 will serve as input for temperature comparison result
CBI DDRD, PD6 ; PD6 will serve as input for humidity comparison 

LDI R31,1

loop:
    ; Read temperature comparison result from PD7
    IN R16, PIND ; Read the input value of PD7
    SBRC R16, 7   ; Check if the temperature comparison result is true (bit 7 is set)
    RJMP temperature_low ; Jump to temperature_low if true

    ; Temperature is high, turn off LED
    CBI PORTB, PB0 ; Turn off LED
    RJMP fan_control ; Jump to fan_control

temperature_low:
    ; Temperature is low, turn on LED
    SBI PORTB, PB0 ; Turn on LED

fan_control:
    ; Read humidity comparison result from PD6
    IN R17, PIND ; Read the input value of PD6
    SBRC R17, 6   ; Check if humidity comparison result is true (bit 6 is set)
    RJMP humidity_high ; Jump to humidity_high if true

    ; Humidity is low, turn off fan
    CBI PORTB, PB2 ; Turn off fan
	CPI R31,0
	breq here
	rjmp end_loop


	here: 
	; Beep the buzzer 3 times
	LDI R18, 3 ; Loop counter for 3 beeps

	buzzer_beep3:
		; Turn on buzzer
		SBI PORTB, PB1 ; Beep on
		delay 500 ; Delay for some milliseconds (you need to define the delay_ms function)
		; Turn off buzzer
		CBI PORTB, PB1 ; Beep off
		delay 500 ; Delay for some milliseconds
			
		DEC R18 ; Decrement loop counter
		BRNE buzzer_beep3 ; Branch if not zero, repeat the beep
	INC R31
    RJMP end_loop ; Jump to end_loop

humidity_high:
    ; Humidity is high, turn on fan
    SBI PORTB, PB2 ; Turn on fan
	

	CPI R31,1
	brlo end_loop

		; Beep the buzzer 2 times
		LDI R18, 2 ; Loop counter for 2 beeps

	buzzer_beep:
		; Turn on buzzer
		SBI PORTB, PB1 ; Beep on
		delay 500 ; Delay for some milliseconds (you need to define the delay_ms function)
		; Turn off buzzer
		CBI PORTB, PB1 ; Beep off
		delay 500 ; Delay for some milliseconds
			
		DEC R18 ; Decrement loop counter
		BRNE buzzer_beep ; Branch if not zero, repeat the beep
	DEC R31


end_loop:
    ; Your main loop code here
    RJMP loop ; Jump back to the loop
