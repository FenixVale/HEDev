//
// NESS V8.0
// Spawn : Corpse Death Script
//
//
//   Do NOT Modify this File
//   See 'spawn__readme' for Instructions
//
//:: Modified: henesua (2016 jul 7) integration with PC corpse as well

#include "spawn_functions"
#include "_inc_color"
#include "_inc_corpse"

/*
void main()
{
    object oDeadNPC = OBJECT_SELF;
    object oLootCorpse, oBlood;
    location lCorpseLoc = GetLocation(oDeadNPC);
    float fCorpseDecay = GetLocalFloat(oDeadNPC, "CorpseDecay");
    int nCorpseDecayType = GetLocalInt(oDeadNPC, "CorpseDecayType");
    int bDropWielded = GetLocalInt(oDeadNPC, "CorpseDropWielded");
    string sLootCorpseResRef = GetLocalString(oDeadNPC, "CorpseRemainsResRef");
    struct NESS_CorpseInfo stCorpseInfo;

    int nCorpseGold = FALSE, nCorpseInv = FALSE, nCorpseEquip = FALSE;

    object oKiller = GetLastDamager();
    if (oKiller == OBJECT_INVALID)
    {
        oKiller = GetLastKiller();
    }

    if (fCorpseDecay > 0.0)
    {
        //Protect our corpse from decaying
        SetIsDestroyable(FALSE, FALSE, FALSE);

        // Create Corpse and Lootable Corpse
        oLootCorpse = CreateObject(OBJECT_TYPE_PLACEABLE, sLootCorpseResRef, lCorpseLoc);

        SetLocalObject(oLootCorpse, "HostBody", oDeadNPC);
        SetLocalObject(oDeadNPC, "Corpse", oLootCorpse);

        switch (nCorpseDecayType)
        {
            // Type 0:
            // Inventory Items
            case 0:
                nCorpseGold = TRUE;
                nCorpseInv = TRUE;
                nCorpseEquip = FALSE;
            break;

            // Type 1:
            // Inventory & Equipped Items
            case 1:
                nCorpseGold = TRUE;
                nCorpseInv = TRUE;
                nCorpseEquip = TRUE;
            break;

            // Type 2:
            // Inventory Items, if PC Killed
            case 2:
                if (GetIsPC(oKiller) == TRUE || GetIsPC(GetMaster(oKiller)) == TRUE)
                {
                    nCorpseGold = TRUE;
                    nCorpseInv = TRUE;
                    nCorpseEquip = FALSE;
                }
            break;

            // Type 3:
            // Inventory & Equipped Items, if PC Killed
            case 3:
                if (GetIsPC(oKiller) == TRUE || GetIsPC(GetMaster(oKiller)) == TRUE)
                {
                    nCorpseGold = TRUE;
                    nCorpseInv = TRUE;
                    nCorpseEquip = TRUE;
                }
            break;
        }

        // Get Gold
        if (nCorpseGold == TRUE)
        {
            int nAmtGold = GetGold(oDeadNPC);
            if(nAmtGold)
            {
                object oGold = CreateItemOnObject("nw_it_gold001", oLootCorpse, nAmtGold);
                AssignCommand(oLootCorpse, TakeGoldFromCreature(nAmtGold, oDeadNPC,TRUE));
            }
        }

        // Get Inventory & Equipment
        if (nCorpseEquip == TRUE)
        {
            stCorpseInfo = TransferAllInventorySlots(oDeadNPC, oLootCorpse, bDropWielded);
        }

        if (nCorpseInv == TRUE)
        {
            LootInventory(oDeadNPC, oLootCorpse);
        }

        // Write a record of stuff left on the original corpse and its loot
        // corpse counterpart.  These are used to remove items from the visual corpse
        // when the corresponding items are looted
        SetLocalObject(oLootCorpse, "OrigArmor", stCorpseInfo.origArmor);
        SetLocalObject(oLootCorpse, "LootArmor", stCorpseInfo.lootArmor);
        SetLocalObject(oLootCorpse, "OrigRgtWpn", stCorpseInfo.origRgtWpn);
        SetLocalObject(oLootCorpse, "LootRgtWpn", stCorpseInfo.lootRgtWpn);
        SetLocalObject(oLootCorpse, "OrigLftWpn", stCorpseInfo.origLftWpn);
        SetLocalObject(oLootCorpse, "LootLftWpn", stCorpseInfo.lootLftWpn);

        // Set Corpse to Decay
        DelayCommand(fCorpseDecay - 0.1, SetLocalInt(oDeadNPC, "DecayTimerExpired", TRUE));
        DelayCommand(fCorpseDecay, ExecuteScript("spawn_corpse_dcy", oDeadNPC));
    }
}
*/

void main()
{
    if(GetLocalInt(OBJECT_SELF,"CORPSE_NONE"))
        return;

    object oKiller = GetLastDamager();
    if (oKiller == OBJECT_INVALID)
        oKiller = GetLastKiller();

    // SUBDUAL DAMAGE has non-lethal results -----------------------------------
    object oRight   = GetItemInSlot(INVENTORY_SLOT_RIGHTHAND,oKiller);
    object oLeft    = GetItemInSlot(INVENTORY_SLOT_LEFTHAND,oKiller);
    if(     GetLocalInt(oRight,"WEAPON_NONLETHAL")
        ||  GetLocalInt(oLeft,"WEAPON_NONLETHAL")
        ||  GetLocalInt(oKiller,"COMBAT_NONLETHAL")// subdual mode
        ||  GetLocalInt(OBJECT_SELF,"DAMAGE_NONLETHAL")
      )
    {
        return;
    }
    // END SUBDUAL DAMAGE ------------------------------------------------------

    object oLootCorpse, oBlood;
    location lCorpseLoc     = GetLocation(OBJECT_SELF);
    float fCorpseDecay      = GetLocalFloat(OBJECT_SELF, "CorpseDecay");
    int nCorpseDecayType    = GetLocalInt(OBJECT_SELF, "CorpseDecayType");
    int bDropWielded        = GetLocalInt(OBJECT_SELF, "CorpseDropWielded");
    string sLootCorpseResRef= GetLocalString(OBJECT_SELF, "CorpseRemainsResRef");

    int strip_gold   = TRUE;
    int strip_invent = TRUE;
    int strip_equip  = TRUE;

    corpseDebug("spawn_corpse_dth for " + GetName(OBJECT_SELF) 
        + " nCorpseDecayType = " + IntToString(nCorpseDecayType) + " bDropWielded = " + IntToString(bDropWielded));

    if (fCorpseDecay > 0.0)
    {
        SetLocalInt(OBJECT_SELF,"CORPSE_DECAY", TRUE);
        //Protect our corpse from decaying
        SetIsDestroyable(FALSE, FALSE, FALSE);

        switch (nCorpseDecayType)
        {
            // Type 0:
            // Inventory Items
            case 0:
                strip_gold  = FALSE;
                strip_invent= FALSE;
            break;

            // Type 1:
            // Inventory & Equipped Items
            case 1:
                strip_gold  = FALSE;
                strip_invent= FALSE;
                strip_equip = FALSE;
            break;

            // Type 2:
            // Inventory Items, if PC Killed
            case 2:
                if (GetIsPC(oKiller) || GetIsPC(GetMaster(oKiller)))
                {
                    strip_gold  = FALSE;
                    strip_invent= FALSE;
                }
            break;

            // Type 3:
            // Inventory & Equipped Items, if PC Killed
            case 3:
                if (GetIsPC(oKiller) || GetIsPC(GetMaster(oKiller)))
                {
                    strip_gold  = FALSE;
                    strip_invent= FALSE;
                    strip_equip = FALSE;
                }
            break;
        }

        corpseDebug("spawn_corpse_dth stripinventory strip_invent = " + IntToString(strip_invent)
                + ", strip_gold = " +  IntToString(strip_gold) + ", strip_equip=" +  IntToString(strip_equip));
        StripInventory(OBJECT_SELF, strip_invent, strip_gold, strip_equip, TRUE);

	// This does not seem to fire - drop wielded is not set
	// Also - not needed because CreateCorpseNodeFromBody will drop items
        //if(bDropWielded && !strip_equip) {
	//	SendMessageToPC(GetFirstPC(), "DEBUG: spawn_corpse_dth calls drop items");
        //		DropItems(OBJECT_SELF);
        //}

            // TODO - only if persistent corpse? - moved this into CreateCiroseNodeFromBody where we know the type.
        //string pcid = GetPCID(OBJECT_SELF);
        //CreatePersistentInventory("INV_CORPSE_"+pcid, OBJECT_SELF, pcid, FALSE);

        // this has to be wrong... i think it probably needs to be after.
        // cleanup the corpse since it is no longer a holder
        //StripInventory(OBJECT_SELF,TRUE,TRUE,FALSE,TRUE);

        oLootCorpse   = CreateCorpseNodeFromBody(OBJECT_SELF, lCorpseLoc, sLootCorpseResRef);

        // the body is already here, so there is no need to create it
        // however body and corpse node point to one another
        SetLocalObject(oLootCorpse, "CORPSE_BODY", OBJECT_SELF);
        SetLocalObject(OBJECT_SELF, "CORPSE_NODE", oLootCorpse);

	// TODO - look at this.
        if(!strip_equip)
            CorpseDress(OBJECT_SELF, oLootCorpse, FALSE);

        // Set Corpse to Decay
        DelayCommand(fCorpseDecay - 0.1, SetLocalInt(OBJECT_SELF, "DecayTimerExpired", TRUE));
        DelayCommand(fCorpseDecay, ExecuteScript("spawn_corpse_dcy", OBJECT_SELF));
    }
}
