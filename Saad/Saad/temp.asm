
cpi r31,60
brlo l1
rjmp loop

l1:

SBI PORTB, PB1 ; Buzzle on
delay(500)
CBI PORTB, PB1
delay(500)
dec r30
cpi r30,0
brge l1

l2:
 
SBI PORTD, PD6
ldi r31,140

