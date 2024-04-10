#line 1 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/i2c_slave.c"
#line 1 "f:/task/pic/ds1302/i2c_ds1302(working)/i2c_slave.h"





void i2c_slave_init(unsigned char slave_address);
void i2c_idle();
unsigned char i2c_slave_read();
void i2c_slave_write(unsigned char write_data);
#line 3 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/i2c_slave.c"
void i2c_slave_init(unsigned char slave_address) {
  TRISC.B4  = 1;
  TRISC.B3  = 1;
 SSPADD = slave_address << 1;
 SSPCON = 0x36;
 SSPSTAT = 0x80;
 PIR1.SSPIF = 0;
 PIE1.SSPIE = 1;
 PIR2.BCLIF = 0;
 PIE2.BCLIE = 1;
 INTCON = 0xC0;
}

void i2c_idle() {




 while(SSPSTAT.R_W || (SSPCON2 & 0x1F));
}

unsigned char i2c_slave_read() {
 return SSPBUF;
}

void i2c_slave_write(unsigned char write_data) {


 SSPBUF = write_data;
 while(SSPSTAT.BF);
}
