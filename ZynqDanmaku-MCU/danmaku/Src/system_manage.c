
#include "common.h"
#include "hdmi_dec_enc.h"
#include "system_manage.h"

enum {
    SINK_NONE = 0,
    SINK_ONE_PRESENCE,
    SINK_BOTH_PRESENCE
};

static uint8_t sink_state;
static int one_sink_index;

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

void SystemManage_Task(void)
{

}