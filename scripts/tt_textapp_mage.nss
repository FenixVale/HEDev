/*   Script generated by
Lilac Soul's NWN Script Generator, v. 2.3

For download info, please visit:
http://nwvault.ign.com/View.php?view=Other.Detail&id=4683&id=625    */

int StartingConditional()
{
object oPC = GetPCSpeaker();

if ((GetLevelByClass(CLASS_TYPE_WIZARD, oPC)==0)&&
    (GetLevelByClass(CLASS_TYPE_SORCERER, oPC)==0)&&
    (GetLevelByClass(CLASS_TYPE_BARD, oPC)==0)&&
    (GetLevelByClass(CLASS_TYPE_DRUID, oPC)==0))
return FALSE;

return TRUE;
}


