

List FileKey 
----------------------------------------------------------------------
C1      C2      C3      C4    || C5
--------------------------------------------------------------
C1:  Address (decimal) of instruction in source file. 
C2:  Segment (code or data) and address (in code or data segment) 
       of inforation associated with current linte. Note that not all
       source lines will contain information in this field.  
C3:  Opcode bits (this field only appears for valid instructions.
C4:  Data field; lists data for labels and assorted directives. 
C5:  Raw line from source code.
----------------------------------------------------------------------


(0001)                            || ;------------------------------------------------------------------------------------
(0002)                            || ;- Experiment #10 
(0003)                            || ;- 
(0004)                            || ;- Description: This program counts the number of interrupts
(0005)                            || ;-              and outputs the count to the 7 segment display
(0006)                            || ;------------------------------------------------------------------------------------
(0007)                            || 
(0008)                            || ;------------------------------------------------------------------------------------
(0009)                            || ; Various Ports 
(0010)                            || ;------------------------------------------------------------------------------------
(0011)                       064  || .EQU LED_PORT = 0x40
(0012)                       130  || .EQU SEGS     = 0x82
(0013)                       131  || .EQU DISP_EN  = 0x83
(0014)                            || ;------------------------------------------------------------------------------------
(0015)                            || ; Segment LUT for Decimal Digits
(0016)                            || ;------------------------------------------------------------------------------------
(0017)                            || .DSEG
(0018)                       000  || .ORG 0x00
(0019)  DS-0x000             005  || seg_data: 	.DB 0x03, 0x9F, 0x25, 0x0D, 0x99	; for (0-4) 
(0020)  DS-0x005             005  || 			.DB 0x49, 0x41, 0x1F, 0x01, 0x09	; for (5-9)
(0021)                            || 
(0022)                            || ;------------------------------------------------------------------------------------
(0023)                            || ; Foreground Task
(0024)                            || ;------------------------------------------------------------------------------------
(0025)                            || .CSEG
(0026)                       021  || .ORG  0x15
(0027)                            || 
-------------------------------------------------------------------------------------------
-STUP-  CS-0x000  0x36003  0x003  ||              MOV     r0,0x03     ; write dseg data to reg
-STUP-  CS-0x001  0x3A000  0x000  ||              LD      r0,0x00     ; place reg data in mem 
-STUP-  CS-0x002  0x3609F  0x09F  ||              MOV     r0,0x9F     ; write dseg data to reg
-STUP-  CS-0x003  0x3A001  0x001  ||              LD      r0,0x01     ; place reg data in mem 
-STUP-  CS-0x004  0x36025  0x025  ||              MOV     r0,0x25     ; write dseg data to reg
-STUP-  CS-0x005  0x3A002  0x002  ||              LD      r0,0x02     ; place reg data in mem 
-STUP-  CS-0x006  0x3600D  0x00D  ||              MOV     r0,0x0D     ; write dseg data to reg
-STUP-  CS-0x007  0x3A003  0x003  ||              LD      r0,0x03     ; place reg data in mem 
-STUP-  CS-0x008  0x36099  0x099  ||              MOV     r0,0x99     ; write dseg data to reg
-STUP-  CS-0x009  0x3A004  0x004  ||              LD      r0,0x04     ; place reg data in mem 
-STUP-  CS-0x00A  0x36049  0x049  ||              MOV     r0,0x49     ; write dseg data to reg
-STUP-  CS-0x00B  0x3A005  0x005  ||              LD      r0,0x05     ; place reg data in mem 
-STUP-  CS-0x00C  0x36041  0x041  ||              MOV     r0,0x41     ; write dseg data to reg
-STUP-  CS-0x00D  0x3A006  0x006  ||              LD      r0,0x06     ; place reg data in mem 
-STUP-  CS-0x00E  0x3601F  0x01F  ||              MOV     r0,0x1F     ; write dseg data to reg
-STUP-  CS-0x00F  0x3A007  0x007  ||              LD      r0,0x07     ; place reg data in mem 
-STUP-  CS-0x010  0x36001  0x001  ||              MOV     r0,0x01     ; write dseg data to reg
-STUP-  CS-0x011  0x3A008  0x008  ||              LD      r0,0x08     ; place reg data in mem 
-STUP-  CS-0x012  0x36009  0x009  ||              MOV     r0,0x09     ; write dseg data to reg
-STUP-  CS-0x013  0x3A009  0x009  ||              LD      r0,0x09     ; place reg data in mem 
-STUP-  CS-0x014  0x080A8  0x100  ||              BRN     0x15        ; jump to start of .cseg in program mem 
-------------------------------------------------------------------------------------------
(0028)  CS-0x015  0x36000  0x015  || init:  	MOV   r0, 0x00			; ones digit 
(0029)  CS-0x016  0x36100         ||         MOV   r1, 0x00			; tens digit
(0030)  CS-0x017  0x1A000         || 		SEI
(0031)                            || 
(0032)  CS-0x018  0x376FF  0x018  || main:   MOV   r22, 0xFF			; Turn off anodes 
(0033)  CS-0x019  0x35683         || 		OUT   r22, DISP_EN		; Output off signal 
(0034)                            || 
(0035)  CS-0x01A  0x04202         || 		LD	  r2, (r0)			; Load the segment value of the 1's digit
(0036)  CS-0x01B  0x34282         || 		OUT   r2, SEGS			; Output that value to the segments
(0037)  CS-0x01C  0x37607         || 		MOV   r22, 0x07			; Only turn on the rightmost segment
(0038)  CS-0x01D  0x35683         || 		OUT   r22, DISP_EN		; Output the signal 
(0039)                            || 		
(0040)  CS-0x01E  0x08201         || 		CALL  delay				; Delay the execution 
(0041)                            || 	
(0042)  CS-0x01F  0x376FF         || 		MOV   r22, 0xFF
(0043)  CS-0x020  0x35683         || 		OUT   r22, DISP_EN
(0044)                            || 
(0045)  CS-0x021  0x0420A         || 		LD    r2, (r1)
(0046)  CS-0x022  0x34282         || 		OUT   r2, SEGS
(0047)  CS-0x023  0x3760B         || 		MOV   r22, 0x0B
(0048)  CS-0x024  0x35683         || 		OUT   r22, DISP_EN
(0049)                            || 		
(0050)  CS-0x025  0x08201         || 		CALL delay
(0051)                            || 
(0052)  CS-0x026  0x080C0         ||         BRN   main
(0053)                            || 
(0054)                            || .CSEG
(0055)                       048  || .ORG  0x30
(0056)                            || 
(0057)                            || ;----------------------------------------------------------
(0058)                            || ;- Interupt Service Routine
(0059)                            || ;- 
(0060)                            || ;- Description: This ISR counts the number of interrupts 
(0061)                            || ;----------------------------------------------------------
(0062)  CS-0x030  0x28001  0x030  || ISR:    ADD    r0, 0x01
(0063)  CS-0x031  0x3000A         || 		CMP    r0, 0x0A
(0064)  CS-0x032  0x081AB         || 		BRNE   done1 
(0065)  CS-0x033  0x28101         || 		ADD    r1, 0x01
(0066)  CS-0x034  0x36000         || 		MOV    r0, 0x00
(0067)                            || 
(0068)  CS-0x035  0x30105  0x035  || done1:  CMP	   r1, 0x05
(0069)  CS-0x036  0x081CB         || 		BRNE   done2
(0070)  CS-0x037  0x36000         || 		MOV	   r0, 0x00
(0071)  CS-0x038  0x36100         || 		MOV	   r1, 0x00
(0072)                            || 		
(0073)  CS-0x039  0x1A003  0x039  || done2:  RETIE
(0074)                            || ;----------------------------------------------------------
(0075)                            || .CSEG
(0076)                       1023  || .ORG  0x3FF
(0077)  CS-0x3FF  0x08180         ||         BRN    ISR
(0078)                            || ;----------------------------------------------------------
(0079)                            || ;- Delay subroutine
(0080)                            || ;- 
(0081)                            || ;- Description: This subroutine delays progression of program
(0082)                            || ;----------------------------------------------------------
(0083)                            || .CSEG
(0084)                       064  || .ORG  0x40
(0085)                            || 		
(0086)  CS-0x040  0x363FF  0x040  || delay:	MOV   r3, 0xFF
(0087)  CS-0x041  0x2C301  0x041  || loop: 	SUB   r3, 0x01
(0088)  CS-0x042  0x30300         || 		CMP   r3, 0x00
(0089)  CS-0x043  0x0820B         || 		BRNE  loop
(0090)  CS-0x044  0x18002         || 		RET





Symbol Table Key 
----------------------------------------------------------------------
C1             C2     C3      ||  C4+
-------------  ----   ----        -------
C1:  name of symbol
C2:  the value of symbol 
C3:  source code line number where symbol defined
C4+: source code line number of where symbol is referenced 
----------------------------------------------------------------------


-- Labels
------------------------------------------------------------ 
DELAY          0x040   (0086)  ||  0040 0050 
DONE1          0x035   (0068)  ||  0064 
DONE2          0x039   (0073)  ||  0069 
INIT           0x015   (0028)  ||  
ISR            0x030   (0062)  ||  0077 
LOOP           0x041   (0087)  ||  0089 
MAIN           0x018   (0032)  ||  0052 


-- Directives: .BYTE
------------------------------------------------------------ 
--> No ".BYTE" directives used


-- Directives: .EQU
------------------------------------------------------------ 
DISP_EN        0x083   (0013)  ||  0033 0038 0043 0048 
LED_PORT       0x040   (0011)  ||  
SEGS           0x082   (0012)  ||  0036 0046 


-- Directives: .DEF
------------------------------------------------------------ 
--> No ".DEF" directives used


-- Directives: .DB
------------------------------------------------------------ 
SEG_DATA       0x005   (0019)  ||  
