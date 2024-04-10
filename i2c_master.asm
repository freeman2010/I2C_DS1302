
_i2c_master_init:

;i2c_master.c,6 :: 		void i2c_master_init() {
;i2c_master.c,7 :: 		SCL_DIR = 1;
	BSF        TRISC+0, 3
;i2c_master.c,8 :: 		SDA_DIR = 1;
	BSF        TRISC+0, 4
;i2c_master.c,9 :: 		SSPCON2 = 0;
	CLRF       SSPCON2+0
;i2c_master.c,10 :: 		SSPSTAT = 0x80;      // slew rate control disblaed for standard speed mode(100kHz and 100MHz)
	MOVLW      128
	MOVWF      SSPSTAT+0
;i2c_master.c,11 :: 		SSPADD = 9;          // Set I2C clock speed 100kHz in Xtal 4MHz
	MOVLW      9
	MOVWF      SSPADD+0
;i2c_master.c,12 :: 		SSPCON = 0b00101000; // Enable I2C Master mode, clock = FOSC/(4 * (SSPADD + 1))
	MOVLW      40
	MOVWF      SSPCON+0
;i2c_master.c,13 :: 		}
L_end_i2c_master_init:
	RETURN
; end of _i2c_master_init

_i2c_idle:

;i2c_master.c,15 :: 		void i2c_idle() {
;i2c_master.c,20 :: 		while(SSPSTAT.R_W || (SSPCON2 & 0x1F));
L_i2c_idle0:
	BTFSC      SSPSTAT+0, 2
	GOTO       L__i2c_idle12
	MOVLW      31
	ANDWF      SSPCON2+0, 0
	MOVWF      R0+0
	BTFSS      STATUS+0, 2
	GOTO       L__i2c_idle12
	GOTO       L_i2c_idle1
L__i2c_idle12:
	GOTO       L_i2c_idle0
L_i2c_idle1:
;i2c_master.c,21 :: 		}
L_end_i2c_idle:
	RETURN
; end of _i2c_idle

_i2c_master_start:

;i2c_master.c,24 :: 		void i2c_master_start() {
;i2c_master.c,25 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,26 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_master.c,27 :: 		SSPCON2.SEN = 1;  // Initiate Start condition
	BSF        SSPCON2+0, 0
;i2c_master.c,28 :: 		while(!PIR1.SSPIF);
L_i2c_master_start4:
	BTFSC      PIR1+0, 3
	GOTO       L_i2c_master_start5
	GOTO       L_i2c_master_start4
L_i2c_master_start5:
;i2c_master.c,29 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_master.c,30 :: 		}
L_end_i2c_master_start:
	RETURN
; end of _i2c_master_start

_i2c_master_stop:

;i2c_master.c,33 :: 		void i2c_master_stop() {
;i2c_master.c,34 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,35 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_master.c,36 :: 		SSPCON2.PEN = 1;  // Initiate Stop condition
	BSF        SSPCON2+0, 2
;i2c_master.c,37 :: 		while(!PIR1.SSPIF);
L_i2c_master_stop6:
	BTFSC      PIR1+0, 3
	GOTO       L_i2c_master_stop7
	GOTO       L_i2c_master_stop6
L_i2c_master_stop7:
;i2c_master.c,38 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_master.c,39 :: 		}
L_end_i2c_master_stop:
	RETURN
; end of _i2c_master_stop

_i2c_master_restart:

;i2c_master.c,42 :: 		void i2c_master_restart() {
;i2c_master.c,43 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,44 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_master.c,45 :: 		SSPCON2.RSEN = 1;
	BSF        SSPCON2+0, 1
;i2c_master.c,46 :: 		while(!PIR1.SSPIF);
L_i2c_master_restart8:
	BTFSC      PIR1+0, 3
	GOTO       L_i2c_master_restart9
	GOTO       L_i2c_master_restart8
L_i2c_master_restart9:
;i2c_master.c,47 :: 		PIR1.SSPIF = 0;
	BCF        PIR1+0, 3
;i2c_master.c,48 :: 		}
L_end_i2c_master_restart:
	RETURN
; end of _i2c_master_restart

_i2c_master_write:

;i2c_master.c,50 :: 		void i2c_master_write(unsigned char slave_address, unsigned char data_index, unsigned char write_data) {
;i2c_master.c,51 :: 		i2c_master_start();
	CALL       _i2c_master_start+0
;i2c_master.c,52 :: 		SSPBUF = (slave_address << 1); // SET SSPSTAT.R_W AS 0;
	MOVF       FARG_i2c_master_write_slave_address+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      SSPBUF+0
;i2c_master.c,53 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,54 :: 		SSPBUF = data_index;
	MOVF       FARG_i2c_master_write_data_index+0, 0
	MOVWF      SSPBUF+0
;i2c_master.c,55 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,56 :: 		SSPBUF = write_data;
	MOVF       FARG_i2c_master_write_write_data+0, 0
	MOVWF      SSPBUF+0
;i2c_master.c,57 :: 		i2c_master_stop();
	CALL       _i2c_master_stop+0
;i2c_master.c,58 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,59 :: 		}
L_end_i2c_master_write:
	RETURN
; end of _i2c_master_write

_i2c_master_read:

;i2c_master.c,61 :: 		unsigned char i2c_master_read(unsigned char slave_address, unsigned char data_index) {
;i2c_master.c,62 :: 		unsigned char read_data = 0;
	CLRF       i2c_master_read_read_data_L0+0
;i2c_master.c,63 :: 		i2c_master_start();
	CALL       _i2c_master_start+0
;i2c_master.c,64 :: 		SSPBUF = slave_address << 1;
	MOVF       FARG_i2c_master_read_slave_address+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVF       R0+0, 0
	MOVWF      SSPBUF+0
;i2c_master.c,65 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,66 :: 		SSPBUF = data_index;
	MOVF       FARG_i2c_master_read_data_index+0, 0
	MOVWF      SSPBUF+0
;i2c_master.c,67 :: 		i2c_master_restart();
	CALL       _i2c_master_restart+0
;i2c_master.c,68 :: 		SSPBUF = (slave_address << 1) | 0x01;
	MOVF       FARG_i2c_master_read_slave_address+0, 0
	MOVWF      R0+0
	RLF        R0+0, 1
	BCF        R0+0, 0
	MOVLW      1
	IORWF      R0+0, 0
	MOVWF      SSPBUF+0
;i2c_master.c,69 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,70 :: 		SSPCON2.RCEN = 1; // enable receive mode
	BSF        SSPCON2+0, 3
;i2c_master.c,71 :: 		i2c_idle();
	CALL       _i2c_idle+0
;i2c_master.c,72 :: 		read_data = SSPBUF;
	MOVF       SSPBUF+0, 0
	MOVWF      i2c_master_read_read_data_L0+0
;i2c_master.c,73 :: 		SSPCON2.ACKDT = 1; // not ack
	BSF        SSPCON2+0, 5
;i2c_master.c,74 :: 		SSPCON2.ACKEN = 1; // init ack sequence, transmit ackdt data bit
	BSF        SSPCON2+0, 4
;i2c_master.c,75 :: 		while(SSPCON2.ACKEN);
L_i2c_master_read10:
	BTFSS      SSPCON2+0, 4
	GOTO       L_i2c_master_read11
	GOTO       L_i2c_master_read10
L_i2c_master_read11:
;i2c_master.c,76 :: 		SSPCON2.ACKDT = 0; // ack
	BCF        SSPCON2+0, 5
;i2c_master.c,77 :: 		i2c_master_stop();
	CALL       _i2c_master_stop+0
;i2c_master.c,78 :: 		return read_data;
	MOVF       i2c_master_read_read_data_L0+0, 0
	MOVWF      R0+0
;i2c_master.c,79 :: 		}
L_end_i2c_master_read:
	RETURN
; end of _i2c_master_read
