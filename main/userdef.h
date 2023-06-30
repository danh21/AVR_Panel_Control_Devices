#include <stddef.h> // define NULL

#define EXMEM_ADD 0x1100    // external memory address  

int i = 0;
unsigned long modeLED; 

/*--------------Chip Select-------------------*/ 
#define CS0 0                
#define CS1 1
#define CS2 2
#define CS3 3
#define CS4 4
#define CS5 5
#define CS6 6
#define CS7 7
#define CS8 8
#define CS9 9
#define CS10 10
#define CS11 11
#define CS12 12
#define CS13 13
#define CS14 14





/*------------------------------LEDs------------------------------------------------*/
#define LEDs0 *(unsigned char*)(EXMEM_ADD + CS0)
#define LEDs1 *(unsigned char*)(EXMEM_ADD + CS1)
#define LEDs2 *(unsigned char*)(EXMEM_ADD + CS2)
#define LEDs3 *(unsigned char*)(EXMEM_ADD + CS3)

void displayLEDs(unsigned long led) {
    LEDs0 = led & 0x000000ff;       
    LEDs1 = (led>>8) & 0x000000ff;
    LEDs2 = (led>>16) & 0x000000ff;
    LEDs3 = (led>>24) & 0x000000ff; 
    delay_ms(250);     
}





/*------------------------------------LEDs 7SEG----------------------------------*/
unsigned char SegCode[] = {0xC0,0xF9,0xA4,0xB0,0x99,0x92,0x82,0xF8,0x80,0x90};



// LEDs 7seg use direct connection method
#define LED7Seg0 *(unsigned char*)(EXMEM_ADD + CS4)
#define LED7Seg1 *(unsigned char*)(EXMEM_ADD + CS5)
#define LED7Seg2 *(unsigned char*)(EXMEM_ADD + CS6)
#define LED7Seg3 *(unsigned char*)(EXMEM_ADD + CS7)

void displayLED7Seg(unsigned int number) {
    LED7Seg3 = SegCode[number/1000];
    LED7Seg2 = SegCode[(number/100)%10];
    LED7Seg1 = SegCode[(number/10)%10];
    LED7Seg0 = SegCode[number%10];
}



// LEDs 7seg use scan method
#define LED7SegCtrl *(unsigned char*)(EXMEM_ADD + CS8)
#define LED7SegData *(unsigned char*)(EXMEM_ADD + CS9)

int i;
void displayLED7SegScan(unsigned int number) {
    for (i = 50; i > 0; i--) {
        LED7SegCtrl = 0b11110111;
        LED7SegData = SegCode[number/1000];
        delay_ms(50);  
                   
        LED7SegCtrl = 0b11111011;
        LED7SegData = SegCode[(number/100)%10];
        delay_ms(50); 
          
        LED7SegCtrl = 0b11111101; 
        LED7SegData = SegCode[(number/10)%10];      
        delay_ms(50); 
          
        LED7SegCtrl = 0b11111110;
        LED7SegData = SegCode[number%10];    
        delay_ms(50);   
    }  
}



void offLED7Seg() {
    LED7Seg3 = 0xFF;
    LED7Seg2 = 0xFF;
    LED7Seg1 = 0xFF;
    LED7Seg0 = 0xFF;
    LED7SegData = 0xFF;  
    LED7SegData = 0xFF;
    LED7SegData = 0xFF;       
    LED7SegData = 0xFF;
}
    




/*--------------------------------Relays--------------------------------------------*/
#define Relays *(unsigned char*)(EXMEM_ADD + CS10)
#define RELAY_ACTIVATION ( *(unsigned char*)(&Relays) = *(unsigned char*)(&ctrlRelays) )

typedef struct {
    unsigned char RL0 : 1;  // use 1 bit 
    unsigned char RL1 : 1;
    unsigned char RL2 : 1;
    unsigned char RL3 : 1;
    unsigned char RL4 : 1;
    unsigned char RL5 : 1;
    unsigned char RL6 : 1;
    unsigned char RL7 : 1;
} RELAYS;

typedef union {
    unsigned char allRelays;    // 8bit
    RELAYS eachRelay;
} RL;

RL ctrlRelays;





/*----------------------------------Motors------------------------------------------*/
#define StopRotate 0
#define RotateForward 1
#define RotateBackward 2

#define Motors *(unsigned char*)(EXMEM_ADD + CS11)
#define MOTOR_ACTIVATION ( *(unsigned char*)(&Motors) = *(unsigned char*)(&ctrlMotors) )

typedef struct {
    unsigned char DC1 : 2;
    unsigned char DC2 : 2;
    unsigned char empty : 4;
} MOTORS;

MOTORS ctrlMotors;





/*----------------------------------Buttons------------------------------------------*/
#define Buttons *(unsigned char*)(EXMEM_ADD + CS12)
#define READ_KEY ( *(unsigned char*)(&ctrlBtns) = *(volatile unsigned char*)(&Buttons) )

typedef struct {
    unsigned char ENTER : 1;   
    unsigned char BACK : 1;
    unsigned char UP : 1;
    unsigned char NEXT : 1;
    unsigned char DOWN : 1;
    unsigned char STOP : 1;
    unsigned char FORWARD : 1;
    unsigned char BACKWARD : 1; 
} BUTTONS;

BUTTONS ctrlBtns;





/*-------------------------------------LCD------------------------------------*/
#define LCD_CMD *(unsigned char*)(EXMEM_ADD + CS14) 
#define LCD_DATA *(unsigned char*)(EXMEM_ADD + CS13)
#define LCD_EN_H ( PORTG |= (1<<3) )    // ENABLE_HIGH
#define LCD_EN_L ( PORTG &= ~(1<<3) )   // ENABLE_LOW

void LCD_WR_CMD(unsigned char cmd) {
    LCD_CMD = cmd;
    LCD_EN_H;
    delay_ms(1);
    LCD_EN_L;  
    delay_ms(1);  
}

void LCD_WR_DATA(unsigned char data) {
    LCD_DATA = data;
    LCD_EN_H;
    delay_ms(1);
    LCD_EN_L;      
}

void LCD_INIT() {
    LCD_WR_CMD(0x38);   
    LCD_WR_CMD(0x0C);
    LCD_WR_CMD(0x06);
    LCD_WR_CMD(0x01);  
}

void LCD_CLEAR() {
    LCD_WR_CMD(0x01);
}

void Print(char* string, int row, int column) {
    switch(row) {
        case 0: 
            LCD_WR_CMD(0x80 + column);    // row 1
            break;
        case 1: 
            LCD_WR_CMD(0xC0 + column);    
            break;
        case 2: 
            LCD_WR_CMD(0x94 + column);    
            break;  
        case 3: 
            LCD_WR_CMD(0xD4 + column);    
            break;
    }
    while(*string != '\0')                            
        LCD_WR_DATA(*string++);
}





/*------------------------------------DS18B20-------------------------------------*/
#define DS18B20 0
#define OneWire_Master          (DDRB |= (1<<DS18B20))      // output
#define OneWire_Master_High     (PORTB |= (1<<DS18B20))
#define OneWire_Master_Low      (PORTB &= ~(1<<DS18B20))
#define OneWire_Free            (DDRB &= ~(1<<DS18B20))     // input
#define OneWire_State           (PINB & (1<<DS18B20))

char OneWireReset(void) {
    unsigned char status;
    OneWire_Master;   
    OneWire_Master_Low;
    delay_us(480); 
    OneWire_Free;
    delay_us(70);
    status = OneWire_State; 
    delay_us(410);
    return status;
}

void OneWireWriteByte(unsigned char Byte) {
    for (i = 0; i < 8; i++) {
        OneWire_Master; 
        OneWire_Master_Low;
        if (Byte & 0x01)    // write bit 1            
            delay_us(15);
        else                // write bit 0
            delay_us(60); 
        OneWire_Free;
        delay_us(30);
        Byte >>= 1;    
    }    
}

unsigned char OneWireReadByte() {
    unsigned char Byte = 0;    
    for (i = 0; i < 8; i++) {
        OneWire_Master;
        OneWire_Master_Low;
        delay_us(15);
        OneWire_Free;
        delay_us(15); 
        Byte >>= 1;
        Byte |= (OneWire_State<<7);
        delay_us(30);   
    } 
    return Byte;
}

unsigned int readTemp(void) {
    unsigned char data[2];
    if (!OneWireReset()) {
        OneWireWriteByte(0xCC);      // skip rom
        OneWireWriteByte(0x44);      // Initiates temperature conversion
        OneWire_Free;
        delay_ms(750);              // Temperature conversion takes up to 750 ms
        data[0] = OneWireReset();
        OneWireWriteByte(0xCC);
        OneWireWriteByte(0xBE);      // Reads bytes from scratchpad and reads CRC byte.
        data[0] = OneWireReadByte();
        data[1] = OneWireReadByte(); 
        return (data[0] + data[1]*256)*0.0625;  // resolution 0.0625   
    }
    return 0;
}





/*------------------------------------MENU------------------------------------------*/
typedef struct MENU{
    struct MENU* preMenu;
    char mainTitle[20];
    int id; // save preSelectRow to back correctly
    char subTitle1[20]; 
    struct MENU* nextMenu1;
    char subTitle2[20];  
    struct MENU* nextMenu2;
    char subTitle3[20];   
    struct MENU* nextMenu3;
    int device;             
    void (*funcCtrl) (char, char);
} MENU;

/*-------------------------declare MENUs-----------------------------------------------*/
MENU MainMenu, SensorMenu, ActuatorMenu, SetMenu, TempMenu, HumiMenu, RelayMenu, MotorMenu, LedMenu, Motor1Menu, Motor2Menu, SingLedMenu, SevenSegLedMenu;

/*------------------------define name devices--------------------------------------------*/
#define led 21
#define led7seg 22
#define relay 23
#define motor1 24
#define motor2 25
#define ds18b20 26

void showMenu(MENU* yourMenu, int selectRow) {
    Print(yourMenu->mainTitle, 0, 6);
    Print(yourMenu->subTitle1, 1, 0);
    Print(yourMenu->subTitle2, 2, 0);
    Print(yourMenu->subTitle3, 3, 0);
    Print(">", selectRow, 0);   
}

void ctrlDevice(char device, char mode) {
    if (device == led) {
        switch(mode) {
            case 1: 
                displayLEDs(0x55555555);    // interleave 
                break;
            case 2:                       
                for (i = 0; i < 32; i++) {  // 1 led on rtl   
                    modeLED = (unsigned long)1 << i;
                    displayLEDs(modeLED);           
                }
                break;
            case 3: // off
                displayLEDs(0); 
                break;
        }    
    }
    else if (device == led7seg) {
        switch(mode) {
            case 1: 
                displayLED7Seg(2112);   // LEDs 7seg use direct connection method  
                break;
            case 2:                       
                offLED7Seg();
                break;
        }    
    }
    else if (device == relay) {
        switch(mode) {
            case 1: 
                ctrlRelays.allRelays = 0xFF;    // on 
                break;
            case 2:                       
                ctrlRelays.allRelays = 0;       // off
                break; 
            case 3:                             // off gradually   
                ctrlRelays.eachRelay.RL7 = 0; 
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL6 = 0;
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL5 = 0;
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL4 = 0;
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL3 = 0;
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL2 = 0;
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL1 = 0;
                RELAY_ACTIVATION;
                delay_ms(500);
                ctrlRelays.eachRelay.RL0 = 0;
                break;
        }  
        RELAY_ACTIVATION;  
    }
    else if (device == motor1) {
        switch(mode) {
            case 1: 
                ctrlMotors.DC1 = RotateForward; 
                break;
            case 2:                       
                ctrlMotors.DC1 = RotateBackward; 
                break;
            case 3: 
                ctrlMotors.DC1 = StopRotate; 
                break;
        }
        MOTOR_ACTIVATION;    
    }
    else if (device == motor2) {
        switch(mode) {
            case 1: 
                ctrlMotors.DC2 = RotateForward; 
                break;
            case 2:                       
                ctrlMotors.DC2 = RotateBackward; 
                break;
            case 3: 
                ctrlMotors.DC2 = StopRotate; 
                break;
        }
        MOTOR_ACTIVATION;    
    }
    else if (device == ds18b20) {
        switch(mode) {
            case 1: 
                displayLED7Seg(readTemp());   // LEDs 7seg use direct connection method  
                break;
            case 2:                       
                offLED7Seg();
                break; 
        }    
    }      
} 



/*--------------------------define MENUs-----------------------------------*/
MENU MainMenu = {
    NULL,
    "MAIN MENU",
    NULL,
    "  Sensors",
    &SensorMenu,
    "  Actuators", 
    &ActuatorMenu,
    "  Settings",
    &SetMenu,
    NULL,
    NULL
};


MENU SensorMenu = {
    &MainMenu,
    "SENSORS",
    1,  
    "  Temperature",
    &TempMenu,
    "  Humidity",
    &HumiMenu,
    "  None",
    NULL,
    NULL,
    NULL
};

MENU TempMenu = {
    &SensorMenu,
    "TEMPERATURE", 
    1, 
    "  ON",
    NULL,
    "  OFF",
    NULL,
    "  None",
    NULL,
    ds18b20,
    &ctrlDevice,
};

MENU HumiMenu = {
    &SensorMenu,
    "HUMIDITY",   
    2, 
    "  None",
    NULL,
    "  None",
    NULL,
    "  None",
    NULL,
    NULL,
    NULL
};


MENU ActuatorMenu = {
    &MainMenu,
    "ACTUATORS",  
    2,
    "  Leds",
    &LedMenu,
    "  Relays",
    &RelayMenu,
    "  Motors",
    &MotorMenu,
    NULL,
    NULL
};

MENU LedMenu = {
    &ActuatorMenu,
    "LEDS",  
    1, 
    "  Single Led",
    &SingLedMenu,
    "  7-Seg Led",
    &SevenSegLedMenu,
    "  None",
    NULL,
    NULL,
    NULL
};
MENU SingLedMenu = {
    &LedMenu,
    "SINGLE LEDS", 
    1, 
    "  INTERLEAVE",
    NULL,
    "  RUN",
    NULL,
    "  OFF",
    NULL,
    led,
    &ctrlDevice,
};
MENU SevenSegLedMenu = {
    &LedMenu,
    "7-SEG LEDS",
    2, 
    "  ON",
    NULL,
    "  OFF",
    NULL,
    "  None",
    NULL,
    led7seg,
    &ctrlDevice,
};

MENU RelayMenu = {
    &ActuatorMenu,
    "RELAYS",  
    2, 
    "  ON",
    NULL,
    "  OFF",
    NULL,
    "  OFF GRADUALLY",
    NULL,
    relay,
    &ctrlDevice,
};

MENU MotorMenu = {
    &ActuatorMenu,
    "MOTORS",
    3, 
    "  Motor1",
    &Motor1Menu,
    "  Motor2",
    &Motor2Menu,
    "  None",
    NULL,
    NULL,
    NULL
};
MENU Motor1Menu = {
    &MotorMenu,
    "MOTOR 01",
    1, 
    "  Forward",
    NULL,
    "  Backward",
    NULL,
    "  Stop",
    NULL,
    motor1,
    &ctrlDevice,
};
MENU Motor2Menu = {
    &MotorMenu,
    "MOTOR 02",
    2, 
    "  Forward",
    NULL,
    "  Backward",
    NULL,
    "  Stop",
    NULL,
    motor2,
    &ctrlDevice,
};


MENU SetMenu = {
    &MainMenu,
    "SETTINGS",
    3,
    "  None",
    NULL,
    "  None",
    NULL,
    "  None",
    NULL,
    NULL,
    NULL
};