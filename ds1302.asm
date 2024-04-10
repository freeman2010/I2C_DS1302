
_start_ds1302:

;ds1302.c,3 :: 		void start_ds1302() {
;ds1302.c,4 :: 		RST_DS1302 = 0;
	BCF        PORTC+0, 0
;ds1302.c,5 :: 		SCLK = 0;
	BCF        PORTC+0, 1
;ds1302.c,6 :: 		RST_DS1302 = 1;
	BSF        PORTC+0, 0
;ds1302.c,7 :: 		Delay_us(4);
	NOP
	NOP
	NOP
	NOP
;ds1302.c,8 :: 		}
L_end_start_ds1302:
	RETURN
; end of _start_ds1302

_stop_ds1302:

;ds1302.c,10 :: 		void stop_ds1302() {
;ds1302.c,11 :: 		RST_DS1302 = 0;
	BCF        PORTC+0, 0
;ds1302.c,12 :: 		Delay_us(4);
	NOP
	NOP
	NOP
	NOP
;ds1302.c,14 :: 		}
L_end_stop_ds1302:
	RETURN
; end of _stop_ds1302

_toggle_read_ds1302:

;ds1302.c,16 :: 		unsigned char toggle_read_ds1302() {
;ds1302.c,18 :: 		IO_DIR = 1;
	BSF        TRISC+0, 2
;ds1302.c,19 :: 		read_data = 0;
	CLRF       R4+0
;ds1302.c,20 :: 		for(i = 0; i < 8; i++) {
	CLRF       R3+0
L_toggle_read_ds13020:
	MOVLW      8
	SUBWF      R3+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_toggle_read_ds13021
;ds1302.c,21 :: 		SCLK = 1;
	BSF        PORTC+0, 1
;ds1302.c,22 :: 		asm nop;
	NOP
;ds1302.c,23 :: 		SCLK = 0;
	BCF        PORTC+0, 1
;ds1302.c,24 :: 		asm nop;
	NOP
;ds1302.c,25 :: 		read_data |= IO << i;
	CLRF       R2+0
	BTFSC      PORTC+0, 2
	INCF       R2+0, 1
	MOVF       R3+0, 0
	MOVWF      R1+0
	MOVF       R2+0, 0
	MOVWF      R0+0
	MOVF       R1+0, 0
L__toggle_read_ds130214:
	BTFSC      STATUS+0, 2
	GOTO       L__toggle_read_ds130215
	RLF        R0+0, 1
	BCF        R0+0, 0
	ADDLW      255
	GOTO       L__toggle_read_ds130214
L__toggle_read_ds130215:
	MOVF       R0+0, 0
	IORWF      R4+0, 1
;ds1302.c,20 :: 		for(i = 0; i < 8; i++) {
	INCF       R3+0, 1
;ds1302.c,26 :: 		}
	GOTO       L_toggle_read_ds13020
L_toggle_read_ds13021:
;ds1302.c,27 :: 		IO_DIR = 0;
	BCF        TRISC+0, 2
;ds1302.c,28 :: 		return read_data;
	MOVF       R4+0, 0
	MOVWF      R0+0
;ds1302.c,29 :: 		}
L_end_toggle_read_ds1302:
	RETURN
; end of _toggle_read_ds1302

_toggle_write_ds1302:

;ds1302.c,31 :: 		void toggle_write_ds1302(unsigned char write_data, unsigned char release) {
;ds1302.c,33 :: 		for(i = 0; i < 8; i++) {
	CLRF       R1+0
L_toggle_write_ds13023:
	MOVLW      8
	SUBWF      R1+0, 0
	BTFSC      STATUS+0, 0
	GOTO       L_toggle_write_ds13024
;ds1302.c,34 :: 		IO = write_data.F0;
	BTFSC      FARG_toggle_write_ds1302_write_data+0, 0
	GOTO       L__toggle_write_ds130217
	BCF        PORTC+0, 2
	GOTO       L__toggle_write_ds130218
L__toggle_write_ds130217:
	BSF        PORTC+0, 2
L__toggle_write_ds130218:
;ds1302.c,35 :: 		write_data >>= 1;
	RRF        FARG_toggle_write_ds1302_write_data+0, 1
	BCF        FARG_toggle_write_ds1302_write_data+0, 7
;ds1302.c,36 :: 		SCLK = 1;
	BSF        PORTC+0, 1
;ds1302.c,37 :: 		asm nop;
	NOP
;ds1302.c,38 :: 		if(release && i == 7) {
	MOVF       FARG_toggle_write_ds1302_release+0, 0
	BTFSC      STATUS+0, 2
	GOTO       L_toggle_write_ds13028
	MOVF       R1+0, 0
	XORLW      7
	BTFSS      STATUS+0, 2
	GOTO       L_toggle_write_ds13028
L__toggle_write_ds130210:
;ds1302.c,39 :: 		IO_DIR = 1;
	BSF        TRISC+0, 2
;ds1302.c,40 :: 		} else {
	GOTO       L_toggle_write_ds13029
L_toggle_write_ds13028:
;ds1302.c,41 :: 		SCLK = 0;
	BCF        PORTC+0, 1
;ds1302.c,42 :: 		asm nop;
	NOP
;ds1302.c,43 :: 		}
L_toggle_write_ds13029:
;ds1302.c,33 :: 		for(i = 0; i < 8; i++) {
	INCF       R1+0, 1
;ds1302.c,44 :: 		}
	GOTO       L_toggle_write_ds13023
L_toggle_write_ds13024:
;ds1302.c,45 :: 		}
L_end_toggle_write_ds1302:
	RETURN
; end of _toggle_write_ds1302

_read_ds1302:

;ds1302.c,47 :: 		unsigned char read_ds1302(unsigned char cmd) {
;ds1302.c,49 :: 		cmd.B0 = 1;
	BSF        FARG_read_ds1302_cmd+0, 0
;ds1302.c,50 :: 		start_ds1302();
	CALL       _start_ds1302+0
;ds1302.c,51 :: 		toggle_write_ds1302(cmd, 1);
	MOVF       FARG_read_ds1302_cmd+0, 0
	MOVWF      FARG_toggle_write_ds1302_write_data+0
	MOVLW      1
	MOVWF      FARG_toggle_write_ds1302_release+0
	CALL       _toggle_write_ds1302+0
;ds1302.c,52 :: 		read_data = toggle_read_ds1302();
	CALL       _toggle_read_ds1302+0
	MOVF       R0+0, 0
	MOVWF      read_ds1302_read_data_L0+0
;ds1302.c,53 :: 		stop_ds1302();
	CALL       _stop_ds1302+0
;ds1302.c,54 :: 		return read_data;
	MOVF       read_ds1302_read_data_L0+0, 0
	MOVWF      R0+0
;ds1302.c,55 :: 		}
L_end_read_ds1302:
	RETURN
; end of _read_ds1302

_write_ds1302:

;ds1302.c,57 :: 		void write_ds1302(unsigned char cmd, unsigned char write_data) {
;ds1302.c,58 :: 		start_ds1302();
	CALL       _start_ds1302+0
;ds1302.c,59 :: 		toggle_write_ds1302(cmd, 0);
	MOVF       FARG_write_ds1302_cmd+0, 0
	MOVWF      FARG_toggle_write_ds1302_write_data+0
	CLRF       FARG_toggle_write_ds1302_release+0
	CALL       _toggle_write_ds1302+0
;ds1302.c,60 :: 		toggle_write_ds1302(write_data, 0);
	MOVF       FARG_write_ds1302_write_data+0, 0
	MOVWF      FARG_toggle_write_ds1302_write_data+0
	CLRF       FARG_toggle_write_ds1302_release+0
	CALL       _toggle_write_ds1302+0
;ds1302.c,61 :: 		stop_ds1302();
	CALL       _stop_ds1302+0
;ds1302.c,62 :: 		}
L_end_write_ds1302:
	RETURN
; end of _write_ds1302

_halt_ds1302:

;ds1302.c,64 :: 		void halt_ds1302() {
;ds1302.c,65 :: 		write_ds1302(DS1302_ENABLE, 0x00);
	MOVLW      142
	MOVWF      FARG_write_ds1302_cmd+0
	CLRF       FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,66 :: 		}
L_end_halt_ds1302:
	RETURN
; end of _halt_ds1302

_get_time:

;ds1302.c,68 :: 		void get_time(unsigned char *hour, unsigned char *minute, unsigned char *second) {
;ds1302.c,69 :: 		*hour   = read_ds1302(READ_HOUR_CMD);
	MOVLW      133
	MOVWF      FARG_read_ds1302_cmd+0
	CALL       _read_ds1302+0
	MOVF       FARG_get_time_hour+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;ds1302.c,70 :: 		*minute = read_ds1302(READ_MINUTE_CMD);
	MOVLW      131
	MOVWF      FARG_read_ds1302_cmd+0
	CALL       _read_ds1302+0
	MOVF       FARG_get_time_minute+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;ds1302.c,71 :: 		*second = read_ds1302(READ_SECOND_CMD);
	MOVLW      129
	MOVWF      FARG_read_ds1302_cmd+0
	CALL       _read_ds1302+0
	MOVF       FARG_get_time_second+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;ds1302.c,72 :: 		}
L_end_get_time:
	RETURN
; end of _get_time

_get_date:

;ds1302.c,74 :: 		void get_date(unsigned char *year, unsigned char *month, unsigned char *day) {
;ds1302.c,75 :: 		*year   = read_ds1302(READ_YEAR_CMD);
	MOVLW      141
	MOVWF      FARG_read_ds1302_cmd+0
	CALL       _read_ds1302+0
	MOVF       FARG_get_date_year+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;ds1302.c,76 :: 		*month = read_ds1302(READ_MONTH_CMD);
	MOVLW      137
	MOVWF      FARG_read_ds1302_cmd+0
	CALL       _read_ds1302+0
	MOVF       FARG_get_date_month+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;ds1302.c,77 :: 		*day   = read_ds1302(READ_DAY_CMD);
	MOVLW      135
	MOVWF      FARG_read_ds1302_cmd+0
	CALL       _read_ds1302+0
	MOVF       FARG_get_date_day+0, 0
	MOVWF      FSR
	MOVF       R0+0, 0
	MOVWF      INDF+0
;ds1302.c,78 :: 		}
L_end_get_date:
	RETURN
; end of _get_date

_set_time:

;ds1302.c,80 :: 		void set_time(unsigned char hour, unsigned char minute, unsigned char second) {
;ds1302.c,82 :: 		write_ds1302(WRITE_HOUR_CMD,   hour);
	MOVLW      132
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_time_hour+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,83 :: 		write_ds1302(WRITE_MINUTE_CMD, minute);
	MOVLW      130
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_time_minute+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,84 :: 		write_ds1302(WRITE_SECOND_CMD, second);
	MOVLW      128
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_time_second+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,85 :: 		}
L_end_set_time:
	RETURN
; end of _set_time

_set_date:

;ds1302.c,87 :: 		void set_date(unsigned char year, unsigned char month, unsigned char day, unsigned char week_day) {
;ds1302.c,89 :: 		write_ds1302(WRITE_YEAR_CMD,    year);
	MOVLW      140
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_date_year+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,90 :: 		write_ds1302(WRITE_MONTH_CMD,   month);
	MOVLW      136
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_date_month+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,91 :: 		write_ds1302(WRITE_DAY_CMD,     day);
	MOVLW      134
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_date_day+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,92 :: 		write_ds1302(WRITE_WEEKDAY_CMD, week_day);
	MOVLW      138
	MOVWF      FARG_write_ds1302_cmd+0
	MOVF       FARG_set_date_week_day+0, 0
	MOVWF      FARG_write_ds1302_write_data+0
	CALL       _write_ds1302+0
;ds1302.c,93 :: 		}
L_end_set_date:
	RETURN
; end of _set_date
