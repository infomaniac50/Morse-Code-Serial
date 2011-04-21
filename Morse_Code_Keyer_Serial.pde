/*
  Morse Code Generator
  
  Generates morse code from serial input or from EEPROM
  
  Serial Commands:
  Save string to EEPROM: w<string>
  Play string from EEPROM: r
  Play string from Serial: m<string>
  
  Note: This generator only accepts characters [A-Z0-9]
  and is case sensitive.  
  
  By Derek Chafin
  11-26-2010    
*/

#include <EEPROM.h>
#include "codetable.h"

//constants won't change. They're used here to 
//set pin numbers:
//pin number of speaker
const int speakerPin = 8;
//pin number of speed adjuster
const int sensorPin = A10;
//pin number of connected button
const int buttonPin = 2;
//length of long beep
const int longbeep = 300;
//length of short beep
const int shortbeep = 100;
//delay between beeps
const int beepdelay = 100;
//smallest delay adjustment percent
const int minsensor = 10;
//beep frequency
const int freq = 440;

// variables will change:
//stores the pot value
int sensorValue;
//stores the multiplier value
float multiplier;

void setup() {
  //wait to start serial in case we are uploading
  delay(1000);
  
  //initialize the pushbutton pin as an input
  pinMode(buttonPin,INPUT);
  //initialize the pot pin as an input
  pinMode(sensorPin,INPUT);
  
  //start a serial 
  Serial.begin(9600);
}

void loop(){
  sensorValue = analogRead(sensorPin);
  multiplier = (float)map(sensorValue,0,1023,minsensor,100) / 100.0F;
  
  if(digitalRead(buttonPin) == HIGH)
  {
    loadcode();
    delay(1000);
  }
  

  if (Serial.available() > 0)
  {
    Serial.print("Mulitplier: ");
    Serial.println(multiplier);
    char command = Serial.read();
    Serial.print("Command: ");
    Serial.println(command);
    switch(command)
    {
    case 'w':
      savecode();
      break;
    case 'r':
      loadcode();
      break;
    case 'm':
      playcodes();
      break;  
    default:
      printhelp();
      break;  
    }
  }
}

int adjustdelay(int d)
{
  return (int)((float)d * multiplier);
}

void printhelp()
{
  Serial.println("Command Help");
  Serial.println("Save Code: w");
  Serial.println("Load Code: r");
  Serial.println("Play String: m");
}

void loadcode()
{
  int i = 0;
  while(i < 100)
  {
    char letter = EEPROM.read(i);
    if (letter != 0)
    {
      int* code = getcode(letter);
      playcode(code);
    }
    else
    {
      break;
    }
    i++;
  } 
}

void savecode()
{

  if (Serial.available() <= 0)
  {
    return;
  }

  //write the program
  int i = 0;  
  while(i < 100)
  {
    if(Serial.available() > 0)
    {
      EEPROM.write(i,Serial.read());
    }
    else
    {
      EEPROM.write(i,0);  
    }
    Serial.print("address: ");
    Serial.println(i);
    i++;
  }
  Serial.println("DONE");
}

void playcodes()
{
  while(Serial.available() > 0)
  {
    int* code = getcode(Serial.read());
    playcode(code);
  } 
}

void playcode(int* code)
{
  for(int i = 0;i < 5;i++)
  {
    playbeep(code[i]); 
    delay(adjustdelay(beepdelay)); 
  }
}
int* getcode(char code)
{
  switch (code)
  {
  case 'A':
    return A_CODE;    
  case 'B':
    return B_CODE;    
  case 'C':
    return C_CODE;    
  case 'D':
    return D_CODE;    
  case 'E':
    return E_CODE;    
  case 'F':
    return F_CODE;    
  case 'G':
    return G_CODE;    
  case 'H':
    return H_CODE;    
  case 'I':
    return I_CODE;    
  case 'J':
    return J_CODE;    
  case 'K':
    return K_CODE;    
  case 'L':
    return L_CODE;    
  case 'M':
    return M_CODE;    
  case 'N':
    return N_CODE;    
  case 'O':
    return O_CODE;    
  case 'P':
    return P_CODE;    
  case 'Q':
    return Q_CODE;    
  case 'R':
    return R_CODE;    
  case 'S':
    return S_CODE;    
  case 'T':
    return T_CODE;    
  case 'U':
    return U_CODE;    
  case 'V':
    return V_CODE;    
  case 'W':
    return W_CODE;    
  case 'X':
    return X_CODE;    
  case 'Y':
    return Y_CODE;    
  case 'Z':
    return Z_CODE;    
  case '1':
    return ONE_CODE;    
  case '2':
    return TWO_CODE;    
  case '3':
    return THREE_CODE;    
  case '4':
    return FOUR_CODE;    
  case '5':
    return FIVE_CODE;    
  case '6':
    return SIX_CODE;    
  case '7':
    return SEVEN_CODE;    
  case '8':
    return EIGHT_CODE;    
  case '9':
    return NINE_CODE;
  case '0':
    return ZERO_CODE;
  default:
    Serial.println("Invalid Code: " + (int)code);
    return NOP_CODE;
  }
}

void playbeep(int beeptype)
{  
  switch (beeptype)
  {
  case 1:    
    tone(speakerPin,freq);
    delay(adjustdelay(shortbeep));
    noTone(speakerPin);
    break;
  case 2:
    tone(speakerPin,freq);
    delay(adjustdelay(longbeep));
    noTone(speakerPin);
    break;
  default:
    break;
  } 
}


















