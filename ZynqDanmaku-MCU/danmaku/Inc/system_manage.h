#ifndef SYSTEM_MANAGE_H_
#define SYSTEM_MANAGE_H_ 

void SystemManage_SetSinkPresence(int index, bool presence);
void SystemManage_SetSourcePresence(uint8_t presence);
void SystemManage_Task(void);


#endif