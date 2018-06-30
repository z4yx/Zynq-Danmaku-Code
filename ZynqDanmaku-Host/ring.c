#include <pthread.h>
#include <assert.h>
#include "ring.h"

// max size of deque is NUM_FRAME_BUFFER-1

int DequeInit(struct deque_t *d)
{
    pthread_mutex_init(&d->ring_mutex, NULL);
    d->rdptr = d->wrptr = 0;
}
int DequeSize(struct deque_t *d)
{
    pthread_mutex_lock(&d->ring_mutex);
    int size = (d->wrptr - d->rdptr + NUM_FRAME_BUFFER)%NUM_FRAME_BUFFER;
    pthread_mutex_unlock(&d->ring_mutex);
    return size;
}
int DequeFront(struct deque_t *d)
{
    int t;
    pthread_mutex_lock(&d->ring_mutex);
    if(d->wrptr == d->rdptr)
        t = -1;
    else
        t = d->data[d->rdptr];
    pthread_mutex_unlock(&d->ring_mutex);
    return t;
}
void DequePopFront(struct deque_t *d)
{
    pthread_mutex_lock(&d->ring_mutex);
    assert(d->rdptr!=d->wrptr);
    d->rdptr = (d->rdptr+1)%NUM_FRAME_BUFFER;
    pthread_mutex_unlock(&d->ring_mutex);
}
void DequePushBack(struct deque_t *d, int data)
{
    int t;
    pthread_mutex_lock(&d->ring_mutex);
    t = (d->wrptr+1)%NUM_FRAME_BUFFER;
    assert(t != d->rdptr);
    d->data[d->wrptr] = data;
    d->wrptr = t;
    pthread_mutex_unlock(&d->ring_mutex);
}

