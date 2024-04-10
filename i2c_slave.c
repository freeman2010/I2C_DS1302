#include "i2c_slave.h"

void i2c_slave_init(unsigned char slave_address) {
  SCL_DIR = 1;
  SDA_DIR = 1;
  SSPADD = slave_address << 1;
  SSPCON = 0x36;  // normal 7bit address mode ckp = 1(nack)
  SSPSTAT = 0x80; // set standard speed mode(100kHz and 1MHz)
  PIR1.SSPIF = 0;
  PIE1.SSPIE = 1;
  PIR2.BCLIF = 0;
  PIE2.BCLIE = 1;
  INTCON = 0xC0;  // GIE, PEIE ENABLE
}

void i2c_idle() {
//  check either i2c bus is busy or free
//  SSPSTAT.R_W as 1
//  SSPCON2.SEN || SSPCON2.PEN || SSPCON2.RCEN || SSPCON2.ACKEN
//  wait to idle
  while(SSPSTAT.R_W || (SSPCON2 & 0x1F));
}

unsigned char i2c_slave_read() {
  return SSPBUF;
}

void i2c_slave_write(unsigned char write_data) {
//  i2c_idle();
//  SSPCON.CKP = 1;
  SSPBUF = write_data;
  while(SSPSTAT.BF); // wait for buffer to be empty
}