
;CodeVisionAVR C Compiler V3.12 Advanced
;(C) Copyright 1998-2014 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Build configuration    : Debug
;Chip type              : ATmega128
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 1024 byte(s)
;Heap size              : 0 byte(s)
;Promote 'char' to 'int': Yes
;'char' is unsigned     : Yes
;8 bit enums            : Yes
;Global 'const' stored in FLASH: No
;Enhanced function parameter passing: Yes
;Enhanced core instructions: On
;Automatic register allocation for global variables: On
;Smart register allocation: On

	#define _MODEL_SMALL_

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4096
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTW2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD2FN
	LDI  R26,LOW(2*@0+(@1))
	LDI  R27,HIGH(2*@0+(@1))
	LDI  R24,BYTE3(2*@0+(@1))
	LDI  R25,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	PUSH R26
	PUSH R27
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	POP  R27
	POP  R26
	ICALL
	.ENDM

	.MACRO __CALL2EX
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	CALL __EEPROMRDD
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1STACK
	IN   R30,SPL
	IN   R31,SPH
	ADIW R30,@0+1
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z
	MOVW R30,R0
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _i=R4
	.DEF _i_msb=R5
	.DEF _pmenu=R6
	.DEF _pmenu_msb=R7
	.DEF _selectRow=R8
	.DEF _selectRow_msb=R9
	.DEF _temp=R10
	.DEF _temp_msb=R11

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

;GLOBAL REGISTER VARIABLES INITIALIZATION
__REG_VARS:
	.DB  0x0,0x0,0x0,0x0
	.DB  0x1,0x0

_0x3:
	.DB  0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8
	.DB  0x80,0x90
_0x4B:
	.DB  0x0,0x0,0x4D,0x41,0x49,0x4E,0x20,0x4D
	.DB  0x45,0x4E,0x55,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x20,0x20,0x53,0x65,0x6E,0x73,0x6F,0x72
	.DB  0x73,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,LOW(_SensorMenu),HIGH(_SensorMenu),0x20,0x20
	.DB  0x41,0x63,0x74,0x75,0x61,0x74,0x6F,0x72
	.DB  0x73,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_ActuatorMenu),HIGH(_ActuatorMenu),0x20,0x20,0x53,0x65
	.DB  0x74,0x74,0x69,0x6E,0x67,0x73,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  LOW(_SetMenu),HIGH(_SetMenu)
_0x4C:
	.DB  LOW(_MainMenu),HIGH(_MainMenu),0x53,0x45,0x4E,0x53,0x4F,0x52
	.DB  0x53,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x20,0x20,0x54,0x65,0x6D,0x70,0x65,0x72
	.DB  0x61,0x74,0x75,0x72,0x65,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,LOW(_TempMenu),HIGH(_TempMenu),0x20,0x20
	.DB  0x48,0x75,0x6D,0x69,0x64,0x69,0x74,0x79
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_HumiMenu),HIGH(_HumiMenu),0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65
_0x4D:
	.DB  LOW(_SensorMenu),HIGH(_SensorMenu),0x54,0x45,0x4D,0x50,0x45,0x52
	.DB  0x41,0x54,0x55,0x52,0x45,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x20,0x20,0x4F,0x4E,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x4F,0x46,0x46,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1A,0x0,LOW(_ctrlDevice),HIGH(_ctrlDevice)
_0x4E:
	.DB  LOW(_SensorMenu),HIGH(_SensorMenu),0x48,0x55,0x4D,0x49,0x44,0x49
	.DB  0x54,0x59,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x2,0x0
	.DB  0x20,0x20,0x4E,0x6F,0x6E,0x65,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x4E,0x6F,0x6E,0x65,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65
_0x4F:
	.DB  LOW(_MainMenu),HIGH(_MainMenu),0x41,0x43,0x54,0x55,0x41,0x54
	.DB  0x4F,0x52,0x53,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x2,0x0
	.DB  0x20,0x20,0x4C,0x65,0x64,0x73,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,LOW(_LedMenu),HIGH(_LedMenu),0x20,0x20
	.DB  0x52,0x65,0x6C,0x61,0x79,0x73,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_RelayMenu),HIGH(_RelayMenu),0x20,0x20,0x4D,0x6F
	.DB  0x74,0x6F,0x72,0x73,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  LOW(_MotorMenu),HIGH(_MotorMenu)
_0x50:
	.DB  LOW(_ActuatorMenu),HIGH(_ActuatorMenu),0x4C,0x45,0x44,0x53,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x20,0x20,0x53,0x69,0x6E,0x67,0x6C,0x65
	.DB  0x20,0x4C,0x65,0x64,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,LOW(_SingLedMenu),HIGH(_SingLedMenu),0x20,0x20
	.DB  0x37,0x2D,0x53,0x65,0x67,0x20,0x4C,0x65
	.DB  0x64,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_SevenSegLedMenu),HIGH(_SevenSegLedMenu),0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65
_0x51:
	.DB  LOW(_LedMenu),HIGH(_LedMenu),0x53,0x49,0x4E,0x47,0x4C,0x45
	.DB  0x20,0x4C,0x45,0x44,0x53,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x20,0x20,0x49,0x4E,0x54,0x45,0x52,0x4C
	.DB  0x45,0x41,0x56,0x45,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x52,0x55,0x4E,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x4F,0x46
	.DB  0x46,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x15,0x0,LOW(_ctrlDevice),HIGH(_ctrlDevice)
_0x52:
	.DB  LOW(_LedMenu),HIGH(_LedMenu),0x37,0x2D,0x53,0x45,0x47,0x20
	.DB  0x4C,0x45,0x44,0x53,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x2,0x0
	.DB  0x20,0x20,0x4F,0x4E,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x4F,0x46,0x46,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x16,0x0,LOW(_ctrlDevice),HIGH(_ctrlDevice)
_0x53:
	.DB  LOW(_ActuatorMenu),HIGH(_ActuatorMenu),0x52,0x45,0x4C,0x41,0x59,0x53
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x2,0x0
	.DB  0x20,0x20,0x4F,0x4E,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x4F,0x46,0x46,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x4F,0x46
	.DB  0x46,0x20,0x47,0x52,0x41,0x44,0x55,0x41
	.DB  0x4C,0x4C,0x59,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x17,0x0,LOW(_ctrlDevice),HIGH(_ctrlDevice)
_0x54:
	.DB  LOW(_ActuatorMenu),HIGH(_ActuatorMenu),0x4D,0x4F,0x54,0x4F,0x52,0x53
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x3,0x0
	.DB  0x20,0x20,0x4D,0x6F,0x74,0x6F,0x72,0x31
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,LOW(_Motor1Menu),HIGH(_Motor1Menu),0x20,0x20
	.DB  0x4D,0x6F,0x74,0x6F,0x72,0x32,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,LOW(_Motor2Menu),HIGH(_Motor2Menu),0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65
_0x55:
	.DB  LOW(_MotorMenu),HIGH(_MotorMenu),0x4D,0x4F,0x54,0x4F,0x52,0x20
	.DB  0x30,0x31,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x20,0x20,0x46,0x6F,0x72,0x77,0x61,0x72
	.DB  0x64,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x42,0x61,0x63,0x6B,0x77,0x61,0x72,0x64
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x53,0x74
	.DB  0x6F,0x70,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x18,0x0,LOW(_ctrlDevice),HIGH(_ctrlDevice)
_0x56:
	.DB  LOW(_MotorMenu),HIGH(_MotorMenu),0x4D,0x4F,0x54,0x4F,0x52,0x20
	.DB  0x30,0x32,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x2,0x0
	.DB  0x20,0x20,0x46,0x6F,0x72,0x77,0x61,0x72
	.DB  0x64,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x42,0x61,0x63,0x6B,0x77,0x61,0x72,0x64
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x53,0x74
	.DB  0x6F,0x70,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x19,0x0,LOW(_ctrlDevice),HIGH(_ctrlDevice)
_0x57:
	.DB  LOW(_MainMenu),HIGH(_MainMenu),0x53,0x45,0x54,0x54,0x49,0x4E
	.DB  0x47,0x53,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x3,0x0
	.DB  0x20,0x20,0x4E,0x6F,0x6E,0x65,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x20,0x20
	.DB  0x4E,0x6F,0x6E,0x65,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x20,0x20,0x4E,0x6F
	.DB  0x6E,0x65
_0x0:
	.DB  0x3E,0x0

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  0x04
	.DW  __REG_VARS*2

	.DW  0x0A
	.DW  _SegCode
	.DW  _0x3*2

	.DW  0x02
	.DW  _0x1A
	.DW  _0x0*2

	.DW  0x5A
	.DW  _MainMenu
	.DW  _0x4B*2

	.DW  0x4A
	.DW  _SensorMenu
	.DW  _0x4C*2

	.DW  0x5E
	.DW  _TempMenu
	.DW  _0x4D*2

	.DW  0x4A
	.DW  _HumiMenu
	.DW  _0x4E*2

	.DW  0x5A
	.DW  _ActuatorMenu
	.DW  _0x4F*2

	.DW  0x4A
	.DW  _LedMenu
	.DW  _0x50*2

	.DW  0x5E
	.DW  _SingLedMenu
	.DW  _0x51*2

	.DW  0x5E
	.DW  _SevenSegLedMenu
	.DW  _0x52*2

	.DW  0x5E
	.DW  _RelayMenu
	.DW  _0x53*2

	.DW  0x4A
	.DW  _MotorMenu
	.DW  _0x54*2

	.DW  0x5E
	.DW  _Motor1Menu
	.DW  _0x55*2

	.DW  0x5E
	.DW  _Motor2Menu
	.DW  _0x56*2

	.DW  0x4A
	.DW  _SetMenu
	.DW  _0x57*2

_0xFFFFFFFF:
	.DW  0

#define __GLOBAL_INI_TBL_PRESENT 1

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

	OUT  RAMPZ,R24

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x500

	.CSEG
;/*
; * main.c
; *
; * Created: 8/26/2022 9:58:33 PM
; * Author: DELL
; */
;
;#include <io.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "userdef.h"

	.CSEG
_displayLEDs:
; .FSTART _displayLEDs
	CALL __PUTPARD2
;	led -> Y+0
	LD   R30,Y
	STS  4352,R30
	CALL __GETD2S0
	LDI  R30,LOW(8)
	CALL __LSRD12
	STS  4353,R30
	CALL __GETD1S0
	CALL __LSRD16
	STS  4354,R30
	LDI  R30,LOW(24)
	CALL __LSRD12
	STS  4355,R30
	LDI  R26,LOW(250)
	LDI  R27,0
	CALL _delay_ms
	RJMP _0x2000002
; .FEND

	.DSEG

	.CSEG
_displayLED7Seg:
; .FSTART _displayLED7Seg
	ST   -Y,R27
	ST   -Y,R26
;	number -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	SUBI R30,LOW(-_SegCode)
	SBCI R31,HIGH(-_SegCode)
	LD   R30,Z
	STS  4359,R30
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x0
	STS  4358,R30
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x0
	STS  4357,R30
	LD   R26,Y
	LDD  R27,Y+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,LOW(-_SegCode)
	SBCI R31,HIGH(-_SegCode)
	LD   R30,Z
	STS  4356,R30
	RJMP _0x2000001
; .FEND
;	number -> Y+0
_offLED7Seg:
; .FSTART _offLED7Seg
	LDI  R30,LOW(255)
	STS  4359,R30
	STS  4358,R30
	STS  4357,R30
	STS  4356,R30
	STS  4361,R30
	STS  4361,R30
	STS  4361,R30
	STS  4361,R30
	RET
; .FEND
_LCD_WR_CMD:
; .FSTART _LCD_WR_CMD
	ST   -Y,R26
;	cmd -> Y+0
	LD   R30,Y
	STS  4366,R30
	RCALL SUBOPT_0x1
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	RJMP _0x2000004
; .FEND
_LCD_WR_DATA:
; .FSTART _LCD_WR_DATA
	ST   -Y,R26
;	data -> Y+0
	LD   R30,Y
	STS  4365,R30
	RCALL SUBOPT_0x1
	RJMP _0x2000004
; .FEND
_LCD_INIT:
; .FSTART _LCD_INIT
	LDI  R26,LOW(56)
	RCALL _LCD_WR_CMD
	LDI  R26,LOW(12)
	RCALL _LCD_WR_CMD
	LDI  R26,LOW(6)
	RCALL _LCD_WR_CMD
; .FEND
_LCD_CLEAR:
; .FSTART _LCD_CLEAR
_0x2000005:
	LDI  R26,LOW(1)
	RCALL _LCD_WR_CMD
	RET
; .FEND
_Print:
; .FSTART _Print
	ST   -Y,R27
	ST   -Y,R26
;	*string -> Y+4
;	row -> Y+2
;	column -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SBIW R30,0
	BRNE _0xA
	LD   R26,Y
	SUBI R26,-LOW(128)
	RJMP _0x85
_0xA:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0xB
	LD   R26,Y
	SUBI R26,-LOW(192)
	RJMP _0x85
_0xB:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC
	LD   R26,Y
	SUBI R26,-LOW(148)
	RJMP _0x85
_0xC:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x9
	LD   R26,Y
	SUBI R26,-LOW(212)
_0x85:
	RCALL _LCD_WR_CMD
_0x9:
_0xE:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X
	CPI  R30,0
	BREQ _0x10
	LD   R30,X+
	STD  Y+4,R26
	STD  Y+4+1,R27
	MOV  R26,R30
	RCALL _LCD_WR_DATA
	RJMP _0xE
_0x10:
	ADIW R28,6
	RET
; .FEND
_OneWireReset:
; .FSTART _OneWireReset
	ST   -Y,R17
;	status -> R17
	SBI  0x17,0
	CBI  0x18,0
	__DELAY_USW 960
	CBI  0x17,0
	__DELAY_USB 187
	IN   R30,0x16
	ANDI R30,LOW(0x1)
	MOV  R17,R30
	__DELAY_USW 820
	RJMP _0x2000003
; .FEND
_OneWireWriteByte:
; .FSTART _OneWireWriteByte
	ST   -Y,R26
;	Byte -> Y+0
	CLR  R4
	CLR  R5
_0x12:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x13
	SBI  0x17,0
	CBI  0x18,0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BREQ _0x14
	__DELAY_USB 40
	RJMP _0x15
_0x14:
	__DELAY_USB 160
_0x15:
	CBI  0x17,0
	__DELAY_USB 80
	LD   R30,Y
	LSR  R30
	ST   Y,R30
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x12
_0x13:
_0x2000004:
	ADIW R28,1
	RET
; .FEND
_OneWireReadByte:
; .FSTART _OneWireReadByte
	ST   -Y,R17
;	Byte -> R17
	LDI  R17,0
	CLR  R4
	CLR  R5
_0x17:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x18
	SBI  0x17,0
	CBI  0x18,0
	__DELAY_USB 40
	CBI  0x17,0
	__DELAY_USB 40
	LSR  R17
	IN   R30,0x16
	ANDI R30,LOW(0x1)
	ROR  R30
	LDI  R30,0
	ROR  R30
	OR   R17,R30
	__DELAY_USB 80
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x17
_0x18:
_0x2000003:
	MOV  R30,R17
	LD   R17,Y+
	RET
; .FEND
_readTemp:
; .FSTART _readTemp
	SBIW R28,2
;	data -> Y+0
	RCALL _OneWireReset
	CPI  R30,0
	BRNE _0x19
	LDI  R26,LOW(204)
	RCALL _OneWireWriteByte
	LDI  R26,LOW(68)
	RCALL _OneWireWriteByte
	CBI  0x17,0
	LDI  R26,LOW(750)
	LDI  R27,HIGH(750)
	CALL _delay_ms
	RCALL _OneWireReset
	ST   Y,R30
	LDI  R26,LOW(204)
	RCALL _OneWireWriteByte
	LDI  R26,LOW(190)
	RCALL _OneWireWriteByte
	RCALL _OneWireReadByte
	ST   Y,R30
	RCALL _OneWireReadByte
	STD  Y+1,R30
	LDD  R22,Y+0
	CLR  R23
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(256)
	LDI  R31,HIGH(256)
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3D800000
	CALL __MULF12
	CALL __CFD1U
	RJMP _0x2000001
_0x19:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RJMP _0x2000001
; .FEND
_showMenu:
; .FSTART _showMenu
	ST   -Y,R27
	ST   -Y,R26
;	*yourMenu -> Y+2
;	selectRow -> Y+0
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	ADIW R30,2
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x2
	ADIW R30,24
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x2
	ADIW R30,46
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x2
	SUBI R30,LOW(-68)
	SBCI R31,HIGH(-68)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RCALL SUBOPT_0x3
	__POINTW1MN _0x1A,0
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RCALL SUBOPT_0x3
_0x2000002:
	ADIW R28,4
	RET
; .FEND

	.DSEG
_0x1A:
	.BYTE 0x2

	.CSEG
_ctrlDevice:
; .FSTART _ctrlDevice
	ST   -Y,R26
;	device -> Y+1
;	mode -> Y+0
	LDD  R26,Y+1
	CPI  R26,LOW(0x15)
	BRNE _0x1B
	RCALL SUBOPT_0x4
	BRNE _0x1F
	__GETD2N 0x55555555
	RJMP _0x86
_0x1F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x20
	CLR  R4
	CLR  R5
_0x22:
	LDI  R30,LOW(32)
	LDI  R31,HIGH(32)
	CP   R4,R30
	CPC  R5,R31
	BRGE _0x23
	MOV  R30,R4
	__GETD2N 0x1
	CALL __LSLD12
	STS  _modeLED,R30
	STS  _modeLED+1,R31
	STS  _modeLED+2,R22
	STS  _modeLED+3,R23
	LDS  R26,_modeLED
	LDS  R27,_modeLED+1
	LDS  R24,_modeLED+2
	LDS  R25,_modeLED+3
	RCALL _displayLEDs
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
	RJMP _0x22
_0x23:
	RJMP _0x1E
_0x20:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1E
	__GETD2N 0x0
_0x86:
	RCALL _displayLEDs
_0x1E:
	RJMP _0x25
_0x1B:
	LDD  R26,Y+1
	CPI  R26,LOW(0x16)
	BRNE _0x26
	RCALL SUBOPT_0x4
	BRNE _0x2A
	LDI  R26,LOW(2112)
	LDI  R27,HIGH(2112)
	RCALL _displayLED7Seg
	RJMP _0x29
_0x2A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x29
	RCALL _offLED7Seg
_0x29:
	RJMP _0x2C
_0x26:
	LDD  R26,Y+1
	CPI  R26,LOW(0x17)
	BRNE _0x2D
	RCALL SUBOPT_0x4
	BRNE _0x31
	LDI  R30,LOW(255)
	RJMP _0x87
_0x31:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x32
	LDI  R30,LOW(0)
	RJMP _0x87
_0x32:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x30
	LDS  R30,_ctrlRelays
	ANDI R30,0x7F
	RCALL SUBOPT_0x5
	ANDI R30,0xBF
	RCALL SUBOPT_0x5
	ANDI R30,0xDF
	RCALL SUBOPT_0x5
	ANDI R30,0xEF
	RCALL SUBOPT_0x5
	ANDI R30,0XF7
	RCALL SUBOPT_0x5
	ANDI R30,0xFB
	RCALL SUBOPT_0x5
	ANDI R30,0xFD
	RCALL SUBOPT_0x5
	ANDI R30,0xFE
_0x87:
	STS  _ctrlRelays,R30
_0x30:
	LDS  R30,_ctrlRelays
	STS  4362,R30
	RJMP _0x34
_0x2D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x18)
	BRNE _0x35
	RCALL SUBOPT_0x4
	BRNE _0x39
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xFC)
	ORI  R30,1
	RJMP _0x88
_0x39:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3A
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xFC)
	ORI  R30,2
	RJMP _0x88
_0x3A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x38
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xFC)
_0x88:
	STS  _ctrlMotors,R30
_0x38:
	RCALL SUBOPT_0x6
	RJMP _0x3C
_0x35:
	LDD  R26,Y+1
	CPI  R26,LOW(0x19)
	BRNE _0x3D
	RCALL SUBOPT_0x4
	BRNE _0x41
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xF3)
	ORI  R30,4
	RJMP _0x89
_0x41:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x42
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xF3)
	ORI  R30,8
	RJMP _0x89
_0x42:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x40
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xF3)
_0x89:
	STS  _ctrlMotors,R30
_0x40:
	RCALL SUBOPT_0x6
	RJMP _0x44
_0x3D:
	LDD  R26,Y+1
	CPI  R26,LOW(0x1A)
	BRNE _0x45
	RCALL SUBOPT_0x4
	BRNE _0x49
	RCALL _readTemp
	MOVW R26,R30
	RCALL _displayLED7Seg
	RJMP _0x48
_0x49:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x48
	RCALL _offLED7Seg
_0x48:
_0x45:
_0x44:
_0x3C:
_0x34:
_0x2C:
_0x25:
_0x2000001:
	ADIW R28,2
	RET
; .FEND

	.DSEG
;
;
;
;MENU* pmenu;
;int selectRow = 1;
;int temp;
;
;
;
;void main(void)
; 0000 0015 {

	.CSEG
_main:
; .FSTART _main
; 0000 0016     MCUCR |= 0x80;      // writing SRE to one enables the External Memory Interface
	IN   R30,0x35
	ORI  R30,0x80
	OUT  0x35,R30
; 0000 0017     XMCRA = 0;          // External Memory Control Register A
	LDI  R30,LOW(0)
	STS  109,R30
; 0000 0018 
; 0000 0019     /*-------------------Initial LED 7SEG--------------------------*/
; 0000 001A     offLED7Seg();
	RCALL _offLED7Seg
; 0000 001B 
; 0000 001C     /*-------------------Initial Motors--------------------------------*/
; 0000 001D     ctrlMotors.DC1 = StopRotate;
	LDS  R30,_ctrlMotors
	ANDI R30,LOW(0xFC)
	STS  _ctrlMotors,R30
; 0000 001E     ctrlMotors.DC2 = StopRotate;
	ANDI R30,LOW(0xF3)
	STS  _ctrlMotors,R30
; 0000 001F     MOTOR_ACTIVATION;
	RCALL SUBOPT_0x6
; 0000 0020 
; 0000 0021     /*--------------------Initial LCD-----------------------------------*/
; 0000 0022     DDRG |= (1<<3);     // output LCD enable
	LDS  R30,100
	ORI  R30,8
	STS  100,R30
; 0000 0023     LCD_INIT();
	RCALL _LCD_INIT
; 0000 0024 
; 0000 0025     /*----------------Initial Main Menu on LCD-----------------------------*/
; 0000 0026     pmenu = &MainMenu;
	LDI  R30,LOW(_MainMenu)
	LDI  R31,HIGH(_MainMenu)
	MOVW R6,R30
; 0000 0027     showMenu(pmenu, selectRow);
	RCALL SUBOPT_0x7
; 0000 0028 
; 0000 0029     /*----------------Initial DS18B20-----------------------------*/
; 0000 002A     /*if (!OneWireReset()) {        // test -> 0040
; 0000 002B         OneWireWriteByte(0x33);
; 0000 002C         displayLED7Seg(OneWireReadByte());
; 0000 002D     }*/
; 0000 002E 
; 0000 002F 
; 0000 0030     while (1)
_0x58:
; 0000 0031     {
; 0000 0032         /*-------------------Control motors by btns --------------------*/
; 0000 0033         /* READ_KEY;
; 0000 0034         if (!ctrlBtns.STOP) {
; 0000 0035             while (!ctrlBtns.STOP)      // debounce button
; 0000 0036                 READ_KEY;
; 0000 0037             ctrlMotors.DC1 = StopRotate;
; 0000 0038             ctrlMotors.DC2 = StopRotate;
; 0000 0039         }
; 0000 003A         else if (!ctrlBtns.FORWARD) {
; 0000 003B             while (!ctrlBtns.FORWARD)
; 0000 003C                 READ_KEY;
; 0000 003D             ctrlMotors.DC1 = RotateForward;
; 0000 003E             ctrlMotors.DC2 = RotateForward;
; 0000 003F         }
; 0000 0040         else if (!ctrlBtns.BACKWARD) {
; 0000 0041             while (!ctrlBtns.BACKWARD)
; 0000 0042                 READ_KEY;
; 0000 0043             ctrlMotors.DC1 = RotateBackward;
; 0000 0044             ctrlMotors.DC2 = RotateBackward;
; 0000 0045         }
; 0000 0046         MOTOR_ACTIVATION; */
; 0000 0047 
; 0000 0048         /*---------------------Control devices by Menu on LCD----------------------*/
; 0000 0049         READ_KEY;
	RCALL SUBOPT_0x8
; 0000 004A         if (!ctrlBtns.UP) {
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x4)
	BRNE _0x5B
; 0000 004B             while (!ctrlBtns.UP)
_0x5C:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x4)
	BRNE _0x5E
; 0000 004C                 READ_KEY;
	RCALL SUBOPT_0x8
	RJMP _0x5C
_0x5E:
; 0000 004D selectRow = (selectRow == 1) ? 3 : (selectRow - 1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x5F
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x60
_0x5F:
	MOVW R30,R8
	SBIW R30,1
_0x60:
	MOVW R8,R30
; 0000 004E             showMenu(pmenu, selectRow);
	RCALL SUBOPT_0x7
; 0000 004F         }
; 0000 0050         else if (!ctrlBtns.DOWN) {
	RJMP _0x62
_0x5B:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x10)
	BRNE _0x63
; 0000 0051             while (!ctrlBtns.DOWN)
_0x64:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x10)
	BRNE _0x66
; 0000 0052                 READ_KEY;
	RCALL SUBOPT_0x8
	RJMP _0x64
_0x66:
; 0000 0053 selectRow = (selectRow == 3) ? 1 : (selectRow + 1);
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R8
	CPC  R31,R9
	BRNE _0x67
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	RJMP _0x68
_0x67:
	MOVW R30,R8
	ADIW R30,1
_0x68:
	MOVW R8,R30
; 0000 0054             showMenu(pmenu, selectRow);
	RCALL SUBOPT_0x7
; 0000 0055         }
; 0000 0056         else if (!ctrlBtns.NEXT) {
	RJMP _0x6A
_0x63:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x8)
	BRNE _0x6B
; 0000 0057             while (!ctrlBtns.NEXT)
_0x6C:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x8)
	BRNE _0x6E
; 0000 0058                 READ_KEY;
	RCALL SUBOPT_0x8
	RJMP _0x6C
_0x6E:
; 0000 0059 switch(selectRow) {
	MOVW R30,R8
; 0000 005A                 case 1:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x72
; 0000 005B                     if (pmenu->nextMenu1 != NULL) {
	MOVW R26,R6
	ADIW R26,44
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x73
; 0000 005C                         LCD_CLEAR();
	RCALL _LCD_CLEAR
; 0000 005D                         pmenu = pmenu->nextMenu1;
	MOVW R26,R6
	ADIW R26,44
	RCALL SUBOPT_0x9
; 0000 005E                         selectRow = 1;
; 0000 005F                         showMenu(pmenu, selectRow);
; 0000 0060                     }
; 0000 0061                     break;
_0x73:
	RJMP _0x71
; 0000 0062                 case 2:
_0x72:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x74
; 0000 0063                     if (pmenu->nextMenu2 != NULL) {
	MOVW R26,R6
	SUBI R26,LOW(-66)
	SBCI R27,HIGH(-66)
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x75
; 0000 0064                         LCD_CLEAR();
	RCALL _LCD_CLEAR
; 0000 0065                         pmenu = pmenu->nextMenu2;
	MOVW R26,R6
	SUBI R26,LOW(-66)
	SBCI R27,HIGH(-66)
	RCALL SUBOPT_0x9
; 0000 0066                         selectRow = 1;
; 0000 0067                         showMenu(pmenu, selectRow);
; 0000 0068                     }
; 0000 0069 
; 0000 006A                     break;
_0x75:
	RJMP _0x71
; 0000 006B                 case 3:
_0x74:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x71
; 0000 006C                     if (pmenu->nextMenu3 != NULL) {
	MOVW R26,R6
	SUBI R26,LOW(-88)
	SBCI R27,HIGH(-88)
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x77
; 0000 006D                         LCD_CLEAR();
	RCALL _LCD_CLEAR
; 0000 006E                         pmenu = pmenu->nextMenu3;
	MOVW R26,R6
	SUBI R26,LOW(-88)
	SBCI R27,HIGH(-88)
	RCALL SUBOPT_0x9
; 0000 006F                         selectRow = 1;
; 0000 0070                         showMenu(pmenu, selectRow);
; 0000 0071                     }
; 0000 0072                     break;
_0x77:
; 0000 0073             }
_0x71:
; 0000 0074         }
; 0000 0075         else if (!ctrlBtns.BACK) {
	RJMP _0x78
_0x6B:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x2)
	BRNE _0x79
; 0000 0076             while (!ctrlBtns.BACK)
_0x7A:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x2)
	BRNE _0x7C
; 0000 0077                 READ_KEY;
	RCALL SUBOPT_0x8
	RJMP _0x7A
_0x7C:
; 0000 0078 if (pmenu->preMenu != 0) {
	MOVW R26,R6
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x7D
; 0000 0079                 LCD_CLEAR();
	RCALL _LCD_CLEAR
; 0000 007A                 selectRow = pmenu->id;
	MOVW R26,R6
	ADIW R26,22
	LD   R8,X+
	LD   R9,X
; 0000 007B                 pmenu = pmenu->preMenu;
	MOVW R26,R6
	LD   R6,X+
	LD   R7,X
; 0000 007C                 showMenu(pmenu, selectRow);
	RCALL SUBOPT_0x7
; 0000 007D             }
; 0000 007E         }
_0x7D:
; 0000 007F         else if (!ctrlBtns.ENTER) {
	RJMP _0x7E
_0x79:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x1)
	BRNE _0x7F
; 0000 0080             while (!ctrlBtns.ENTER)
_0x80:
	LDS  R30,_ctrlBtns
	ANDI R30,LOW(0x1)
	BRNE _0x82
; 0000 0081                 READ_KEY;
	RCALL SUBOPT_0x8
	RJMP _0x80
_0x82:
; 0000 0082 if (pmenu->funcCtrl != 0) {
	MOVW R26,R6
	SUBI R26,LOW(-92)
	SBCI R27,HIGH(-92)
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x83
; 0000 0083                 pmenu->funcCtrl(pmenu->device, selectRow);
	MOVW R26,R6
	SUBI R26,LOW(-92)
	SBCI R27,HIGH(-92)
	CALL __GETW1P
	PUSH R31
	PUSH R30
	MOVW R26,R6
	SUBI R26,LOW(-90)
	SBCI R27,HIGH(-90)
	LD   R30,X
	ST   -Y,R30
	MOV  R26,R8
	POP  R30
	POP  R31
	ICALL
; 0000 0084             }
; 0000 0085         }
_0x83:
; 0000 0086     }
_0x7F:
_0x7E:
_0x78:
_0x6A:
_0x62:
	RJMP _0x58
; 0000 0087 }
_0x84:
	RJMP _0x84
; .FEND

	.DSEG
_modeLED:
	.BYTE 0x4
_SegCode:
	.BYTE 0xA
_ctrlRelays:
	.BYTE 0x1
_ctrlMotors:
	.BYTE 0x1
_ctrlBtns:
	.BYTE 0x1
_MainMenu:
	.BYTE 0x5E
_SensorMenu:
	.BYTE 0x5E
_ActuatorMenu:
	.BYTE 0x5E
_SetMenu:
	.BYTE 0x5E
_TempMenu:
	.BYTE 0x5E
_HumiMenu:
	.BYTE 0x5E
_RelayMenu:
	.BYTE 0x5E
_MotorMenu:
	.BYTE 0x5E
_LedMenu:
	.BYTE 0x5E
_Motor1Menu:
	.BYTE 0x5E
_Motor2Menu:
	.BYTE 0x5E
_SingLedMenu:
	.BYTE 0x5E
_SevenSegLedMenu:
	.BYTE 0x5E

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	CALL __DIVW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	SUBI R30,LOW(-_SegCode)
	SBCI R31,HIGH(-_SegCode)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDS  R30,101
	ORI  R30,8
	STS  101,R30
	LDI  R26,LOW(1)
	LDI  R27,0
	CALL _delay_ms
	LDS  R30,101
	ANDI R30,0XF7
	STS  101,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R27,0
	RCALL _Print
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	LDI  R26,LOW(0)
	LDI  R27,0
	RJMP _Print

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x4:
	LD   R30,Y
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x5:
	STS  _ctrlRelays,R30
	STS  4362,R30
	LDI  R26,LOW(500)
	LDI  R27,HIGH(500)
	CALL _delay_ms
	LDS  R30,_ctrlRelays
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDS  R30,_ctrlMotors
	STS  4363,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x7:
	ST   -Y,R7
	ST   -Y,R6
	MOVW R26,R8
	RJMP _showMenu

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x8:
	LDS  R30,4364
	STS  _ctrlBtns,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x9:
	LD   R6,X+
	LD   R7,X
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	MOVW R8,R30
	RJMP SUBOPT_0x7


	.CSEG
_delay_ms:
	adiw r26,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r26,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSLD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSLD12R
__LSLD12L:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R0
	BRNE __LSLD12L
__LSLD12R:
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__LSRD16:
	MOV  R30,R22
	MOV  R31,R23
	LDI  R22,0
	LDI  R23,0
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTPARD2:
	ST   -Y,R25
	ST   -Y,R24
	ST   -Y,R27
	ST   -Y,R26
	RET

;END OF CODE MARKER
__END_OF_CODE:
