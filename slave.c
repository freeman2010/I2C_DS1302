#include "ds1302.h"
#include "i2c_slave.h"
unsigned char i2c_address = 6; // must be in 0~7 in 7bit address mode

// hour, minute, second, year, month, day, week_day
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
  if(PIR1.SSPIF) // Check for SSPIF
  {
    if(SSPSTAT.R_W == 1) // Master read (slave transmit)
    {
      SSPBUF = get_date_array[array_index]; // Load array value
      SSPCON.CKP = 1; // Release clock stretch
    }
    
    if(SSPSTAT.R_W == 0) // Master write (slave receive)
    {
      if(SSPSTAT.D_A == 0) // Last byte was an address
      {
        reg_adr_flag = 1; // Next byte register address
        temp = SSPBUF; // Clear BF
        SSPCON.CKP = 1; // Release clock stretch
      }
      if(SSPSTAT.D_A == 1) // Last byte was data
      {
        if(reg_adr_flag == 1) // Last byte was register add
        {
          array_index = SSPBUF; // Load register address
          reg_adr_flag = 0; // Next byte will be true data
        }
        else
        {
          set_date_array[array_index] = SSPBUF; // Yes, read SSP1BUF
          if(array_index == (array_length - 1)) {
            set_date_time_flag = 1;
          }
          SSPCON.CKP = 1; // Release clock stretch
        }
      }
    }      
    PIR1.SSPIF = 0; // Clear SSP1IF
  }
  
  if(PIR2.BCLIF == 1)
  {
    temp = SSPBUF; // Clear BF
    PIR2.BCLIF = 0; // Clear BCLIF
    SSPCON.CKP = 1; // Release clock stretching
  }
}

void init() {
  ANSEL = 0;
  ANSELh = 0;

  // PORTB pull up enable
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
    // hour, minute, second
    get_time(get_date_array, get_date_array + 1, get_date_array + 2);
    // year, month, day
    get_date(get_date_array + 3, get_date_array + 4, get_date_array + 5);

    if(set_date_time_flag == 1) {
      set_date_time_flag = 0;
      set_time(set_date_array[0], set_date_array[1], set_date_array[2]);
      set_date(set_date_array[3], set_date_array[4], set_date_array[5], set_date_array[6]);
    }
  }
}