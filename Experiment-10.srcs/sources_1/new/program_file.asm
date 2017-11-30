;------------------------------------------------------------------------------------
;- Experiment #10 
;- 
;- Description: This program counts the number of interrupts
;-              and outputs the count to the 7 segment display
;------------------------------------------------------------------------------------

;------------------------------------------------------------------------------------
; Various Ports 
;------------------------------------------------------------------------------------
.EQU LED_PORT = 0x40
.EQU SEGS     = 0x82
.EQU DISP_EN  = 0x83
;------------------------------------------------------------------------------------
; Segment LUT for Decimal Digits
;------------------------------------------------------------------------------------
.DSEG
.ORG 0x00
seg_data: 	.DB 0x03, 0x9F, 0x25, 0x0D, 0x99	; for (0-4) 
			.DB 0x49, 0x41, 0x1F, 0x01, 0x09	; for (5-9)

;------------------------------------------------------------------------------------
; Foreground Task
;------------------------------------------------------------------------------------
.CSEG
.ORG  0x15

init:  	MOV   r0, 0x00			; Ones digit 
        MOV   r1, 0x00			; Tens digit
		SEI						; Turn on the interrupt

main:   MOV   r22, 0xFF			; Turn off anodes 
		OUT   r22, DISP_EN		; Output off signal 

		LD	  r2, (r0)			; Load the segment value of the 1's digit
		OUT   r2, SEGS			; Output that value to the segments
		MOV   r22, 0x07			; Only turn on the rightmost segment
		OUT   r22, DISP_EN		; Output the signal 
		
		CALL  delay				; Delay the execution for visibility
	
		MOV   r22, 0xFF			; Turn off anodes
		OUT   r22, DISP_EN		; Output off signal

		LD    r2, (r1)			; Load the segment value of the 10's digit
		OUT   r2, SEGS			; Output that value to the segments
		MOV   r22, 0x0B			; Only turn on the second to the right segment
		OUT   r22, DISP_EN		; Output the signal
		
		CALL delay				; Delay the execution for visibility

        BRN   main				; Do it all again

.CSEG
.ORG  0x30

;------------------------------------------------------------------------------------
;- Interupt Service Routine
;- 
;- Description: This ISR increments the count to the segments, and if it is above
;-              49, it resets the value outputted to 0.
;------------------------------------------------------------------------------------
ISR:    ADD    r0, 0x01			; Increment r0
		CMP    r0, 0x0A			; See if r0 > 10
		BRNE   done1 			; If it is not, then you are done with this part
		ADD    r1, 0x01			; If it is add 1 to the 10's place
		MOV    r0, 0x00			; Set the 1's place to 0

done1:  CMP	   r1, 0x05			; Check if the 10's place = 50
		BRNE   done2			; If its not, then you are done
		MOV	   r0, 0x00			; Otherwise, reset the 10's place ...
		MOV	   r1, 0x00			; ... and the 1's place
		
done2:  RETIE					; Return with interrupt enabled
;------------------------------------------------------------------------------------
.CSEG
.ORG  0x3FF
        BRN    ISR
;------------------------------------------------------------------------------------
;- Delay subroutine
;- 
;- Description: This subroutine delays progression of program
;------------------------------------------------------------------------------------
.CSEG
.ORG  0x40
		
delay:	MOV   r3, 0xFF			; Does nothing 256 times
loop: 	SUB   r3, 0x01
		CMP   r3, 0x00
		BRNE  loop
		RET
