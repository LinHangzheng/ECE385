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

/** RotWord
 *  rotate the word
 *  Bytes ABCD -> BCDA
 *
 *  Input: address of word
 *  Output: the word after rotation
 */
unsigned long RotWord(unsigned long* word)
{
	return (((*word<<8) & 0xFFFFFFF0)|((*word>>24) & 0x000000FF));
}

/** SubWord
 *  Convert 16 bytes into sbox form.
 *
 *  Input: pointer to state
 *
 */
unsigned long SubWord(unsigned long word)
{
	unsigned char* temp = (unsigned char*)&word;
	unsigned char out[4];
	int i = 0;
	for (;i<4;i++){
		out[i] = aes_sbox[(int)temp[i]];
	}
	return *((unsigned long*)out);
}


/** KeyExpansion
 *  Takes the Cipher Key and performs a Key Expansion
 *  to generate a series of Round Keys (4-Word matrix) and
 *  store them into Key Schedule
 *
 *  Input: unsigned char* key, unsigned long* w, unsigned Nk
 */
void KeyExpansion(unsigned char* key, unsigned long* w, unsigned int Nk){
	unsigned long temp;
	unsigned int i = 0;
//	while (i < Nk){
//		w[i] = (unsigned long)((key[4*i]<<24)+ (key[4*i+1]<<16)+(key[4*i+2]<<8)+(key[4*i+3]));
//		i = i+1;
//	}
	while (i < Nk){
		w[i] = (unsigned long)((key[i]<<24)+ (key[i+4]<<16)+(key[i+8]<<8)+(key[i+12]));
		i = i+1;
	}
	i = Nk;
	while (i<4 * (10+1)){
		temp = w[i-1];
		if (i % Nk == 0){
			temp = SubWord(RotWord(&temp)) ^ Rcon[i/Nk];
		}
		w[i] = w[i-Nk] ^ temp;
		i = i+1;
	}
}



void AddRoundKey(unsigned char* state, unsigned long* w){
	int row;
	int col;
	for (row=0; row<4;row++){
		for (col=0;col<4;col++){
			state[row*4+col] = state[row*4+col] ^ ((w[col]>>((3-row)*8)) & 0xFF);
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
		state[i] = aes_sbox[(int)state[i]];
	}
}



void ShiftLeft (unsigned char* byte, int n)
{
	int i;
	unsigned char temp;
	for (i=0;i<n;i++){
		temp = byte[0];
		byte[0] = byte[1];
		byte[1] = byte[2];
		byte[2] = byte[3];
		byte[3] = temp;
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
	int row;
	for (row=0;row<4;row++){
		ShiftLeft(state+4*row,row);
	}
}



unsigned char xtime(unsigned char in)
{
	// bit-wise left shift then a conditional bit-wise
	// XOR with {1b} if the 8th bit before the shift is 1
	return (in & 0x80)? ((in<<1) ^ 0x1b): (in<<1);
}

void MixColumns(unsigned char* state)
{
	int i;
	int j;
	unsigned char b[4];
	unsigned char a[4];
	for (i=0;i<4;i++){
		// assign a1 to a4
		for (j=0;j<4;j++){
			a[j] = state[i+4*j];
		}

		b[0] = xtime(a[0]) ^ (xtime(a[1]) ^ a[1]) ^ a[2] ^ a[3];
		b[1] = a[0] ^ xtime(a[1]) ^ (xtime(a[2]) ^ a[2]) ^ a[3];
		b[2] = a[0] ^ a[1] ^ xtime(a[2]) ^ (xtime(a[3]) ^ a[3]);
		b[3] = (xtime(a[0]) ^ a[0]) ^ a[1] ^ a[2] ^ xtime(a[3]);
		for (j=0;j<4;j++){
			state[4*j+i] = b[j];
		}
	}
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
	int i,j,round;
	unsigned char state[4*4];
	unsigned char keyInit[4*4];
	unsigned long w[4*(10+1)];
	// assign the words for state and key
	for (i=0;i<16;i++){
		state[(i%4)*4 + i/4] = charsToHex(msg_ascii[2*i],msg_ascii[2*i+1]);
		keyInit[(i%4)*4 + i/4] = charsToHex(key_ascii[2*i],key_ascii[2*i+1]);
	}

	// create words by KeyExpansion
	KeyExpansion(keyInit,w,4);

	AddRoundKey(state,w);

	for (round=1; round<10;round++){
		SubBytes(state);
		ShiftRows(state);
		MixColumns(state);
		AddRoundKey(state,w+round*4);
	}
	// last round
	SubBytes(state);
	ShiftRows(state);
	AddRoundKey(state,w+10*4);

	// assign output
	for (i=0; i<4; i++){
		msg_enc[i]= state[i]<<24 | state[i+4]<<16 | state[i+8]<<8 | state[i+12];
		key [i] =keyInit[i]<<24 | keyInit[i+4]<<16 | keyInit[i+8]<<8 | keyInit[i+12];
	}
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
	int i;
	AES_PTR[14] = 0;
	AES_PTR[15] = 0;
	// set the AES_KEY and AES_MSG_EN
	for (i=0; i<4; i++){
		AES_PTR[i] = key[3-i];
		AES_PTR[i+4] = msg_enc[3-i];
	}

	// set the AES_START to 1
	AES_PTR[14] = 1;

	// wait for AES_DONE, this process will be
	// implemented by hardware in hdl.
	while (AES_PTR[15] == 0){
//		for (i=0;i<16;i++){
//			printf("%08x",AES_PTR[i]);
//		}
//		printf("\n");
	}

	// set the AES_MSG_DE
	for (i=0; i<4; i++){
		msg_dec[3-i] = AES_PTR[i+8];
	}

	// set the AES_START to 0
	AES_PTR[14] = 0;
	AES_PTR[15] = 0;

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


//void ShiftRight (unsigned char* byte, int n)
//{
//	int i;
//	unsigned char temp;
//	for (i=0;i<n;i++){
//		temp = byte[0];
//		byte[0] = byte[3];
//		byte[1] = temp;
//		byte[2] = byte[1];
//		byte[3] = byte[2];
//	}
//}


//void InvShiftRows(unsigned char* state)
//{
//	int row;
//	for (row=0;row<4;row++){
//		ShiftRight(state+4*row,row);
//	}
//}



//
//void InvMixColumns(unsigned char* state)
//{
//	// 0x02, 0x03, 0x09, 0x0b, 0x0d, 0x0e,
//	//    0,    1,    2,    3,    4,    5
//	int i;
//	int j;
//	unsigned char b[4];
//	unsigned char a[4];
//	for (i=0;i<4;i++){
//		// assign a1 to a4
//		for (j=0;j<4;j++){
//			a[j] = state[i+4*j];
//		}
//
//		b[0] = gf_mul[a[0]][5] ^ gf_mul[a[1]][3] ^ gf_mul[a[2]][4] ^ gf_mul[a[3]][2];
//		b[1] = gf_mul[a[0]][2] ^ gf_mul[a[1]][5] ^ gf_mul[a[2]][3] ^ gf_mul[a[3]][4];
//		b[2] = gf_mul[a[0]][4] ^ gf_mul[a[1]][2] ^ gf_mul[a[2]][5] ^ gf_mul[a[3]][3];
//		b[3] = gf_mul[a[0]][3] ^ gf_mul[a[1]][4] ^ gf_mul[a[2]][2] ^ gf_mul[a[3]][5];
//		for (j=0;j<4;j++){
//			state[4*j+i] = b[j];
//		}
//	}
//}
//
//void decrypt(unsigned int * msg_enc, unsigned int * msg_dec, unsigned int * key)
//{
//	// Implement this function
//	int i,round;
//	unsigned char state[4*4];
//	unsigned char keyInit[4*4];
//	unsigned long w[4*(10+1)];
//	// assign the words for state and key
//	for (i=0;i<4;i++){
//		state[i + 0]  = (msg_enc[i] & 0xFF000000) >> 24;
//		state[i + 4]  = (msg_enc[i] & 0x00FF0000) >> 16;
//		state[i + 8]  = (msg_enc[i] & 0x0000FF00) >> 8;
//		state[i + 12] = (msg_enc[i] & 0x000000FF) >> 0;
//
//		keyInit[i + 0]  = (key[i] & 0xFF000000) >> 24;
//		keyInit[i + 4]  = (key[i] & 0x00FF0000) >> 16;
//		keyInit[i + 8]  = (key[i] & 0x0000FF00) >> 8;
//		keyInit[i + 12] = (key[i] & 0x000000FF) >> 0;
//	}
//	KeyExpansion(keyInit,w,4);
//
//	AddRoundKey(state,w+10*4);
//	for (round = 9; round > 0; round--){
//		InvShiftRows(state);
//		InvSubBytes(state);
//		AddRoundKey(state,w+round*4);
//		InvMixColumns(state);
//	}
//	InvShiftRows(state);
//	InvSubBytes(state);
//	AddRoundKey(state,w);
//Encrypted Message
//daec3055df058e1c39e814ea76f6747e
//Key
//000102030405060708090a0b0c0d0e0f
//Key Expansion
//13111d7fe3944a17f307a78b4d2b30c5
//Decrypted Message
//ece298dcece298dcece298dcece298dc
//
//
//Encrypted Message
//439d619920ce415661019634f59fcf63
//Key
//3b280014beaac269d613a16bfdc2be03
//Key Expansion
//9915cfa2913edd62c645ddee2367395b
//Decrypted Message
//dbe429ca8610ea6275b100476d87a2c5
//
//}
