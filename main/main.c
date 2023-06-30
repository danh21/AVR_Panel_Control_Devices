/*
 * main.c
 *
 * Created: 8/26/2022 9:58:33 PM
 * Author: DELL
 */
 
#include <io.h>
#include <delay.h>
#include "userdef.h"



MENU* pmenu;
int selectRow = 1;
int temp;



void main(void)
{
    MCUCR |= 0x80;      // writing SRE to one enables the External Memory Interface          
    XMCRA = 0;          // External Memory Control Register A
    
    /*-------------------Initial LED 7SEG--------------------------*/
    offLED7Seg();                        
        
    /*-------------------Initial Motors--------------------------------*/ 
    ctrlMotors.DC1 = StopRotate; 
    ctrlMotors.DC2 = StopRotate; 
    MOTOR_ACTIVATION;      
    
    /*--------------------Initial LCD-----------------------------------*/
    DDRG |= (1<<3);     // output LCD enable
    LCD_INIT(); 
    
    /*----------------Initial Main Menu on LCD-----------------------------*/    
    pmenu = &MainMenu;
    showMenu(pmenu, selectRow);            
    
    /*----------------Initial DS18B20-----------------------------*/ 
    /*if (!OneWireReset()) {        // test -> 0040 
        OneWireWriteByte(0x33);
        displayLED7Seg(OneWireReadByte());   
    }*/
              
        
    while (1) 
    {                     
        /*-------------------Control motors by btns --------------------*/ 
        /* READ_KEY;
        if (!ctrlBtns.STOP) {      
            while (!ctrlBtns.STOP)      // debounce button
                READ_KEY;    
            ctrlMotors.DC1 = StopRotate;
            ctrlMotors.DC2 = StopRotate;    
        }
        else if (!ctrlBtns.FORWARD) {
            while (!ctrlBtns.FORWARD)
                READ_KEY;   
            ctrlMotors.DC1 = RotateForward;
            ctrlMotors.DC2 = RotateForward;
        } 
        else if (!ctrlBtns.BACKWARD) { 
            while (!ctrlBtns.BACKWARD)
                READ_KEY;
            ctrlMotors.DC1 = RotateBackward;
            ctrlMotors.DC2 = RotateBackward;
        }
        MOTOR_ACTIVATION; */
                         
        /*---------------------Control devices by Menu on LCD----------------------*/
        READ_KEY;
        if (!ctrlBtns.UP) {
            while (!ctrlBtns.UP)
                READ_KEY; 
            selectRow = (selectRow == 1) ? 3 : (selectRow - 1);     
            showMenu(pmenu, selectRow);
        }
        else if (!ctrlBtns.DOWN) {
            while (!ctrlBtns.DOWN)
                READ_KEY;    
            selectRow = (selectRow == 3) ? 1 : (selectRow + 1);     
            showMenu(pmenu, selectRow);
        }
        else if (!ctrlBtns.NEXT) {
            while (!ctrlBtns.NEXT)
                READ_KEY; 
            switch(selectRow) {
                case 1: 
                    if (pmenu->nextMenu1 != NULL) {
                        LCD_CLEAR(); 
                        pmenu = pmenu->nextMenu1;
                        selectRow = 1;  
                        showMenu(pmenu, selectRow);
                    }                                                  
                    break;
                case 2:   
                    if (pmenu->nextMenu2 != NULL) {
                        LCD_CLEAR();
                        pmenu = pmenu->nextMenu2;
                        selectRow = 1;
                        showMenu(pmenu, selectRow); 
                    }                          
                        
                    break;
                case 3:
                    if (pmenu->nextMenu3 != NULL) {
                        LCD_CLEAR();
                        pmenu = pmenu->nextMenu3; 
                        selectRow = 1;
                        showMenu(pmenu, selectRow); 
                    }                                     
                    break;
            }            
        } 
        else if (!ctrlBtns.BACK) {
            while (!ctrlBtns.BACK)
                READ_KEY;   
            if (pmenu->preMenu != NULL) {
                LCD_CLEAR(); 
                selectRow = pmenu->id; 
                pmenu = pmenu->preMenu;             
                showMenu(pmenu, selectRow);          
            }              
        } 
        else if (!ctrlBtns.ENTER) {
            while (!ctrlBtns.ENTER)
                READ_KEY;   
            if (pmenu->funcCtrl != NULL) {
                pmenu->funcCtrl(pmenu->device, selectRow);             
            }              
        }
    }
}
