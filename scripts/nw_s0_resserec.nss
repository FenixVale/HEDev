//::///////////////////////////////////////////////
//:: [Ressurection]
//:: [NW_S0_Ressurec.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Brings a character back to life with full
//:: health.
//:: When cast on placeables, you get a default error message.
//::   * You can specify a different message in
//::      X2_L_RESURRECT_SPELL_MSG_RESREF
//::   * You can turn off the message by setting the variable
//::     to -1
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 31, 2001
//:://////////////////////////////////////////////
//:: Last Updated By: Georg Z on 2003-07-31
//:: VFX Pass By: Preston W, On: June 22, 2001

#include "70_inc_spells"
#include "x2_inc_spellhook"

#include "_inc_corpse"

void main()
{
    // Spellcast Hook Code check x2_inc_spellhook.nss to find out more
    if (!X2PreSpellCastCode())
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
        return;
    // End of Spell Cast Hook

    spellsDeclareMajorVariables();
    //Check to make sure the target is dead first
    //Fire cast spell at event for the specified target
    if (GetIsObjectValid(spell.Target))
    {
        SignalEvent(spell.Target, EventSpellCastAt(spell.Caster, spell.Id, FALSE));
        if (GetIsDead(spell.Target))
        {
            //Declare major variables
            int nHealed = GetMaxHitPoints(spell.Target);
            effect eRaise = EffectResurrection();
            effect eHeal = EffectHeal(nHealed + 10);
            effect eVis = EffectVisualEffect(VFX_IMP_RAISE_DEAD);
            //Apply the heal, raise dead and VFX impact effect
            ApplyEffectToObject(DURATION_TYPE_INSTANT, eRaise, spell.Target);
            DelayCommand(0.1, ApplyEffectToObject(DURATION_TYPE_INSTANT, eHeal, spell.Target));
            ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eVis, spell.Loc);
        }
        // if the target is not dead,
        // we still need to check if its a corpse that we can raise
        // check the object for the RAISEABLE bitflag in the local CORPSE int
        // if CORPSE is not set, this will also fail.
        else if( !SpellRaiseCorpse(spell.Target, spell.Id, spell.Loc, spell.Caster) )
        {
            // provide a potential fail message
            int nStrRef = GetLocalInt(spell.Target,"X2_L_RESURRECT_SPELL_MSG_RESREF");
            if (nStrRef == 0)
                nStrRef = 83861;

            if (nStrRef != -1)
                FloatingTextStrRefOnCreature(nStrRef,spell.Caster);
        }
    }
}
