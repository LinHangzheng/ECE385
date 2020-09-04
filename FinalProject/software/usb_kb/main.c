#include <stdio.h>
#include "system.h"
#include "time.h"
#include "alt_types.h"
#include <unistd.h>  // usleep
#include "io_handler.h"
#include "monster_logic.h"
#include "saber_logic.h"
#include "usb_main.h"
//#ifdef _WIN32
//#include <Windows.h>
//#else
//#include <unistd.h>
//#endif

#define UP_END 0
#define DOWN_END 479
#define NOPRESS 0
#define LEFT_END 0
#define RIGHT_END 637
#define MAX_KEY 4 // allow four keys pressed in the same time

volatile unsigned int *game_file =(unsigned int*) 0x00000100;



enum Key_event
{PRESS_UP = 1, PRESS_DOWN, PRESS_LEFT, PRESS_RIGHT, PRESS_ATK, PRESS_SKILL
}event;

void frame_clock (double frame_time){
	double time_to_switch = frame_time;
	clock_t begin = clock();
	clock_t end = clock();
	while ((double)(end-begin)/CLOCKS_PER_SEC <time_to_switch){
		end = clock();
	}
}

void game_init(saber_t *saber, monster_t *snowman, monster_t *gingerbreadman){
	saber_init(saber);
	monster_init(snowman, 1, 2, 50, 20, 1, 20);
	monster_init(gingerbreadman, 0, 2, 60, 20, 1, 50);
}



/*
 * key_event: get key codes and update saber information
 * input : saber structure
 */
void key_event(int* game_start, saber_t* saber,monster_t* snowman, monster_t* gingerbreadman){
	unsigned long key;
	int key_array[4];
	int cur_key;
	int walk_x, walk_y;
	walk_x = 0;
	walk_y = 0;
	key = get_keycode();
	key_array[0]= (key>>24) & 0xff;
	key_array[1]= (key>>16) & 0xff;
	key_array[2]= (key>>8) & 0xff;
	key_array[3]= key & 0xff;

	for (int i =0; i< MAX_KEY;i++){
		cur_key = key_array[i];
		if (cur_key == KEY_W ){
			press_w(saber);
			walk_y = 1;
		}
		if (cur_key == KEY_S){
			press_s(saber);
			walk_y = 1;
		}
		if (cur_key == KEY_A){
			press_a(saber);
			walk_x = 1;
		}
		if (cur_key == KEY_D){
			press_d(saber);
			walk_x = 1;
		}
		if (cur_key == KEY_J){
			press_j(saber);
		}
		if (cur_key == KEY_K){
			press_k(saber);
		}
		if (cur_key == KEY_L){
			press_l(saber);
		}
		if (cur_key == KEY_ENTER){
			*game_start = 1;
			return;
		}
		if (cur_key == KEY_ESC){
			*game_start = 0;
			game_init(saber, snowman, gingerbreadman);
			return;
		}
	}

	if (walk_x == 0){saber->vx = 0;}
	if (walk_y == 0){saber->vy = 0;}
}

/*
 * gamefile_update : use characters information to update the game file,
 * 					which will communicate with the hardware
 */
void gamefile_update(int *game_start, saber_t *saber, monster_t *snowman, monster_t* gingerbreadman){
	game_file[0] = saber->exit;
	game_file[1] = saber->x;
	game_file[2] = saber->y;
	game_file[3] = saber->state;
	game_file[4] = saber->HP > 2;

	game_file[7] = snowman->exit;
	game_file[8] = snowman->x;
	game_file[9] = snowman->y;
	game_file[10] = snowman->state;

	game_file[13] = gingerbreadman->exit;
	game_file[14] = gingerbreadman->x;
	game_file[15] = gingerbreadman->y;
	game_file[16] = gingerbreadman->state;

	game_file[19] = *game_start;
	game_file[20] = *game_start==0;
}


int main(){
	saber_t saber;
	int game_start = 0;
	monster_t snowman;
	monster_t gingerbreadman;
	usb_init();		// initialize usb
	GAME_INITIAL:
	while(game_start == 0){
		key_event(&game_start, &saber, &snowman, &gingerbreadman);
		gamefile_update(&game_start, &saber, &snowman, &gingerbreadman);
	}
	printf("game start\n");
	game_init(&saber, &snowman, &gingerbreadman);
	int frame_time = 0.2;
	while (1){
		// wait until next clock
		frame_clock (frame_time);

		// use key code update saber state, vx and vy
		key_event(&game_start, &saber, &snowman, &gingerbreadman);
		if (game_start ==0){goto GAME_INITIAL;}
		saber_be_attacked_check(&saber,&snowman);
		saber_be_attacked_check(&saber,&gingerbreadman);

		// update saber state and x, y
		update(&saber);
		// use information for both snowman and saber to update snowman
		monster_update(&snowman, &saber);
		if (snowman.exit == 0){
			gingerbreadman.exit = 1;
		}
		// use information for both gingerbreadman and saber to update snowman
		monster_update(&gingerbreadman, &saber);

		// send the information to the hardware
		gamefile_update(&game_start, &saber, &snowman, &gingerbreadman);

//		printf("saber vx :%x\n", saber.vx);
	}
}













