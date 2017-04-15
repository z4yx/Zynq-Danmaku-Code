#ifndef QUEUE_H_
#define QUEUE_H_ 

int GetFilledBuffer(void);
int GetEmptyBuffer(void);
void ReleaseBuffer(void);
void CommitBuffer(void);
int RingSize(void);

#endif