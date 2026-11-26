
-----------------------------------------------------------------------------------
local twipe = table.wipe;
local tinsert = table.insert;
local floor = floor;
local CreateMacro = CreateMacro;
local EditMacro = EditMacro;
local strsub = strsub;
local GetMacroBody = GetMacroBody;
local GetMacroIndexByName = GetMacroIndexByName;
local tonumber = tonumber;
local pairs = pairs;
local GetNumMacros = GetNumMacros;
local InCombatLockdown = InCombatLockdown;
local _;
local format = format;

local VUHDO_RAID;
local VUHDO_CONFIG;
local VUHDO_GROUPS;

local VUHDO_getOrCreateUnitInfo;
local VUHDO_unregisterAllUnitEventFrames;
local VUHDO_utf8Cut;
local VUHDO_initDynamicPanelModels;
local VUHDO_refreshUiNoMembers;
local VUHDO_deferRefreshUiNoMembers;



--
function VUHDO_dcShieldInitLocalOverrides()

	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_GROUPS = _G["VUHDO_GROUPS"];

	VUHDO_getOrCreateUnitInfo = _G["VUHDO_getOrCreateUnitInfo"];
	VUHDO_unregisterAllUnitEventFrames = _G["VUHDO_unregisterAllUnitEventFrames"];
	VUHDO_utf8Cut = _G["VUHDO_utf8Cut"];
	VUHDO_initDynamicPanelModels = _G["VUHDO_initDynamicPanelModels"];
	VUHDO_refreshUiNoMembers = _G["VUHDO_refreshUiNoMembers"];
	VUHDO_deferRefreshUiNoMembers = _G["VUHDO_deferRefreshUiNoMembers"];

	return;

end

-----------------------------------------------------------------------------------



local VUHDO_MAX_PER_CHAR_MACROS = 30;
local VUHDO_MACRO_NAME_GROUPS = "VuhDoDCShieldData";
local VUHDO_MACRO_NAME_NAMES = "VuhDoDCShieldNames";
local VUHDO_EMPTY_SNIPPET = "[x]";
local VUHDO_IS_DC_TEMP_DISABLE = false;


local VUHDO_CLASS_TO_MACRO = {
	[VUHDO_ID_WARRIORS] = "W",
	[VUHDO_ID_ROGUES] = "R",
	[VUHDO_ID_HUNTERS] = "H",
	[VUHDO_ID_PALADINS] = "P",
	[VUHDO_ID_MAGES] = "M",
	[VUHDO_ID_WARLOCKS] = "L",
	[VUHDO_ID_SHAMANS] = "S",
	[VUHDO_ID_DRUIDS] = "D",
	[VUHDO_ID_PRIESTS] = "I",
	[VUHDO_ID_DEATH_KNIGHT] = "E",
	[VUHDO_ID_MONKS] = "O",
	[VUHDO_ID_DEMON_HUNTERS] = "N",
	[VUHDO_ID_EVOKERS] = "V",
};


local VUHDO_MACRO_TO_CLASS = {
	["W"] = VUHDO_ID_WARRIORS,
	["R"] = VUHDO_ID_ROGUES,
	["H"] = VUHDO_ID_HUNTERS,
	["P"] = VUHDO_ID_PALADINS,
	["M"] = VUHDO_ID_MAGES,
	["L"] = VUHDO_ID_WARLOCKS,
	["S"] = VUHDO_ID_SHAMANS,
	["D"] = VUHDO_ID_DRUIDS,
	["I"] = VUHDO_ID_PRIESTS,
	["E"] = VUHDO_ID_DEATH_KNIGHT,
	["O"] = VUHDO_ID_MONKS,
	["N"] = VUHDO_ID_DEMON_HUNTERS,
	["V"] = VUHDO_ID_EVOKERS,
};


local VUHDO_ROLE_TO_MACRO = {
	[VUHDO_ID_MELEE_TANK] = "T",
	[VUHDO_ID_MELEE_DAMAGE] = "M",
	[VUHDO_ID_RANGED_DAMAGE] = "R",
	[VUHDO_ID_RANGED_HEAL] = "H"
};


local VUHDO_MACRO_TO_ROLE = {
	["T"] = VUHDO_ID_MELEE_TANK,
	["M"] = VUHDO_ID_MELEE_DAMAGE,
	["R"] = VUHDO_ID_RANGED_DAMAGE,
	["H"] = VUHDO_ID_RANGED_HEAL
};


local VUHDO_GROUP_SNIPPETS = { };
local VUHDO_NAME_SNIPPETS = { };



--
local tMacroIndex;
local tName;
local tNumChars;
local tNameSnippet;
local function VUHDO_buildSnippetArray()
	for tUnit, tInfo in pairs(VUHDO_RAID) do
		tMacroIndex = ("player" == tUnit or "pet" == tUnit) and 41 or tInfo["number"];

		if (tMacroIndex or 0) > 0 then -- nicht: Target, Focus
			if tInfo["isPet"] then tMacroIndex = tMacroIndex + 41; end -- VUHDO_MAX_MACRO_UNITS

			VUHDO_GROUP_SNIPPETS[tMacroIndex] = format("%01d%s%s",
				(tInfo["group"] or 0) % 10,
				VUHDO_CLASS_TO_MACRO[tInfo["classId"]] or "_",
				VUHDO_ROLE_TO_MACRO[tInfo["role"]] or "_");

			if not tInfo["hasSecretName"] then
				tName = tInfo["name"] or "";
				tNumChars = 3;
				tNameSnippet = VUHDO_utf8Cut(tName, tNumChars);

				while #tNameSnippet > 3 and tNumChars > 0 do
					tNumChars = tNumChars - 1;
					tNameSnippet = VUHDO_utf8Cut(tName, tNumChars);
				end

				while #tNameSnippet < 3 do
					tNameSnippet = tNameSnippet .. "_";
				end

				VUHDO_NAME_SNIPPETS[tMacroIndex] = tNameSnippet;
			end
		end
	end
end



--
local tMacroString, tMacroNames;
local tIndexGroups, tIndexNames;
local tNumMacros;
function VUHDO_mirrorToMacro()
	if VUHDO_IS_DC_TEMP_DISABLE then return; end

	tIndexGroups = GetMacroIndexByName(VUHDO_MACRO_NAME_GROUPS);
	tIndexNames = GetMacroIndexByName(VUHDO_MACRO_NAME_NAMES);

	if VUHDO_CONFIG["IS_DC_SHIELD_DISABLED"] then
		if (tIndexGroups or 0) ~= 0 then DeleteMacro(tIndexGroups); end
		if (tIndexNames or 0) ~= 0 then DeleteMacro(tIndexNames); end
		return;
	end

	tMacroString = VUHDO_GROUP_TYPE_RAID == VUHDO_getCurrentGroupType() and "R" or "P";
	tMacroNames = "N"; -- Filler

	VUHDO_buildSnippetArray();
	for tCnt = 1, 82 do -- VUHDO_MAX_MACRO_UNITS * 2
		tMacroString = tMacroString .. (VUHDO_GROUP_SNIPPETS[tCnt] or VUHDO_EMPTY_SNIPPET);
		tMacroNames = tMacroNames .. (VUHDO_NAME_SNIPPETS[tCnt] or VUHDO_EMPTY_SNIPPET)
	end
	twipe(VUHDO_GROUP_SNIPPETS);
	twipe(VUHDO_NAME_SNIPPETS);

	if (tIndexGroups or 0) == 0 then
		_, tNumMacros = GetNumMacros();
		if (tNumMacros or 0) > (VUHDO_MAX_PER_CHAR_MACROS - 1) then
			VUHDO_Msg(VUHDO_I18N_DC_SHIELD_NO_MACROS);
			VUHDO_IS_DC_TEMP_DISABLE = true;
		else
			CreateMacro(VUHDO_MACRO_NAME_GROUPS, "Ability_Repair", tMacroString, 1, 1);
		end
	else
		EditMacro(tIndexGroups, VUHDO_MACRO_NAME_GROUPS, "Ability_Repair", tMacroString, 1, 1);
	end

	if (tIndexNames or 0) == 0 then
		_, tNumMacros = GetNumMacros();
		if (tNumMacros or 0) > (VUHDO_MAX_PER_CHAR_MACROS - 1) then
			VUHDO_Msg(VUHDO_I18N_DC_SHIELD_NO_MACROS);
			VUHDO_IS_DC_TEMP_DISABLE = true;
		else
			CreateMacro(VUHDO_MACRO_NAME_NAMES, "Ability_Repair", tMacroNames, 1, 1);
		end
	else
		EditMacro(tIndexNames, VUHDO_MACRO_NAME_NAMES, "Ability_Repair", tMacroNames, 1, 1);
	end
end



--
local function VUHDO_buildInfoFromSnippet(aUnit, aSnippet, aName)
	local tInfo;
	local tClassId;

	tInfo = VUHDO_getOrCreateUnitInfo(aUnit);

	tClassId = VUHDO_MACRO_TO_CLASS[strsub(aSnippet, 2, 2)] or VUHDO_ID_PETS;
	tInfo["healthmax"] = 100;
	tInfo["health"] = 100;
	tInfo["name"] = aName or VUHDO_I18N_NOT_AVAILABLE;
	tInfo["number"] = VUHDO_getUnitNo(aUnit);
	tInfo["unit"] = aUnit;
	tInfo["class"] = VUHDO_ID_CLASSES[tClassId];
	tInfo["range"] = true;
	tInfo["debuff"] = 0;
	tInfo["isPet"] = strfind(aUnit, "pet", 1, true) ~= nil;
	tInfo["powertype"] = VUHDO_UNIT_POWER_MANA;
	tInfo["power"] = 100;
	tInfo["powermax"] = 100;
	tInfo["charmed"] = false;
	tInfo["dead"] = false;
	tInfo["connected"] = true;
	tInfo["aggro"] = false;
	tInfo["group"] = tonumber(strsub(aSnippet, 1, 1) or "1") or 1;
	tInfo["afk"] = false;
	tInfo["threat"] = 0;
	tInfo["threatPerc"] = 0;
	tInfo["isVehicle"] = false;
	tInfo["ownerUnit"] = VUHDO_PET_2_OWNER[aUnit];
	tInfo["className"] = "";
	tInfo["petUnit"] = VUHDO_OWNER_2_PET[aUnit];
	tInfo["targetUnit"] = VUHDO_getTargetUnit(aUnit);
	tInfo["classId"] = tClassId;
	tInfo["sortMaxHp"] = 1;
	tInfo["role"] = VUHDO_MACRO_TO_ROLE[strsub(aSnippet, 3, 3)];
	tInfo["fullName"] = tInfo["name"];
	tInfo["raidIcon"] = nil;
	tInfo["visible"] = true;
	tInfo["zone"], tInfo["map"] = "foo", "foo";
	tInfo["baseRange"] = true;
end



--
function VUHDO_buildRaidFromMacro()
	local tIndexGroups;
	local tIndexNames;
	local tMacroGroups;
	local tMacroNames;
	local tStrIdx;
	local tSnippet;
	local tPrefix;
	local tUnit;
	local tName;

	tIndexGroups = GetMacroIndexByName(VUHDO_MACRO_NAME_GROUPS);
	tIndexNames = GetMacroIndexByName(VUHDO_MACRO_NAME_NAMES);

	if (tIndexGroups or 0) == 0 or (tIndexNames or 0) == 0 then return false; end

	twipe(VUHDO_RAID);

	VUHDO_unregisterAllUnitEventFrames();

	tMacroGroups = GetMacroBody(tIndexGroups);
	tMacroNames = GetMacroBody(tIndexNames);

	tSnippet = strsub(tMacroGroups, 1, 1);
	tPrefix = tSnippet == "R" and "raid" or "party";

	for tCnt = 1, 82 do -- VUHDO_MAX_MACRO_UNITS * 2
	  tStrIdx = tCnt * 3 - 1;
		tSnippet = strsub(tMacroGroups, tStrIdx, tStrIdx + 2);
		if (tSnippet or VUHDO_EMPTY_SNIPPET) ~= VUHDO_EMPTY_SNIPPET then

			tUnit = tCnt == 41 and "player"
				or tCnt == 82 and "pet"
				or tCnt > 41 and format("%spet%d", tPrefix, tCnt - 41)
				or tPrefix .. tCnt;

			tName = strsub(tMacroNames, tStrIdx, tStrIdx + 2);
			tName = (tName or ""):gsub("_+$", "");
			VUHDO_buildInfoFromSnippet(tUnit, tSnippet, tName);
		end
	end

	return true;
end



--
local VUHDO_SAFE_PARTY = { "player", "party1", "party2", "party3", "party4" };



--
local function VUHDO_buildSafePartyGroup(aGroupId)

	if not VUHDO_GROUPS[aGroupId] then
		VUHDO_GROUPS[aGroupId] = { };
	end

	twipe(VUHDO_GROUPS[aGroupId]);

	for tCnt = 1, #VUHDO_SAFE_PARTY do
		tinsert(VUHDO_GROUPS[aGroupId], VUHDO_SAFE_PARTY[tCnt]);
	end

	return;

end



--
local tSubtypeId;
local tUnit;
local tGroupId;
function VUHDO_buildSafeParty()

	if InCombatLockdown() then
		return;
	end

	_, _, _, tSubtypeId = GetLFGProposal();

	if LFG_SUBTYPEID_RAID == tSubtypeId then
		for tCnt = 0, 25 do
			tGroupId = floor(tCnt / 5) + 1;
			tUnit = tCnt == 0 and "player" or "raid" .. tCnt;

			if not VUHDO_GROUPS[tGroupId] then
				VUHDO_GROUPS[tGroupId] = { };
			end

			if tCnt % 5 == 0 then
				twipe(VUHDO_GROUPS[tGroupId]);
			end

			tinsert(VUHDO_GROUPS[tGroupId], tUnit);
		end
	else
		VUHDO_buildSafePartyGroup(1); -- VUHDO_ID_GROUP_1
		VUHDO_buildSafePartyGroup(10); -- VUHDO_ID_GROUP_OWN
	end

	VUHDO_initDynamicPanelModels();

	if VUHDO_CONFIG["USE_DEFERRED_REDRAW"] then
		VUHDO_deferRefreshUiNoMembers();
	else
		VUHDO_refreshUiNoMembers();
	end

	return;

end