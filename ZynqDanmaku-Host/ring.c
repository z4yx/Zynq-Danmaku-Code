#include <pthread.h>
#include <assert.h>
#include "ring.h"
#include "constants.h"

static pthread_mutex_t  ring_mutex = PTHREAD_MUTEX_INITIALIZER;
static int rdptr, wrptr;

int RingSize(void)
{
    pthread_mutex_lock(&ring_mutex);
    int size = (wrptr-rdptr+NUM_FRAME_BUFFER)%NUM_FRAME_BUFFER;
    pthread_mutex_unlock(&ring_mutex);
    return size;
}
int GetFilledBuffer(void)
{
    int t;
    pthread_mutex_lock(&ring_mutex);
    if(wrptr == rdptr)
        t = -1;
    else
        t=rdptr;
    pthread_mutex_unlock(&ring_mutex);
    return t;
}
int GetEmptyBuffer(void)
{
    int ret;
    pthread_mutex_lock(&ring_mutex);
    if((wrptr+1)%NUM_FRAME_BUFFER==rdptr)
        ret = -1;
    else
        ret = wrptr;
    pthread_mutex_unlock(&ring_mutex);
    return ret;
}
void ReleaseBuffer(void)
{
    pthread_mutex_lock(&ring_mutex);
    assert(rdptr!=wrptr);
    rdptr = (rdptr+1)%NUM_FRAME_BUFFER;
    pthread_mutex_unlock(&ring_mutex);
}
void CommitBuffer(void)
{
    int t;
    pthread_mutex_lock(&ring_mutex);
    t = (wrptr+1)%NUM_FRAME_BUFFER;
    assert(t!=rdptr);
    wrptr=t;
    pthread_mutex_unlock(&ring_mutex);
}

