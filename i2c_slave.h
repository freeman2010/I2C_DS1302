#define SDA     PORTC.B3
#define SCL     PORTC.B4
#define SDA_DIR TRISC.B3
#define SCL_DIR TRISC.B4

void i2c_slave_init(unsigned char slave_address);
void i2c_idle();
unsigned char i2c_slave_read();
void i2c_slave_write(unsigned char write_data);