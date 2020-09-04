/*
 * SnowMan_logic.c
 *
 *  Created on: 2020��9��2��
 *      Author: cc
 */

#ifndef SNOWMAN_LOGIC_C_
#define SNOWMAN_LOGIC_C_
#include <stdlib.h>
#include "monster_logic.h"
int monster_hit_check(monster_t *monster, saber_t *saber);
void monster_update(monster_t *monster, saber_t *saber);
void monster_init(monster_t *monster, int exit, int speed, int fat, int HP, int ATK, int ATTACK_BIAS){
	monster->exit = exit;
	monster->x = SNOWMAN_INIT_X;
	monster->y = SNOWMAN_INIT_Y;
	monster->attack_x = monster->x;
	monster->attack_y = monster->y + ATTACK_BIAS;
	monster->attack_bias = ATTACK_BIAS;
	monster->vx = -speed;
	monster->vy = 0;
	monster->FAT = fat;
	monster->HP = HP;
	monster->ATK = ATK;
	monster->state = WALK1;
	monster->state_count = 0; 	// frame count for each state
	monster->bleeding = 0;
	monster->Dying = 0;
	monster->dead_count = 0;
	monster->hit_count = 0;
}

int monster_hit_check(monster_t *monster, saber_t *saber){
	if (saber->HP<=0 || monster-> HP <=0){return FALSE;}
	int position_x_diff;
	position_x_diff = monster->x - saber->x;
	if (monster -> state <= WALK4 && saber->IsFighting && abs(monster->attack_y - saber-> y) < ATTACK_RANGEY &&
			((position_x_diff >=0 && saber->FaceDirection ==RIGHT && position_x_diff-monster->FAT < ATTACK_RANGEX ) ||
			(position_x_diff <=0 && saber->FaceDirection ==LEFT && -position_x_diff-monster->FAT < ATTACK_RANGEX))){
		return TRUE;
	}else{
		return FALSE;
	}
}

void saber_be_attacked_check(saber_t *saber, monster_t *monster){
	if (saber->exit ==0||monster->HP<=0){return;}
	if (abs(saber->x - monster->attack_x)<= monster->FAT && abs(saber->y - monster->attack_y)<=monster->FAT){
		if (saber->x < monster->attack_x){
			saber->x = saber->x -40;
		}else{
			saber->x = saber->x +40;
		}
		saber->injuring = 1;
		saber-> HP = saber-> HP - monster-> ATK;
	}

}

void monster_update(monster_t *monster, saber_t *saber){
	if (monster-> exit ==0){
		return;
	}
//	if (monster-> bleeding >0){
//		monster->
//	}

	// if monster is dead, set the frame for his corpse to remain
	if (monster->state == DEAD2 && monster->dead_count++ == DEAD_COUNT){
		monster->exit = 0;
		return;
	}
	// check whether the monster can be dead
	if (monster->HP <= 0 ){
		monster->Dying =1;
	}

	// update monster's state
	if (monster->state <= WALK4){
		monster-> x = (monster->x + monster->vx< LEFT_MOST)?LEFT_MOST:monster->x + monster->vx;
		if (monster-> y + monster->vy > UP_MOST && monster-> y + monster->vy < DOWN_MOST){
			monster->y = monster->y + monster->vy;
		}
		monster->attack_x = monster-> x;
		monster->attack_y = monster-> y + monster-> attack_bias;
	}
	if (monster->state_count ++ > STATE_COUNT_MAX){
		// set the frame for monster when he is attacked
		if (monster->state == HIT){
			if (monster->hit_count < 2){
				monster->hit_count= monster->hit_count+1 ;
				monster->state_count = 0;
				return;
			}else{
				monster->hit_count = 0;
			}
		}
		if (monster->state <=HIT && monster->Dying ==0){
			// IF WALK4 OR HIT, RETURN BACK TO WALK1
			monster->state = (monster->state >= WALK4)? WALK1:monster->state+1;
		}else if (monster->Dying && monster->state <= HIT){
			monster->state = DEAD1;
		}
		else if (monster->state == DEAD1){
			monster->state = DEAD2;
		}
		monster->state_count=0;
	}

	// check if is being attacked
	if (monster_hit_check(monster,saber)){
		monster->state = HIT;
		monster->HP = monster->HP - saber->ATK;
		if (saber->FaceDirection == RIGHT){
			monster->x = monster ->x + 20;
		}else{
			monster->x = monster ->x - 20;
		}
		printf("monster HP:%x\n",monster->HP);
	}
}




#endif /* SNOWMAN_LOGIC_C_ */
