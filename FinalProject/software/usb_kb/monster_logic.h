/*
 * SnowMan_logic.h
 *
 *  Created on: 2020��9��2��
 *      Author: cc
 */

#ifndef SNOWMAN_LOGIC_H_
#define SNOWMAN_LOGIC_H_
#include "saber_logic.h"
#define TRUE 1
#define FALSE 0
#define UP_MOST 170
#define LEFT_MOST 33
#define RIGHT_MOST 607
#define DOWN_MOST 280
#define SNOWMAN_INIT_X 600
#define SNOWMAN_INIT_Y 200
#define VY_MOST 3
#define VX_MOST 4
#define STATE_COUNT_MAX 3
#define RIGHT 0
#define LEFT 1
#define DEAD_COUNT 100


typedef struct monster_t{
	int exit;
    int x,y;
    int attack_x, attack_y; // the center for attack and beening attack
    int vx,vy;
    int attack_bias; 	// distance between center and the point for attack
    int FAT;			// half x size of snowman, used for attack check
    int HP;
    int ATK;
    int state;
    int state_count; 	// frame count for each state
    int dead_count;		// count for disappear after snowman dead
    int hit_count;		// count for hit frame
    int Dying;		// the snowman are dying
    int bleeding;
}monster_t;

#define WALK_FRAME 6
#define ATK_FRAME  4
#define SKILL_FRAME 4
#define POSE_FRAME  2

enum monster_state
{WALK1 = 0, WALK2, WALK3, WALK4,
 HIT,
 DEAD1,DEAD2
} monster_state;


void monster_init(monster_t *monster, int exit,  int speed, int fat, int HP, int ATK, int ATTACK_BIAS);
void saber_be_attacked_check(saber_t *saber, monster_t *monster);

#endif /* SNOWMAN_LOGIC_H_ */
