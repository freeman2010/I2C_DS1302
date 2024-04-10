#line 1 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/ds1302.c"
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
#line 3 "F:/TASK/PIC/DS1302/I2C_DS1302(Working)/ds1302.c"
void start_ds1302() {
  PORTC.B0  = 0;
  PORTC.B1  = 0;
  PORTC.B0  = 1;
 Delay_us(4);
}

void stop_ds1302() {
  PORTC.B0  = 0;
 Delay_us(4);

}

unsigned char toggle_read_ds1302() {
 unsigned char i, read_data;
  TRISC.B2  = 1;
 read_data = 0;
 for(i = 0; i < 8; i++) {
  PORTC.B1  = 1;
 asm nop;
  PORTC.B1  = 0;
 asm nop;
 read_data |=  PORTC.B2  << i;
 }
  TRISC.B2  = 0;
 return read_data;
}

void toggle_write_ds1302(unsigned char write_data, unsigned char release) {
 unsigned char i;
 for(i = 0; i < 8; i++) {
  PORTC.B2  = write_data.F0;
 write_data >>= 1;
  PORTC.B1  = 1;
 asm nop;
 if(release && i == 7) {
  TRISC.B2  = 1;
 } else {
  PORTC.B1  = 0;
 asm nop;
 }
 }
}

unsigned char read_ds1302(unsigned char cmd) {
 unsigned char read_data;
 cmd.B0 = 1;
 start_ds1302();
 toggle_write_ds1302(cmd, 1);
 read_data = toggle_read_ds1302();
 stop_ds1302();
 return read_data;
}

void write_ds1302(unsigned char cmd, unsigned char write_data) {
 start_ds1302();
 toggle_write_ds1302(cmd, 0);
 toggle_write_ds1302(write_data, 0);
 stop_ds1302();
}

void halt_ds1302() {
 write_ds1302( 0x8E , 0x00);
}

void get_time(unsigned char *hour, unsigned char *minute, unsigned char *second) {
 *hour = read_ds1302( 0x85 );
 *minute = read_ds1302( 0x83 );
 *second = read_ds1302( 0x81 );
}

void get_date(unsigned char *year, unsigned char *month, unsigned char *day) {
 *year = read_ds1302( 0x8D );
 *month = read_ds1302( 0x89 );
 *day = read_ds1302( 0x87 );
}

void set_time(unsigned char hour, unsigned char minute, unsigned char second) {

 write_ds1302( 0x84 , hour);
 write_ds1302( 0x82 , minute);
 write_ds1302( 0x80 , second);
}

void set_date(unsigned char year, unsigned char month, unsigned char day, unsigned char week_day) {

 write_ds1302( 0x8C , year);
 write_ds1302( 0x88 , month);
 write_ds1302( 0x86 , day);
 write_ds1302( 0x8A , week_day);
}
