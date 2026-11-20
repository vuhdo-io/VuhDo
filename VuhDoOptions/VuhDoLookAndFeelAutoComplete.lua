local _;

local strlower = string.lower;
local strsub = string.sub;
local strfind = string.find;
local strmatch = string.match;
local strtrim = strtrim;
local type = type;
local tinsert = table.insert;
local tsort = table.sort;
local twipe = table.wipe;
local pairs = pairs;
local ipairs = ipairs;
local tonumber = tonumber;
local tostring = tostring;
local strlen = string.len;
local format = string.format;
local max = math.max;
local band = bit.band;
local bor = bit.bor;
local lshift = bit.lshift;
local rshift = bit.rshift;
local InCombatLockdown = InCombatLockdown;

local GetNumSpellBookSkillLines = C_SpellBook.GetNumSpellBookSkillLines;
local GetSpellBookSkillLineInfo = C_SpellBook.GetSpellBookSkillLineInfo;
local GetSpellBookItemInfo = C_SpellBook.GetSpellBookItemInfo;
local GetSpellTexture = GetSpellTexture or C_Spell.GetSpellTexture;
local SpellBookSpellBank = Enum.SpellBookSpellBank;
local SpellBookItemType = Enum.SpellBookItemType;
local GetMacroInfo = GetMacroInfo;

VUHDO_LF_AUTOCOMPLETE_SPELLS = 1;
VUHDO_LF_AUTOCOMPLETE_AURAS = 2;
VUHDO_LF_AUTOCOMPLETE_ACTIONS = 3;
VUHDO_LF_AUTOCOMPLETE_HOSTILE_ACTIONS = 4;

local VUHDO_LF_AUTOCOMPLETE_MIN_LEN = 2;
local VUHDO_LF_AUTOCOMPLETE_MAX_RESULTS = 10;
local VUHDO_LF_AUTOCOMPLETE_MAX_MACRO_INDEX = 150;
local VUHDO_LF_AUTOCOMPLETE_ROW_HEIGHT = 20;
local VUHDO_LF_AUTOCOMPLETE_FALLBACK_ICON = 134400;

local VUHDO_AURA_LIST_ENTRY_SPELL;
local VUHDO_AURA_GROUP_TYPE_LIST;
local VUHDO_AURA_GROUP_TYPE_FILTER;
local VUHDO_BOUQUET_BUFFS_SPECIAL;

local VUHDO_resolveSpellId;
local VUHDO_getGlobalIcon;
local VUHDO_decompressIfCompressed;

local VUHDO_PixelUtil;

local sEmpty = { };
local sProviderStates = { };
local sPopup;
local sRows = { };
local sActiveEditBox;
local sSelectedIndex;
local sShownResults = { };
local sShownCount;
local sIsInitialized;
local sLowerFocusText;
local sFriendlyCommands = { };
local sHostileCommands = { };



do
	--
	function VUHDO_lnfAutoCompleteInitLocalOverrides()

		VUHDO_AURA_LIST_ENTRY_SPELL = _G["VUHDO_AURA_LIST_ENTRY_SPELL"];
		VUHDO_AURA_GROUP_TYPE_LIST = _G["VUHDO_AURA_GROUP_TYPE_LIST"];
		VUHDO_AURA_GROUP_TYPE_FILTER = _G["VUHDO_AURA_GROUP_TYPE_FILTER"];
		VUHDO_BOUQUET_BUFFS_SPECIAL = _G["VUHDO_BOUQUET_BUFFS_SPECIAL"];

		VUHDO_resolveSpellId = _G["VUHDO_resolveSpellId"];
		VUHDO_getGlobalIcon = _G["VUHDO_getGlobalIcon"];
		VUHDO_decompressIfCompressed = _G["VUHDO_decompressIfCompressed"];

		VUHDO_PixelUtil = _G["VUHDO_PixelUtil"];

		twipe(sFriendlyCommands);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_ASSIST"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_FOCUS"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_TARGET"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_EXTRAACTIONBUTTON"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_MENU"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_TELL"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_DROPDOWN"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_MOUSELOOK"]);
		tinsert(sFriendlyCommands, _G["VUHDO_SPELL_KEY_PING"]);

		twipe(sHostileCommands);
		tinsert(sHostileCommands, _G["VUHDO_SPELL_KEY_ASSIST"]);
		tinsert(sHostileCommands, _G["VUHDO_SPELL_KEY_FOCUS"]);
		tinsert(sHostileCommands, _G["VUHDO_SPELL_KEY_TARGET"]);
		tinsert(sHostileCommands, _G["VUHDO_SPELL_KEY_EXTRAACTIONBUTTON"]);
		tinsert(sHostileCommands, _G["VUHDO_SPELL_KEY_MOUSELOOK"]);
		tinsert(sHostileCommands, _G["VUHDO_SPELL_KEY_PING"]);

		return;

	end
end



do
	--
	local tState;
	function VUHDO_lnfAutoCompleteEnsureProviderState(aProviderId)

		tState = sProviderStates[aProviderId];

		if not tState then
			tState = {
				["keys"] = { },
				["entries"] = { },
				["rangeByPrefix"] = { },
				["isDirty"] = true,
			};

			sProviderStates[aProviderId] = tState;
		end

		return tState;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteMarkDirty()

		for tProviderId = VUHDO_LF_AUTOCOMPLETE_SPELLS, VUHDO_LF_AUTOCOMPLETE_HOSTILE_ACTIONS do
			VUHDO_lnfAutoCompleteEnsureProviderState(tProviderId);

			sProviderStates[tProviderId]["isDirty"] = true;
		end

		return;

	end
end



do
	--
	local tSearchKeys;
	local tSpacePos;
	local tSuffix;
	function VUHDO_lnfAutoCompleteGetSearchKeys(aLowerText)

		tSearchKeys = { aLowerText };

		tSpacePos = 1;

		while true do
			_, tSpacePos = strfind(aLowerText, " ", tSpacePos, true);

			if not tSpacePos then
				break;
			end

			tSuffix = strsub(aLowerText, tSpacePos + 1);

			if tSuffix ~= "" and not strfind(tSuffix, "^[%d%p]") then
				tinsert(tSearchKeys, tSuffix);
			end

			tSpacePos = tSpacePos + 1;
		end

		return tSearchKeys;

	end
end



do
	--
	local tRank;
	function VUHDO_lnfAutoCompleteParseRank(aSubName)

		if not aSubName or aSubName == "" then
			return;
		end

		tRank = tonumber(strmatch(aSubName, "(%d+)$"));

		if not tRank then
			return;
		end

		return tRank;

	end
end



do
	--
	local tEntry;
	function VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, aDisplay, aBracketText, aPlainText, aSpellId, aName, anIcon, aLowerText, aRank)

		if aSeenTexts[aPlainText] then
			return;
		end

		aSeenTexts[aPlainText] = true;

		tEntry = {
			["display"] = aDisplay,
			["bracketText"] = aBracketText,
			["plainText"] = aPlainText,
			["spellId"] = aSpellId,
			["name"] = aName,
			["icon"] = anIcon,
			["rank"] = aRank,
		};

		for _, tSearchKey in ipairs(VUHDO_lnfAutoCompleteGetSearchKeys(aLowerText)) do
			tinsert(aKeyedEntries, { tSearchKey, tEntry });
		end

		return tEntry;

	end
end



do
	--
	local tSpellId;
	local tSpellName;
	local tDisplay;
	function VUHDO_lnfAutoCompleteAddIdOrName(aSeenTexts, aKeyedEntries, anIdOrName)

		tSpellId = tonumber(anIdOrName);

		if tSpellId then
			tSpellName = VUHDO_resolveSpellId(tSpellId);

			if type(tSpellName) == "string" then
				tDisplay = "[" .. tSpellId .. "] " .. tSpellName;
			else
				tDisplay = tostring(tSpellId);

				tSpellName = tDisplay;
			end
		else
			tSpellName = tostring(anIdOrName);

			tDisplay = tSpellName;
		end

		VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, tDisplay, tDisplay, tSpellName, tSpellId, tSpellName, nil, strlower(tSpellName));

		return;

	end
end



do
	--
	local tSkillLineInfo;
	local tItemIndexOffset;
	local tNumSpellBookItems;
	local tSpellBookItemInfo;
	local tSubName;
	local tRank;
	local tDisplay;
	function VUHDO_lnfAutoCompleteCollectSpellbookEntries(aSeenTexts, aKeyedEntries)

		for tSkillLineCnt = 1, GetNumSpellBookSkillLines() do
			tSkillLineInfo = GetSpellBookSkillLineInfo(tSkillLineCnt);

			if tSkillLineInfo and not tSkillLineInfo["offSpecID"] then
				tItemIndexOffset = tSkillLineInfo["itemIndexOffset"];
				tNumSpellBookItems = tSkillLineInfo["numSpellBookItems"];

				for tSlot = tItemIndexOffset + 1, tItemIndexOffset + tNumSpellBookItems do
					tSpellBookItemInfo = GetSpellBookItemInfo(tSlot, SpellBookSpellBank.Player);

					if tSpellBookItemInfo and SpellBookItemType.Spell == tSpellBookItemInfo["itemType"] and tSpellBookItemInfo["name"] and not tSpellBookItemInfo["isPassive"] then
						tSubName = tSpellBookItemInfo["subName"];
						tRank = VUHDO_lnfAutoCompleteParseRank(tSubName);

						if tRank then
							tDisplay = tSpellBookItemInfo["name"] .. "(" .. tSubName .. ")";
						else
							tDisplay = tSpellBookItemInfo["name"];
						end

						VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, tDisplay, tDisplay, tDisplay,
							tSpellBookItemInfo["spellID"], tSpellBookItemInfo["name"], tSpellBookItemInfo["iconID"], strlower(tDisplay), tRank);
					end
				end
			end
		end

		return;

	end
end



do
	--
	local tCommand;
	local tDisplay;
	local tEntry;
	function VUHDO_lnfAutoCompleteCollectCommandEntries(aCommands, aSeenTexts, aKeyedEntries)

		for tCnt = 1, #aCommands do
			tCommand = aCommands[tCnt];

			tDisplay = format("%s (%s)", tCommand, VUHDO_I18N_COMMAND);

			tEntry = VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, tDisplay, tCommand, tCommand, nil, tCommand, false, strlower(tCommand));

			if tEntry then
				tEntry["isIconless"] = true;
			end
		end

		return;

	end
end



do
	--
	local tMacroName;
	local tMacroIcon;
	local tDisplay;
	function VUHDO_lnfAutoCompleteCollectMacroEntries(aSeenTexts, aKeyedEntries)

		for tMacroIdx = 1, VUHDO_LF_AUTOCOMPLETE_MAX_MACRO_INDEX do
			tMacroName, tMacroIcon = GetMacroInfo(tMacroIdx);

			if tMacroName then
				tDisplay = format("%s (%s)", tMacroName, VUHDO_I18N_MACRO);

				VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, tDisplay, tMacroName, tMacroName, nil, tMacroName, tMacroIcon, strlower(tMacroName));
			end
		end

		return;

	end
end



do
	--
	local tValue;
	local tSpellId;
	local tSpellName;
	local tDisplay;
	function VUHDO_lnfAutoCompleteCollectAuraGroupEntries(aGroups, aSeenTexts, aKeyedEntries)

		for _, tGroup in pairs(aGroups) do
			if (tGroup["type"] or 1) == VUHDO_AURA_GROUP_TYPE_LIST and tGroup["entries"] then
				for _, tListEntry in ipairs(tGroup["entries"]) do
					if (tListEntry["entryType"] or 0) == VUHDO_AURA_LIST_ENTRY_SPELL and tListEntry["value"] then
						tValue = tListEntry["value"];
						tSpellId = tonumber(tValue);

						if tSpellId then
							tSpellName = VUHDO_resolveSpellId(tSpellId);

							if type(tSpellName) == "string" then
								tDisplay = "[" .. tSpellId .. "] " .. tSpellName;

								VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, tDisplay, tDisplay, tSpellName, tSpellId, tSpellName, nil, strlower(tSpellName));
							end
						elseif type(tValue) == "string" then
							tSpellName = tValue;
							tDisplay = tSpellName;

							VUHDO_lnfAutoCompleteAddEntry(aSeenTexts, aKeyedEntries, tDisplay, tDisplay, tSpellName, nil, tSpellName, nil, strlower(tSpellName));
						end
					end
				end
			elseif (tGroup["type"] or 1) == VUHDO_AURA_GROUP_TYPE_FILTER and tGroup["ignoreList"] then
				for tIgnoreKey, _ in pairs(tGroup["ignoreList"]) do
					VUHDO_lnfAutoCompleteAddIdOrName(aSeenTexts, aKeyedEntries, tIgnoreKey);
				end
			end
		end

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteCollectIgnoreListEntries(aSeenTexts, aKeyedEntries)

		for tIgnoreKey, _ in pairs(_G["VUHDO_AURA_IGNORE_LIST"] or sEmpty) do
			VUHDO_lnfAutoCompleteAddIdOrName(aSeenTexts, aKeyedEntries, tIgnoreKey);
		end

		return;

	end
end



do
	--
	local tItems;
	local tItem;
	function VUHDO_lnfAutoCompleteCollectBouquetEntries(aSeenTexts, aKeyedEntries)

		for _, tStoredItems in pairs((_G["VUHDO_BOUQUETS"] or sEmpty)["STORED"] or sEmpty) do
			tItems = VUHDO_decompressIfCompressed(tStoredItems);

			for _, tItem in pairs(tItems) do
				if tItem["name"] and not VUHDO_BOUQUET_BUFFS_SPECIAL[tItem["name"]] then
					VUHDO_lnfAutoCompleteAddIdOrName(aSeenTexts, aKeyedEntries, tItem["name"]);
				end
			end
		end

		return;

	end
end



do
	--
	local function VUHDO_lnfAutoCompleteSearchKeySorter(aPair, anotherPair)

		return aPair[1] < anotherPair[1];

	end



	local tPair;
	function VUHDO_lnfAutoCompleteStoreIndex(aState, aKeyedEntries)

		twipe(aState["keys"]);
		twipe(aState["entries"]);
		twipe(aState["rangeByPrefix"]);

		tsort(aKeyedEntries, VUHDO_lnfAutoCompleteSearchKeySorter);

		for tCnt = 1, #aKeyedEntries do
			tPair = aKeyedEntries[tCnt];

			aState["keys"][tCnt] = tPair[1];
			aState["entries"][tCnt] = tPair[2];
		end

		aState["isDirty"] = false;

		return;

	end
end



do
	--
	local tKeyedEntries;
	local tSeenTexts;
	function VUHDO_lnfAutoCompleteBuildSpellIndex(aState)

		if InCombatLockdown() and #aState["keys"] > 0 then
			return;
		end

		tKeyedEntries = { };
		tSeenTexts = { };

		VUHDO_lnfAutoCompleteCollectSpellbookEntries(tSeenTexts, tKeyedEntries);
		VUHDO_lnfAutoCompleteStoreIndex(aState, tKeyedEntries);

		return;

	end
end



do
	--
	local tKeyedEntries;
	local tSeenTexts;
	function VUHDO_lnfAutoCompleteBuildActionIndex(aState, aCommands)

		if InCombatLockdown() and #aState["keys"] > 0 then
			return;
		end

		tKeyedEntries = { };
		tSeenTexts = { };

		VUHDO_lnfAutoCompleteCollectSpellbookEntries(tSeenTexts, tKeyedEntries);
		VUHDO_lnfAutoCompleteCollectCommandEntries(aCommands, tSeenTexts, tKeyedEntries);
		VUHDO_lnfAutoCompleteCollectMacroEntries(tSeenTexts, tKeyedEntries);
		VUHDO_lnfAutoCompleteStoreIndex(aState, tKeyedEntries);

		return;

	end
end



do
	--
	local tKeyedEntries;
	local tSeenTexts;
	local tConfig;
	local tDefaultGroups;
	function VUHDO_lnfAutoCompleteBuildAuraIndex(aState)

		if InCombatLockdown() and #aState["keys"] > 0 then
			return;
		end

		tKeyedEntries = { };
		tSeenTexts = { };

		tDefaultGroups = _G["VUHDO_DEFAULT_AURA_GROUPS"];

		VUHDO_lnfAutoCompleteCollectAuraGroupEntries(tDefaultGroups or sEmpty, tSeenTexts, tKeyedEntries);

		tConfig = _G["VUHDO_CONFIG"];

		if tConfig and tConfig["AURA_GROUPS"] then
			VUHDO_lnfAutoCompleteCollectAuraGroupEntries(tConfig["AURA_GROUPS"], tSeenTexts, tKeyedEntries);
		end

		VUHDO_lnfAutoCompleteCollectIgnoreListEntries(tSeenTexts, tKeyedEntries);
		VUHDO_lnfAutoCompleteCollectBouquetEntries(tSeenTexts, tKeyedEntries);

		VUHDO_lnfAutoCompleteStoreIndex(aState, tKeyedEntries);

		return;

	end
end



do
	--
	local tState;
	function VUHDO_lnfAutoCompleteGetIndex(aProviderId)

		tState = VUHDO_lnfAutoCompleteEnsureProviderState(aProviderId);

		if not tState["isDirty"] and #tState["keys"] > 0 then
			return tState;
		end

		if VUHDO_LF_AUTOCOMPLETE_SPELLS == aProviderId then
			VUHDO_lnfAutoCompleteBuildSpellIndex(tState);
		elseif VUHDO_LF_AUTOCOMPLETE_AURAS == aProviderId then
			VUHDO_lnfAutoCompleteBuildAuraIndex(tState);
		elseif VUHDO_LF_AUTOCOMPLETE_ACTIONS == aProviderId then
			VUHDO_lnfAutoCompleteBuildActionIndex(tState, sFriendlyCommands);
		elseif VUHDO_LF_AUTOCOMPLETE_HOSTILE_ACTIONS == aProviderId then
			VUHDO_lnfAutoCompleteBuildActionIndex(tState, sHostileCommands);
		end

		return tState;

	end
end



do
	--
	local tMid;
	local tMidKey;
	function VUHDO_lnfAutoCompleteBinaryLowerBound(aKeys, aFirst, aLast, aPrefix)

		while aFirst <= aLast do
			tMid = rshift(aFirst + aLast, 1);
			tMidKey = aKeys[tMid];

			if tMidKey < aPrefix then
				aFirst = tMid + 1;
			else
				aLast = tMid - 1;
			end
		end

		return aFirst;

	end
end



do
	--
	local tParentPrefix;
	local tParentPacked;
	local tParentFirst;
	local tParentLast;
	local tKeys;
	local tPrefixLen;
	local tKey;
	local tPacked;
	local tRangeFirst;
	local tRangeLast;
	function VUHDO_lnfAutoCompleteResolvePrefixRange(aState, aPrefix)

		tKeys = aState["keys"];

		if #tKeys < 1 then
			return;
		end

		tPacked = aState["rangeByPrefix"][aPrefix];

		if tPacked then
			if 0 == tPacked then
				return;
			end

			return rshift(tPacked, 16), band(tPacked, 0xFFFF);
		end

		if strlen(aPrefix) > VUHDO_LF_AUTOCOMPLETE_MIN_LEN then
			tParentPrefix = strsub(aPrefix, 1, -2);
			tParentPacked = aState["rangeByPrefix"][tParentPrefix];

			if 0 == tParentPacked then
				aState["rangeByPrefix"][aPrefix] = 0;

				return;
			elseif tParentPacked then
				tParentFirst = rshift(tParentPacked, 16);
				tParentLast = band(tParentPacked, 0xFFFF);
			else
				tParentFirst, tParentLast = VUHDO_lnfAutoCompleteResolvePrefixRange(aState, tParentPrefix);
			end
		else
			tParentFirst = 1;
			tParentLast = #tKeys;
		end

		if not tParentFirst then
			aState["rangeByPrefix"][aPrefix] = 0;

			return;
		end

		tPrefixLen = strlen(aPrefix);

		tRangeFirst = VUHDO_lnfAutoCompleteBinaryLowerBound(tKeys, tParentFirst, tParentLast, aPrefix);

		tRangeLast = tRangeFirst;

		while tRangeLast <= tParentLast do
			tKey = tKeys[tRangeLast];

			if strsub(tKey, 1, tPrefixLen) ~= aPrefix then
				break;
			end

			tRangeLast = tRangeLast + 1;
		end

		if tRangeFirst > tParentLast or strsub(tKeys[tRangeFirst] or "", 1, tPrefixLen) ~= aPrefix then
			tPacked = 0;
		else
			tPacked = bor(lshift(tRangeFirst, 16), tRangeLast - 1);
		end

		aState["rangeByPrefix"][aPrefix] = tPacked;

		if 0 == tPacked then
			return;
		end

		return tRangeFirst, tRangeLast - 1;

	end
end



do
	--
	local tLowerPlainText;
	function VUHDO_lnfAutoCompleteIsOwnTextEntry(anEntry, aPrefix)

		if anEntry["spellId"] then
			return false;
		end

		tLowerPlainText = anEntry["lowerPlainText"];

		if not tLowerPlainText then
			tLowerPlainText = strlower(anEntry["plainText"] or "");
			anEntry["lowerPlainText"] = tLowerPlainText;
		end

		if tLowerPlainText == sLowerFocusText or tLowerPlainText == aPrefix then
			return true;
		end

		return false;

	end
end



do
	--
	local sSeenDisplays = { };

	local function VUHDO_lnfAutoCompleteShownResultSorter(anEntry, anotherEntry)

		if anEntry["name"] == anotherEntry["name"] then
			return (anEntry["rank"] or 0) < (anotherEntry["rank"] or 0);
		end

		return anEntry["display"] < anotherEntry["display"];

	end



	local tFirst;
	local tLast;
	local tEntry;
	local tResultCount;
	function VUHDO_lnfAutoCompleteFillResults(aState, aPrefix, aResults)

		twipe(aResults);
		twipe(sSeenDisplays);

		tFirst, tLast = VUHDO_lnfAutoCompleteResolvePrefixRange(aState, aPrefix);

		if not tFirst then
			return 0;
		end

		tResultCount = 0;

		for tKeyIdx = tFirst, tLast do
			if tResultCount >= VUHDO_LF_AUTOCOMPLETE_MAX_RESULTS then
				break;
			end

			tEntry = aState["entries"][tKeyIdx];

			if tEntry and not sSeenDisplays[tEntry["display"]] and not VUHDO_lnfAutoCompleteIsOwnTextEntry(tEntry, aPrefix) then
				sSeenDisplays[tEntry["display"]] = true;

				tResultCount = tResultCount + 1;

				aResults[tResultCount] = tEntry;
			end
		end

		if tResultCount > 1 then
			tsort(aResults, VUHDO_lnfAutoCompleteShownResultSorter);
		end

		return tResultCount;

	end
end



do
	--
	local tIcon;
	function VUHDO_lnfAutoCompleteResolveEntryIcon(anEntry)

		if anEntry["icon"] ~= nil then
			return anEntry["icon"] or VUHDO_LF_AUTOCOMPLETE_FALLBACK_ICON;
		end

		tIcon = nil;

		if anEntry["spellId"] then
			tIcon = GetSpellTexture(anEntry["spellId"]);
		end

		if not tIcon and anEntry["name"] then
			tIcon = GetSpellTexture(anEntry["name"]);
		end

		if not tIcon then
			tIcon = VUHDO_getGlobalIcon(tostring(anEntry["spellId"] or anEntry["name"] or ""));
		end

		if tIcon == "" or not tIcon then
			anEntry["icon"] = false;

			return VUHDO_LF_AUTOCOMPLETE_FALLBACK_ICON;
		end

		anEntry["icon"] = tIcon;

		return tIcon;

	end
end



do
	--
	local tState;
	function VUHDO_lnfAutoCompleteQuery(aProviderId, aPrefix, aResults)

		tState = VUHDO_lnfAutoCompleteGetIndex(aProviderId);

		return VUHDO_lnfAutoCompleteFillResults(tState, strlower(strtrim(aPrefix or "")), aResults);

	end
end



do
	--
	local tIconFrame;
	function VUHDO_lnfAutoCompleteSetRowHighlight(aRow, anIsHighlighted)

		tIconFrame = aRow["vuhdoAutoCompleteIconFrame"];

		aRow["vuhdoAutoCompleteIsHighlighted"] = anIsHighlighted;

		if anIsHighlighted then
			aRow:SetBackdropColor(0.8, 0.8, 1, 1);

			tIconFrame:SetScale(2);
			VUHDO_PixelUtil.SetPoint(tIconFrame, "RIGHT", aRow:GetName(), "RIGHT", -10, 0);
		else
			aRow:SetBackdropColor(1, 1, 1, 1);

			tIconFrame:SetScale(1);
			VUHDO_PixelUtil.SetPoint(tIconFrame, "RIGHT", aRow:GetName(), "RIGHT", -6, 0);
		end

		return;

	end
end



do
	--
	local tRow;
	local tLabel;
	local tIconFrame;
	local tIconTexture;
	local tTexture;
	local tEntry;
	function VUHDO_lnfAutoCompleteRefreshPopup()

		for tCnt = 1, VUHDO_LF_AUTOCOMPLETE_MAX_RESULTS do
			tRow = sRows[tCnt];

			if tCnt <= sShownCount then
				VUHDO_lnfAutoCompleteSetRowHighlight(tRow, tCnt == sSelectedIndex);

				tRow:Show();
			else
				VUHDO_lnfAutoCompleteSetRowHighlight(tRow, false);

				tRow:Hide();
			end
		end

		for tCnt = 1, sShownCount do
			tRow = sRows[tCnt];
			tEntry = sShownResults[tCnt];

			if tRow["vuhdoAutoCompleteEntry"] ~= tEntry then
				tRow["vuhdoAutoCompleteEntry"] = tEntry;

				tLabel = _G[tRow:GetName() .. "LabelLabel"];
				tIconFrame = tRow["vuhdoAutoCompleteIconFrame"];
				tIconTexture = _G[tRow:GetName() .. "IconTexture"];

				tLabel:SetText(tEntry["display"]);

				if tEntry["isIconless"] then
					tIconFrame:SetShown(false);
				else
					tIconFrame:SetShown(true);

					tTexture = VUHDO_lnfAutoCompleteResolveEntryIcon(tEntry);

					if tIconTexture:GetTexture() ~= tTexture then
						tIconTexture:SetTexture(tTexture);
						tIconTexture:SetTexCoord(0, 1, 0, 1);
					end
				end
			end
		end

		VUHDO_PixelUtil.SetHeight(sPopup, sShownCount * VUHDO_LF_AUTOCOMPLETE_ROW_HEIGHT + 4);
		sPopup:Show();

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteHide()

		sPopup:Hide();

		sActiveEditBox = nil;
		sShownCount = 0;
		sSelectedIndex = 0;

		return;

	end
end



do
	--
	local tEntry;
	local tInsertText;
	function VUHDO_lnfAutoCompleteAcceptSelection(anEditBox, anIndex)

		if anIndex < 1 or anIndex > sShownCount then
			return false;
		end

		tEntry = sShownResults[anIndex];

		if anEditBox["vuhdoAutoCompleteIsPlainInsert"] then
			tInsertText = tEntry["plainText"];
		else
			tInsertText = tEntry["bracketText"];
		end

		anEditBox:SetText(tInsertText);
		VUHDO_lnfAutoCompleteHide();

		return true;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteMoveSelection(aDelta)

		if sShownCount < 1 then
			return;
		end

		sSelectedIndex = sSelectedIndex + aDelta;

		if sSelectedIndex < 1 then
			sSelectedIndex = sShownCount;
		elseif sSelectedIndex > sShownCount then
			sSelectedIndex = 1;
		end

		VUHDO_lnfAutoCompleteRefreshPopup();

		return;

	end
end



do
	--
	local tText;
	function VUHDO_lnfAutoCompleteUpdatePopup(anEditBox)

		if anEditBox ~= sActiveEditBox then
			return;
		end

		tText = strtrim(anEditBox:GetText() or "");

		if strlen(tText) < VUHDO_LF_AUTOCOMPLETE_MIN_LEN or tonumber(tText) then
			VUHDO_lnfAutoCompleteHide();

			return;
		end

		sShownCount = VUHDO_lnfAutoCompleteQuery(anEditBox["vuhdoAutoCompleteProvider"], tText, sShownResults);

		if sShownCount < 1 then
			VUHDO_lnfAutoCompleteHide();

			return;
		end

		if sSelectedIndex < 1 or sSelectedIndex > sShownCount then
			sSelectedIndex = 1;
		end

		sActiveEditBox = anEditBox;

		VUHDO_PixelUtil.SetScale(sPopup, anEditBox:GetEffectiveScale() / UIParent:GetEffectiveScale());

		sPopup:ClearAllPoints();
		VUHDO_PixelUtil.SetPoint(sPopup, "TOPLEFT", anEditBox:GetName(), "BOTTOMLEFT", 0, -2);
		VUHDO_PixelUtil.SetWidth(sPopup, max(280, anEditBox:GetWidth() + 60));

		VUHDO_lnfAutoCompleteRefreshPopup();

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteOnTextChanged(anEditBox, anIsUserInput)

		if anIsUserInput then
			sActiveEditBox = anEditBox;
			sSelectedIndex = 1;

			VUHDO_lnfAutoCompleteUpdatePopup(anEditBox);
		end

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteOnEditFocusGained(anEditBox)

		sActiveEditBox = anEditBox;

		sLowerFocusText = strlower(strtrim(anEditBox:GetText() or ""));

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteOnEditFocusLost(anEditBox)

		if sActiveEditBox == anEditBox and not (sPopup:IsShown() and sPopup:IsMouseOver()) then
			VUHDO_lnfAutoCompleteHide();
		end

		return;

	end
end



do
	--
	local tOrigHandler;
	function VUHDO_lnfAutoCompleteOnEnterPressed(anEditBox)

		if sActiveEditBox == anEditBox and sShownCount > 0 and VUHDO_lnfAutoCompleteAcceptSelection(anEditBox, sSelectedIndex) then
			return;
		end

		tOrigHandler = anEditBox["vuhdoAutoCompleteOrigEnter"];

		if tOrigHandler then
			tOrigHandler(anEditBox);
		end

		return;

	end
end



do
	--
	local tOrigHandler;
	function VUHDO_lnfAutoCompleteOnTabPressed(anEditBox)

		if sActiveEditBox == anEditBox and sShownCount > 0 and VUHDO_lnfAutoCompleteAcceptSelection(anEditBox, sSelectedIndex) then
			return;
		end

		tOrigHandler = anEditBox["vuhdoAutoCompleteOrigTab"];

		if tOrigHandler then
			tOrigHandler(anEditBox);
		end

		return;

	end
end



do
	--
	local tOrigHandler;
	function VUHDO_lnfAutoCompleteOnArrowPressed(anEditBox, aKey)

		if sActiveEditBox == anEditBox and sShownCount > 0 then
			if "UP" == aKey then
				VUHDO_lnfAutoCompleteMoveSelection(-1);

				return;
			elseif "DOWN" == aKey then
				VUHDO_lnfAutoCompleteMoveSelection(1);

				return;
			end
		end

		tOrigHandler = anEditBox["vuhdoAutoCompleteOrigArrow"];

		if tOrigHandler then
			tOrigHandler(anEditBox, aKey);
		end

		return;

	end
end



do
	--
	local tOrigHandler;
	function VUHDO_lnfAutoCompleteOnEscapePressed(anEditBox)

		if sActiveEditBox == anEditBox and sShownCount > 0 then
			VUHDO_lnfAutoCompleteHide();

			return;
		end

		tOrigHandler = anEditBox["vuhdoAutoCompleteOrigEscape"];

		if tOrigHandler then
			tOrigHandler(anEditBox);
		end

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompletePopupOnMouseDown()

		if sActiveEditBox then
			sActiveEditBox:SetFocus();
		end

		return;

	end
end



do
	--
	local tRowIndex;
	local tEditBox;
	function VUHDO_lnfAutoCompleteRowOnMouseDown(aRow)

		tRowIndex = aRow["vuhdoAutoCompleteIndex"];
		tEditBox = sActiveEditBox;

		if tEditBox and tRowIndex and VUHDO_lnfAutoCompleteAcceptSelection(tEditBox, tRowIndex) then
			tEditBox:SetFocus();
		end

		return;

	end
end



do
	--
	local tRowIndex;
	function VUHDO_lnfAutoCompleteRowOnEnter(aRow)

		tRowIndex = aRow["vuhdoAutoCompleteIndex"];

		if tRowIndex then
			sSelectedIndex = tRowIndex;

			VUHDO_lnfAutoCompleteRefreshPopup();
		end

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteOnEvent()

		VUHDO_lnfAutoCompleteMarkDirty();

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteAttach(anEditBox, aProviderId, anIsPlainInsert)

		if anEditBox["vuhdoAutoCompleteIsAttached"] then
			return;
		end

		VUHDO_lnfAutoCompleteInit();

		anEditBox["vuhdoAutoCompleteIsAttached"] = true;
		anEditBox["vuhdoAutoCompleteProvider"] = aProviderId;
		anEditBox["vuhdoAutoCompleteIsPlainInsert"] = anIsPlainInsert and true or false;

		anEditBox["vuhdoAutoCompleteOrigEnter"] = anEditBox:GetScript("OnEnterPressed");
		anEditBox["vuhdoAutoCompleteOrigTab"] = anEditBox:GetScript("OnTabPressed");
		anEditBox["vuhdoAutoCompleteOrigArrow"] = anEditBox:GetScript("OnArrowPressed");
		anEditBox["vuhdoAutoCompleteOrigEscape"] = anEditBox:GetScript("OnEscapePressed");

		anEditBox:SetScript("OnEnterPressed", VUHDO_lnfAutoCompleteOnEnterPressed);
		anEditBox:SetScript("OnTabPressed", VUHDO_lnfAutoCompleteOnTabPressed);
		anEditBox:SetScript("OnArrowPressed", VUHDO_lnfAutoCompleteOnArrowPressed);
		anEditBox:SetScript("OnEscapePressed", VUHDO_lnfAutoCompleteOnEscapePressed);

		anEditBox:HookScript("OnTextChanged", VUHDO_lnfAutoCompleteOnTextChanged);
		anEditBox:HookScript("OnEditFocusGained", VUHDO_lnfAutoCompleteOnEditFocusGained);
		anEditBox:HookScript("OnEditFocusLost", VUHDO_lnfAutoCompleteOnEditFocusLost);

		anEditBox:SetAltArrowKeyMode(false);

		return;

	end
end



do
	--
	local tRowName;
	function VUHDO_lnfAutoCompleteInitPopup()

		sPopup = VuhDoAutoCompletePopup;
		sPopup:SetFrameStrata("TOOLTIP");
		sPopup:SetClampedToScreen(true);

		sPopup:ApplyBackdrop();
		sPopup:SetScript("OnMouseDown", VUHDO_lnfAutoCompletePopupOnMouseDown);

		for tCnt = 1, VUHDO_LF_AUTOCOMPLETE_MAX_RESULTS do
			tRowName = sPopup:GetName() .. "Row" .. tCnt;

			sRows[tCnt] = CreateFrame("Button", tRowName, sPopup, "VuhDoAutoCompleteRowTemplate");

			VUHDO_PixelUtil.SetPoint(sRows[tCnt], "TOPLEFT", sPopup:GetName(), "TOPLEFT", 2, -2 - (tCnt - 1) * VUHDO_LF_AUTOCOMPLETE_ROW_HEIGHT);
			VUHDO_PixelUtil.SetPoint(sRows[tCnt], "TOPRIGHT", sPopup:GetName(), "TOPRIGHT", -2, -2 - (tCnt - 1) * VUHDO_LF_AUTOCOMPLETE_ROW_HEIGHT);

			sRows[tCnt]:SetScript("OnMouseDown", VUHDO_lnfAutoCompleteRowOnMouseDown);
			sRows[tCnt]:SetScript("OnEnter", VUHDO_lnfAutoCompleteRowOnEnter);

			sRows[tCnt]["vuhdoAutoCompleteIndex"] = tCnt;
			sRows[tCnt]["skinAutoCompleteRow"] = true;
			sRows[tCnt]["vuhdoAutoCompleteIconFrame"] = _G[tRowName .. "Icon"];
		end

		return;

	end
end



do
	--
	local sEventFrame;
	function VUHDO_lnfAutoCompleteInitEvents()

		sEventFrame = CreateFrame("Frame");

		sEventFrame:RegisterEvent("SPELLS_CHANGED");
		sEventFrame:RegisterEvent("LEARNED_SPELL_IN_SKILL_LINE");
		sEventFrame:RegisterEvent("TRAIT_CONFIG_UPDATED");
		sEventFrame:RegisterEvent("UPDATE_MACROS");

		sEventFrame:SetScript("OnEvent", VUHDO_lnfAutoCompleteOnEvent);

		return;

	end
end



do
	--
	function VUHDO_lnfAutoCompleteInit()

		if sIsInitialized then
			return;
		end

		sIsInitialized = true;

		VUHDO_lnfAutoCompleteInitLocalOverrides();
		VUHDO_lnfAutoCompleteInitPopup();
		VUHDO_lnfAutoCompleteInitEvents();

		return;

	end
end