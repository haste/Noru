-- This is just a quick add-on to handle mounting across my chars. I don't
-- really plan on doing anything special with it, or extend it beyond what it
-- currently does.

local addon = CreateFrame'Frame'
local player = {}

local mounts = {
	flying = {
		-- 310
		{
			40192,59976,58615,64927,44744,32345,60021,63963,37015,49193
		},
		-- 280
		{
			60025,63844,61230,61229,59567,41514,59650,61996,59568,59996,
			39803,59569,43927,41515,61294,39798,61309,41513,41516,39801,
			61997,59570,59961,39800,39802,32242,32290,32295,32292,32297,
			32289,32246,32296,60002,44151,59571,41517,41518,46199
		},
		-- 60
		{
			32244,32239,61451,44153,32235,32245,32240,32243,46197
		},
	},
	ground = {
		-- 100
		{
			60025,43688,16056,63844,61230,60114,60116,61229,40192,59567,
			41514,51412,22719,59650,16055,59976,26656,17461,60118,60119,
			48027,22718,59785,59788,22720,22721,22717,22723,22724,61996,
			59568,59996,39803,64656,59569,58615,43927,41515,39315,34896,
			39316,34790,63635,63637,64927,63639,36702,63643,17460,23509,
			63638,61465,61467,61469,61470,65637,35713,49379,23249,65641,
			23248,35712,35714,23247,18991,61294,39798,17465,59797,59799,
			17459,63636,17450,61309,55531,60424,44744,16084,41513,63640,
			16082,32345,60021,41516,39801,23246,41252,61997,59570,59961,
			39800,22722,16080,17481,63963,39802,39317,34898,63642,23510,
			63232,32242,23241,43900,23238,23229,23250,65646,23221,23239,
			65640,23252,32290,35025,23225,32295,23219,65638,37015,23242,
			23243,23227,33660,32292,35027,65644,32297,24242,32289,65639,
			32246,42777,23338,23251,65643,35028,46628,23223,23240,23228,
			23222,32296,49322,24252,39318,34899,18992,63641,60002,61425,
			61447,44151,65642,59571,49193,41517,41518,15779,54753,39319,
			65645,16083,34897,16081,17229,59791,59793,46199
		},
		-- 60
		{
			35022,64977,470,64658,35020,10969,17463,32244,43899,34406,
			458,18990,6899,17464,6654,6648,6653,32239,8395,61451,44153,
			32235,35710,18989,6777,17453,32245,472,35711,35018,34795,
			10873,17462,32240,42776,10789,8394,10793,32243,580,10796,
			17454,10799,64657,6898,46197
		},
		-- 0
		{
			30174
		},
	},
	aq40 = {
		-- 100
		{
			25953,26056,26054,26055
		},
	},
}


addon:SetScript('OnEvent', function()
	local list = {}
	for i=1, GetNumCompanions'MOUNT' do
		local _, spellName, spellId = GetCompanionInfo('MOUNT', i)
		list[spellId] = spellName
	end

	for type, skill in pairs(mounts) do
		for _, data in ipairs(skill) do
			local done
			for _, mount in ipairs(data) do
				if(list[mount]) then
					if(not player[type]) then player[type] = {} end
					table.insert(player[type], list[mount])
					done = true
				end
			end

			if(done) then break end
		end
	end
end)
addon:RegisterEvent'PLAYER_LOGIN'

SlashCmdList['NORU_MOUNT'] = function()
	if(not IsMounted() and not InCombatLockdown()) then
		local flying = player.flying
		local ground = player.ground
		if(IsFlyableArea() and (GetRealZoneText() ~= 'Dalaran' or GetMinimapZoneText() == "Krasus' Landing") and GetZoneText() ~= 'Wintergrasp' and flying) then
			CastSpellByName(flying[math.random(#flying)])
		elseif(ground) then
			CastSpellByName(ground[math.random(#ground)])
		end
	else
		Dismount()
	end
end
SLASH_NORU_MOUNT1 = '/mount'
SLASH_NORU_MOUNT2 = '/noru'
