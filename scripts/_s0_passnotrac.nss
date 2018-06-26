//::///////////////////////////////////////////////
//:: _s0_passnotrac
//:://////////////////////////////////////////////
/*
    Spell Script for Pass Without Trace
    Spell equivalent of Trackless Step
        player is not trackable or smellable
*/
//:://////////////////////////////////////////////
//:: Created:   Henesua (2013 sept 15)
//:: Modified:
//:://////////////////////////////////////////////

#include "70_inc_spells"
#include "x2_inc_spellhook"
#include "x3_inc_skin"

#include "_inc_spells"

void DoPassWithoutTrace(object oPC, float fDuration)
{
    effect eVis = EffectVisualEffect(VFX_IMP_IMPROVE_ABILITY_SCORE);
    effect eDur = EffectVisualEffect(VFX_DUR_CESSATE_POSITIVE);

    //Fire spell cast at event for target
    SignalEvent(oPC, EventSpellCastAt(oPC, spell.Id, FALSE));
    //Apply VFX impact and bonus effects
    ApplyEffectToObject(DURATION_TYPE_INSTANT, eVis, oPC);
    ApplyEffectToObject(DURATION_TYPE_TEMPORARY, eDur, oPC, fDuration);
}

void main()
{
    // Spellcast Hook Code
    // If code within the PreSpellCastHook (i.e. UMD) reports FALSE, do not run this spell
    if (!X2PreSpellCastCode())
        return;

    //Declare major variables
    spellsDeclareMajorVariables();

    effect eImpact = EffectVisualEffect(VFX_IMP_PULSE_NATURE);
    ApplyEffectAtLocation(DURATION_TYPE_INSTANT, eImpact, spell.Loc);

    int nMaxTargets = spell.Level;
    if (nMaxTargets < 1)
        nMaxTargets = 1;
    int nTarget = 1;

    int nDuration   = spell.Level;
    if(spell.Meta == METAMAGIC_EXTEND)    //Duration is +100%
        nDuration   *= 2;
    float fDuration = HoursToSeconds(nDuration);

    //Get the first target in the radius around the caster
    if(nMaxTargets>1)
    {
      int bPartyOnly;
      if(GetIsPC(OBJECT_SELF))
        bPartyOnly = TRUE;
      object oTarget = GetFirstObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, spell.Loc);
      while(GetIsObjectValid(oTarget))
      {
        int bFaction =GetFactionEqual(oTarget);

        if(     (bPartyOnly && bFaction)
            ||  (GetIsReactionTypeFriendly(oTarget) || bFaction)
          )
        {
            if(!GetHasFeat(FEAT_TRACKLESS_STEP, oTarget) && !GetHasSpellEffect(SPELL_PASS_WITH_NO_TRACE,oTarget))
            {
                DoPassWithoutTrace(oTarget, fDuration);
                ++nTarget;
            }
            if(nTarget > nMaxTargets){break;}
        }
        //Get the next target in the specified area around the caster
        oTarget = GetNextObjectInShape(SHAPE_SPHERE, RADIUS_SIZE_COLOSSAL, spell.Loc);
      }
    }
    // self last
    if(!GetHasFeat(FEAT_TRACKLESS_STEP, OBJECT_SELF) && !GetHasSpellEffect(SPELL_PASS_WITH_NO_TRACE,OBJECT_SELF))
        DoPassWithoutTrace(OBJECT_SELF, fDuration);
}
