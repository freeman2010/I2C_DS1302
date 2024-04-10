#define SCL PORTC.B3
#define SDA PORTC.B4
#define SCL_DIR TRISC.B3
#define SDA_DIR TRISC.B4

void i2c_master_init() {
  SCL_DIR = 1;
  SDA_DIR = 1;
  SSPCON2 = 0;
  SSPSTAT = 0x80;      // slew rate control disblaed for standard speed mode(100kHz and 100MHz)
  SSPADD = 9;          // Set I2C clock speed 100kHz in Xtal 4MHz
  SSPCON = 0b00101000; // Enable I2C Master mode, clock = FOSC/(4 * (SSPADD + 1))
}

void i2c_idle() {
//  check either i2c bus is busy or free
//  SSPSTAT.R_W as 1
//  SSPCON2.SEN || SSPCON2.PEN || SSPCON2.RCEN || SSPCON2.ACKEN
//  wait to idle
  while(SSPSTAT.R_W || (SSPCON2 & 0x1F));
}

// I2C Master Start Condition
void i2c_master_start() {
  i2c_idle();
  PIR1.SSPIF = 0;
  SSPCON2.SEN = 1;  // Initiate Start condition
  while(!PIR1.SSPIF);
  PIR1.SSPIF = 0;
}

// I2C Master Stop Condition
void i2c_master_stop() {
  i2c_idle();
  PIR1.SSPIF = 0;
  SSPCON2.PEN = 1;  // Initiate Stop condition
  while(!PIR1.SSPIF);
  PIR1.SSPIF = 0;
}

// I2C Master Restart Condition
void i2c_master_restart() {
  i2c_idle();
  PIR1.SSPIF = 0;
  SSPCON2.RSEN = 1;
  while(!PIR1.SSPIF);
  PIR1.SSPIF = 0;
}

void i2c_master_write(unsigned char slave_address, unsigned char data_index, unsigned char write_data) {
  i2c_master_start();
  SSPBUF = (slave_address << 1); // SET SSPSTAT.R_W AS 0;
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
  SSPCON2.RCEN = 1; // enable receive mode
  i2c_idle();
  read_data = SSPBUF;
  SSPCON2.ACKDT = 1; // not ack
  SSPCON2.ACKEN = 1; // init ack sequence, transmit ackdt data bit
  while(SSPCON2.ACKEN);
  SSPCON2.ACKDT = 0; // ack
  i2c_master_stop();
  return read_data;
}
