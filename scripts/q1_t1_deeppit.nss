#include "q_inc_traps"

void main()
{
    if(GetLocalInt(OBJECT_SELF,"TRP_TRIGGERED"))
        return;

    SetLocalInt(OBJECT_SELF,"TRP_TRIGGERED",1);


    object oTrap;

    if(GetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW")==0)
    {
        location lPlcbl = GetLocalLocation(OBJECT_SELF,"TRP_PLCBL_LOC");
        SetLocalInt(OBJECT_SELF,"TRP_PLCBL_SHOW",1);
        oTrap = CreateObject(OBJECT_TYPE_PLACEABLE,"metalpitpcbl",lPlcbl);
        SetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ",oTrap);
    }
    else
        oTrap = GetLocalObject(OBJECT_SELF,"TRP_PLCBL_OBJ");

    AssignCommand(oTrap,DelayCommand(1.0,TrapPlayAnim(oTrap)));
    ApplyEffectAtLocation(DURATION_TYPE_TEMPORARY,EffectAreaOfEffect(53),GetLocation(oTrap),HoursToSeconds(200));
    object oAOE = GetNearestObject(OBJECT_TYPE_AREA_OF_EFFECT,oTrap);
    SetLocalObject(oAOE, "TRP_TRIGGER_OBJECT",OBJECT_SELF);
    SetLocalObject(oAOE, "TRP_PLCBL_OBJ", oTrap);

    SetLocalObject(oAOE,"TRAP_TRIGGERER_EXECUTE", GetEnteringObject());
    DelayCommand(0.01,ExecuteScript("q1_t0_deeppita",oAOE));
}

