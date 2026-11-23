local _;

local strfind = strfind;
local pairs = pairs;
local twipe = table.wipe;
local format = format;

local GetRaidTargetIndex = GetRaidTargetIndex;
local GetUnitTotalModifiedMaxHealthPercent = GetUnitTotalModifiedMaxHealthPercent;
local UnitExists = UnitExists;
local UnitGetDetailedHealPrediction = UnitGetDetailedHealPrediction;
local CreateUnitHealPredictionCalculator = CreateUnitHealPredictionCalculator;
local UnitHealthPercent = UnitHealthPercent;
local CreateColorCurve = C_CurveUtil and C_CurveUtil.CreateColorCurve;
local CreateColor = CreateColor;
local issecretvalue = issecretvalue;

VUHDO_NAME_TEXTS = { };
local VUHDO_NAME_TEXTS = VUHDO_NAME_TEXTS;

local VUHDO_PixelUtil;

local VUHDO_getHealthBar;
local VUHDO_getBarText;
local VUHDO_getBarTextSolo;
local VUHDO_getIncHealOnUnit;
local VUHDO_getDiffColor;
local VUHDO_isPanelVisible;
local VUHDO_updateManaBars;
local VUHDO_updateAllHoTs;
local VUHDO_removeAllHots;
local VUHDO_getPanelButtons;
local VUHDO_updateBouquetsForEvent;
local VUHDO_invalidateUnitBouquetChangeStates;
local VUHDO_resolveVehicleUnit;
local VUHDO_getOverhealPanel;
local VUHDO_getOverhealText;
local VUHDO_getUnitButtons;
local VUHDO_getUnitButtonsSafe;
local VUHDO_getResolvedTextProvider;
local VUHDO_getBarRoleIcon;
local VUHDO_updateClusterHighlights;
local VUHDO_customizeTargetBar;
local VUHDO_getHealAbsorbBar;
local VUHDO_setStatusBarVuhDoColor;
local VUHDO_applyAllLayersToBar;
local VUHDO_getAuraGroupGlowInfo;
local VUHDO_isAuraModeContainers;
local VUHDO_isAuraDataRestricted;
local VUHDO_startUnitButtonAuraGroupGlow;
local VUHDO_stopUnitButtonAuraGroupGlow;
local VUHDO_refreshPrivateAuras;
local VUHDO_setOverlayChainBaselineColor;
local VUHDO_hideOverlayFillChainBackground;
local VUHDO_showOverlayFillChainBackground;
local VUHDO_resetBarTextVertexColor;
local VUHDO_setPredictionSpanLoss;
local VUHDO_hasManaOffsetBar;

local VUHDO_PANEL_SETUP;
local VUHDO_BUTTON_CACHE;
local VUHDO_RAID;
local VUHDO_CONFIG;
local VUHDO_INDICATOR_CONFIG;
local VUHDO_IN_RAID_TARGET_BUTTONS;
local VUHDO_INTERNAL_TOGGLES;
local VUHDO_CUSTOM_GLOW_AURA_GROUP_KEY;
local VUHDO_AURA_GROUP_GLOW_ACTIVE_KEY;

local VUHDO_IMMEDIATE = Enum.StatusBarInterpolation.Immediate;

local sSecretsEnabled = VUHDO_SECRETS_ENABLED;
local sShieldCalculator;
local sTotalShieldCalculator;
local sHealAbsorbCalculator;
local sHideWhenFullHealthCurve;
local sIsOverhealText;
local sIsAggroText;
local sHealthInterpolation = { };
local sShieldInterpolation = { };
local sOvershieldInterpolation = { };
local sHealAbsorbInterpolation = { };
local sHealthLossInterpolation = { };
local sConfigShieldColor;
local sConfigOvershieldColor;
local sConfigHealAbsorbColor;
local sConfigHealthLossColor;

local sTransparentColor = {
	["R"] = 0,
	["G"] = 0,
	["B"] = 0,
	["O"] = 0,
};

local sConfigIncColor;



--
function VUHDO_customHealthInitBurstCache()

	VUHDO_PANEL_SETUP = _G["VUHDO_PANEL_SETUP"];
	VUHDO_BUTTON_CACHE = _G["VUHDO_BUTTON_CACHE"];
	VUHDO_RAID = _G["VUHDO_RAID"];
	VUHDO_CONFIG = _G["VUHDO_CONFIG"];
	VUHDO_INDICATOR_CONFIG = _G["VUHDO_INDICATOR_CONFIG"];
 	VUHDO_IN_RAID_TARGET_BUTTONS = _G["VUHDO_IN_RAID_TARGET_BUTTONS"];
	VUHDO_INTERNAL_TOGGLES = _G["VUHDO_INTERNAL_TOGGLES"];
	VUHDO_CUSTOM_GLOW_AURA_GROUP_KEY = _G["VUHDO_CUSTOM_GLOW_AURA_GROUP_KEY"];
	VUHDO_AURA_GROUP_GLOW_ACTIVE_KEY = _G["VUHDO_AURA_GROUP_GLOW_ACTIVE_KEY"];

	VUHDO_PixelUtil = _G["VUHDO_PixelUtil"];

	VUHDO_getUnitButtons = _G["VUHDO_getUnitButtons"];
	VUHDO_getHealthBar = _G["VUHDO_getHealthBar"];
	VUHDO_getBarText = _G["VUHDO_getBarText"];
	VUHDO_getBarTextSolo = _G["VUHDO_getBarTextSolo"];
	VUHDO_getIncHealOnUnit = _G["VUHDO_getIncHealOnUnit"];
	VUHDO_getDiffColor = _G["VUHDO_getDiffColor"];
	VUHDO_isPanelVisible = _G["VUHDO_isPanelVisible"];
	VUHDO_updateManaBars = _G["VUHDO_updateManaBars"];
	VUHDO_removeAllHots = _G["VUHDO_removeAllHots"];
	VUHDO_updateAllHoTs = _G["VUHDO_updateAllHoTs"];
	VUHDO_getPanelButtons = _G["VUHDO_getPanelButtons"];
	VUHDO_updateBouquetsForEvent = _G["VUHDO_updateBouquetsForEvent"];
	VUHDO_invalidateUnitBouquetChangeStates = _G["VUHDO_invalidateUnitBouquetChangeStates"];
	VUHDO_resolveVehicleUnit = _G["VUHDO_resolveVehicleUnit"];
	VUHDO_getOverhealPanel = _G["VUHDO_getOverhealPanel"];
	VUHDO_getOverhealText = _G["VUHDO_getOverhealText"];
	VUHDO_getBarRoleIcon = _G["VUHDO_getBarRoleIcon"];
	VUHDO_updateClusterHighlights = _G["VUHDO_updateClusterHighlights"];
	VUHDO_customizeTargetBar = _G["VUHDO_customizeTargetBar"];
	VUHDO_getUnitButtonsSafe = _G["VUHDO_getUnitButtonsSafe"];
	VUHDO_getResolvedTextProvider = _G["VUHDO_getResolvedTextProvider"];
	VUHDO_getHealAbsorbBar = _G["VUHDO_getHealAbsorbBar"];
	VUHDO_setStatusBarVuhDoColor = _G["VUHDO_setStatusBarVuhDoColor"];
	VUHDO_applyAllLayersToBar = _G["VUHDO_applyAllLayersToBar"];
	VUHDO_getAuraGroupGlowInfo = _G["VUHDO_getAuraGroupGlowInfo"];
	VUHDO_isAuraModeContainers = _G["VUHDO_isAuraModeContainers"];
	VUHDO_isAuraDataRestricted = _G["VUHDO_isAuraDataRestricted"];
	VUHDO_startUnitButtonAuraGroupGlow = _G["VUHDO_startUnitButtonAuraGroupGlow"];
	VUHDO_stopUnitButtonAuraGroupGlow = _G["VUHDO_stopUnitButtonAuraGroupGlow"];
	VUHDO_refreshPrivateAuras = _G["VUHDO_refreshPrivateAuras"];
	VUHDO_setPredictionSpanLoss = _G["VUHDO_setPredictionSpanLoss"];
	VUHDO_hasManaOffsetBar = _G["VUHDO_hasManaOffsetBar"];
	VUHDO_setOverlayChainBaselineColor = _G["VUHDO_setOverlayChainBaselineColor"];
	VUHDO_hideOverlayFillChainBackground = _G["VUHDO_hideOverlayFillChainBackground"];
	VUHDO_showOverlayFillChainBackground = _G["VUHDO_showOverlayFillChainBackground"];
	VUHDO_resetBarTextVertexColor = _G["VUHDO_resetBarTextVertexColor"];

	return;

end



--
function VUHDO_customHealthInitShared()

	sShieldCalculator = CreateUnitHealPredictionCalculator();

	sShieldCalculator:SetDamageAbsorbClampMode(Enum.UnitDamageAbsorbClampMode.MissingHealth);
	sShieldCalculator:SetHealAbsorbClampMode(Enum.UnitHealAbsorbClampMode.MaximumHealth);
	sShieldCalculator:SetIncomingHealClampMode(Enum.UnitIncomingHealClampMode.MaximumHealth);
	sShieldCalculator:SetHealAbsorbMode(Enum.UnitHealAbsorbMode.Total);
	sShieldCalculator:SetIncomingHealOverflowPercent(1.0);

	sTotalShieldCalculator = CreateUnitHealPredictionCalculator();

	sTotalShieldCalculator:SetDamageAbsorbClampMode(Enum.UnitDamageAbsorbClampMode.MaximumHealth);
	sTotalShieldCalculator:SetHealAbsorbClampMode(Enum.UnitHealAbsorbClampMode.MaximumHealth);
	sTotalShieldCalculator:SetIncomingHealClampMode(Enum.UnitIncomingHealClampMode.MaximumHealth);
	sTotalShieldCalculator:SetHealAbsorbMode(Enum.UnitHealAbsorbMode.Total);
	sTotalShieldCalculator:SetIncomingHealOverflowPercent(1.0);

	sHealAbsorbCalculator = CreateUnitHealPredictionCalculator();

	sHealAbsorbCalculator:SetDamageAbsorbClampMode(Enum.UnitDamageAbsorbClampMode.MaximumHealth);
	sHealAbsorbCalculator:SetHealAbsorbClampMode(Enum.UnitHealAbsorbClampMode.CurrentHealth);
	sHealAbsorbCalculator:SetIncomingHealClampMode(Enum.UnitIncomingHealClampMode.MaximumHealth);
	sHealAbsorbCalculator:SetHealAbsorbMode(Enum.UnitHealAbsorbMode.Total);
	sHealAbsorbCalculator:SetIncomingHealOverflowPercent(1.0);

	sIsOverhealText = VUHDO_CONFIG["SHOW_TEXT_OVERHEAL"]
	sIsAggroText = VUHDO_CONFIG["THREAT"]["AGGRO_USE_TEXT"];

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		sHealthInterpolation[tPanelNum] = VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["HEALTH_BAR"]["smooth"] and Enum.StatusBarInterpolation.ExponentialEaseOut or Enum.StatusBarInterpolation.Immediate;
		sShieldInterpolation[tPanelNum] = VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["HEALTH_BAR"]["smoothShield"] and Enum.StatusBarInterpolation.ExponentialEaseOut or Enum.StatusBarInterpolation.Immediate;
		sOvershieldInterpolation[tPanelNum] = VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["HEALTH_BAR"]["smoothOvershield"] and Enum.StatusBarInterpolation.ExponentialEaseOut or Enum.StatusBarInterpolation.Immediate;
		sHealAbsorbInterpolation[tPanelNum] = VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["HEALTH_BAR"]["smoothHealAbsorb"] and Enum.StatusBarInterpolation.ExponentialEaseOut or Enum.StatusBarInterpolation.Immediate;
		sHealthLossInterpolation[tPanelNum] = VUHDO_INDICATOR_CONFIG[tPanelNum]["CUSTOM"]["HEALTH_BAR"]["smoothHealthLoss"] and Enum.StatusBarInterpolation.ExponentialEaseOut or Enum.StatusBarInterpolation.Immediate;
	end

	sHideWhenFullHealthCurve = VUHDO_buildHideWhenFullHealthCurve();

	twipe(VUHDO_NAME_TEXTS);

	return;

end



--
function VUHDO_customHealthInitLocalOverrides()

	VUHDO_customHealthInitBurstCache();
	VUHDO_customHealthInitShared();

	return;

end



--
local tCurve;
local tShieldBarColor;
local tLowAlpha;
function VUHDO_buildHideWhenFullHealthCurve()

	if not sSecretsEnabled then
		return nil;
	end

	tShieldBarColor = VUHDO_PANEL_SETUP["BAR_COLORS"]["SHIELD"];
	tLowAlpha = (tShieldBarColor and tShieldBarColor["useOpacity"] and tShieldBarColor["O"]) or 1;

	tCurve = CreateColorCurve();
	tCurve:SetType(Enum.LuaCurveType.Step);
	tCurve:AddPoint(0.0, CreateColor(1, 1, 1, tLowAlpha));
	tCurve:AddPoint(1.0, CreateColor(1, 1, 1, 0));

	return tCurve;

end



function VUHDO_resetNameTextCache()
	twipe(VUHDO_NAME_TEXTS);
end



--
local tIncColor = { ["useBackground"] = true };
local tLossColor = { ["useBackground"] = true };



--
function VUHDO_getUnitHealthModiPercent(anInfo, aModifier)
	return anInfo["healthmax"] == 0 and 0
		or (anInfo["health"] + aModifier) / anInfo["healthmax"];
end
local VUHDO_getUnitHealthModiPercent = VUHDO_getUnitHealthModiPercent;



--
local tOpacity;
local function VUHDO_setStatusBarColor(aBar, aColor)

	tOpacity = aColor["useOpacity"] and aColor["O"] or nil;

	if aColor["useBackground"] then
		if tOpacity then
			aBar:SetStatusBarColor(aColor["R"], aColor["G"], aColor["B"], tOpacity);
		else
			aBar:SetStatusBarColor(aColor["R"], aColor["G"], aColor["B"]);
		end
	elseif tOpacity then
		aBar:SetAlpha(tOpacity);
	end

end



--
local tBarColor, tBarClassColor;
local tInfo;
local function VUHDO_getStatusBarColor(aBarType, aUnit)

	tBarColor = VUHDO_PANEL_SETUP["BAR_COLORS"][aBarType];

	if not tBarColor then
		return;
	end

	if not tBarColor["useClassColor"] then
		return tBarColor;
	else
		tInfo = VUHDO_RAID[aUnit];

		if not tInfo then
			return tBarColor;
		end

		tBarClassColor = VUHDO_copyColor(VUHDO_getClassColor(tInfo));

		if tBarColor["useOpacity"] then
			tBarClassColor["useOpacity"] = true;
			tBarClassColor["O"], tBarClassColor["TO"] = tBarColor["O"], tBarColor["TO"];
		end

		return tBarClassColor;
	end

end



do
	--
	local tShieldInBar;
	local tTotalShield;
	local tHealthMax;
	local tAlpha;
	local tHealthBar;
	local tShieldBar;
	local tOvershieldBar;
	local tSecretColor;
	local tPanelNum;
	local tInterpolation;
	local tOvershieldInterpolation;
	function VUHDO_updateShieldBarsForButtons(aUnit, aAllButtons, anInterpolation)

		sShieldCalculator:ResetPredictedValues();

		UnitGetDetailedHealPrediction(aUnit, "player", sShieldCalculator);

		tShieldInBar, _ = sShieldCalculator:GetDamageAbsorbs();
		tHealthMax = sShieldCalculator:GetMaximumHealth();

		sTotalShieldCalculator:ResetPredictedValues();

		UnitGetDetailedHealPrediction(aUnit, "player", sTotalShieldCalculator);

		tTotalShield = sTotalShieldCalculator:GetTotalDamageAbsorbs();

		for _, tButton in pairs(aAllButtons) do
			tPanelNum = VUHDO_BUTTON_CACHE[tButton];
			tInterpolation = anInterpolation or sShieldInterpolation[tPanelNum];
			tOvershieldInterpolation = anInterpolation or sOvershieldInterpolation[tPanelNum];
			tHealthBar = VUHDO_getHealthBar(tButton, 1);
			tShieldBar = VUHDO_getHealthBar(tButton, 19);
			tOvershieldBar = VUHDO_getHealthBar(tButton, 20);

			tShieldBar:SetMinMaxValues(0, tHealthMax);
			tShieldBar:SetValue(tShieldInBar, tInterpolation);

			if tHealthBar["secretCurveColor"] and tHealthBar["secretCurveColor"]["R"] then
				sConfigShieldColor = VUHDO_getStatusBarColor("SHIELD", aUnit);

				if sConfigShieldColor then
					tSecretColor = tHealthBar["secretCurveColor"];

					if sConfigShieldColor["useBackground"] then
						tShieldBar:GetStatusBarTexture():SetVertexColor(sConfigShieldColor["R"], sConfigShieldColor["G"], sConfigShieldColor["B"], tSecretColor["O"]);
					else
						tShieldBar:GetStatusBarTexture():SetVertexColor(tSecretColor["R"], tSecretColor["G"], tSecretColor["B"], tSecretColor["O"]);
					end

					if sConfigShieldColor["useOpacity"] then
						tShieldBar:SetAlpha(sConfigShieldColor["O"] or 1);
					end
				end
			else
				sConfigShieldColor = VUHDO_getStatusBarColor("SHIELD", aUnit);

				if sConfigShieldColor then
					VUHDO_setStatusBarVuhDoColor(tShieldBar, sConfigShieldColor);
				end
			end

			tShieldBar:Show();

			if tHealthBar["isInverted"] and sHideWhenFullHealthCurve then
				tAlpha = UnitHealthPercent(aUnit, true, sHideWhenFullHealthCurve);
				tShieldBar:SetAlpha(tAlpha and tAlpha["a"] or 1);
			end

			VUHDO_updateIncShieldPredictionAnchors(tButton, tPanelNum);

			if VUHDO_CONFIG["SHOW_OVERSHIELD_BAR"] then
				tOvershieldBar:SetMinMaxValues(0, tHealthMax);
				tOvershieldBar:SetValue(tTotalShield, tOvershieldInterpolation);

				if tHealthBar["secretCurveColor"] and tHealthBar["secretCurveColor"]["R"] then
					sConfigOvershieldColor = VUHDO_getStatusBarColor("OVERSHIELD", aUnit);

					if sConfigOvershieldColor then
						tSecretColor = tHealthBar["secretCurveColor"];

						if sConfigOvershieldColor["useBackground"] then
							tOvershieldBar:GetStatusBarTexture():SetVertexColor(sConfigOvershieldColor["R"], sConfigOvershieldColor["G"], sConfigOvershieldColor["B"], tSecretColor["O"]);
						else
							tOvershieldBar:GetStatusBarTexture():SetVertexColor(tSecretColor["R"], tSecretColor["G"], tSecretColor["B"], tSecretColor["O"]);
						end

						if sConfigOvershieldColor["useOpacity"] then
							tOvershieldBar:SetAlpha(sConfigOvershieldColor["O"] or 1);
						end
					end
				else
					sConfigOvershieldColor = VUHDO_getStatusBarColor("OVERSHIELD", aUnit);

					if sConfigOvershieldColor then
						VUHDO_setStatusBarVuhDoColor(tOvershieldBar, sConfigOvershieldColor);
					end
				end

				if tHealthBar["secretCurveColor"] and tHealthBar["secretCurveColor"]["R"]
					and not (sConfigOvershieldColor and sConfigOvershieldColor["useOpacity"]) then
					tOvershieldBar:SetAlpha(1);
				end

				VUHDO_updateOvershieldPredictionAnchors(tButton, tPanelNum);

				tOvershieldBar:Show();
			else
				tOvershieldBar:Hide();
			end
		end

		return;

	end
end



do
	--
	local tInfo;
	local tAllButtons;
	local function VUHDO_hideShieldBarsForButtons(aAllButtons)

		for _, tButton in pairs(aAllButtons) do
			VUHDO_getHealthBar(tButton, 19):Hide();
			VUHDO_getHealthBar(tButton, 20):Hide();
		end

		return;

	end



	--
	function VUHDO_updateShieldBar(aUnit, anInterpolation)

		tInfo = VUHDO_RAID[aUnit];
		tAllButtons = VUHDO_getUnitButtonsSafe(VUHDO_resolveVehicleUnit(aUnit));

		if not tInfo or not VUHDO_CONFIG["SHOW_SHIELD_BAR"] then
			VUHDO_hideShieldBarsForButtons(tAllButtons);

			return;
		end

		if not tInfo["connected"] or tInfo["dead"] then
			VUHDO_hideShieldBarsForButtons(tAllButtons);

			return;
		end

		VUHDO_updateShieldBarsForButtons(aUnit, tAllButtons, anInterpolation);

		return;

	end
end



--
local tInfo;
local tAllButtons;
local tHealAbsorb;
local tHealthBar;
local tHealAbsorbBar;
local tPanelNum;
local tSecretColor;
local tHealth;
local tHealAbsorbInterpolation;
function VUHDO_updateHealAbsorbBar(aUnit, anInterpolation)

	tInfo = VUHDO_RAID[aUnit];
	tAllButtons = VUHDO_getUnitButtonsSafe(VUHDO_resolveVehicleUnit(aUnit));

	if not tInfo or not VUHDO_CONFIG["SHOW_HEAL_ABSORB_BAR"] then
		for _, tButton in pairs(tAllButtons) do
			VUHDO_getHealAbsorbBar(VUHDO_getHealthBar(tButton, 1)):Hide();
		end

		return;
	end

	if not tInfo["connected"] or tInfo["dead"] then
		for _, tButton in pairs(tAllButtons) do
			VUHDO_getHealAbsorbBar(VUHDO_getHealthBar(tButton, 1)):Hide();
		end

		return;
	end

	sHealAbsorbCalculator:ResetPredictedValues();

	UnitGetDetailedHealPrediction(aUnit, "player", sHealAbsorbCalculator);

	tHealAbsorb = sHealAbsorbCalculator:GetHealAbsorbs();
	tHealth = sHealAbsorbCalculator:GetCurrentHealth();

	for _, tButton in pairs(tAllButtons) do
		tPanelNum = VUHDO_BUTTON_CACHE[tButton];
		tHealAbsorbInterpolation = anInterpolation or sHealAbsorbInterpolation[tPanelNum];
		tHealthBar = VUHDO_getHealthBar(tButton, 1);
		tHealAbsorbBar = VUHDO_getHealAbsorbBar(tHealthBar);

		tHealAbsorbBar:SetMinMaxValues(0, tHealth);
		tHealAbsorbBar:SetValue(tHealAbsorb, tHealAbsorbInterpolation);

		if tHealthBar["secretCurveColor"] and tHealthBar["secretCurveColor"]["R"] then
			sConfigHealAbsorbColor = VUHDO_getStatusBarColor("HEAL_ABSORB", aUnit);

			if sConfigHealAbsorbColor then
				tSecretColor = tHealthBar["secretCurveColor"];

				if sConfigHealAbsorbColor["useBackground"] then
					tHealAbsorbBar:GetStatusBarTexture():SetVertexColor(sConfigHealAbsorbColor["R"], sConfigHealAbsorbColor["G"], sConfigHealAbsorbColor["B"], tSecretColor["O"]);
				else
					tHealAbsorbBar:GetStatusBarTexture():SetVertexColor(tSecretColor["R"], tSecretColor["G"], tSecretColor["B"], tSecretColor["O"]);
				end

				if sConfigHealAbsorbColor["useOpacity"] then
					tHealAbsorbBar:SetAlpha(sConfigHealAbsorbColor["O"] or 1);
				end
			end
		else
			sConfigHealAbsorbColor = VUHDO_getStatusBarColor("HEAL_ABSORB", aUnit);

			if sConfigHealAbsorbColor then
				VUHDO_setStatusBarVuhDoColor(tHealAbsorbBar, sConfigHealAbsorbColor);
			end
		end

		tHealAbsorbBar:Show();
	end

	return;

end
local VUHDO_updateHealAbsorbBar = VUHDO_updateHealAbsorbBar;



--
local tAllButtons;
local tIncBar;
local tInfo;
local tOpacity;
local tHealthBar;
local tIncHealAmount;
local tSecretColor;
local tOvershieldOffsetBar;
local tInterpolation;
local function VUHDO_updateIncHealForButton(aUnit, aButton, anInterpolation, aInfo, aIncHealAmount)

	tPanelNum = VUHDO_BUTTON_CACHE[aButton];
	tInterpolation = anInterpolation or sHealthInterpolation[tPanelNum];
	tIncBar = VUHDO_getHealthBar(aButton, 6);
	tHealthBar = VUHDO_getHealthBar(aButton, 1);

	if aIncHealAmount and aInfo["healthmax"] and (not sSecretsEnabled or issecretvalue(aIncHealAmount) or aIncHealAmount > 0) and (not sSecretsEnabled or aInfo["hasSecretHealthMax"] or aInfo["healthmax"] > 0) then
		tIncBar:SetMinMaxValues(0, aInfo["healthmax"]);
		tIncBar:SetValue(aIncHealAmount, tInterpolation);

		if sSecretsEnabled then
			tOvershieldOffsetBar = VUHDO_getHealthBar(aButton, 23);

			tOvershieldOffsetBar:SetMinMaxValues(0, aInfo["healthmax"]);
			tOvershieldOffsetBar:SetValue(aIncHealAmount, tInterpolation);
		end

		if sSecretsEnabled and tHealthBar["secretCurveColor"] and tHealthBar["secretCurveColor"]["R"] then
			sConfigIncColor = VUHDO_getStatusBarColor("INCOMING", aUnit);

			if sConfigIncColor then
				tSecretColor = tHealthBar["secretCurveColor"];

				if sConfigIncColor["useBackground"] then
					tIncBar:GetStatusBarTexture():SetVertexColor(sConfigIncColor["R"], sConfigIncColor["G"], sConfigIncColor["B"], tSecretColor["O"]);
				else
					tIncBar:GetStatusBarTexture():SetVertexColor(tSecretColor["R"], tSecretColor["G"], tSecretColor["B"], tSecretColor["O"]);
				end

				if sConfigIncColor["useOpacity"] then
					tIncBar:SetAlpha(sConfigIncColor["O"] or 1);
				end
			end
		elseif not sSecretsEnabled then
			tIncColor["R"], tIncColor["G"], tIncColor["B"], tOpacity = tHealthBar:GetStatusBarColor();
			tIncColor = VUHDO_getDiffColor(tIncColor, VUHDO_getStatusBarColor("INCOMING", aUnit));

			if tIncColor["O"] and tOpacity then
				tIncColor["O"] = tIncColor["O"] * tOpacity * (tHealthBar:GetAlpha() or 1);
			end

			VUHDO_setStatusBarColor(tIncBar, tIncColor);
		else
			sConfigIncColor = VUHDO_getStatusBarColor("INCOMING", aUnit);

			if sConfigIncColor then
				VUHDO_setStatusBarColor(tIncBar, sConfigIncColor);
			end
		end

		tIncBar:Show();
	else
		tIncBar:SetValue(0, VUHDO_IMMEDIATE);
		tIncBar:Hide();

		if sSecretsEnabled then
			tOvershieldOffsetBar = VUHDO_getHealthBar(aButton, 23);

			tOvershieldOffsetBar:SetValue(0, VUHDO_IMMEDIATE);
		end
	end

	return;

end



--
local function VUHDO_updateIncHeal(aUnit, anInterpolation, aInfo, aAllButtons)

	tInfo = aInfo or VUHDO_RAID[aUnit];
	tAllButtons = aAllButtons or VUHDO_getUnitButtons(VUHDO_resolveVehicleUnit(aUnit));

	if not tInfo or not tAllButtons then
		return;
	end

	tIncHealAmount = VUHDO_getIncHealOnUnit(aUnit);

	for _, tButton in pairs(tAllButtons) do
		VUHDO_updateIncHealForButton(aUnit, tButton, anInterpolation, tInfo, tIncHealAmount);
	end

	VUHDO_updateShieldBar(aUnit, anInterpolation);
	VUHDO_updateHealAbsorbBar(aUnit, anInterpolation);

	return;

end



--
local tRatio, tBar, tScale;
local tPanelNum;
local tIndicatorConfig;
local tFontString;
function VUHDO_overhealTextCallback(aUnit, aProviderName, aValue, anIndicatorName, aBouquetName, ...)

	for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
		tPanelNum = VUHDO_BUTTON_CACHE[tButton];
		tIndicatorConfig = VUHDO_INDICATOR_CONFIG[tPanelNum]["TEXT_INDICATORS"][anIndicatorName];

		if (aBouquetName == nil or VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"][anIndicatorName] == aBouquetName)
			and VUHDO_getResolvedTextProvider(tIndicatorConfig["TEXT_PROVIDER_SOURCE"], tIndicatorConfig["TEXT_PROVIDER_FORMAT"]) == aProviderName then
			tBar = VUHDO_getHealthBar(tButton, 1);
			tFontString = VUHDO_getOverhealText(tBar);

			tFontString:SetText(format(...));
			tFontString:SetAlpha(type(aValue) == "string" and 0 or aValue);

			if aProviderName["sourceKey"] == "OVERHEAL" then
				tInfo = VUHDO_RAID[aUnit];

				if tInfo then
					if sSecretsEnabled and (issecretvalue(aValue) or tInfo["hasSecretHealthMax"]) then
						-- FIXME
					elseif aValue > 0 and tInfo["healthmax"] > 0 then
						tRatio = aValue / tInfo["healthmax"];
						tScale = VUHDO_PANEL_SETUP[tPanelNum]["OVERHEAL_TEXT"]["scale"];

						VUHDO_PixelUtil.SetScale(VUHDO_getOverhealPanel(tBar), tRatio < 1 and (0.5 + tRatio) * tScale or 1.5 * tScale);
					end
				end
			end
		end
	end

	return;

end



--
VUHDO_CUSTOM_INFO = {
	["number"] = 1,
	["range"] = true,
	["debuff"] = 0,
	--["isPet"] = false,
	--["charmed"] = false,
	--["aggro"] = false,
	["group"] = 0,
	--["afk"] = false,
	["threat"] = 0,
	["threatPerc"] = 0,
	--["isVehicle"] = false,
	--["ownerUnit"] = nil,
	--["petUnit"] = nil,
	--["missbuff"] = nil,
	--["mibucateg"] = nil,
	--["mibuvariants"] = nil,
	--["raidIcon"] = nil,
	["visible"] = true,
	["baseRange"] = true,
};
local VUHDO_CUSTOM_INFO = VUHDO_CUSTOM_INFO;



--
local tUnit;
function VUHDO_getDisplayUnit(aButton)

	tUnit = aButton:GetAttribute("unit");

	if not tUnit then
		return nil, nil;
	elseif strfind(tUnit, "target", 1, true) and tUnit ~= "target" then
		if not VUHDO_CUSTOM_INFO["fixResolveId"] then
			return tUnit, VUHDO_CUSTOM_INFO;
		else
			return VUHDO_CUSTOM_INFO["fixResolveId"], VUHDO_RAID[VUHDO_CUSTOM_INFO["fixResolveId"]];
		end
	else
		if VUHDO_RAID[tUnit] and VUHDO_RAID[tUnit]["isVehicle"] then
			tUnit = VUHDO_RAID[tUnit]["petUnit"];
		end

		return tUnit, VUHDO_RAID[tUnit];
	end

	return;

end
local VUHDO_getDisplayUnit = VUHDO_getDisplayUnit;



do
	--
	local tHealthBar;
	local tPanelNum;
	local tQuota;
	local tBackgroundBouquet;
	local tCanGlow;
	local tGlowColor;
	local tGlowStyle;
	local tWasGlowActive;
	local tUseLegacyAuraGroupGlow;
	local tInterpolation;
	local function VUHDO_updateHealthBarValueForUnit(aUnit, aCurrValue, aMaxValue, aColor, aMaxColor, aBouquetName, aLayerTemplate, aCurrValue2, anEventType, anHasHealthData)

		tCanGlow = false;
		tGlowColor = nil;
		tGlowStyle = nil;

		tUseLegacyAuraGroupGlow = not VUHDO_isAuraModeContainers() and not VUHDO_isAuraDataRestricted();

		if tUseLegacyAuraGroupGlow then
			tCanGlow, tGlowColor, tGlowStyle = VUHDO_getAuraGroupGlowInfo(aUnit);
		end

		for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
			tPanelNum = VUHDO_BUTTON_CACHE[tButton];

			if VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["HEALTH_BAR"] == aBouquetName then
				tHealthBar = VUHDO_getHealthBar(tButton, 1);

				tInterpolation = (tHealthBar["forceImmediate"] or 1 == anEventType) and VUHDO_IMMEDIATE or sHealthInterpolation[tPanelNum];

				if anHasHealthData then
					tHealthBar["forceImmediate"] = nil;
				end

				if anHasHealthData then
					if not VUHDO_RAID[aUnit] then
						tHealthBar:SetMinMaxValues(0, 1, VUHDO_IMMEDIATE);
						tHealthBar:SetValue(tHealthBar["isInverted"] and 1 or 0, tInterpolation);
					else
						tHealthBar:SetMinMaxValues(0, aMaxValue, tInterpolation);

						if tHealthBar["isInverted"] then
							tQuota = sSecretsEnabled and aCurrValue2 or (aMaxValue - aCurrValue);
						else
							tQuota = aCurrValue;
						end

						tHealthBar:SetValue(tQuota, tInterpolation);
					end
				else
					tHealthBar:SetMinMaxValues(0, 1, VUHDO_IMMEDIATE);
					tHealthBar:SetValue(0, VUHDO_IMMEDIATE);
				end

				if aLayerTemplate then
					VUHDO_applyAllLayersToBar(tButton, tHealthBar, aLayerTemplate, "HEALTH_BAR", aBouquetName);
				elseif aColor then
					VUHDO_setStatusBarVuhDoColor(tHealthBar, aColor, aMaxColor);

					VUHDO_resetBarTextVertexColor(tHealthBar);

					if aColor["useText"] then
						VUHDO_getBarText(tHealthBar):SetTextColor(aColor["TR"], aColor["TG"], aColor["TB"]);
						VUHDO_getBarTextSolo(tHealthBar):SetTextColor(aColor["TR"], aColor["TG"], aColor["TB"]);
						VUHDO_getLifeText(tHealthBar):SetTextColor(aColor["TR"], aColor["TG"], aColor["TB"]);
					end
				end

				if tUseLegacyAuraGroupGlow then
					tWasGlowActive = tButton[VUHDO_AURA_GROUP_GLOW_ACTIVE_KEY];

					if tCanGlow and tGlowColor and tGlowStyle then
						VUHDO_startUnitButtonAuraGroupGlow(tButton, tGlowStyle, tGlowColor, VUHDO_CUSTOM_GLOW_AURA_GROUP_KEY);

						tButton[VUHDO_AURA_GROUP_GLOW_ACTIVE_KEY] = true;
					elseif tWasGlowActive then
						VUHDO_stopUnitButtonAuraGroupGlow(tButton, VUHDO_CUSTOM_GLOW_AURA_GROUP_KEY);

						tButton[VUHDO_AURA_GROUP_GLOW_ACTIVE_KEY] = nil;
					end
				end

				if sSecretsEnabled then
					tBackgroundBouquet = VUHDO_INDICATOR_CONFIG[tPanelNum]["BOUQUETS"]["BACKGROUND_BAR"];

					if not tBackgroundBouquet or tBackgroundBouquet == "" then
						VUHDO_updateIndicatorAlphaChain(tButton, "HEALTH_BAR", VUHDO_RAID[aUnit]);
					end
				end
			end
		end

		return;

	end



	--
	local tAllButtons;
	local tInfo;
	local tHasHealthData;
	function VUHDO_healthBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName, aLevel, aCurrValue2, aClipL, aClipR, aClipT, aClipB, aMaxColor, aLayerTemplate, anIsAliveTime, anEventType)

		tHasHealthData = anIsActive and ((sSecretsEnabled and issecretvalue(aMaxValue)) or (aMaxValue and 0 ~= aMaxValue));

		if tHasHealthData then
			aMaxValue = aMaxValue or 0;
			aCurrValue = aCurrValue or 0;
			aCurrValue2 = aCurrValue2 or 0;
		end

		VUHDO_updateHealthBarValueForUnit(aUnit, aCurrValue, aMaxValue, aColor, aMaxColor, aBouquetName, aLayerTemplate, aCurrValue2, anEventType, tHasHealthData);

		tInfo = VUHDO_RAID[aUnit];

		if not tInfo then
			return;
		end

		if tInfo["hasSecretName"] then
			return;
		end

		tAllButtons = VUHDO_IN_RAID_TARGET_BUTTONS[VUHDO_getUnitIdentityKey(tInfo)];

		if not tAllButtons then
			return;
		end

		VUHDO_CUSTOM_INFO["fixResolveId"] = aUnit;

		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeTargetBar(tButton, aUnit, tInfo["range"]);
		end

		if sSecretsEnabled then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_updateIndicatorAlphaChain(tButton, "HEALTH_BAR", tInfo);
			end
		end

		return;

	end



	--
	local tAggroBar;
	function VUHDO_aggroBarBouquetCallback(aUnit, anIsActive, anIcon, aTimer, aCounter, aDuration, aColor, aBuffName, aBouquetName, aLevel, aCurrValue2, aClipL, aClipR, aClipT, aClipB, aMaxColor, aLayerTemplate)

		for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
			if aBouquetName == nil or VUHDO_INDICATOR_CONFIG[VUHDO_BUTTON_CACHE[tButton]]["BOUQUETS"]["AGGRO_BAR"] == aBouquetName then
				tAggroBar = VUHDO_getHealthBar(tButton, 4);

				if anIsActive then
					tAggroBar:SetValue(1);

					if aLayerTemplate then
						VUHDO_applyAllLayersToBar(tButton, tAggroBar, aLayerTemplate, "AGGRO_BAR", aBouquetName);
					elseif aColor then
						VUHDO_setStatusBarVuhDoColor(tAggroBar, aColor);
					end

					tAggroBar:Show();
				else
					tAggroBar:SetValue(0);

					tAggroBar:Hide();
				end

				if sSecretsEnabled then
					VUHDO_updateIndicatorAlphaChain(tButton, "AGGRO_BAR", VUHDO_RAID[aUnit]);
				end
			end
		end

	end



	--
	local tBar;
	local tQuota;
	local tShouldDelegateToFillChain;
	local tColorOpacity;
	function VUHDO_backgroundBarBouquetCallback(aUnit, anIsActive, anIcon, aCurrValue, aCounter, aMaxValue, aColor, aBuffName, aBouquetName, aLevel, aCurrValue2, aClipL, aClipR, aClipT, aClipB, aMaxColor, aLayerTemplate)

		tQuota = (anIsActive or (aMaxValue or 0) > 1) and 1 or 0;

		for _, tButton in pairs(VUHDO_getUnitButtonsSafe(aUnit)) do
			if VUHDO_INDICATOR_CONFIG[VUHDO_BUTTON_CACHE[tButton]]["BOUQUETS"]["BACKGROUND_BAR"] == aBouquetName then
				tBar = VUHDO_getHealthBar(tButton, 3);

				tBar:SetMinMaxValues(0, 1, Enum.StatusBarInterpolation.Immediate);
				tBar:SetValue(tQuota);

				if anIsActive then
					if aLayerTemplate then
						VUHDO_applyAllLayersToBar(tButton, tBar, aLayerTemplate, "BACKGROUND_BAR", aBouquetName);
					elseif aColor then
						VUHDO_setStatusBarVuhDoColor(tBar, aColor);
					end

					if aColor then
						VUHDO_setOverlayChainBaselineColor(tButton, aColor);
					end
				else
					tBar:SetStatusBarColor(0, 0, 0, 0);

					VUHDO_setOverlayChainBaselineColor(tButton, sTransparentColor);
				end

				tColorOpacity = aColor and (aColor["O"] == nil and 1 or aColor["O"]) or 0;
				tShouldDelegateToFillChain = anIsActive and (aLayerTemplate or (aColor and tColorOpacity > 0));

				if tShouldDelegateToFillChain then
					VUHDO_hideOverlayFillChainBackground(tButton);
				else
					VUHDO_showOverlayFillChainBackground(tButton);
				end

				if sSecretsEnabled then
					VUHDO_updateIndicatorAlphaChain(tButton, "BACKGROUND_BAR", VUHDO_RAID[aUnit]);
				end
			end
		end

	end
end



--
local tTexture;
local tIcon;
local tUnit;
local tPrivateAura;
local tCustomizeInfo;
function VUHDO_customizeHealButton(aButton)

	VUHDO_customizeText(aButton, 1, false); -- VUHDO_UPDATE_ALL

	tUnit = VUHDO_getDisplayUnit(aButton);

	if sSecretsEnabled then
		tCustomizeInfo = VUHDO_RAID[tUnit];

		VUHDO_updateAllIndicatorAlphaChains(aButton, tCustomizeInfo);
	end

	-- Raid icon
	if VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["RAID_ICON"]["show"] and tUnit then
		tIcon = GetRaidTargetIndex(tUnit);

		if tIcon then
			if sSecretsEnabled and issecretvalue(tIcon) then
				tTexture = VUHDO_getBarRoleIcon(aButton, 50);

				VUHDO_setRaidTargetIconTexture(tTexture, tIcon);

				tTexture:Show();
			elseif VUHDO_PANEL_SETUP["RAID_ICON_FILTER"][tIcon] then
				tTexture = VUHDO_getBarRoleIcon(aButton, 50);

				VUHDO_setRaidTargetIconTexture(tTexture, tIcon);

				tTexture:Show();
			else
				VUHDO_getBarRoleIcon(aButton, 50):Hide();
			end
		else
			VUHDO_getBarRoleIcon(aButton, 50):Hide();
		end
	end

	for tAuraIndex = 1, VUHDO_MAX_PRIVATE_AURAS do
		tPrivateAura = VUHDO_getPrivateAuraIcon(aButton, tAuraIndex);

		if not tPrivateAura then
			break;
		end

		if VUHDO_PANEL_SETUP[VUHDO_BUTTON_CACHE[aButton]]["PRIVATE_AURA"]["show"] and tPrivateAura["anchorId"] then
			tPrivateAura:Show();

			VUHDO_getPrivateAuraContainer(aButton):Show();
		else
			tPrivateAura:Hide();
		end
	end

end
local VUHDO_customizeHealButton = VUHDO_customizeHealButton;



do
	--
	local tLossInfo;
	local tLossButtons;
	local tLossPanelNum;
	local tLossHealthBar;
	local tLossBar;
	local tLossPerc;
	local tLossInterpolation;
	local tResolvedUnit;
	local tLossOpacity;
	local tSecretColor;
	local tSpanLossPerc;
	function VUHDO_updateHealthLossBar(aUnit, anInterpolation, aInfo, aAllButtons)

		tLossInfo = aInfo or VUHDO_RAID[aUnit];

		if not tLossInfo then
			return;
		end

		tLossButtons = aAllButtons or VUHDO_getUnitButtonsSafe(VUHDO_resolveVehicleUnit(aUnit));

		if not VUHDO_CONFIG["SHOW_HEALTH_LOSS_BAR"] then
			for _, tButton in pairs(tLossButtons) do
				tLossPanelNum = VUHDO_BUTTON_CACHE[tButton];

				if tLossPanelNum and VUHDO_hasManaOffsetBar(tButton) then
					tLossBar = VUHDO_getHealthBar(tButton, 22);

					if tLossBar then
						tLossBar:SetValue(0, anInterpolation or sHealthLossInterpolation[tLossPanelNum]);
						VUHDO_setPredictionSpanLoss(tButton, 0, anInterpolation or sHealthLossInterpolation[tLossPanelNum]);
					end
				end
			end

			return;
		end

		tResolvedUnit = VUHDO_resolveVehicleUnit(aUnit);

		if not UnitExists(tResolvedUnit) then
			return;
		end

		tLossPerc = GetUnitTotalModifiedMaxHealthPercent(tResolvedUnit);

		for _, tButton in pairs(tLossButtons) do
			tLossPanelNum = VUHDO_BUTTON_CACHE[tButton];

			if tLossPanelNum and VUHDO_hasManaOffsetBar(tButton) then
				tLossHealthBar = VUHDO_getHealthBar(tButton, 1);
				tLossBar = VUHDO_getHealthBar(tButton, 22);

				if tLossBar then
					tLossInterpolation = anInterpolation or sHealthLossInterpolation[tLossPanelNum];

					tLossBar:SetValue(tLossPerc, tLossInterpolation);

					tSpanLossPerc = tLossPerc;

					if tButton["isHealthLossAnchored"] == false then
						tSpanLossPerc = 0;
					end

					VUHDO_setPredictionSpanLoss(tButton, tSpanLossPerc, tLossInterpolation);

					if sSecretsEnabled and tLossHealthBar and tLossHealthBar["secretCurveColor"] and tLossHealthBar["secretCurveColor"]["R"] then
						sConfigHealthLossColor = VUHDO_getStatusBarColor("HEALTH_LOSS", aUnit);

						if sConfigHealthLossColor then
							tSecretColor = tLossHealthBar["secretCurveColor"];

							if sConfigHealthLossColor["useBackground"] then
								tLossBar:GetStatusBarTexture():SetVertexColor(sConfigHealthLossColor["R"], sConfigHealthLossColor["G"], sConfigHealthLossColor["B"], tSecretColor["O"]);
							else
								tLossBar:GetStatusBarTexture():SetVertexColor(tSecretColor["R"], tSecretColor["G"], tSecretColor["B"], tSecretColor["O"]);
							end

							if sConfigHealthLossColor["useOpacity"] then
								tLossBar:SetAlpha(sConfigHealthLossColor["O"] or 1);
							end
						end
					elseif not sSecretsEnabled and tLossHealthBar then
						tLossColor["R"], tLossColor["G"], tLossColor["B"], tLossOpacity = tLossHealthBar:GetStatusBarColor();
						tLossColor = VUHDO_getDiffColor(tLossColor, VUHDO_getStatusBarColor("HEALTH_LOSS", aUnit));

						if tLossColor["O"] and tLossOpacity then
							tLossColor["O"] = tLossColor["O"] * tLossOpacity * (tLossHealthBar:GetAlpha() or 1);
						end

						VUHDO_setStatusBarVuhDoColor(tLossBar, tLossColor);
					else
						sConfigHealthLossColor = VUHDO_getStatusBarColor("HEALTH_LOSS", aUnit);

						if sConfigHealthLossColor then
							VUHDO_setStatusBarVuhDoColor(tLossBar, sConfigHealthLossColor);
						end
					end
				end
			end
		end

		return;

	end
end



do
	--
	local tAllButtons;
	function VUHDO_initHealthBarsFor(aUnit)

		if not aUnit then
			return;
		end

		VUHDO_invalidateUnitBouquetChangeStates(aUnit);

		tAllButtons = VUHDO_getUnitButtons(aUnit);

		if tAllButtons then
			VUHDO_updateHealthBarsFor(aUnit, 1); -- VUHDO_UPDATE_ALL
		else
			VUHDO_updateBouquetsForEvent(aUnit, 1); -- VUHDO_UPDATE_ALL
		end

		return;

	end
end



--
local tInfo;
local tAllButtons;
local tIncHealAmount;
function VUHDO_updateHealthBarsFor(aUnit, anUpdateMode)

	-- as of patch 7.1 we are seeing empty units on health related events
	if not aUnit then
		return;
	end

	tInfo = VUHDO_RAID[aUnit];
	tAllButtons = VUHDO_getUnitButtons(aUnit);

	if not tAllButtons then
		return;
	end

	VUHDO_updateBouquetsForEvent(aUnit, anUpdateMode);

	if 1 == anUpdateMode or 2 == anUpdateMode or 3 == anUpdateMode or VUHDO_UPDATE_HEALTH_LOSS == anUpdateMode then
		VUHDO_updateHealthLossBar(aUnit, 1 == anUpdateMode and VUHDO_IMMEDIATE or nil, tInfo, tAllButtons);
	end

	if 2 == anUpdateMode then -- VUHDO_UPDATE_HEALTH
		VUHDO_determineIncHeal(aUnit);

		tInfo = VUHDO_RAID[aUnit];
		tIncHealAmount = tInfo and VUHDO_getIncHealOnUnit(aUnit) or nil;

		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH

			if tInfo then
				VUHDO_customizeDamageFlash(tButton, tInfo);

				VUHDO_updateIncHealForButton(aUnit, tButton, nil, tInfo, tIncHealAmount);
			end
		end

		if tInfo then
			tInfo["lifeLossPerc"] = nil;

			VUHDO_updateShieldBar(aUnit);
			VUHDO_updateHealAbsorbBar(aUnit);
		end

	elseif 9 == anUpdateMode then -- VUHDO_UPDATE_INC
		VUHDO_determineIncHeal(aUnit);

		if sIsOverhealText then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
			end
		end

		VUHDO_updateIncHeal(aUnit, nil, tInfo, tAllButtons);

	elseif 7 == anUpdateMode then -- VUHDO_UPDATE_AGGRO
		if sIsAggroText then
			for _, tButton in pairs(tAllButtons) do
				VUHDO_customizeText(tButton, 7, false); -- VUHDO_UPDATE_AGGRO
			end
		end

	elseif 5 == anUpdateMode then -- VUHDO_UPDATE_RANGE
		VUHDO_determineIncHeal(aUnit);

		tInfo = VUHDO_RAID[aUnit];

		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- for d/c tag -- VUHDO_UPDATE_HEALTH
			VUHDO_customizeDebuffIconsRange(tButton);

			if sSecretsEnabled then
				VUHDO_updateAllIndicatorAlphaChains(tButton, tInfo);
			end
		end

		VUHDO_updateIncHeal(aUnit, nil, tInfo, tAllButtons);

	elseif 3 == anUpdateMode then -- VUHDO_UPDATE_HEALTH_MAX
		VUHDO_determineIncHeal(aUnit);

		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH
		end

		VUHDO_updateIncHeal(aUnit, nil, nil, tAllButtons);

	elseif 6 == anUpdateMode then -- VUHDO_UPDATE_AFK
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end

	elseif 10 == anUpdateMode then -- VUHDO_UPDATE_ALIVE
		VUHDO_determineIncHeal(aUnit);

		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL

			VUHDO_refreshPrivateAuras(VUHDO_BUTTON_CACHE[tButton], tButton, aUnit);
		end

		VUHDO_updateIncHeal(aUnit, nil, nil, tAllButtons);

	elseif 25 == anUpdateMode then -- VUHDO_UPDATE_RESURRECTION
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 1, false); -- VUHDO_UPDATE_ALL
		end

	elseif 19 == anUpdateMode then -- VUHDO_UPDATE_DC
		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeText(tButton, 2, false); -- VUHDO_UPDATE_HEALTH

			VUHDO_refreshPrivateAuras(VUHDO_BUTTON_CACHE[tButton], tButton, aUnit);
		end

	elseif 1 == anUpdateMode then -- VUHDO_UPDATE_ALL
		VUHDO_determineIncHeal(aUnit);

		for _, tButton in pairs(tAllButtons) do
			VUHDO_customizeHealButton(tButton);
		end

		VUHDO_updateIncHeal(aUnit, VUHDO_IMMEDIATE, nil, tAllButtons);
	end

	return;

end



--
function VUHDO_updateAllPanelBars(aPanelNum)

	for _, tButton in pairs(VUHDO_getPanelButtons(aPanelNum)) do
		if not tButton:GetAttribute("unit") then break; end
		VUHDO_customizeHealButton(tButton);
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateHealthLossBar(tUnit, VUHDO_IMMEDIATE);
		VUHDO_updateIncHeal(tUnit, VUHDO_IMMEDIATE);
		VUHDO_updateManaBars(tUnit, 3);
	end

	return;

end



--
local tPanelButtons;
local tButton;
VUHDO_REMOVE_HOTS = true;
function VUHDO_updateAllRaidBars()

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if VUHDO_isPanelVisible(tPanelNum) then
			tPanelButtons = VUHDO_getPanelButtons(tPanelNum);

			for tBtnIdx = 1, #tPanelButtons do
				tButton = tPanelButtons[tBtnIdx];

				if tButton["raidid"] then
					VUHDO_customizeHealButton(tButton);
				end
			end
		end
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateHealthLossBar(tUnit, VUHDO_IMMEDIATE);
		VUHDO_updateIncHeal(tUnit, VUHDO_IMMEDIATE);
		VUHDO_updateManaBars(tUnit, 3);
		VUHDO_aggroBarBouquetCallback(tUnit, false);
	end

	if VUHDO_REMOVE_HOTS then
		if sSecretsEnabled then
			VUHDO_showAllAuras();
		else
			VUHDO_removeAllHots();
			VUHDO_updateAllHoTs();
		end

		if VUHDO_INTERNAL_TOGGLES[18] then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
			VUHDO_updateClusterHighlights();
		end
	else
		VUHDO_REMOVE_HOTS = true;
	end

	return;

end



--
function VUHDO_updatePanelButtons(aPanelNum)

	if not VUHDO_isPanelVisible(aPanelNum) then
		return;
	end

	for _, tButton in pairs(VUHDO_getPanelButtons(aPanelNum)) do
		if not tButton:GetAttribute("unit") then
			break;
		end

		VUHDO_customizeHealButton(tButton);
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateHealthLossBar(tUnit, VUHDO_IMMEDIATE);
	end

	return;

end



--
function VUHDO_deferUpdateAllRaidBarsDelegate(aPriority)

	for tPanelNum = 1, 10 do -- VUHDO_MAX_PANELS
		if VUHDO_isPanelVisible(tPanelNum) then
			VUHDO_deferUpdatePanelButtons(tPanelNum, aPriority);
		end
	end

	for tUnit, _ in pairs(VUHDO_RAID) do
		VUHDO_updateIncHeal(tUnit, VUHDO_IMMEDIATE);
		VUHDO_updateHealthLossBar(tUnit, VUHDO_IMMEDIATE);
		VUHDO_deferUpdateManaBars(tUnit, 3, aPriority);
		VUHDO_deferUpdateUnitAggro(tUnit, nil, aPriority);
	end

	if VUHDO_REMOVE_HOTS then
		VUHDO_deferUpdateAllHoTs(aPriority);

		if VUHDO_INTERNAL_TOGGLES[18] then -- VUHDO_UPDATE_MOUSEOVER_CLUSTER
			VUHDO_deferUpdateClusterHighlights(aPriority);
		end
	else
		VUHDO_REMOVE_HOTS = true;
	end

	return;

end