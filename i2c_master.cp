#line 1 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/i2c_master.c"





void i2c_master_init() {
  TRISC.B3  = 1;
  TRISC.B4  = 1;
 SSPCON2 = 0;
 SSPSTAT = 0x80;
 SSPADD = 9;
 SSPCON = 0b00101000;
}

void i2c_idle() {




 while(SSPSTAT.R_W || (SSPCON2 & 0x1F));
}


void i2c_master_start() {
 i2c_idle();
 PIR1.SSPIF = 0;
 SSPCON2.SEN = 1;
 while(!PIR1.SSPIF);
 PIR1.SSPIF = 0;
}


void i2c_master_stop() {
 i2c_idle();
 PIR1.SSPIF = 0;
 SSPCON2.PEN = 1;
 while(!PIR1.SSPIF);
 PIR1.SSPIF = 0;
}


void i2c_master_restart() {
 i2c_idle();
 PIR1.SSPIF = 0;
 SSPCON2.RSEN = 1;
 while(!PIR1.SSPIF);
 PIR1.SSPIF = 0;
}

void i2c_master_write(unsigned char slave_address, unsigned char data_index, unsigned char write_data) {
 i2c_master_start();
 SSPBUF = (slave_address << 1);
 i2c_idle();
 SSPBUF = data_index;
 i2c_idle();
 SSPBUF = write_data;
 i2c_master_stop();
 i2c_idle();
}

unsigned char i2c_master_read(unsigned char slave_address, unsigned char data_index) {
 unsigned char read_data = 0;
 i2c_master_start();
 SSPBUF = slave_address << 1;
 i2c_idle();
 SSPBUF = data_index;
 i2c_master_restart();
 SSPBUF = (slave_address << 1) | 0x01;
 i2c_idle();
 SSPCON2.RCEN = 1;
 i2c_idle();
 read_data = SSPBUF;
 SSPCON2.ACKDT = 1;
 SSPCON2.ACKEN = 1;
 while(SSPCON2.ACKEN);
 SSPCON2.ACKDT = 0;
 i2c_master_stop();
 return read_data;
}
