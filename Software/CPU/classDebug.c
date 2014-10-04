 // Copyright (c) 2014 Ricardo Acevedo

 // Permission is hereby granted, free of charge, to any person
 // obtaining a copy of this software and associated documentation
 // files (the "Software"), to deal in the Software without
 // restriction, including without limitation the rights to use,
 // copy, modify, merge, publish, distribute, sublicense, and/or sell
 // copies of the Software, and to permit persons to whom the
 // Software is furnished to do so, subject to the following
 // conditions:

 // The above copyright notice and this permission notice shall be
 // included in all copies or substantial portions of the Software.

 // THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 // EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
 // OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 // NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
 // HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 // WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
 // FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 // OTHER DEALINGS IN THE SOFTWARE.


// ---File Name: classDebug.c---
// ---Date: May. 1, 2014
// ---Description:
// --- Debugging application for HW classifier
// ---Associated Files:
// 
// ---Author : Ricardo Acevedo

#include <stdio.h>
#include <stdlib.h>
#include <memory.h>
#include <time.h>
#include "PCIE.h"


#define DEMO_PCIE_USER_BAR			PCIE_BAR0
#define DEMO_PCIE_IO_BUTTON_ADDR	0x20

#define CTRLTEST_ADDR				0x48

#define READ_MODE 					0xFFFFFFFF //read-only mode
#define WRITE_MODE					0
#define FRAME_SIZE 					76800 //320 x 240 img size



typedef enum{
	MENU_CT1 = 0,
	MENU_CT2,
	MENU_BUTTON,
	MENU_READ_CLASS,
	MENU_QUIT = 98
}MENU_ID;

int power(int base, int exp) {
    if (exp == 0)
        return 1;
    else if (exp % 2)
        return base * power(base, exp - 1);
    else {
        int temp = power(base, exp / 2);
        return temp * temp;
    }
}

int getData(FILE* fp){
    char line[6];
    int wordValue;
    char ch = getc(fp);
    int j = 0;
    
    if(ch != EOF)
    {
        while(ch != '\n')
        {
            line[j++] = ch;
            ch = getc(fp); 
        }
            line[j] = '\0';
            j = 0;
            //convert string to integer:                
            wordValue = 0;
            int k;
            for (k = 0; line[k] != '\0'; k++) 
            {
               wordValue = wordValue * 10 + line[k] - '0';
            }
            
            return wordValue;

               
    }else{
       printf("Reached end of file. \n"); 
       return -1;
    }    
    
}

FILE *openFile(char fN[], int fileIndex, char fE[], char *mode){
	char fName[11];
	char fExt[5]; 
	char fNumber[7];
	//copy arguments to destiny strings:
	strcpy(fName, fN);
	strcpy(fExt, fE);
	//compose file name:
	sprintf(fNumber, "%d", fileIndex);
	strcat(fNumber, fExt);
	strcat(fName, fNumber);
	
    printf("Opening file: %s", fName);
	printf(" in mode: %s\n", mode);
	
    FILE *fp = fopen(fName, mode);
	//return pointer to file:
	return fp;

}

void putData(FILE* fp, int wordValue){
    
	int i;
	int wordDigit;
	int wordChar;	
	for(i = 2; i >= 0; i--) //3 decimals (bits) per word (255 max)
	{	  
	  wordDigit = ( wordValue / power(10,i) ) %10;
	  wordChar = (int)( wordDigit + '0' );	  
	  putc(wordChar, fp);
	}
	putc((int)('\n'), fp); //add new line (int) char
	printf("Wrote word: %d", wordValue);
	printf(" to file.\n");  
  
}

BOOL writePixel(PCIE_HANDLE hPCIe, int wordValue){
	BOOL bPass;
	
	//set mode:
	printf("Mode is 'write': %d\n", WRITE_MODE);	
	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,(DWORD)WRITE_MODE);
	
	if (!bPass){ 
		printf("Mode write failed, no idea why... Data was:=%xh\r\n", WRITE_MODE);
		return bPass;
	}	
	
	//set word:
	printf("Write word, value is %d\n", wordValue);
	bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,(DWORD)wordValue);
	
	if (bPass)
		printf("Write success. Data was:=%xh\r\n", wordValue);
	else
		printf("Write to controller failed, Data was:=%xh\r\n", wordValue);
		
	return bPass;
}

BOOL readPixel(PCIE_HANDLE hPCIe, DWORD readBuffer){
	BOOL bPass;
	printf("Reading Data...\n");
	bPass = PCIE_Read32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,&readBuffer);
	if (!bPass){
		printf("Failed to read data value:=%xh\r\n", readBuffer);
		return bPass;
	}
	printf("Data value is:=%xh\r\n", readBuffer);
	return bPass;
}

void UI_ShowMenu(void){
	printf("==============================\r\n");
	printf("[%d]: Classsifier R-O Test\r\n", MENU_CT1);
	printf("[%d]: Classsifier Auto Wr Test\r\n", MENU_CT2);
	printf("[%d]: Classsifier Class Read\r\n", MENU_READ_CLASS);
	printf("[%d]: Button Status Read\r\n", MENU_BUTTON);
	
	printf("[%d]: Quit\r\n", MENU_QUIT);
	printf("Please input your selection:");
}

int UI_UserSelect(void){
	int nSel;
	scanf("%d",&nSel);
	return nSel;
}

BOOL READ_MEM(PCIE_HANDLE hPCIe){
	BOOL bPass;
	int	Mask;
	int i;
	int j;
	DWORD readBuffer;
	
	printf("Input RAM address (hex):");		
	scanf("%d", &Mask);		
	
	for	(j = 0; j < 3; j++){
	
		//write mode:
		printf("Mode is 'read-only': %d\n", READ_MODE);
		bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,(DWORD)READ_MODE);
		
		if (!bPass) 
			printf("Mode write failed, no idea why... Data was:=%xh\r\n", READ_MODE);
		else{		
			// write target memory:
			bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,(DWORD)j);
			if (!bPass)
				printf("Target memory selection failed, Data was:=%xh\r\n", j);
			else{
				//write address:
				bPass = PCIE_Write32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,(DWORD)Mask);		
				if (!bPass)
					printf("Write address to controller failed, Data was:=%xh\r\n", Mask);		
				else{
					printf("Hold on...\r\n");		
					for(i = 0; i < 100000000; i++)
					{
						//Safe wait... ???
					}						
					printf("Fetching data...\r\n");				
					bPass = PCIE_Read32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,&readBuffer);
					if (bPass){
						switch(j){
							case 0:
								printf("--> 0. Max/stdDev sez: %xh\r\n", readBuffer);
								break;
							case 1:
								printf("--> 1. Min sez: %xh\r\n", readBuffer);
								break;
							case 2:
								printf("--> 2. Sum sez: %xh\r\n", readBuffer);
								printf("--- 2. Shifted: %xh\r\n", (readBuffer<<1) );
								break;
							default:
								printf("Selection not valid!\n");
						}								
					}else
						printf("Failed to read data value:=%xh\r\n", readBuffer);
				}
					
			}
			
		}
	
	}
	return bPass;
}

BOOL READ_CLASS(PCIE_HANDLE hPCIe){
	BOOL bPass;
	
	int writeCount = 1;
	int pixelCount = 0;
	
	int frameStart;		
	printf("Enter frame start:");		
	scanf("%d", &frameStart);	
    
	int frameEnd;
	printf("Enter frame end:");		
	scanf("%d", &frameEnd);	
	
	//Ready sink file:
	FILE *fpWrite = openFile("outD",writeCount,".dat","a");
	
	if (fpWrite == NULL)    
	{
		perror("Error while opening file (write)\n");
		return 1;
	} 	
	
	//Read a file and send each line as a pixel:
	int i; 
    for (i = frameStart ; i < frameEnd + 1 ; i++)    
    {  
		//open file:
		FILE *fpRead = openFile("data",i,".dat","r");
		if (fpRead == NULL)    
		{
			perror("Error while opening file!\n");
			return 1;
		} 
		
		//get pixel from file:
		int wordValue = getData(fpRead);
		int count = 0;
		
		while (wordValue != -1)
		{	
			//send pixel to FPGA:
			bPass = writePixel(hPCIe, wordValue);
			//get new pixel from file:
			wordValue = getData(fpRead);
			//some debug info:
			count = count + 1;
			printf("%d", count);
            printf("%s", " ");
            printf("%d", wordValue);
			printf("%s", " ");
			printf("%d\n", i);
			
			//request pixel data:
			printf("Requesting pixel data...\n");
			DWORD readBuffer;
			bPass = PCIE_Read32(hPCIe, DEMO_PCIE_USER_BAR, CTRLTEST_ADDR,&readBuffer);
			if (!bPass){
				printf("Failed to read data value:=%xh\r\n", readBuffer);
				return bPass;
			}
			
			int newData = (readBuffer >> 31) & 0x01; //last bit from word
			
			//check new data from FPGA:
			if (newData == 1)
			{				
				printf("New data found.\n");
				printf("Word is: %xh\r\n", readBuffer);
				int z;
				for(z = 0 ; z < 3 ; z++)
				{	
					pixelCount = pixelCount + 1;
					//get 3 pixels:
					int pixelData = ( readBuffer >> (8*z) ) & 0xff;
					printf("Writing Pixel %d", z + 1);
					printf("%s", " ");
					printf("value: %xh\r\n", pixelData);
					//write pixels to file:
					putData(fpWrite, pixelData);	
					printf("Wrote pixel: %d\r\n", pixelCount);						
				}
				//check if reached max frame size
				if (pixelCount == 76800)
				{
					//close file:
					pixelCount = 0;					
					fclose(fpWrite);  
					printf("Closed write file.\n");
					
					//open new sink file:
					printf("Request new write file.\n");						
					writeCount = writeCount + 1;
					fpWrite = openFile("outD",writeCount,".dat","a");
					if (fpWrite == NULL)    
					{
						perror("Error while opening file (write)\n");
						return 1;
					}											
				}
			}			
			
		}
		printf("Closing file. %d\n", i); 
		fclose(fpRead);
    } 	
	
	return bPass;		
}

BOOL AUTO_WRITE(PCIE_HANDLE hPCIe){
	BOOL bPass;
	
	int frameStart, frameEnd;
	
	printf("Enter frame start:");		
	scanf("%d", &frameStart);	
    
	printf("Enter frame end:");		
	scanf("%d", &frameEnd);	
    
	//Read a file and send each line as a pixel:
	int i; 
    for (i = frameStart ; i < frameEnd + 1 ; i++)    
    {  
		//open file:
		FILE *fpRead = openFile("data",i,".dat","r");
	
		if (fpRead == NULL)    
		{
			perror("Error while opening file!\n");
			return 1;
		} 
		//get pixel from file:
		int wordValue = getData(fpRead);
		int count = 0;
		while (wordValue != -1)
		{	
			//send pixel to FPGA:
			bPass = writePixel(hPCIe, wordValue);
			//get new pixel from file:
			wordValue = getData(fpRead);
			//some debug info:
			count = count + 1;
			printf("%d", count);
            printf("%s", " ");
            printf("%d", wordValue);
			printf("%s", " ");
			printf("%d\n", i);
		};
		printf("Closing file. %d\n", i); 
		fclose(fpRead);
    } 
	
	return bPass;
}

BOOL TEST_BUTTON(PCIE_HANDLE hPCIe){
	BOOL bPass = TRUE;
	DWORD Status;

	bPass = PCIE_Read32(hPCIe, DEMO_PCIE_USER_BAR, DEMO_PCIE_IO_BUTTON_ADDR,&Status);
	if (bPass)
		printf("Button status mask:=%xh\r\n", Status);
	else
		printf("Failed to read button status\r\n");

	
	return bPass;
}


int main(void)
{
	void *lib_handle;
	PCIE_HANDLE hPCIE;
	BOOL bQuit = FALSE;
	int nSel;

	printf("== Classifier Peripheral Test ==\r\n");
	printf("== ver: 24.06.2014 ==\r\n");
	
	lib_handle = PCIE_Load();
	if (!lib_handle){
		printf("PCIE_Load failed!\r\n");
		return 0;
	}

	hPCIE = PCIE_Open(0,0,0);
	if (!hPCIE){
		printf("PCIE_Open failed\r\n");
	}else{
		while(!bQuit){
			UI_ShowMenu();
			nSel = UI_UserSelect();
			switch(nSel){	
				case MENU_CT1:
					READ_MEM(hPCIE);
					break;
				case MENU_CT2:
					AUTO_WRITE(hPCIE);
					break;
				case MENU_BUTTON:
					TEST_BUTTON(hPCIE);					
					break;
				case MENU_READ_CLASS:
					READ_CLASS(hPCIE);
					break;
				case MENU_QUIT:
					bQuit = TRUE;
					printf("Bye from classDebug app!\r\n");
					break;
				default:
					printf("Invalid selection\r\n");
			} // switch

		}// while

		PCIE_Close(hPCIE);

	}


	PCIE_Unload(lib_handle);
	return 0;
}
