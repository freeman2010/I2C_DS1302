#line 1 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/slave.c"
#line 1 "f:/task/pic/ds1302/i2c_ds1302(working)/ds1302.h"
#line 38 "f:/task/pic/ds1302/i2c_ds1302(working)/ds1302.h"
void start_ds1302();
void stop_ds1302();
void halt_ds1302();
unsigned char toggle_read_ds1302();
unsigned char read_ds1302(unsigned char cmd);
void toggle_write_ds1302(unsigned char write_data, unsigned char release);
void write_ds1302(unsigned char cmd, unsigned char write_data);
void get_time(unsigned char *hour, unsigned char *minute, unsigned char *second);
void get_date(unsigned char *year, unsigned char *month, unsigned char *day);
void set_time(unsigned char hour, unsigned char minute, unsigned char second);
void set_date(unsigned char year, unsigned char month, unsigned char day, unsigned char week_day);
#line 1 "f:/task/pic/ds1302/i2c_ds1302(working)/i2c_slave.h"





void i2c_slave_init(unsigned char slave_address);
void i2c_idle();
unsigned char i2c_slave_read();
void i2c_slave_write(unsigned char write_data);
#line 3 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/slave.c"
unsigned char i2c_address = 6;


unsigned char master_read_flag = 0;
unsigned char array_index = 0;
const unsigned char array_length = 7;
unsigned char get_date_array[array_length] = {0, };
unsigned char set_date_array[array_length] = {0, };

unsigned char set_date_time_flag = 0;
unsigned char reg_adr_flag = 0;
unsigned char temp;

void interrupt()
{
 if(PIR1.SSPIF)
 {
 if(SSPSTAT.R_W == 1)
 {
 SSPBUF = get_date_array[array_index];
 SSPCON.CKP = 1;
 }

 if(SSPSTAT.R_W == 0)
 {
 if(SSPSTAT.D_A == 0)
 {
 reg_adr_flag = 1;
 temp = SSPBUF;
 SSPCON.CKP = 1;
 }
 if(SSPSTAT.D_A == 1)
 {
 if(reg_adr_flag == 1)
 {
 array_index = SSPBUF;
 reg_adr_flag = 0;
 }
 else
 {
 set_date_array[array_index] = SSPBUF;
 if(array_index == (array_length - 1)) {
 set_date_time_flag = 1;
 }
 SSPCON.CKP = 1;
 }
 }
 }
 PIR1.SSPIF = 0;
 }

 if(PIR2.BCLIF == 1)
 {
 temp = SSPBUF;
 PIR2.BCLIF = 0;
 SSPCON.CKP = 1;
 }
}

void init() {
 ANSEL = 0;
 ANSELh = 0;


 OPTION_REG = 0;

 PORTA = 0;
 TRISA = 0;
 PORTB = 0;
 TRISB = 0;
 PORTC = 0;
 TRISC = 0;
 PORTD = 0;
 TRISD = 0;

 i2c_slave_init(i2c_address);
}

void main() {
 init();

 while(1) {

 get_time(get_date_array, get_date_array + 1, get_date_array + 2);

 get_date(get_date_array + 3, get_date_array + 4, get_date_array + 5);

 if(set_date_time_flag == 1) {
 set_date_time_flag = 0;
 set_time(set_date_array[0], set_date_array[1], set_date_array[2]);
 set_date(set_date_array[3], set_date_array[4], set_date_array[5], set_date_array[6]);
 }
 }
}
