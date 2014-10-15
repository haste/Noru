-- This is just a quick add-on to handle mounting across my chars. I don't
-- really plan on doing anything special with it, or extend it beyond what it
-- currently does.

local addon = CreateFrame'Frame'
local sealegs = GetSpellInfo(76377)

local vashjir = function()
	return IsSwimming() and UnitBuff('player', sealegs)
end

SlashCmdList['NORU_MOUNT'] = function()
	if(not IsMounted() and not InCombatLockdown()) then

		if(vashjir()) then
			CastSpellByName("Abyssal Seahorse")
		elseif(not IsFlyableArea() and IsSwimming()) then
			CastSpellByName("Azure Water Strider")
		else
			C_MountJournal.Summon(0)
		end
	else
		Dismount()
	end
end
SLASH_NORU_MOUNT1 = '/mount'
SLASH_NORU_MOUNT2 = '/noru'
