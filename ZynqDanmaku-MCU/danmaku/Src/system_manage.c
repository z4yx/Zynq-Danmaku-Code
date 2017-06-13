
#include "common.h"
#include "hdmi_dec_enc.h"
#include "system_manage.h"

enum {
    SINK_NONE = 0,
    SINK_ONE_PRESENCE,
    SINK_BOTH_PRESENCE
};

enum {
    SOURCE_NONE = 0,
    SOURCE_ONE_PRESENCE,
    SOURCE_BOTH_PRESENCE
};

static uint8_t sink_state, source_state;
static int one_sink_index, one_source_index;

static void StateChanged(uint8_t from, uint8_t to)
{
    DBG_MSG("from %d to %d", from, to);
    if(to == SINK_NONE){
        HDMIEnc_DisableEDID();
    }else if(to == SINK_ONE_PRESENCE){
        HDMIEnc_SetEDID(HDMIDec_GetEDID(one_sink_index));
        HDMIEnc_EnableEDID();
    }else{
        //TODO: choose one
        HDMIEnc_SetEDID(HDMIDec_GetEDID(0));
        HDMIEnc_EnableEDID();
    }
}

void SystemManage_SetSinkPresence(int index, bool presence)
{
    switch(sink_state){
        case SINK_NONE:
            if(presence){
                one_sink_index = index;
                sink_state = SINK_ONE_PRESENCE;
                StateChanged(SINK_NONE, SINK_ONE_PRESENCE);
            }
            break;
        case SINK_ONE_PRESENCE:
            if(index == one_sink_index){
                if(!presence){
                    sink_state = SINK_NONE;
                    StateChanged(SINK_ONE_PRESENCE, SINK_NONE);
                }
            }else{
                if(presence){
                    sink_state = SINK_BOTH_PRESENCE;
                    StateChanged(SINK_ONE_PRESENCE, SINK_BOTH_PRESENCE);
                }
            }
            break;
        case SINK_BOTH_PRESENCE:
            if(!presence){
                sink_state = SINK_ONE_PRESENCE;
                one_sink_index = 1-index; //the other one presences
                StateChanged(SINK_BOTH_PRESENCE, SINK_ONE_PRESENCE);
            }
            break;
    }
}

void SystemManage_SetSourceLED(uint8_t presence)
{
    uint8_t active = (1<<one_source_index) & presence;
    uint8_t inactive = presence & ~active;
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_4, !!(inactive & 1));
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_6, !!(inactive & 2));
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_5, !!(active & 1));
    HAL_GPIO_WritePin(GPIOA, GPIO_PIN_7, !!(active & 2));
}

void SystemManage_SetSourcePresence(uint8_t presence)
{
    switch(source_state){
        case SOURCE_NONE:
            if(presence == 3){
                one_source_index = 0; //default behavior
                HDMIDec_SelectSource(one_source_index);
                source_state = SOURCE_BOTH_PRESENCE;
                INFO_MSG("enabling default source %d", one_source_index);
            }else if(presence){
                one_source_index = (presence>>1); // bit mask to index number
                HDMIDec_SelectSource(one_source_index);
                source_state = SOURCE_ONE_PRESENCE;
                INFO_MSG("enabling source %d", one_source_index);
            }
            break;
        case SOURCE_ONE_PRESENCE:
            if(presence == 3){
                //do not switch source in use
                source_state = SOURCE_BOTH_PRESENCE;
                INFO_MSG("another source detected");
            }else if(presence){
                if(one_source_index != (presence>>1)){
                    one_source_index = (presence>>1); // bit mask to index number
                    HDMIDec_SelectSource(one_source_index);
                    INFO_MSG("source changed to %d", one_source_index);
                }
            }else{
                source_state = SOURCE_NONE;
                INFO_MSG("source %d lost", one_source_index);
            }
            break;
        case SOURCE_BOTH_PRESENCE:
            if(presence == 3){

            }else if(presence){
                INFO_MSG("lost one source");
                if(one_source_index != (presence>>1)){
                    one_source_index = (presence>>1); // bit mask to index number
                    HDMIDec_SelectSource(one_source_index);
                    INFO_MSG("fallback to %d", one_source_index);
                }
                source_state = SOURCE_ONE_PRESENCE;
            }else{
                source_state = SOURCE_NONE;
                INFO_MSG("both source lost");
            }
            break;
    }
    SystemManage_SetSourceLED(presence);
}

void SystemManage_Task(void)
{

}