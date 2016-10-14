# MPLAB IDE generated this makefile for use with GNU make.
# Project: examen1.mcp
# Date: Thu Oct 13 21:35:32 2016

AS = MPASMWIN.exe
CC = 
LD = mplink.exe
AR = mplib.exe
RM = rm

examen1.cof : 16F887TEMP.o
	$(CC) /p16F887 "16F887TEMP.o" /u_DEBUG /z__MPLAB_BUILD=1 /z__MPLAB_DEBUG=1 /z__MPLAB_DEBUGGER_PICKIT2=1 /z__ICD2RAM=1 /o"examen1.cof" /M"examen1.map" /W

16F887TEMP.o : 16F887TEMP.ASM ../../../../../Program\ Files\ (x86)/Microchip/MPASM\ Suite/p16f887.inc
	$(AS) /q /p16F887 "16F887TEMP.ASM" /l"16F887TEMP.lst" /e"16F887TEMP.err" /o"16F887TEMP.o" /d__DEBUG=1 /d__MPLAB_DEBUGGER_PICKIT2=1

clean : 
	$(CC) "16F887TEMP.o" "16F887TEMP.err" "16F887TEMP.lst" "examen1.cof" "examen1.hex"

