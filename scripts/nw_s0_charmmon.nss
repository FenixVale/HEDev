//::///////////////////////////////////////////////
//:: [Charm Monster]
//:: [NW_S0_CharmMon.nss]
//:: Copyright (c) 2000 Bioware Corp.
//:://////////////////////////////////////////////
//:: Will save or the target is charmed for 1 round
//:: per 2 caster levels.
//:://////////////////////////////////////////////
//:: Created By: Preston Watamaniuk
//:: Created On: Jan 29, 2001
//:://////////////////////////////////////////////
//:: Update Pass By: Preston W, On: July 25, 2001
//:://////////////////////////////////////////////
//:: Modified:   Henesua (2013 sept 8)
//        Duration Changed to 1 Turn/level
//        Incorporating a personal reputation system. Reputation is adjusted for 1hr/level

// INCLUDES --------------------------------------------------------------------
#include "70_inc_spells"
#include "x0_i0_spells"
#include "x2_inc_spellhook"

// Vendalus's Personal Reputation and Reaction System
//#include "_prr_main"

// MAIN ------------------------------------------------------------------------
void main()
{
    // Spellcast Hook Code Added 2003-06-23 by GeorgZ
    // check x2_inc_spellhook.nss to find out more
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode()){return;}

    //Declare major variables
    spellsDeclareMajorVariables();
    effect eVis     = EffectVisualEffect(VFX_IMP_CHARM);
    effect eCharm   = EffectCharmed();
           eCharm   = GetScaledEffect(eCharm, spell.Target);
    effect eMind    = EffectVisualEffect(VFX_DUR_MIND_AFFECTING_NEGATIVE);
    effect eDur     = EffectVisualEffect(VFX_DUR_CESSATE_NEGATIVE);
    //Link effects
    effect eLink    = EffectLinkEffects(eMind, eCharm);
           eLink    = EffectLinkEffects(eLink, eDur);

    int nDuration   = spell.Level;
        nDuration   = GetScaledDuration(nDuration, spell.Target);
    //Metamagic extend check
    if (spell.Meta == METAMAGIC_EXTEND)
        nDuration = nDuration * 2;

    if(spellsIsTarget(spell.Target, SPELL_TARGET_SINGLETARGET, spell.Caster))
    {
        //Fire cast spell at event for the specified target
        SignalEvent(spell.Target, EventSpellCastAt(spell.Caster, spell.Id, FALSE));
        // Make SR Check
        if (!MyResistSpell(spell.Caster, spell.Target))
        {
            // Make Will save vs Mind-Affecting,
            if (!MySavingThrow(SAVING_THROW_WILL, spell.Target, spell.DC, SAVING_THROW_TYPE_MIND_SPELLS, spell.Caster))
            {
                //Apply impact and linked effect
                ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eLink, spell.Target, TurnsToSeconds(nDuration));
                ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, spell.Target);

                // Personal Reputation and Reaction System
                //PRR_CHARM_AffectTarget(spell.Target, OBJECT_SELF, nDuration);
            }
            else
            {
                // Reputation
                //  - Unimplemented
                // Caster's reputation should suffer when a target makes a save
                // and realizes that a charm spell was cast

            }
        }
    }
}
