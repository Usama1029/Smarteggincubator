.include "m328pdef.inc"
.include "delay_Macro.inc"

.cseg
.org 0x0000

;We will try to connect Light to PB1, Buzzer to PB2 and Fan to PB3


SBI DDRB, PB0 ; PB0 set as OUTPUT Pin
CBI PORTB, PB0 ; light off

SBI DDRB, PB1 ; PB1 set as OUTPUT Pin
CBI PORTB, PB1 ; Buzzer off

SBI DDRB, PB2 ; PB2 set as OUTPUT Pin
CBI PORTB, PB2 ; fan off

;We will use the PORTD for Input
CBI DDRD, PD7 
;PD7 will serve as input that will tell temprature is high or low (High = High temprature and Low = Low temprature)
CBI DDRD PD6
;PD6 will serve as input that will tell humidity value is high or low (High = High Humidity and Low = Low Humidity)
loop:








end: 
	rjmp loop
exit:

