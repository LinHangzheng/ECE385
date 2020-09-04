#ifndef SABER_LOGIC_H_
#define SABER_LOGIC_H_
#define TRUE 1
#define FALSE 0
#define UP_MOST 170
#define LEFT_MOST 33
#define RIGHT_MOST 607
#define DOWN_MOST 280
#define INIT_X 50
#define INIT_Y 240
#define VY_MOST 3
#define VX_MOST 4
#define STATE_COUNT_MAX 3
#define RIGHT 0
#define LEFT 1
#define ATTACK_RANGEX 80
#define ATTACK_RANGEY 20
typedef struct saber_t{
	int exit;
    int x,y;
    int vx,vy;
    int HP;
    int ATK;
    int FaceDirection; // -1 for left and 1 for right
    int state;
    int state_count; 	// frame count for each state
    int IsFighting;
    int injuring;		// just be attacked
}saber_t;

#define WALK_FRAME 6
#define ATK_FRAME  4
#define SKILL_FRAME 4
#define POSE_FRAME  2

enum Saber_state
{WALK_LEFT1 = 0, WALK_LEFT2, WALK_LEFT3, WALK_LEFT4, WALK_LEFT5, WALK_LEFT6,
 WALK_RIGHT1, WALK_RIGHT2, WALK_RIGHT3, WALK_RIGHT4, WALK_RIGHT5, WALK_RIGHT6,
 ATTACK_LEFT1, ATTACK_LEFT2, ATTACK_LEFT3, ATTACK_LEFT4,
 SKILL_LEFT1, SKILL_LEFT2, SKILL_LEFT3, SKILL_LEFT4,
 POSE_LEFT1, POSE_LEFT2,
 ATTACK_RIGHT1, ATTACK_RIGHT2, ATTACK_RIGHT3, ATTACK_RIGHT4,
 SKILL_RIGHT1, SKILL_RIGHT2, SKILL_RIGHT3, SKILL_RIGHT4,
 POSE_RIGHT1, POSE_RIGHT2
} saber_state;

void press_w(saber_t *saber);
void press_s(saber_t *saber);
void press_a(saber_t *saber);
void press_d(saber_t *saber);
void press_j(saber_t *saber);
void press_k(saber_t *saber);
void press_l(saber_t *saber);
void saber_init(saber_t *saber);
void update(saber_t *saber);
void stop(saber_t *saber);
void update_helper(saber_t*saber, int state_start, int state_end);
#endif /* SABER_LOGIC_H_ */
