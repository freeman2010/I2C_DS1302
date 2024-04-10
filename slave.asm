
_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;slave.c,16 :: 		void interrupt()
;slave.c,18 :: 		if(PIR1.SSPIF) // Check for SSPIF
	BTFSS      PIR1+0, 3
	GOTO       L_interrupt0
;slave.c,20 :: 		if(SSPSTAT.R_W == 1) // Master read (slave transmit)
	BTFSS      SSPSTAT+0, 2
	GOTO       L_interrupt1
;slave.c,22 :: 		SSPBUF = get_date_array[array_index]; // Load array value
	MOVF       _array_index+0, 0
	ADDLW      _get_date_array+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      SSPBUF+0
;slave.c,23 :: 		SSPCON.CKP = 1; // Release clock stretch
	BSF        SSPCON+0, 4
;slave.c,24 :: 		}
L_interrupt1:
;slave.c,26 :: 		if(SSPSTAT.R_W == 0) // Master write (slave receive)
	BTFSC      SSPSTAT+0, 2
	GOTO       L_interrupt2
;slave.c,28 :: 		if(SSPSTAT.D_A == 0) // Last byte was an address
	BTFSC      SSPSTAT+0, 5
	GOTO       L_interrupt3
;slave.c,30 :: 		reg_adr_flag = 1; // Next byte register address
	MOVLW      1
	MOVWF      _reg_adr_flag+0
;slave.c,31 :: 		temp = SSPBUF; // Clear BF
	MOVF       SSPBUF+0, 0
	MOVWF      _temp+0
;slave.c,32 :: 		SSPCON.CKP = 1; // Release clock stretch
	BSF        SSPCON+0, 4
;slave.c,33 :: 		}
L_interrupt3:
;slave.c,34 :: 		if(SSPSTAT.D_A == 1) // Last byte was data
	BTFSS      SSPSTAT+0, 5
	GOTO       L_interrupt4
;slave.c,36 :: 		if(reg_adr_flag == 1) // Last byte was register add
	MOVF       _reg_adr_flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt5
;slave.c,38 :: 		array_index = SSPBUF; // Load register address
	MOVF       SSPBUF+0, 0
	MOVWF      _array_index+0
;slave.c,39 :: 		reg_adr_flag = 0; // Next byte will be true data
	CLRF       _reg_adr_flag+0
;slave.c,40 :: 		}
	GOTO       L_interrupt6
L_interrupt5:
;slave.c,43 :: 		set_date_array[array_index] = SSPBUF; // Yes, read SSP1BUF
	MOVF       _array_index+0, 0
	ADDLW      _set_date_array+0
	MOVWF      FSR
	MOVF       SSPBUF+0, 0
	MOVWF      INDF+0
;slave.c,44 :: 		if(array_index == (array_length - 1)) {
	MOVF       _array_index+0, 0
	XORLW      6
	BTFSS      STATUS+0, 2
	GOTO       L_interrupt7
;slave.c,45 :: 		set_date_time_flag = 1;
	MOVLW      1
	MOVWF      _set_date_time_flag+0
;slave.c,46 :: 		}
L_interrupt7:
;slave.c,47 :: 		SSPCON.CKP = 1; // Release clock stretch
	BSF        SSPCON+0, 4
;slave.c,48 :: 		}
L_interrupt6:
;slave.c,49 :: 		}
L_interrupt4:
;slave.c,50 :: 		}
L_interrupt2:
;slave.c,51 :: 		PIR1.SSPIF = 0; // Clear SSP1IF
	BCF        PIR1+0, 3
;slave.c,52 :: 		}
L_interrupt0:
;slave.c,54 :: 		if(PIR2.BCLIF == 1)
	BTFSS      PIR2+0, 3
	GOTO       L_interrupt8
;slave.c,56 :: 		temp = SSPBUF; // Clear BF
	MOVF       SSPBUF+0, 0
	MOVWF      _temp+0
;slave.c,57 :: 		PIR2.BCLIF = 0; // Clear BCLIF
	BCF        PIR2+0, 3
;slave.c,58 :: 		SSPCON.CKP = 1; // Release clock stretching
	BSF        SSPCON+0, 4
;slave.c,59 :: 		}
L_interrupt8:
;slave.c,60 :: 		}
L_end_interrupt:
L__interrupt13:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_init:

;slave.c,62 :: 		void init() {
;slave.c,63 :: 		ANSEL = 0;
	CLRF       ANSEL+0
;slave.c,64 :: 		ANSELh = 0;
	CLRF       ANSELH+0
;slave.c,67 :: 		OPTION_REG = 0;
	CLRF       OPTION_REG+0
;slave.c,69 :: 		PORTA = 0;
	CLRF       PORTA+0
;slave.c,70 :: 		TRISA = 0;
	CLRF       TRISA+0
;slave.c,71 :: 		PORTB = 0;
	CLRF       PORTB+0
;slave.c,72 :: 		TRISB = 0;
	CLRF       TRISB+0
;slave.c,73 :: 		PORTC = 0;
	CLRF       PORTC+0
;slave.c,74 :: 		TRISC = 0;
	CLRF       TRISC+0
;slave.c,75 :: 		PORTD = 0;
	CLRF       PORTD+0
;slave.c,76 :: 		TRISD = 0;
	CLRF       TRISD+0
;slave.c,78 :: 		i2c_slave_init(i2c_address);
	MOVF       _i2c_address+0, 0
	MOVWF      FARG_i2c_slave_init_slave_address+0
	CALL       _i2c_slave_init+0
;slave.c,79 :: 		}
L_end_init:
	RETURN
; end of _init

_main:

;slave.c,81 :: 		void main() {
;slave.c,82 :: 		init();
	CALL       _init+0
;slave.c,84 :: 		while(1) {
L_main9:
;slave.c,86 :: 		get_time(get_date_array, get_date_array + 1, get_date_array + 2);
	MOVLW      _get_date_array+0
	MOVWF      FARG_get_time_hour+0
	MOVLW      _get_date_array+1
	MOVWF      FARG_get_time_minute+0
	MOVLW      _get_date_array+2
	MOVWF      FARG_get_time_second+0
	CALL       _get_time+0
;slave.c,88 :: 		get_date(get_date_array + 3, get_date_array + 4, get_date_array + 5);
	MOVLW      _get_date_array+3
	MOVWF      FARG_get_date_year+0
	MOVLW      _get_date_array+4
	MOVWF      FARG_get_date_month+0
	MOVLW      _get_date_array+5
	MOVWF      FARG_get_date_day+0
	CALL       _get_date+0
;slave.c,90 :: 		if(set_date_time_flag == 1) {
	MOVF       _set_date_time_flag+0, 0
	XORLW      1
	BTFSS      STATUS+0, 2
	GOTO       L_main11
;slave.c,91 :: 		set_date_time_flag = 0;
	CLRF       _set_date_time_flag+0
;slave.c,92 :: 		set_time(set_date_array[0], set_date_array[1], set_date_array[2]);
	MOVF       _set_date_array+0, 0
	MOVWF      FARG_set_time_hour+0
	MOVF       _set_date_array+1, 0
	MOVWF      FARG_set_time_minute+0
	MOVF       _set_date_array+2, 0
	MOVWF      FARG_set_time_second+0
	CALL       _set_time+0
;slave.c,93 :: 		set_date(set_date_array[3], set_date_array[4], set_date_array[5], set_date_array[6]);
	MOVF       _set_date_array+3, 0
	MOVWF      FARG_set_date_year+0
	MOVF       _set_date_array+4, 0
	MOVWF      FARG_set_date_month+0
	MOVF       _set_date_array+5, 0
	MOVWF      FARG_set_date_day+0
	MOVF       _set_date_array+6, 0
	MOVWF      FARG_set_date_week_day+0
	CALL       _set_date+0
;slave.c,94 :: 		}
L_main11:
;slave.c,95 :: 		}
	GOTO       L_main9
;slave.c,96 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
