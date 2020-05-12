/************************************************************************
Lab 9 Nios Software

Dong Kai Wang, Fall 2017
Christine Chen, Fall 2013

For use with ECE 385 Experiment 9
University of Illinois ECE Department
************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include "aes.h"

// Pointer to base address of AES module, make sure it matches Qsys
volatile unsigned int * AES_PTR = (unsigned int *) 0x00000100;

// Execution mode: 0 for testing, 1 for benchmarking
int run_mode = 0;

/** charToHex
 *  Convert a single character to the 4-bit value it represents.
 *  
 *  Input: a character c (e.g. 'A')
 *  Output: converted 4-bit value (e.g. 0xA)
 */
char charToHex(char c)
{
	char hex = c;

	if (hex >= '0' && hex <= '9')
		hex -= '0';
	else if (hex >= 'A' && hex <= 'F')
	{
		hex -= 'A';
		hex += 10;
	}
	else if (hex >= 'a' && hex <= 'f')
	{
		hex -= 'a';
		hex += 10;
	}
	return hex;
}

/** charsToHex
 *  Convert two characters to byte value it represents.
 *  Inputs must be 0-9, A-F, or a-f.
 *  
 *  Input: two characters c1 and c2 (e.g. 'A' and '7')
 *  Output: converted byte value (e.g. 0xA7)
 */
char charsToHex(char c1, char c2)
{
	char hex1 = charToHex(c1);
	char hex2 = charToHex(c2);
	return (hex1 << 4) + hex2;
}

/** KeyExpansion
 *  Takes the Cipher Key and performs a Key Expansion
 *  to generate a series of Round Keys (4-Word matrix) and
 *  store them into Key Schedule
 *
 *  Input: unsigned char* key, unsigned long* w, unsigned Nk
 */
void KeyExpansion(unsigned char* key, unsigned long* w, unsigned Nk){
	unsigned long temp;
	int i = 0;
	while (i < Nk){
		w[i] = (unsigned long)((key[4*i]<<24)+ (key[4*i+1]<<16)+(key[4*i+2]<<8)+(key[4*i+3]));
		i = i+1£»
	}
	i = Nk;
	while (i<4 * (10+1)){
		temp = w[i-1];
		if (i % Nk = 0){
			temp = SubWord(RotWord(&temp)) ^ Rcon[i/Nk];
		}
		w[i] = w[i-Nk] ^ temp;
		i = i+1;
	}
}

void AddRoundKey(unsigned char* state, unsigned long* w){
	int row = 0;
	int col = 0;
	for (; row<4;row++){
		for (;col<4;col++){
			state[row*4+col] = state[row*4+col] ^ (w[col]>>((3-row)*8));
		}
	}
}

/** SubByte
 *  Convert one byte into sbox form.
 *
 *  Input: pointer to the byte
 *
 */
void SubByte(unsigned char* byte)
{
	*byte = aes_sbox[(int)*byte];
}


/** SubBytes
 *  Convert 16 bytes into sbox form.
 *
 *  Input: pointer to state
 *
 */
void SubBytes(unsigned char* state)
{
	int i = 0;
	for (;i<16;i++){
		*(state+i) = aes_sbox[(int)state[i]];
	}
}

/** ShiftRows
 *  Each row in the updating State is shifted by some offsets
 *
 *  Input: pointer to state
 *
 */
void ShiftRows(unsigned char* state)
{
	unsigned char temp1;
	unsigned char temp2;

	// Second row
	temp1 = state[4];
	state[4] = state[5];
	state[5] = state[6];
	state[6] = state[7];
	state[7] = temp1;

	// Third row
	temp1 = state[8];
	temp2 = state[9];
	state[8] = state[10];
	state[9] = state[11];
	state[10] = temp1;
	state[11] = temp2;

	// Fourth row
	temp1 = state[12];
	state[12] = state[15];
	state[13] = temp1;
	state[14] = state[13];
	state[15] = state[14];
}


/** encrypt
 *  Perform AES encryption in software.
 *
 *  Input: msg_ascii - Pointer to 32x 8-bit char array that contains the input message in ASCII format
 *         key_ascii - Pointer to 32x 8-bit char array that contains the input key in ASCII format
 *  Output:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *               key - Pointer to 4x 32-bit int array that contains the input key
 */
void encrypt(unsigned char * msg_ascii, unsigned char * key_ascii, unsigned int * msg_enc, unsigned int * key)
{
	// Implement this function
}

/** decrypt
 *  Perform AES decryption in hardware.
 *
 *  Input:  msg_enc - Pointer to 4x 32-bit int array that contains the encrypted message
 *              key - Pointer to 4x 32-bit int array that contains the input key
 *  Output: msg_dec - Pointer to 4x 32-bit int array that contains the decrypted message
 */
void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
{
	// Implement this function
}

/** main
 *  Allows the user to enter the message, key, and select execution mode
 *
 */
int main()
{
	// Input Message and Key as 32x 8-bit ASCII Characters ([33] is for NULL terminator)
	unsigned char msg_ascii[33];
	unsigned char key_ascii[33];
	// Key, Encrypted Message, and Decrypted Message in 4x 32-bit Format to facilitate Read/Write to Hardware
	unsigned int key[4];
	unsigned int msg_enc[4];
	unsigned int msg_dec[4];

	printf("Select execution mode: 0 for testing, 1 for benchmarking: ");
	scanf("%d", &run_mode);

	if (run_mode == 0) {
		// Continuously Perform Encryption and Decryption
		while (1) {
			int i = 0;
			printf("\nEnter Message:\n");
			scanf("%s", msg_ascii);
			printf("\n");
			printf("\nEnter Key:\n");
			scanf("%s", key_ascii);
			printf("\n");
			encrypt(msg_ascii, key_ascii, msg_enc, key);
			printf("\nEncrpted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_enc[i]);
			}
			printf("\n");
			decrypt(msg_enc, msg_dec, key);
			printf("\nDecrypted message is: \n");
			for(i = 0; i < 4; i++){
				printf("%08x", msg_dec[i]);
			}
			printf("\n");
		}
	}
	else {
		// Run the Benchmark
		int i = 0;
		int size_KB = 2;
		// Choose a random Plaintext and Key
		for (i = 0; i < 32; i++) {
			msg_ascii[i] = 'a';
			key_ascii[i] = 'b';
		}
		// Run Encryption
		clock_t begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			encrypt(msg_ascii, key_ascii, msg_enc, key);
		clock_t end = clock();
		double time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		double speed = size_KB / time_spent;
		printf("Software Encryption Speed: %f KB/s \n", speed);
		// Run Decryption
		begin = clock();
		for (i = 0; i < size_KB * 64; i++)
			decrypt(msg_enc, msg_dec, key);
		end = clock();
		time_spent = (double)(end - begin) / CLOCKS_PER_SEC;
		speed = size_KB / time_spent;
		printf("Hardware Encryption Speed: %f KB/s \n", speed);
	}
	return 0;
}
