local _;

local pairs = pairs;
local twipe = table.wipe;
local debugprofilestop = debugprofilestop;

local VUHDO_updateEventBouquet;
local VUHDO_recordBouquetEvalMerged;
local VUHDO_recordPendingBouquetEvalsEnd;

local sIsQueueingBouquetEvals = false;
local sPendingEvals = { };
local sProcessingEvals = { };
local sQueuedEventTypesPool;
local sPendingEvalCostUs = 0;
local sPendingEvalCount = 0;
local sAvgEvalCostUs = 120;



--
function VUHDO_bouquetEvalQueueInitLocalOverrides()

	VUHDO_updateEventBouquet = _G["VUHDO_updateEventBouquet"];
	VUHDO_recordBouquetEvalMerged = _G["VUHDO_recordBouquetEvalMerged"];
	VUHDO_recordPendingBouquetEvalsEnd = _G["VUHDO_recordPendingBouquetEvalsEnd"];

	if not sQueuedEventTypesPool then
		sQueuedEventTypesPool = VUHDO_createTablePool("BouquetQueuedEventTypes", 400);
	end

	return;

end



do
	--
	local function VUHDO_getBouquetDelegateEventType(aQueuedEventTypes)

		if aQueuedEventTypes[1] then
			return 1;
		end

		for tEventType = 2, 50 do
			if aQueuedEventTypes[tEventType] then
				return tEventType;
			end
		end

		return 1;

	end



	--
	function VUHDO_setBouquetEvalQueueing(anIsEnabled)

		sIsQueueingBouquetEvals = anIsEnabled;

		return;

	end



	--
	function VUHDO_shouldQueueBouquetEval(anEventType)

		return sIsQueueingBouquetEvals and -1 ~= anEventType;

	end



	--
	function VUHDO_getPendingBouquetEvalCost()

		return sPendingEvalCostUs;

	end



	--
	local tUnitBouquets;
	local tQueuedEventTypes;
	function VUHDO_queueBouquetEval(aUnit, aBouquetName, anEventType)

		if not aUnit or not aBouquetName then
			return;
		end

		tUnitBouquets = sPendingEvals[aUnit];

		if not tUnitBouquets then
			tUnitBouquets = { };

			sPendingEvals[aUnit] = tUnitBouquets;
		end

		tQueuedEventTypes = tUnitBouquets[aBouquetName];

		if not tQueuedEventTypes then
			tQueuedEventTypes = sQueuedEventTypesPool:get();

			tUnitBouquets[aBouquetName] = tQueuedEventTypes;

			sPendingEvalCostUs = sPendingEvalCostUs + sAvgEvalCostUs;
			sPendingEvalCount = sPendingEvalCount + 1;
		else
			if VUHDO_BOUQUET_PROFILING_ENABLED then
				VUHDO_recordBouquetEvalMerged(aBouquetName);
			end
		end

		tQueuedEventTypes[anEventType] = true;

		return;

	end



	--
	local tDelegateEventType;
	local tProcessStartTime;
	local tProcessDurationUs;
	local tPairCount;
	local tMeasuredCostUs;
	function VUHDO_processPendingBouquetEvals()

		if 0 == sPendingEvalCount then
			return;
		end

		sProcessingEvals, sPendingEvals = sPendingEvals, sProcessingEvals;
		sPendingEvalCostUs = 0;
		sPendingEvalCount = 0;

		tProcessStartTime = debugprofilestop();
		tPairCount = 0;

		for tPendingUnit, tPendingUnitBouquets in pairs(sProcessingEvals) do
			for tPendingBouquetName, tPendingEventTypes in pairs(tPendingUnitBouquets) do
				tDelegateEventType = VUHDO_getBouquetDelegateEventType(tPendingEventTypes);

				VUHDO_updateEventBouquet(tPendingUnit, tPendingBouquetName, tDelegateEventType, tPendingEventTypes);

				tPairCount = tPairCount + 1;

				twipe(tPendingEventTypes);

				sQueuedEventTypesPool:release(tPendingEventTypes);
			end

			twipe(tPendingUnitBouquets);
		end

		tProcessDurationUs = (debugprofilestop() - tProcessStartTime) * 1000;

		if tPairCount > 0 then
			tMeasuredCostUs = tProcessDurationUs / tPairCount;

			sAvgEvalCostUs = sAvgEvalCostUs * 0.9 + tMeasuredCostUs * 0.1;
		end

		if VUHDO_BOUQUET_PROFILING_ENABLED then
			VUHDO_recordPendingBouquetEvalsEnd(tPairCount, tProcessDurationUs);
		end

		return;

	end
end