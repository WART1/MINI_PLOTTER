#define in1_A_X 2
#define in2_B_X 3 
#define in3_C_X 4 
#define in4_D_X 5

#define in1_A_Y A3
#define in2_B_Y A2
#define in3_C_Y A1
#define in4_D_Y A0

#define in1_A_Z 8
#define in2_B_Z 9
#define in3_C_Z 12
#define in4_D_Z 13

#define HOMING_SPEED 2000
#define NORMAL_SPEED 1000 
#define MAX_SPEED 500
#define PIEZO 18
#define SERVO 10
#define X_ENDSWITCH 11
#define Y_ENDSWITCH 19

const int stepsPerRotation = 64 * 64;         //                              64 steps per rotation and 1:64 gearbox
const float stepsPerMM = 91.02;
const uint16_t minDelay = 500;               //                              minimum delay time between steps (in microseconds)
const uint16_t maxDelay = 1000;               //                              maximum delay time between steps (in microseconds)
const int servoPenDown = 0;     //                                            servo angle pen down
const int servoPenUp = 50;     //                                            servo angle pen up