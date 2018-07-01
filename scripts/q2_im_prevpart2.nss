//::///////////////////////////////////////////////
//:: Name: Q Shield Crafting Conversation
//:: FileName: q2_im_prevpart2
//:: Website: http://www.qnwn.net
//:: Contact: projectq@qnwn.net
//:://////////////////////////////////////////////
/*
    Project Q - Release 1.5

    Changes the color of the currently active shield part
    on the tailor to the previous color

    Based on an original script by BioWare
*/
//:://////////////////////////////////////////////
//:: Created By: pstemarie
//:: Created On: 21 Dec 2011
//:://////////////////////////////////////////////

#include "q_inc_itemprop"

void main()
{
    int nPart =  GetLocalInt(OBJECT_SELF,"X2_TAILOR_CURRENT_PART");

    object oPC  = GetPCSpeaker();
    object oItem =  CIGetCurrentModItem(oPC);

    int  nCurrentAppearance;
    if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
    {
        nCurrentAppearance = GetItemAppearance(oItem,ITEM_APPR_TYPE_ARMOR_MODEL,nPart);
    }

    if(GetIsObjectValid(oItem) == TRUE)
    {
        object oNew;
        int nCost;
        int nDC;
        AssignCommand(oPC,ClearAllActions(TRUE));
        if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_ARMOR)
        {
            oNew = IPGetModifiedArmor(oItem, nPart, X2_IP_ARMORTYPE_PREV, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_CHEST));
            nCost = CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);
            nDC = CIGetArmorModificationDC(CIGetCurrentModBackup(oPC),oNew);
        }
        else if (CIGetCurrentModMode(oPC) ==  X2_CI_MODMODE_WEAPON)
        {
            oNew = Q_IPGetModifiedShield(oItem, ITEM_APPR_TYPE_WEAPON_COLOR, nPart, X2_IP_WEAPONTYPE_PREV, TRUE);
            CISetCurrentModItem(oPC,oNew);
            AssignCommand(oPC, ActionEquipItem(oNew, INVENTORY_SLOT_LEFTHAND));
            nCost = CIGetWeaponModificationCost(CIGetCurrentModBackup(oPC),oNew); //CIGetArmorModificationCost(CIGetCurrentModBackup(oPC),oNew);
            nDC =15; //CIGetArmorModificationDC(CIGetCurrentModBackup(oPC),oNew);
        }
        CIUpdateModItemCostDC(oPC, nDC, nCost);

    }
    // Store the cost for modifying this item here
}
