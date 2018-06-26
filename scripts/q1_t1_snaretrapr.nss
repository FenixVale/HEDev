#include "q_inc_traps"



void main()
{
    object oTrap;
    if(GetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW")==0)
    {
        location lPlcbl = GetLocalLocation(OBJECT_SELF,"TRP_PLCBL_LOC");
        SetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW",1);
        oTrap = CreateObject(OBJECT_TYPE_PLACEABLE,"snaretraprplcb",lPlcbl);
        SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);
    }
    else
        oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");


    int nDC     = Trap_GetCustomDC(OBJECT_SELF);
    object oPC = GetEnteringObject();
    if(GetTrapDetectedBy(OBJECT_SELF, oPC))
        nDC =10;
    else if(!nDC)
        nDC =25;

    if (!ReflexSave(oPC,nDC,SAVING_THROW_TYPE_NONE))
    {
        ApplyEffectToObject(DURATION_TYPE_INSTANT, EffectVisualEffect( VFX_IMP_DAZED_S), oPC);
        PlayVoiceChat(VOICE_CHAT_PAIN1,oPC);
        ApplyEffectToObject(DURATION_TYPE_TEMPORARY,EffectMovementSpeedDecrease(99),oPC,RoundsToSeconds(2));
    }
}
