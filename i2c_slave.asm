
_i2c_slave_init:

;i2c_slave.c,3 :: 		void i2c_slave_init(unsigned char slave_address) {
;i2c_slave.c,4 :: 		SCL_DIR = 1;
	BSF        TRISC+0, 4
;i2c_slave.c,5 :: 		SDA_DIR = 1;
	BSF        TRISC+0, 3
;i2c_slave.c,6 :: 		SSPADD = slave_address << 1;
	MOVF       FARG_i2c_slave_init_slave_address+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      SSPADD+0
;i2c_slave.c,7 :: 		SSPCON = 0x36;  // normal 7bit address mode ckp = 1(nack)
	MOVLW      54
	MOVWF      SSPCON+0
;i2c_slave.c,8 :: 		SSPSTAT = 0x80; // set standard speed mode(100kHz and 1MHz)
	MOVLW      128
	MOVWF      SSPSTAT+0
;i2c_slave.c,9 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_slave.c,10 :: 		PIE1.SSPIE = 1;
	BSF        PIE1+0, 3
;i2c_slave.c,11 :: 		PIR2.BCLIF = 0;
	BCF        PIR2+0, 3
;i2c_slave.c,12 :: 		PIE2.BCLIE = 1;
	BSF        PIE2+0, 3
;i2c_slave.c,13 :: 		INTCON = 0xC0;  // GIE, PEIE ENABLE
	MOVLW      192
	MOVWF      INTCON+0
;i2c_slave.c,14 :: 		}
L_end_i2c_slave_init:
	RETURN
; end of _i2c_slave_init

_i2c_idle:

;i2c_slave.c,16 :: 		void i2c_idle() {
;i2c_slave.c,21 :: 		while(SSPSTAT.R_W || (SSPCON2 & 0x1F));
L_i2c_idle0:
	BTFSC      SSPSTAT+0, 2
	GOTO       L__i2c_idle6
	MOVLW      31
	ANDWF      SSPCON2+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L__i2c_idle6
	GOTO       L_i2c_idle1
L__i2c_idle6:
	GOTO       L_i2c_idle0
L_i2c_idle1:
;i2c_slave.c,22 :: 		}
L_end_i2c_idle:
	RETURN
; end of _i2c_idle

_i2c_slave_read:

;i2c_slave.c,24 :: 		unsigned char i2c_slave_read() {
;i2c_slave.c,25 :: 		return SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      R0+0
;i2c_slave.c,26 :: 		}
L_end_i2c_slave_read:
	RETURN
; end of _i2c_slave_read

_i2c_slave_write:

;i2c_slave.c,28 :: 		void i2c_slave_write(unsigned char write_data) {
;i2c_slave.c,31 :: 		SSPBUF = write_data;
	MOVF       FARG_i2c_slave_write_write_data+0, 0
	MOVWF      SSPBUF+0
;i2c_slave.c,32 :: 		while(SSPSTAT.BF); // wait for buffer to be empty
L_i2c_slave_write4:
	BTFSS      SSPSTAT+0, 0
	GOTO       L_i2c_slave_write5
	GOTO       L_i2c_slave_write4
L_i2c_slave_write5:
;i2c_slave.c,33 :: 		}
L_end_i2c_slave_write:
	RETURN
; end of _i2c_slave_write
