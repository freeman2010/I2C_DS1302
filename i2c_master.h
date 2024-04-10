void i2c_idle();
void i2c_master_init();
void i2c_master_start();
void i2c_master_stop();
void i2c_master_restart();
unsigned char i2c_master_read(unsigned char slave_address, unsigned char data_index);
void i2c_master_write(unsigned char slave_address, unsigned char data_index, unsigned char write_data);