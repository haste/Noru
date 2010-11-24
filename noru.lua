-- This is just a quick add-on to handle mounting across my chars. I don't
-- really plan on doing anything special with it, or extend it beyond what it
-- currently does.

local addon = CreateFrame'Frame'
local player = {}

local oldworld = function()
	local c = GetCurrentMapContinent()
		if (c ~= 3 or c ~= 4 and not IsSpellKnown(90269)) then return true end
end

local wg = function()
	local wait = GetWintergraspWaitTime()
	local zone = GetZoneText()
	if (zone == "Wintergrasp") and not wait then return true end
end

local mounts = {
	flying = {
		-- 310
		{
			69395,65439,63963,63956,63796,60024,60021,59976,58615,49193,
			44744,40192,37015,32345,
		},
		-- 280
		{
			66088,66087,63844,61997,61996,61309,61294,61230,61229,60025,
			60002,59996,59961,59650,59571,59570,59569,59568,59567,54729,
			46199,44151,43927,41518,41517,41516,41515,41514,41513,39803,
			39802,39801,39800,39798,32297,32296,32295,32292,32290,32289,
			32246,32242,
		},
		-- 150
		{
			61451,46197,44153,32245,32244,32243,32240,32239,32235,
		},
	},
	ground = {
		-- 100
		{
			68057,68056,67466,66906,66846,66091,66090,65646,65645,65644,
			65643,65642,65641,65640,65639,65638,65637,64659,64656,63643,
			63642,63641,63640,63639,63638,63637,63636,63635,63232,61470,
			61469,61467,61465,61447,61425,60424,60119,60118,60116,60114,
			59799,59797,59793,59791,59788,59785,55531,54753,51412,49379,
			49322,48778,48027,46628,43900,43688,42777,41252,39319,39318,
			39317,39316,39315,36702,35714,35713,35712,35028,35027,35025,
			34899,34898,34897,34896,34790,34767,33660,26656,24252,24242,
			23510,23509,23338,23252,23251,23250,23249,23248,23247,23246,
			23243,23242,23241,23240,23239,23238,23229,23228,23227,23225,
			23223,23222,23221,23219,23214,23161,22724,22723,22722,22721,
			22720,22719,22718,22717,18992,18991,17481,17465,17461,17460,
			17459,17450,17229,16084,16083,16082,16081,16080,16056,16055,
			15779,
		},
		-- 60
		{
			66847,64977,64658,64657,43899,42776,35711,35710,35022,35020,
			35018,34795,34769,34406,18990,18989,17464,17463,17462,17454,
			17453,13819,10969,10873,10799,10796,10793,10789,8395,8394,
			6899,6898,6777,6654,6653,6648,5784,580,472,470,458,
		},
		-- 0
		{
			46109,30174,
		},
	},
	aq40 = {
		-- 100
		{
			26056,26055,26054,25953,
		},
	},
}
-- Flying/Ground/AQ40: 65 / 173 / 4.

addon:SetScript('OnEvent', function(self, event, type)
	if(type) then return end

	local list = {}

	table.wipe(player)

	for i=1, GetNumCompanions'MOUNT' do
		local _, _, spellId = GetCompanionInfo('MOUNT', i)
		list[spellId] = i
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
addon:RegisterEvent'COMPANION_UPDATE'
addon:RegisterEvent'PLAYER_LOGIN'

SlashCmdList['NORU_MOUNT'] = function()
	if(not IsMounted() and not InCombatLockdown()) then
		local flying = player.flying
		local ground = player.ground
		if(IsFlyableArea() and flying and not wg() and not oldworld()) then
			CallCompanion('MOUNT', flying[math.random(#flying)])
		elseif(ground) then
			CallCompanion('MOUNT', ground[math.random(#ground)])
		end
	else
		Dismount()
	end
end
SLASH_NORU_MOUNT1 = '/mount'
SLASH_NORU_MOUNT2 = '/noru'
