#include "i2c_master.h"

#define SET_DATE PORTB.B0

// LCD module connections
sbit LCD_RS at RD4_bit;
sbit LCD_EN at RD5_bit;
sbit LCD_D4 at RD0_bit;
sbit LCD_D5 at RD1_bit;
sbit LCD_D6 at RD2_bit;
sbit LCD_D7 at RD3_bit;

sbit LCD_RS_Direction at TRISD4_bit;
sbit LCD_EN_Direction at TRISD5_bit;
sbit LCD_D4_Direction at TRISD0_bit;
sbit LCD_D5_Direction at TRISD1_bit;
sbit LCD_D6_Direction at TRISD2_bit;
sbit LCD_D7_Direction at TRISD3_bit;
// End LCD module connections

unsigned char str_week_day_name[7][4] = {"Mon", "Tue", "Wen", "Thu", "Fri", "Sat", "Sun"};
unsigned char str_month_name[12][4]   = {"Jan", "Feb", "Mar", "Apr", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};

// hour, minute, second, year, month, day, week_day
const unsigned char array_length = 7;
unsigned char get_date_array[array_length] = {0, };
unsigned char set_date_array[array_length] = {12, 30, 40, 24, 4, 5, 4};
unsigned char temp;

const unsigned char slave_address = 6;

void disp_date() {
  unsigned char temp;
  // month
  temp = ((get_date_array[4] >> 4) * 10) + (get_date_array[4] & 0x0F);
  Lcd_Out(1, 1, "Date:");
  Lcd_Out_Cp(str_month_name[temp - 1]);
  Lcd_Chr_Cp('-');
  // day
  Lcd_Chr_Cp('0' + ((get_date_array[5] >> 4) & 0x0F));
  Lcd_Chr_Cp('0' + (get_date_array[5] & 0x0F));
  Lcd_Chr_Cp('-');
  // year
  Lcd_Out_Cp("20");
  Lcd_Chr_Cp('0' + ((get_date_array[3] >> 4) & 0x0F));
  Lcd_Chr_Cp('0' + (get_date_array[3] & 0x0F));
}

void disp_time() {
  Lcd_Out(2, 1, "Time:");
  Lcd_Chr_Cp('0' + ((get_date_array[0] >> 4) & 0x0F));
  Lcd_Chr_Cp('0' + (get_date_array[0] & 0x0F));
  Lcd_Chr_Cp(':');
  Lcd_Chr_Cp('0' + ((get_date_array[1] >> 4) & 0x0F));
  Lcd_Chr_Cp('0' + (get_date_array[1] & 0x0F));
  Lcd_Chr_Cp(':');
  Lcd_Chr_Cp('0' + ((get_date_array[2] >> 4) & 0x0F));
  Lcd_Chr_Cp('0' + (get_date_array[2] & 0x0F));
}

void interrupt() {
  if(PIR1.SSPIF) {
//    start condition
//    stop condition
//    data transfer byte transmitted/received
//    acknowledge transmit
//    repeated start condition
    PIR1.SSPIF = 0;
  }
}

void init() {
  OPTION_REG = 0;
  ANSEL = 0;
  ANSELH = 0;
  
  PORTA = 0;
  TRISA = 0;
  PORTB = 0;
  TRISB = 0x01;
  PORTC = 0;
  TRISC = 0;
  PORTD = 0;
  TRISD = 0;
  PIR1 = 0;
  
  Lcd_Init();
  Lcd_Cmd(_LCD_CLEAR);
  Lcd_Cmd(_LCD_CURSOR_OFF);
  Lcd_Out(1, 5, "Welcome");
  Lcd_Out(2, 2, "Initializing...");

  i2c_master_init();
}

void set_date() {
  unsigned char i;
  for(i = 0; i < array_length; i++) {
    temp = ((set_date_array[i] / 10) << 4) | ((set_date_array[i] % 10) & 0x0F);
    i2c_master_write(slave_address, i, temp);
  }
}

void get_date() {
  unsigned char i;
  for(i = 0; i < array_length; i++) {
    get_date_array[i] = i2c_master_read(slave_address, i);
  }
}

void main() {
  init();
  Delay_ms(500);
  Lcd_Cmd(_LCD_CLEAR);

  while(1) {
    get_date();

    disp_time();
    disp_date();
    
    Delay_ms(300);

    if(!SET_DATE) {
      Delay_ms(500);
      set_date();
      Delay_ms(500);
    }
  }
}