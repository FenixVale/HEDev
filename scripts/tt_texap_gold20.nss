int StartingConditional()
{
object oPC = GetPCSpeaker();

if (GetGold(oPC) < 20) return FALSE;

return TRUE;
}
