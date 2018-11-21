// --------------------------------------------------------------------
// Copyright (c) 2010 by Terasic Technologies Inc.
// --------------------------------------------------------------------
//
// Permission:
//
//   Terasic grants permission to use and modify this code for use
//   in synthesis for all Terasic Development Boards and Altera Development
//   Kits made by Terasic.  Other use of this code, including the selling
//   ,duplication, or modification of any portion is strictly prohibited.
//
// Disclaimer:
//
//   This VHDL/Verilog or C/C++ source code is intended as a design reference
//   which illustrates how these types of functions can be implemented.
//   It is the user's responsibility to verify their design for
//   consistency and functionality through the use of formal
//   verification methods.  Terasic provides no warranty regarding the use
//   or functionality of this code.
//
// --------------------------------------------------------------------
//
//                     Terasic Technologies Inc
//                     356 Fu-Shin E. Rd Sec. 1. JhuBei City,
//                     HsinChu County, Taiwan
//                     302
//
//                     web: http://www.terasic.com/
//                     email: support@terasic.com
//
// --------------------------------------------------------------------

#include <stdio.h>
#include "terasic_includes.h"
#include "FatFileSystem.h"
#include "system.h"
#include "alt_types.h"


bool Fat_Test(FAT_HANDLE hFat, char *pDumpFile){
    bool bSuccess;
    int nCount = 0;
    FAT_BROWSE_HANDLE hBrowse;
    FILE_CONTEXT FileContext;

    bSuccess = Fat_FileBrowseBegin(hFat, &hBrowse);
    if (bSuccess){
        while(Fat_FileBrowseNext(&hBrowse, &FileContext)){
            if (FileContext.bLongFilename){
                alt_u16 *pData16;
                alt_u8 *pData8;
                pData16 = (alt_u16 *)FileContext.szName;
                pData8 = FileContext.szName;
                printf("[%d]", nCount);
                while(*pData16){
                    if (*pData8)
                        printf("%c", *pData8);
                    pData8++;
                    if (*pData8)
                        printf("%c", *pData8);
                    pData8++;
                    //
                    pData16++;
                }
                printf("\n");
            }else{
                printf("[%d]%s\n", nCount, FileContext.szName);
            }
            nCount++;
        }
    }
    if (bSuccess && pDumpFile && strlen(pDumpFile)){
        FAT_FILE_HANDLE hFile;
        hFile =  Fat_FileOpen(hFat, pDumpFile);
        if (hFile){
            char szRead[256];
            int nReadSize, nFileSize, nTotalReadSize=0;
            nFileSize = Fat_FileSize(hFile);
            if (nReadSize > sizeof(szRead))
                nReadSize = sizeof(szRead);
            printf("%s dump:\n", pDumpFile);
            while(bSuccess && nTotalReadSize < nFileSize){
                nReadSize = sizeof(szRead);
                if (nReadSize > (nFileSize - nTotalReadSize))
                    nReadSize = (nFileSize - nTotalReadSize);
                //
                if (Fat_FileRead(hFile, szRead, nReadSize)){
                    int i;
                    for(i=0;i<nReadSize;i++){
                        printf("%c", szRead[i]);
                    }
                    nTotalReadSize += nReadSize;
                }else{
                    bSuccess = FALSE;
                    printf("\nFaied to read the file \"%s\"\n", pDumpFile);
                }
            } // while
            if (bSuccess)
                printf("\n");
            Fat_FileClose(hFile);
        }else{
            bSuccess = FALSE;
            printf("Cannot find the file \"%s\"\n", pDumpFile);
        }
    }

    return bSuccess;
}

int main()
{
    const alt_u32 LED_TEST_PATTERN = 0x00;
    const alt_u32 LED_NG_PATTERN = 0x1F;
    const alt_u32 LED_PASS_PATTERN = 0x3E0;
    FAT_HANDLE hFat;
    bool bSuccess;
    int i;
    printf("========== DE0-CV SDCARD Demo ==========\n");
    printf("please ensure the sd card has been inserted into de0-cv board\n");
    while(1)
    {
        printf("Processing...\r\n");
        IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, LED_TEST_PATTERN);
        bSuccess = SDLIB_Init();
       	    for(i=0;i<5 && !bSuccess;i++){ // try 3 time at max
       	        bSuccess = SDLIB_Init();
       	    }
        hFat = Fat_Mount(FAT_SD_CARD, 0);
        if (hFat){
            printf("sdcard mount success!\n");
            printf("Root Directory Item Count:%d\n", Fat_FileCount(hFat));
            Fat_Test(hFat, "test.txt");
            Fat_Unmount(hFat);
            IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, LED_PASS_PATTERN);
            printf("===== Test Done =====\r\nPress KEY3 to test again.\r\n");
        }else{
            printf("Failed to mount the SDCARD!\r\nPlease insert the SDCARD into DE0-CV board and press KEY3.\r\n");
            IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, LED_NG_PATTERN);
        }
        // wait users to press BUTTON3
        while ((IORD_ALTERA_AVALON_PIO_DATA(KEY_BASE) & 0x08) == 0x08);
        IOWR_ALTERA_AVALON_PIO_DATA(LEDR_BASE, LED_TEST_PATTERN);
        usleep(400*1000); // debounce
    } // while

  return 0;
}
