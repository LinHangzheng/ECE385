#include "saber_logic.h"
#include <stdio.h>

void press_w(saber_t *saber){
	char can_walk = 0;
	if (saber->state <= WALK_LEFT6 ){
		// if count reach the state_count_max we set, update the saber state
		if (saber->state_count ++ > STATE_COUNT_MAX){
			saber->state = (saber->state == WALK_LEFT6)? WALK_LEFT1:saber->state+1;
			saber->state_count = 0;
		}
		can_walk = 1;
	}
	else if(saber->state >= WALK_RIGHT1 && saber->state <= WALK_RIGHT6){
		if (saber->state_count ++ > STATE_COUNT_MAX){
			saber->state = (saber->state == WALK_RIGHT6)? WALK_RIGHT1:saber->state+1;
			saber->state_count = 0;
		}
		can_walk = 1;
	}
    if (can_walk == 1 && saber->vy > -VY_MOST){
    	saber->vy--;
    }
}

void press_s(saber_t *saber){
	char can_walk = 0;
	if (saber->state <= WALK_LEFT6 ){
		if (saber->state_count ++ > STATE_COUNT_MAX){
		saber->state = (saber->state == WALK_LEFT6)? WALK_LEFT1:saber->state+1;
		saber->state_count = 0;
		}
		can_walk = 1;
	}
	else if(saber->state >= WALK_RIGHT1 && saber->state <= WALK_RIGHT6){
		if (saber->state_count ++ > STATE_COUNT_MAX){
		saber->state = (saber->state == WALK_RIGHT6)? WALK_RIGHT1:saber->state+1;
		saber->state_count = 0;
		}
		can_walk = 1;
	}
    if (can_walk == 1 && saber->vy < VY_MOST){
    	saber->vy++;
    }
}

void press_a(saber_t *saber){
	if (saber->state <= WALK_LEFT6 ){
		if (saber->state_count ++ > STATE_COUNT_MAX){
		saber->state = (saber->state == WALK_LEFT6)? WALK_LEFT1:saber->state+1;
		saber->state_count = 0;
		}
		if (saber->vx > -VX_MOST){
			saber->vx--;
		}
	}
	else if(saber->state >= WALK_RIGHT1 && saber->state <= WALK_RIGHT6){
		saber->state = WALK_LEFT1;
		saber -> vx = 0;
		saber->FaceDirection = LEFT;
	}
}

void press_d(saber_t *saber){
	if (saber->state >= WALK_RIGHT1 && saber->state <= WALK_RIGHT6 ){
		if (saber->state_count ++ > STATE_COUNT_MAX){
		saber->state = (saber->state == WALK_RIGHT6)? WALK_RIGHT1:saber->state+1;
		saber->state_count = 0;
		}
		if (saber->vx < VX_MOST){
			saber->vx++;
		}
	}
	else if(saber->state <= WALK_LEFT6){
		saber->state = WALK_RIGHT1;
		saber-> vx = 0;
		saber->FaceDirection = RIGHT;
	}
}

void press_j(saber_t *saber){
	if (saber->state <= WALK_LEFT6){
		saber-> state = ATTACK_LEFT1;
		saber-> state_count = 0;
		saber-> IsFighting = 1;
	}else if (saber->state >= WALK_RIGHT1 &&saber->state <= WALK_RIGHT6){
		saber-> state = ATTACK_RIGHT1;
		saber-> state_count = 0;
		saber-> IsFighting = 1;
	}
}

void press_k(saber_t *saber){
	if (saber->state <= WALK_LEFT6){
		saber-> state = SKILL_LEFT1;
		saber-> state_count = 0;
	}else if (saber->state >= WALK_RIGHT1 &&saber->state <= WALK_RIGHT6){
		saber-> state = SKILL_RIGHT1;
		saber-> state_count = 0;
	}
}

void press_l(saber_t *saber){
	if (saber->state <= WALK_LEFT6){
		saber-> state = POSE_LEFT1;
		saber-> state_count = 0;
	}else if (saber->state >= WALK_RIGHT1 &&saber->state <= WALK_RIGHT6){
		saber-> state = POSE_RIGHT1;
		saber-> state_count = 0;
	}
}


void saber_init(saber_t *saber){
	saber -> exit = 1;
	saber -> vx = 0;
	saber -> vy = 0;
	saber -> x = INIT_X;
	saber -> y = INIT_Y;
	saber -> HP = 3;
	saber -> ATK = 3;
	saber -> state = 6;
	saber -> state_count = 0;
	saber -> IsFighting = 0;
	saber ->FaceDirection = RIGHT;
}


void update(saber_t *saber){
	saber -> x = saber ->x + saber->vx;
	saber -> y = saber ->y + saber->vy;

	if (saber->injuring){
		saber->exit = (saber->injuring-1)/2 % 2;
		saber->injuring = (saber->injuring>=8)?0:saber->injuring+1;
	}
	// boundary check
	if (saber-> x < LEFT_MOST){saber-> x = LEFT_MOST;}
	if (saber-> x > RIGHT_MOST){saber-> x = RIGHT_MOST;}
	if (saber-> y < UP_MOST){saber-> y = UP_MOST;}
	if (saber-> y > DOWN_MOST){saber-> y = DOWN_MOST;}

	update_helper(saber, ATTACK_LEFT1, ATTACK_LEFT4);
	update_helper(saber, ATTACK_RIGHT1, ATTACK_RIGHT4);
	update_helper(saber, SKILL_LEFT1, SKILL_LEFT4);
	update_helper(saber, SKILL_RIGHT1, SKILL_RIGHT4);
	update_helper(saber, POSE_LEFT1, POSE_LEFT2);
	update_helper(saber, POSE_RIGHT1, POSE_RIGHT2);
}

void stop(saber_t *saber){
	saber-> vx =0;
	saber-> vy =0;
	if (saber -> FaceDirection == RIGHT){
		saber -> state = WALK_RIGHT1;
	}else{
		saber -> state = WALK_LEFT1;
	}
}

void update_helper(saber_t*saber, int state_start, int state_end){
	int final_frame;
	final_frame = saber->FaceDirection == RIGHT? WALK_RIGHT1:WALK_LEFT1;
	if (saber->HP == 0){
		saber->exit = 0;
	}
	if (saber->state >= state_start && saber->state<= state_end){
		saber->vx = 0;
		saber->vy = 0;
		if (saber->state_count ++ > STATE_COUNT_MAX){
			saber->state = (saber->state == state_end)? final_frame:saber->state+1;
			saber->state_count = 0;
			saber->IsFighting = 0;
		}
	}
}



