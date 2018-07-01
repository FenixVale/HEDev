//::///////////////////////////////////////////////
//:: Tailoring - Decrement Weapon Bottom
//:: tlr_decrweapbot.nss
//::
//:://////////////////////////////////////////////
/*
    Decrements appearances for an equipped weapon
*/
//:://////////////////////////////////////////////
//:: Created By: Stacy L. Ropella
//:: Created On: January 29, 2006
//:://////////////////////////////////////////////


////////////////////////////////////////////////////////////////////////////////
//The Mad Poet - Modified for Avernostra                                      //
//  Project Q shields are 3 piece, treat them as weapons instead              //
////////////////////////////////////////////////////////////////////////////////

#include "tlr_items_inc"

void main()
{
    object oNPC = OBJECT_SELF;
    object oItem = GetItemInSlot(INVENTORY_SLOT_LEFTHAND, oNPC);
    RemakeWeapon(oNPC, oItem, ITEM_APPR_WEAPON_MODEL_BOTTOM, PART_PREV);
}
