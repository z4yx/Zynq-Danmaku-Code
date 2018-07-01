#ifndef QUEUE_H_
#define QUEUE_H_ 
#include "constants.h"
#include <pthread.h>

struct deque_t{
    pthread_mutex_t ring_mutex;
    int rdptr, wrptr;
    int data[NUM_FRAME_BUFFER];
};

int DequeFront(struct deque_t *d);
void DequePopFront(struct deque_t *d);
void DequePushBack(struct deque_t *d, int data);
int DequeSize(struct deque_t *d);
int DequeInit(struct deque_t *d);

#endif