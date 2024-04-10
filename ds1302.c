#include "ds1302.h"

void start_ds1302() {
  RST_DS1302 = 0;
  SCLK = 0;
  RST_DS1302 = 1;
  Delay_us(4);
}

void stop_ds1302() {
  RST_DS1302 = 0;
  Delay_us(4);
  
}

unsigned char toggle_read_ds1302() {
  unsigned char i, read_data;
  IO_DIR = 1;
  read_data = 0;
  for(i = 0; i < 8; i++) {
    SCLK = 1;
    asm nop;
    SCLK = 0;
    asm nop;
    read_data |= IO << i;
  }
  IO_DIR = 0;
  return read_data;
}

void toggle_write_ds1302(unsigned char write_data, unsigned char release) {
  unsigned char i;
  for(i = 0; i < 8; i++) {
    IO = write_data.F0;
    write_data >>= 1;
    SCLK = 1;
    asm nop;
    if(release && i == 7) {
      IO_DIR = 1;
    } else {
      SCLK = 0;
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
  write_ds1302(DS1302_ENABLE, 0x00);
}

void get_time(unsigned char *hour, unsigned char *minute, unsigned char *second) {
  *hour   = read_ds1302(READ_HOUR_CMD);
  *minute = read_ds1302(READ_MINUTE_CMD);
  *second = read_ds1302(READ_SECOND_CMD);
}

void get_date(unsigned char *year, unsigned char *month, unsigned char *day) {
  *year   = read_ds1302(READ_YEAR_CMD);
  *month = read_ds1302(READ_MONTH_CMD);
  *day   = read_ds1302(READ_DAY_CMD);
}

void set_time(unsigned char hour, unsigned char minute, unsigned char second) {
  // set time
  write_ds1302(WRITE_HOUR_CMD,   hour);
  write_ds1302(WRITE_MINUTE_CMD, minute);
  write_ds1302(WRITE_SECOND_CMD, second);
}

void set_date(unsigned char year, unsigned char month, unsigned char day, unsigned char week_day) {
  // set date
  write_ds1302(WRITE_YEAR_CMD,    year);
  write_ds1302(WRITE_MONTH_CMD,   month);
  write_ds1302(WRITE_DAY_CMD,     day);
  write_ds1302(WRITE_WEEKDAY_CMD, week_day);
}