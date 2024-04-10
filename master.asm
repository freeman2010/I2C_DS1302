
_disp_date:

;master.c,32 :: 		void disp_date() {
;master.c,35 :: 		temp = ((get_date_array[4] >> 4) * 10) + (get_date_array[4] & 0x0F);
	MOVF       _get_date_array+4, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      10
	MOVWF      R4+0
	CALL       _Mul_8X8_U+0
	MOVLW      15
	ANDWF      _get_date_array+4, 0
	MOVWF      R1+0
	MOVF       R1+0, 0
	ADDWF      R0+0, 0
	MOVWF      disp_date_temp_L0+0
;master.c,36 :: 		Lcd_Out(1, 1, "Date:");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr1_master+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;master.c,37 :: 		Lcd_Out_Cp(str_month_name[temp - 1]);
	MOVLW      1
	SUBWF      disp_date_temp_L0+0, 0
	MOVWF      R3+0
	CLRF       R3+1
	BTFSS      STATUS+0, 0
	DECF       R3+1, 1
	MOVF       R3+0, 0
	MOVWF      R0+0
	MOVF       R3+1, 0
	MOVWF      R0+1
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	RLF        R0+0, 1
	RLF        R0+1, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	ADDLW      _str_month_name+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;master.c,38 :: 		Lcd_Chr_Cp('-');
	MOVLW      45
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,40 :: 		Lcd_Chr_Cp('0' + ((get_date_array[5] >> 4) & 0x0F));
	MOVF       _get_date_array+5, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      15
	ANDWF      R0+0, 1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,41 :: 		Lcd_Chr_Cp('0' + (get_date_array[5] & 0x0F));
	MOVLW      15
	ANDWF      _get_date_array+5, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,42 :: 		Lcd_Chr_Cp('-');
	MOVLW      45
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,44 :: 		Lcd_Out_Cp("20");
	MOVLW      ?lstr2_master+0
	MOVWF      FARG_Lcd_Out_CP_text+0
	CALL       _Lcd_Out_CP+0
;master.c,45 :: 		Lcd_Chr_Cp('0' + ((get_date_array[3] >> 4) & 0x0F));
	MOVF       _get_date_array+3, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      15
	ANDWF      R0+0, 1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,46 :: 		Lcd_Chr_Cp('0' + (get_date_array[3] & 0x0F));
	MOVLW      15
	ANDWF      _get_date_array+3, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,47 :: 		}
L_end_disp_date:
	RETURN
; end of _disp_date

_disp_time:

;master.c,49 :: 		void disp_time() {
;master.c,50 :: 		Lcd_Out(2, 1, "Time:");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      1
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr3_master+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;master.c,51 :: 		Lcd_Chr_Cp('0' + ((get_date_array[0] >> 4) & 0x0F));
	MOVF       _get_date_array+0, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      15
	ANDWF      R0+0, 1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,52 :: 		Lcd_Chr_Cp('0' + (get_date_array[0] & 0x0F));
	MOVLW      15
	ANDWF      _get_date_array+0, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,53 :: 		Lcd_Chr_Cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,54 :: 		Lcd_Chr_Cp('0' + ((get_date_array[1] >> 4) & 0x0F));
	MOVF       _get_date_array+1, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      15
	ANDWF      R0+0, 1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,55 :: 		Lcd_Chr_Cp('0' + (get_date_array[1] & 0x0F));
	MOVLW      15
	ANDWF      _get_date_array+1, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,56 :: 		Lcd_Chr_Cp(':');
	MOVLW      58
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,57 :: 		Lcd_Chr_Cp('0' + ((get_date_array[2] >> 4) & 0x0F));
	MOVF       _get_date_array+2, 0
	MOVWF      R0+0
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	RRF        R0+0, 1
	BCF        R0+0, 7
	MOVLW      15
	ANDWF      R0+0, 1
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,58 :: 		Lcd_Chr_Cp('0' + (get_date_array[2] & 0x0F));
	MOVLW      15
	ANDWF      _get_date_array+2, 0
	MOVWF      R0+0
	MOVF       R0+0, 0
	ADDLW      48
	MOVWF      FARG_Lcd_Chr_CP_out_char+0
	CALL       _Lcd_Chr_CP+0
;master.c,59 :: 		}
L_end_disp_time:
	RETURN
; end of _disp_time

_interrupt:
	MOVWF      R15+0
	SWAPF      STATUS+0, 0
	CLRF       STATUS+0
	MOVWF      ___saveSTATUS+0
	MOVF       PCLATH+0, 0
	MOVWF      ___savePCLATH+0
	CLRF       PCLATH+0

;master.c,61 :: 		void interrupt() {
;master.c,62 :: 		if(PIR1.SSPIF) {
	BTFSS      PIR1+0, 3
	GOTO       L_interrupt0
;master.c,68 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;master.c,69 :: 		}
L_interrupt0:
;master.c,70 :: 		}
L_end_interrupt:
L__interrupt17:
	MOVF       ___savePCLATH+0, 0
	MOVWF      PCLATH+0
	SWAPF      ___saveSTATUS+0, 0
	MOVWF      STATUS+0
	SWAPF      R15+0, 1
	SWAPF      R15+0, 0
	RETFIE
; end of _interrupt

_init:

;master.c,72 :: 		void init() {
;master.c,73 :: 		OPTION_REG = 0;
	CLRF       OPTION_REG+0
;master.c,74 :: 		ANSEL = 0;
	CLRF       ANSEL+0
;master.c,75 :: 		ANSELH = 0;
	CLRF       ANSELH+0
;master.c,77 :: 		PORTA = 0;
	CLRF       PORTA+0
;master.c,78 :: 		TRISA = 0;
	CLRF       TRISA+0
;master.c,79 :: 		PORTB = 0;
	CLRF       PORTB+0
;master.c,80 :: 		TRISB = 0x01;
	MOVLW      1
	MOVWF      TRISB+0
;master.c,81 :: 		PORTC = 0;
	CLRF       PORTC+0
;master.c,82 :: 		TRISC = 0;
	CLRF       TRISC+0
;master.c,83 :: 		PORTD = 0;
	CLRF       PORTD+0
;master.c,84 :: 		TRISD = 0;
	CLRF       TRISD+0
;master.c,85 :: 		PIR1 = 0;
	CLRF       PIR1+0
;master.c,87 :: 		Lcd_Init();
	CALL       _Lcd_Init+0
;master.c,88 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;master.c,89 :: 		Lcd_Cmd(_LCD_CURSOR_OFF);
	MOVLW      12
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;master.c,90 :: 		Lcd_Out(1, 5, "Welcome");
	MOVLW      1
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      5
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr4_master+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;master.c,91 :: 		Lcd_Out(2, 2, "Initializing...");
	MOVLW      2
	MOVWF      FARG_Lcd_Out_row+0
	MOVLW      2
	MOVWF      FARG_Lcd_Out_column+0
	MOVLW      ?lstr5_master+0
	MOVWF      FARG_Lcd_Out_text+0
	CALL       _Lcd_Out+0
;master.c,93 :: 		i2c_master_init();
	CALL       _i2c_master_init+0
;master.c,94 :: 		}
L_end_init:
	RETURN
; end of _init

_set_date:

;master.c,96 :: 		void set_date() {
;master.c,98 :: 		for(i = 0; i < array_length; i++) {
	CLRF       set_date_i_L0+0
L_set_date1:
	MOVLW      7
	SUBWF      set_date_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_set_date2
;master.c,99 :: 		temp = ((set_date_array[i] / 10) << 4) | ((set_date_array[i] % 10) & 0x0F);
	MOVF       set_date_i_L0+0, 0
	ADDLW      _set_date_array+0
	MOVWF      FSR
	MOVF       INDF+0, 0
	MOVWF      FLOC__set_date+1
	MOVLW      10
	MOVWF      R4+0
	MOVF       FLOC__set_date+1, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R0+0, 0
	MOVWF      FLOC__set_date+0
	RLF        FLOC__set_date+0, 1
	BCF        FLOC__set_date+0, 0
	RLF        FLOC__set_date+0, 1
	BCF        FLOC__set_date+0, 0
	RLF        FLOC__set_date+0, 1
	BCF        FLOC__set_date+0, 0
	RLF        FLOC__set_date+0, 1
	BCF        FLOC__set_date+0, 0
	MOVLW      10
	MOVWF      R4+0
	MOVF       FLOC__set_date+1, 0
	MOVWF      R0+0
	CALL       _Div_8X8_U+0
	MOVF       R8+0, 0
	MOVWF      R0+0
	MOVLW      15
	ANDWF      R0+0, 1
	MOVF       FLOC__set_date+0, 0
	IORWF      R0+0, 1
	MOVF       R0+0, 0
	MOVWF      _temp+0
;master.c,100 :: 		i2c_master_write(slave_address, i, temp);
	MOVLW      6
	MOVWF      FARG_i2c_master_write_slave_address+0
	MOVF       set_date_i_L0+0, 0
	MOVWF      FARG_i2c_master_write_data_index+0
	MOVF       R0+0, 0
	MOVWF      FARG_i2c_master_write_write_data+0
	CALL       _i2c_master_write+0
;master.c,98 :: 		for(i = 0; i < array_length; i++) {
	INCF       set_date_i_L0+0, 1
;master.c,101 :: 		}
	GOTO       L_set_date1
L_set_date2:
;master.c,102 :: 		}
L_end_set_date:
	RETURN
; end of _set_date

_get_date:

;master.c,104 :: 		void get_date() {
;master.c,106 :: 		for(i = 0; i < array_length; i++) {
	CLRF       get_date_i_L0+0
L_get_date4:
	MOVLW      7
	SUBWF      get_date_i_L0+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_get_date5
;master.c,107 :: 		get_date_array[i] = i2c_master_read(slave_address, i);
	MOVF       get_date_i_L0+0, 0
	ADDLW      _get_date_array+0
	MOVWF      FLOC__get_date+0
	MOVLW      6
	MOVWF      FARG_i2c_master_read_slave_address+0
	MOVF       get_date_i_L0+0, 0
	MOVWF      FARG_i2c_master_read_data_index+0
	CALL       _i2c_master_read+0
	MOVF       FLOC__get_date+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;master.c,106 :: 		for(i = 0; i < array_length; i++) {
	INCF       get_date_i_L0+0, 1
;master.c,108 :: 		}
	GOTO       L_get_date4
L_get_date5:
;master.c,109 :: 		}
L_end_get_date:
	RETURN
; end of _get_date

_main:

;master.c,111 :: 		void main() {
;master.c,112 :: 		init();
	CALL       _init+0
;master.c,113 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main7:
	DECFSZ     R13+0, 1
	GOTO       L_main7
	DECFSZ     R12+0, 1
	GOTO       L_main7
	DECFSZ     R11+0, 1
	GOTO       L_main7
	NOP
	NOP
;master.c,114 :: 		Lcd_Cmd(_LCD_CLEAR);
	MOVLW      1
	MOVWF      FARG_Lcd_Cmd_out_char+0
	CALL       _Lcd_Cmd+0
;master.c,116 :: 		while(1) {
L_main8:
;master.c,117 :: 		get_date();
	CALL       _get_date+0
;master.c,119 :: 		disp_time();
	CALL       _disp_time+0
;master.c,120 :: 		disp_date();
	CALL       _disp_date+0
;master.c,122 :: 		Delay_ms(300);
	MOVLW      4
	MOVWF      R11+0
	MOVLW      12
	MOVWF      R12+0
	MOVLW      51
	MOVWF      R13+0
L_main10:
	DECFSZ     R13+0, 1
	GOTO       L_main10
	DECFSZ     R12+0, 1
	GOTO       L_main10
	DECFSZ     R11+0, 1
	GOTO       L_main10
	NOP
	NOP
;master.c,124 :: 		if(!SET_DATE) {
	BTFSC      PORTB+0, 0
	GOTO       L_main11
;master.c,125 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main12:
	DECFSZ     R13+0, 1
	GOTO       L_main12
	DECFSZ     R12+0, 1
	GOTO       L_main12
	DECFSZ     R11+0, 1
	GOTO       L_main12
	NOP
	NOP
;master.c,126 :: 		set_date();
	CALL       _set_date+0
;master.c,127 :: 		Delay_ms(500);
	MOVLW      6
	MOVWF      R11+0
	MOVLW      19
	MOVWF      R12+0
	MOVLW      173
	MOVWF      R13+0
L_main13:
	DECFSZ     R13+0, 1
	GOTO       L_main13
	DECFSZ     R12+0, 1
	GOTO       L_main13
	DECFSZ     R11+0, 1
	GOTO       L_main13
	NOP
	NOP
;master.c,128 :: 		}
L_main11:
;master.c,129 :: 		}
	GOTO       L_main8
;master.c,130 :: 		}
L_end_main:
	GOTO       $+0
; end of _main
