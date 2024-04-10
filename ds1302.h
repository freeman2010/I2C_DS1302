#define RST_DS1302  PORTC.B0
#define SCLK        PORTC.B1
#define IO          PORTC.B2
#define IO_DIR      TRISC.B2

#define WRITE_SECOND_CMD 0x80
#define READ_SECOND_CMD  0x81
#define WRITE_MINUTE_CMD 0x82
#define READ_MINUTE_CMD  0x83
#define WRITE_HOUR_CMD   0x84
#define READ_HOUR_CMD    0x85

#define WRITE_DAY_CMD      0x86
#define READ_DAY_CMD       0x87
#define WRITE_MONTH_CMD    0x88
#define READ_MONTH_CMD     0x89
#define WRITE_WEEKDAY_CMD 0x8A
#define READ_WEEKDAY_CMD  0x8B
#define WRITE_YEAR_CMD     0x8C
#define READ_YEAR_CMD      0x8D

#define DS1302_ENABLE            0x8E
#define DS1302_TRICKLE           0x90
#define DS1302_CLOCK_BURST       0xBE
#define DS1302_CLOCK_BURST_WRITE 0xBE
#define DS1302_CLOCK_BURST_READ  0xBF
#define DS1302_RAMSTART          0xC0
#define DS1302_RAMEND            0xFC
#define DS1302_RAM_BURST         0xFE
#define DS1302_RAM_BURST_WRITE   0xFE
#define DS1302_RAM_BURST_READ    0xFF

#define bcd2bin(h,l) (((h)*10) + (l))
#define bin2bcd_h(x) ((x)/10)
#define bin2bcd_l(x) ((x)%10)


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