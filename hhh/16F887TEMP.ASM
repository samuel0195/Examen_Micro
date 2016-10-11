;**********************************************************************
;   This file is a basic code template for assembly code generation   *
;   on the PIC16F887. This file contains the basic code               *
;   building blocks to build upon.                                    *
;                                                                     *
;   Refer to the MPASM User's Guide for additional information on     *
;   features of the assembler (Document DS33014).                     *
;                                                                     *
;   Refer to the respective PIC data sheet for additional             *
;   information on the instruction set.                               *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Filename:	    xxx.asm                                           *
;    Date:                                                            *
;    File Version:                                                    *
;                                                                     *
;    Author:                                                          *
;    Company:                                                         *
;                                                                     *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Files Required: P16F887.INC                                      *
;                                                                     *
;**********************************************************************
;                                                                     *
;    Notes:                                                           *
;                                                                     *
;**********************************************************************


	list		p=16f887	; list directive to define processor
	#include	<p16f887.inc>	; processor specific variable definitions


; '__CONFIG' directive is used to embed configuration data within .asm file.
; The labels following the directive are located in the respective .inc file.
; See respective data sheet for additional information on configuration word.

	__CONFIG    _CONFIG1, _LVP_OFF & _FCMEN_ON & _IESO_OFF & _BOR_OFF & _CPD_OFF & _CP_OFF & _MCLRE_ON & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT
	__CONFIG    _CONFIG2, _WRT_OFF & _BOR21V



;***** VARIABLE DEFINITIONS
REG1		EQU	0x20		;registro usado en subrutina 1 seg
REG2		EQU	0x21		;
REG3		EQU	0x22		;
conv		EQU	0x23		;

w_temp		EQU	0x7D		; variable used for context saving
status_temp	EQU	0x7E		; variable used for context saving
pclath_temp	EQU	0x7F		; variable used for context saving


;**********************************************************************
	ORG     0x000             ; processor reset vector

	nop
  	goto    main              ; go to beginning of program


	ORG     0x004             ; interrupt vector location

	movwf   w_temp            ; save off current W register contents
	movf	STATUS,w          ; move status register into W register
	movwf	status_temp       ; save off contents of STATUS register
	movf	PCLATH,w	  ; move pclath register into w register
	movwf	pclath_temp	  ; save off contents of PCLATH register

; isr code can go here or be located as a call subroutine elsewhere

	movf	pclath_temp,w	  ; retrieve copy of PCLATH register
	movwf	PCLATH		  ; restore pre-isr PCLATH register contents
	movf    status_temp,w     ; retrieve copy of STATUS register
	movwf	STATUS            ; restore pre-isr STATUS register contents
	swapf   w_temp,f
	swapf   w_temp,w          ; restore pre-isr W register contents
	retfie                    ; return from interrupt



main

;RELOJ IN
BANKSEL		T1CON			;
	CLRF		T1CON			;inicializa timer1
	BSF			T1CON,6			;habilita el timer
	CLRF		TMR1H			;
	;CLRF		TMR1L			;inicializa timer1 en ceros
	NOP							;espacio para colocar la interrup.
	BSF			T1CON,0			;inicia cuenta
;RELOJ END

;inicia bloque configuracion
		BANKSEL		TRISA		;
		CLRF		TRISD		;ajusta puerto D como salida
		BSF			TRISA,0		;RA0 como entrada
		BSF			TRISB,0		;RB0 como input
		BANKSEL		ANSEL		;
		BSF			ANSEL,0		;ajusta RA0 como entrada analogica
		BCF			ANSELH,4	;RB0 como input digital
		BANKSEL		ADCON0		;
		MOVLW		b'00000001'	;
		MOVWF		ADCON0		;
		CLRF		PORTD		;limpia leds
		MOVLW		0x24		;
		MOVWF		FSR			;apunta a registro 0x24
		BANKSEL		ADCON1		;
		CLRF		ADCON1		;
;inicia programa
		CALL		seg1		;espera 1 segundo a que voltaje en canal se estabilize
main3
BANKSEL	PORTB
BTFSC		PORTB,0		;
GOTO		main3		;
CALL		seg1		;
BTFSC		PORTB,0		;
GOTO		main3		;
BANKSEL		T1CON		;
BCF			T1CON,0			;detiene cuenta(timer1)
main1

		MOVF		TMR1H,0	;contenido de adresh pasa a W

		MOVLW		d'32'		;
		BCF			STATUS,0	;limpia carry
		SUBWF		TMR1H,0	;
		BTFSS		STATUS,C	;
		GOTO		ld0			;

		MOVLW		d'64'		;
		BCF			STATUS,0	;limpia carry
		SUBWF		TMR1H,0	;
		BTFSS		STATUS,C	;
		GOTO		ld1			;

		MOVLW		d'96'		;
		BCF			STATUS,0	;limpia carry
		SUBWF		TMR1H,0	;
		BTFSS		STATUS,C	;
		GOTO		ld2			;

		MOVLW		d'128'		;
		BCF			STATUS,0	;limpia carry
		SUBWF		TMR1H,0	;
		BTFSS		STATUS,C	;
		GOTO		ld3			;

		MOVLW		d'160'		;
		BCF			STATUS,0	;limpia carry
		SUBWF		TMR1H,0	;
		BTFSS		STATUS,C	;
		GOTO		ld4			;

		MOVLW		d'192'		;
		BCF			STATUS,0	;limpia carry
		SUBWF		TMR1H,0	;
		BTFSS		STATUS,C	;
		GOTO		ld5			;



		CLRF		PORTD		;
		BSF			PORTD,5
		BSF			PORTD,6
		BSF			PORTD,7
		CALL		ms1			;
		GOTO		main2		;
ld0
		CLRF		PORTD		;
		BSF			PORTD,0		;
		BSF			PORTD,1
		BSF			PORTD,2
		CALL		ms1			;
		GOTO		main2		;
ld1
		CLRF		PORTD		;
		BSF			PORTD,1		;
		BSF			PORTD,2
		BSF			PORTD,3
		CALL		ms1			;
		GOTO		main2		;
ld2
		CLRF		PORTD		;
		BSF			PORTD,2		;
		BSF			PORTD,3
		BSF			PORTD,4
		CALL		ms1			;
		GOTO		main2		;
ld3
		CLRF		PORTD		;
		BSF			PORTD,3		;
		BSF			PORTD,4
		BSF			PORTD,5
		CALL		ms1			;
		GOTO		main2		;
ld4
		CLRF		PORTD		;
		BSF			PORTD,4		;
		BSF			PORTD,5
		BSF			PORTD,6
		CALL		ms1			;
		GOTO		main2		;
ld5
		CLRF		PORTD		;
		BSF			PORTD,5		;
		BSF			PORTD,6
		BSF			PORTD,7
		CALL		ms1			;
		GOTO		main2		;


main2
		BSF			T1CON,0			;inicia cuenta
		GOTO main3


;AREA DE SUBRUTINAS
;*******************************************************************************************************************************
;*******************************************************************************************************************************
;*******************************************************************************************************************************
;*******************************************************************************************************************************
;*******************************************************************************************************************************
;Subrutina que espera 1 segundo
;Variables de trabajo REG1, REG2 y REG3
seg1
	BANKSEL		PORTD			;
	MOVLW		0xFF			;
	MOVWF		REG1			;
	MOVWF		REG2			;
	MOVLW		d'3'			;
	MOVWF		REG3			;
ciclo1
	DECFSZ		REG1,1			;
	GOTO		ciclo1			;
	MOVLW		0xFF			;
	MOVWF		REG1			;
	DECFSZ		REG2,1			;
	GOTO		ciclo1			;
	MOVWF		REG2			;
	DECFSZ		REG3			;
	GOTO		ciclo1			;
	RETURN						;
;*******************************************************************************************************************************
;Subrutina que espera 1 segundo
;Variables de trabajo REG1, REG2 y REG3
ms1
	BANKSEL		PORTD			;
	MOVLW		0xFF			;
	MOVWF		REG1			;
;	MOVWF		REG2			;
	MOVLW		d'240'			;
	MOVWF		REG3			;
ciclo2
	DECFSZ		REG1,1			;
	GOTO		ciclo2			;
	MOVLW		0xFF			;
	MOVWF		REG1			;
	DECFSZ		REG3,1			;
	GOTO		ciclo2			;
;	MOVWF		REG2			;
;	DECFSZ		REG3			;
;	GOTO		ciclo1			;
	RETURN						;



; example of preloading EEPROM locations

	ORG	0x2100
	DE	5, 4, 3, 2, 1

	END                       ; directive 'end of program'
