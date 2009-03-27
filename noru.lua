-- This is just a quick add-on to handle mounting across my chars. I don't
-- really plan on doing anything special with it, or extend it beyond what it
-- currently does.

local addon = CreateFrame'Frame'
local player = {}

local mounts = {
	ground = {
		-- 100
		{
			23214,34767,23161,43688,16056,60114,60116,51412,58983,22719,16055,59572,
			17461,60118,60119,48027,22718,59785,59788,22720,22721,22717,22723,22724,
			59573,39315,34896,39316,34790,36702,17460,23509,59810,59811,61465,61467,
			60136,60140,59802,59804,61469,61470,35713,49379,23249,34407,23248,35712,
			35714,23247,18991,17465,48025,59797,59799,17459,17450,55531,60424,16084,
			29059,16082,23246,41252,22722,579,16080,17481,39317,34898,23510,23241,
			43900,23238,23229,23250,23220,23221,23239,23252,35025,23225,23219,23242,
			23243,23227,33660,35027,24242,42777,23338,23251,47037,35028,46628,23223,
			23240,23228,23222,48954,49322,24252,39318,34899,18992,61425,61447,42781,
			15779,54753,39319,16083,34897,16081,17229,59791,59793,26656
		},
		-- 60
		{
			13819,34769,5784,35022,6896,470,578,35020,10969,33630,6897,17463,50869,
			43899,50870,49378,34406,458,18990,6899,17464,6654,6648,6653,8395,17458,
			16060,35710,18989,6777,459,15780,17453,10795,10798,471,472,16058,35711,
			35018,17455,17456,34795,10873,17462,18363,8980,42776,10789,15781,8394,
			10793,16059,580,10796,17454,10799,6898,468,581,58983,48025
		},
		-- 0
		{
			30174
		},
	},

	flying = {
		-- 310
		{
			40192,59976,58615,44317,44744,3363,32345,60021,37015,49193,60024
		},
		-- 280
		{
			60025,61230,61229,59567,41514,59650,59568,59996,39803,59569,43927,
			41515,43810,51960,61294,39798,61309,41513,41516,39801,59570,59961,
			39800,39802,32242,32290,32295,61442,32292,32297,32289,32246,61444,
			61446,32296,60002,44151,59571,41517,41518,54729,46199
		},
		-- 60
		{
			32244,32239,61451,44153,32235,32245,32240,32243,46197
		},
	},

	aq40 = {
		-- 100
		{
			25953,26056,26054,26055
		},
	},
}

-- math.randomseed was removed in 3.1.
if(math.randomseed) then math.randomseed(time()) end

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
	if(InCombatLockdown()) then return end
	if(not IsMounted()) then
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
