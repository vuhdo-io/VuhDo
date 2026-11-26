local _;

local pairs = pairs;
local ipairs = ipairs;
local format = string.format;
local unpack = unpack;
local tinsert = table.insert;
local tconcat = table.concat;
local tsort = table.sort;
local twipe = table.wipe;
local floor = math.floor;

local GetTime = GetTime;
local debugprofilestop = debugprofilestop;
local debugstack = debugstack;
local gmatch = string.gmatch;
local strmatch = string.match;

VUHDO_BOUQUET_PROFILING_ENABLED = false;
VUHDO_BOUQUET_CALLER_TRACE_ENABLED = false;

VUHDO_BOUQUET_METRICS = {
	["events"] = { },
	["bouquets"] = { },
	["lastEvalTimes"] = { },
	["lastEvalEventTypes"] = { },
	["lastEvalCallers"] = { },
	["startTime"] = 0,
};
local VUHDO_BOUQUET_METRICS = VUHDO_BOUQUET_METRICS;

local VUHDO_startBouquetTimer;
local VUHDO_stopBouquetTimer;
local VUHDO_printBouquetTailMeanLine;
local VUHDO_captureBouquetCallerTrace;
local VUHDO_formatBouquetDupEventTypesLine;
local VUHDO_formatBouquetDupCallersLine;
local VUHDO_printBouquetRows;
local VUHDO_printPendingBouquetEvals;
local VUHDO_printBouquetEventRows;

local sTimerStartTimes = { };
local sTimerDepth = 0;
local sCallerParts = { };
local sIsSecretForced = false;
local sIsSecretSkipped = false;
local sTailMeanArgs = { };
local sDupSortRows = { };
local sDupLineParts = { };
local sBouquetRows = { };
local sEventRows = { };



do
	--
	function VUHDO_startBouquetTimer()

		sTimerDepth = sTimerDepth + 1;
		sTimerStartTimes[sTimerDepth] = debugprofilestop();

		return;

	end



	--
	local tStartTime;
	local tDurationUs;
	function VUHDO_stopBouquetTimer()

		if sTimerDepth <= 0 then
			return 0;
		end

		tStartTime = sTimerStartTimes[sTimerDepth];
		sTimerStartTimes[sTimerDepth] = nil;
		sTimerDepth = sTimerDepth - 1;
		tDurationUs = (debugprofilestop() - tStartTime) * 1000;

		return tDurationUs;

	end
end



do
	--
	local tStack;
	local tStackFile;
	local tStackLineNum;
	local tCallerPartCnt;
	function VUHDO_captureBouquetCallerTrace()

		tStack = debugstack(5, 3, 0);

		twipe(sCallerParts);
		tCallerPartCnt = 0;

		for tStackFrame in gmatch(tStack, "[^\n]+") do
			tStackFile, tStackLineNum = strmatch(tStackFrame, "([%w_]+%.lua)%]:(%d+)");

			if tStackFile then
				tCallerPartCnt = tCallerPartCnt + 1;
				sCallerParts[tCallerPartCnt] = format("%s:%s", tStackFile, tStackLineNum);

				if tCallerPartCnt >= 3 then
					break;
				end
			end
		end

		if tCallerPartCnt > 0 then
			return tconcat(sCallerParts, " < ", 1, tCallerPartCnt);
		end

		return "?";

	end
end



do
	--
	local tBouquetMetrics;
	local function VUHDO_getBouquetMetrics(aBouquetName)

		tBouquetMetrics = VUHDO_BOUQUET_METRICS["bouquets"][aBouquetName];

		if not tBouquetMetrics then
			tBouquetMetrics = {
				["evalTracker"] = VUHDO_createTailMeanTracker(),
				["delegateTracker"] = VUHDO_createTailMeanTracker(),
				["changed"] = 0,
				["duplicates"] = 0,
				["secretForced"] = 0,
				["secretSkipped"] = 0,
				["secretSkipMismatch"] = 0,
				["dupEventTypePairs"] = { },
				["dupCallers"] = { },
				["merged"] = 0,
			};
			VUHDO_BOUQUET_METRICS["bouquets"][aBouquetName] = tBouquetMetrics;
		end

		return tBouquetMetrics;

	end



	--
	function VUHDO_recordBouquetSecretForced()

		sIsSecretForced = true;

		return;

	end



	--
	function VUHDO_recordBouquetSecretSkipped()

		sIsSecretSkipped = true;

		return;

	end



	--
	local tBouquetMetrics;
	function VUHDO_recordBouquetSecretSkipMismatch(aBouquetName)

		tBouquetMetrics = VUHDO_getBouquetMetrics(aBouquetName);

		tBouquetMetrics["secretSkipMismatch"] = (tBouquetMetrics["secretSkipMismatch"] or 0) + 1;

		return;

	end



	--
	local tBouquetMetrics;
	function VUHDO_recordBouquetEvalMerged(aBouquetName)

		tBouquetMetrics = VUHDO_getBouquetMetrics(aBouquetName);

		tBouquetMetrics["merged"] = (tBouquetMetrics["merged"] or 0) + 1;

		return;

	end



	--
	local tLastEvalTimes;
	local tLastEvalEventTypes;
	local tLastEvalCallers;
	local tNow;
	local tPrevEventType;
	local tDupEventTypePairKey;
	local tPrevCaller;
	local tCaller;
	local tDupCallerKey;
	local tBouquetMetrics;
	function VUHDO_recordBouquetEvalStart(aUnit, aBouquetName, anEventType)

		sIsSecretForced = false;
		sIsSecretSkipped = false;

		tBouquetMetrics = VUHDO_getBouquetMetrics(aBouquetName);

		tLastEvalTimes = VUHDO_BOUQUET_METRICS["lastEvalTimes"][aBouquetName];

		if not tLastEvalTimes then
			tLastEvalTimes = { };
			VUHDO_BOUQUET_METRICS["lastEvalTimes"][aBouquetName] = tLastEvalTimes;
		end

		tLastEvalEventTypes = VUHDO_BOUQUET_METRICS["lastEvalEventTypes"][aBouquetName];

		if not tLastEvalEventTypes then
			tLastEvalEventTypes = { };
			VUHDO_BOUQUET_METRICS["lastEvalEventTypes"][aBouquetName] = tLastEvalEventTypes;
		end

		tNow = GetTime();

		if tLastEvalTimes[aUnit] == tNow then
			tBouquetMetrics["duplicates"] = (tBouquetMetrics["duplicates"] or 0) + 1;

			tPrevEventType = tLastEvalEventTypes[aUnit] or 0;
			tDupEventTypePairKey = tPrevEventType * 100 + (anEventType or 0);
			tBouquetMetrics["dupEventTypePairs"][tDupEventTypePairKey] = (tBouquetMetrics["dupEventTypePairs"][tDupEventTypePairKey] or 0) + 1;

			if VUHDO_BOUQUET_CALLER_TRACE_ENABLED then
				tLastEvalCallers = VUHDO_BOUQUET_METRICS["lastEvalCallers"][aBouquetName];

				if tLastEvalCallers then
					tPrevCaller = tLastEvalCallers[aUnit];
					tCaller = VUHDO_captureBouquetCallerTrace();

					if tPrevCaller and tCaller then
						tDupCallerKey = tPrevCaller .. " > " .. tCaller;
						tBouquetMetrics["dupCallers"][tDupCallerKey] = (tBouquetMetrics["dupCallers"][tDupCallerKey] or 0) + 1;
					end
				end
			end
		end

		tLastEvalTimes[aUnit] = tNow;
		tLastEvalEventTypes[aUnit] = anEventType or 0;

		if VUHDO_BOUQUET_CALLER_TRACE_ENABLED then
			tLastEvalCallers = VUHDO_BOUQUET_METRICS["lastEvalCallers"][aBouquetName];

			if not tLastEvalCallers then
				tLastEvalCallers = { };
				VUHDO_BOUQUET_METRICS["lastEvalCallers"][aBouquetName] = tLastEvalCallers;
			end

			tLastEvalCallers[aUnit] = VUHDO_captureBouquetCallerTrace();
		end

		VUHDO_startBouquetTimer();

		return;

	end



	--
	local tDurationUs;
	local tBouquetMetrics;
	function VUHDO_recordBouquetEvalEnd(aBouquetName, anIsChanged)

		tDurationUs = VUHDO_stopBouquetTimer();

		tBouquetMetrics = VUHDO_BOUQUET_METRICS["bouquets"][aBouquetName];

		if not tBouquetMetrics then
			sIsSecretForced = false;
			sIsSecretSkipped = false;

			return;
		end

		if tDurationUs > 0 then
			tBouquetMetrics["evalTracker"]:update(tDurationUs);
		end

		if anIsChanged then
			tBouquetMetrics["changed"] = (tBouquetMetrics["changed"] or 0) + 1;
		end

		if sIsSecretForced then
			tBouquetMetrics["secretForced"] = (tBouquetMetrics["secretForced"] or 0) + 1;
		end

		if sIsSecretSkipped then
			tBouquetMetrics["secretSkipped"] = (tBouquetMetrics["secretSkipped"] or 0) + 1;
		end

		sIsSecretForced = false;
		sIsSecretSkipped = false;

		return;

	end
end



do
	--
	function VUHDO_recordBouquetDelegatesStart()

		VUHDO_startBouquetTimer();

		return;

	end



	--
	local tBouquetMetrics;
	local tDurationUs;
	function VUHDO_recordBouquetDelegatesEnd(aBouquetName)

		tBouquetMetrics = VUHDO_BOUQUET_METRICS["bouquets"][aBouquetName];

		tDurationUs = VUHDO_stopBouquetTimer();

		if not tBouquetMetrics then
			return;
		end

		if tDurationUs > 0 then
			tBouquetMetrics["delegateTracker"]:update(tDurationUs);
		end

		return;

	end
end



do
	--
	local tEventMetrics;
	local function VUHDO_getBouquetEventMetrics(anEventType)

		tEventMetrics = VUHDO_BOUQUET_METRICS["events"][anEventType];

		if not tEventMetrics then
			tEventMetrics = {
				["callTracker"] = VUHDO_createTailMeanTracker(),
				["interestedBouquets"] = 0,
			};
			VUHDO_BOUQUET_METRICS["events"][anEventType] = tEventMetrics;
		end

		return tEventMetrics;

	end



	--
	function VUHDO_recordBouquetEventStart(anEventType)

		VUHDO_getBouquetEventMetrics(anEventType);

		VUHDO_startBouquetTimer();

		return;

	end



	--
	local tInterestedCount;
	local tDurationUs;
	local tEventMetrics;
	function VUHDO_recordBouquetEventEnd(anEventType, anInterestedBouquets)

		tEventMetrics = VUHDO_getBouquetEventMetrics(anEventType);

		tDurationUs = VUHDO_stopBouquetTimer();

		if tDurationUs > 0 then
			tEventMetrics["callTracker"]:update(tDurationUs);
		end

		tInterestedCount = 0;

		if anInterestedBouquets then
			for _ in pairs(anInterestedBouquets) do
				tInterestedCount = tInterestedCount + 1;
			end
		end

		tEventMetrics["interestedBouquets"] = (tEventMetrics["interestedBouquets"] or 0) + tInterestedCount;

		return;

	end
end



do
	--
	local tPendingEvalMetrics;
	local function VUHDO_getPendingBouquetEvalMetrics()

		tPendingEvalMetrics = VUHDO_BOUQUET_METRICS["pendingEvals"];

		if not tPendingEvalMetrics then
			tPendingEvalMetrics = {
				["calls"] = 0,
				["pairs"] = 0,
				["pairTracker"] = VUHDO_createTailMeanTracker(),
				["timeTracker"] = VUHDO_createTailMeanTracker(),
			};
			VUHDO_BOUQUET_METRICS["pendingEvals"] = tPendingEvalMetrics;
		end

		return tPendingEvalMetrics;

	end



	--
	local tPendingEvalMetrics;
	function VUHDO_recordPendingBouquetEvalsEnd(aPairCount, aDurationUs)

		tPendingEvalMetrics = VUHDO_getPendingBouquetEvalMetrics();

		tPendingEvalMetrics["calls"] = tPendingEvalMetrics["calls"] + 1;
		tPendingEvalMetrics["pairs"] = tPendingEvalMetrics["pairs"] + (aPairCount or 0);

		if aPairCount and aPairCount > 0 then
			tPendingEvalMetrics["pairTracker"]:update(aPairCount);
		end

		if aDurationUs and aDurationUs > 0 then
			tPendingEvalMetrics["timeTracker"]:update(aDurationUs);
		end

		return;

	end
end



do
	--
	function VUHDO_setBouquetProfiling(anIsEnabled)

		VUHDO_BOUQUET_PROFILING_ENABLED = anIsEnabled;

		if anIsEnabled then
			if (VUHDO_BOUQUET_METRICS["startTime"] or 0) == 0 then
				VUHDO_BOUQUET_METRICS["startTime"] = GetTime();
			end

			VUHDO_Msg("Bouquet profiling is enabled.");
		else
			VUHDO_Msg("Bouquet profiling is disabled.");
		end

		return;

	end



	--
	function VUHDO_resetBouquetMetrics()

		twipe(VUHDO_BOUQUET_METRICS["events"]);
		twipe(VUHDO_BOUQUET_METRICS["bouquets"]);
		twipe(VUHDO_BOUQUET_METRICS["lastEvalTimes"]);
		twipe(VUHDO_BOUQUET_METRICS["lastEvalEventTypes"]);
		twipe(VUHDO_BOUQUET_METRICS["lastEvalCallers"]);
		VUHDO_BOUQUET_METRICS["pendingEvals"] = nil;
		VUHDO_BOUQUET_METRICS["startTime"] = VUHDO_BOUQUET_PROFILING_ENABLED and GetTime() or 0;

		if VUHDO_BOUQUET_PROFILING_ENABLED then
			VUHDO_Msg("Bouquet metrics reset.");
		end

		return;

	end



	--
	function VUHDO_setBouquetCallerTrace(anIsEnabled)

		VUHDO_BOUQUET_CALLER_TRACE_ENABLED = anIsEnabled;

		if anIsEnabled then
			VUHDO_Msg("Bouquet caller trace is enabled (timings inflated by debugstack).");
		else
			VUHDO_Msg("Bouquet caller trace is disabled.");
		end

		return;

	end
end



do
	--
	local tTailMeanFormat;
	function VUHDO_printBouquetTailMeanLine(aLabel, aTailMeans)

		_, tTailMeanFormat = VUHDO_getTailMeanFormats();

		twipe(sTailMeanArgs);

		sTailMeanArgs[1] = aLabel;

		for tArgIdx, tTailMeanKey in ipairs(VUHDO_TAIL_MEAN_KEYS) do
			sTailMeanArgs[tArgIdx + 1] = VUHDO_formatTime(aTailMeans[tTailMeanKey] or 0) or "0 us";
		end

		VUHDO_Msg(format("    |cff98FB98%s|r " .. tTailMeanFormat, unpack(sTailMeanArgs)));

		return;

	end
end



do
	--
	local function VUHDO_sortBouquetDupEventTypeRows(aRow, anotherRow)

		if aRow["count"] == anotherRow["count"] then
			return (aRow["key"] or 0) < (anotherRow["key"] or 0);
		end

		return aRow["count"] > anotherRow["count"];

	end



	--
	local function VUHDO_sortBouquetDupCallerRows(aRow, anotherRow)

		if aRow["count"] == anotherRow["count"] then
			return (aRow["key"] or "") < (anotherRow["key"] or "");
		end

		return aRow["count"] > anotherRow["count"];

	end



	--
	local tDupSortRow;
	function VUHDO_formatBouquetDupEventTypesLine(aDupEventTypePairs)

		twipe(sDupSortRows);

		for tDupEventTypePairKey, tDupCount in pairs(aDupEventTypePairs) do
			tinsert(sDupSortRows, {
				["key"] = tDupEventTypePairKey,
				["count"] = tDupCount,
			});
		end

		tsort(sDupSortRows, VUHDO_sortBouquetDupEventTypeRows);

		twipe(sDupLineParts);

		for tRank = 1, #sDupSortRows do
			if tRank > 3 then
				break;
			end

			tDupSortRow = sDupSortRows[tRank];
			tinsert(sDupLineParts, format("%d>%d x%d",
				floor(tDupSortRow["key"] / 100), tDupSortRow["key"] % 100, tDupSortRow["count"]));
		end

		if #sDupLineParts == 0 then
			return nil;
		end

		return "Dup modes: " .. tconcat(sDupLineParts, ", ");

	end



	--
	local tDupSortRow;
	function VUHDO_formatBouquetDupCallersLine(aDupCallers)

		twipe(sDupSortRows);

		for tDupCallerKey, tDupCount in pairs(aDupCallers) do
			tinsert(sDupSortRows, {
				["key"] = tDupCallerKey,
				["count"] = tDupCount,
			});
		end

		tsort(sDupSortRows, VUHDO_sortBouquetDupCallerRows);

		twipe(sDupLineParts);

		for tRank = 1, #sDupSortRows do
			if tRank > 3 then
				break;
			end

			tDupSortRow = sDupSortRows[tRank];
			tinsert(sDupLineParts, format("%s x%d", tDupSortRow["key"], tDupSortRow["count"]));
		end

		if #sDupLineParts == 0 then
			return nil;
		end

		return "Dup callers: " .. tconcat(sDupLineParts, ", ");

	end
end



do
	--
	local function VUHDO_sortBouquetRows(aRow, anotherRow)

		if aRow["totalUs"] == anotherRow["totalUs"] then
			return (aRow["name"] or "") < (anotherRow["name"] or "");
		end

		return aRow["totalUs"] > anotherRow["totalUs"];

	end



	--
	local tRowStats;
	local tRowName;
	local tEvals;
	local tChanged;
	local tDuplicates;
	local tEvalTotalUs;
	local tDelegateTotalUs;
	local tTotalUs;
	local tChangedPct;
	local tDupPct;
	local tSecretForced;
	local tSecretSkipped;
	local tSecretSkipMismatch;
	local tSecretPct;
	local tSecretSkipPct;
	local tEvalTracker;
	local tDelegateTracker;
	local tEvalTailMeans;
	local tDelegateTailMeans;
	local tDupEventTypePairs;
	local tDupCallers;
	local tDupLine;
	local tMerged;
	local tRowCnt;
	function VUHDO_printBouquetRows(aMetrics)

		twipe(sBouquetRows);

		for tBouquetName, tBouquetStats in pairs(aMetrics["bouquets"]) do
			tEvalTracker = tBouquetStats["evalTracker"];
			tDelegateTracker = tBouquetStats["delegateTracker"];
			tEvalTotalUs = tEvalTracker and tEvalTracker:getCumulativeTotal() or 0;
			tDelegateTotalUs = tDelegateTracker and tDelegateTracker:getCumulativeTotal() or 0;
			tTotalUs = tEvalTotalUs + tDelegateTotalUs;

			tinsert(sBouquetRows, {
				["name"] = tBouquetName,
				["totalUs"] = tTotalUs,
				["stats"] = tBouquetStats,
			});
		end

		tsort(sBouquetRows, VUHDO_sortBouquetRows);

		VUHDO_Msg("|cffFFA500** Top bouquets (by eval+delegate total):|r");

		tRowCnt = 0;

		for _, tRow in ipairs(sBouquetRows) do
			tRowCnt = tRowCnt + 1;

			if tRowCnt > 15 then
				break;
			end

			tRowStats = tRow["stats"];
			tRowName = tRow["name"];
			tEvalTracker = tRowStats["evalTracker"];
			tDelegateTracker = tRowStats["delegateTracker"];
			tEvals = tEvalTracker and tEvalTracker["totalCount"] or 0;
			tChanged = tRowStats["changed"] or 0;
			tDuplicates = tRowStats["duplicates"] or 0;
			tSecretForced = tRowStats["secretForced"] or 0;
			tSecretSkipped = tRowStats["secretSkipped"] or 0;
			tSecretSkipMismatch = tRowStats["secretSkipMismatch"] or 0;
			tEvalTotalUs = tEvalTracker and tEvalTracker:getCumulativeTotal() or 0;
			tDelegateTotalUs = tDelegateTracker and tDelegateTracker:getCumulativeTotal() or 0;
			tTotalUs = tEvalTotalUs + tDelegateTotalUs;
			tChangedPct = tEvals > 0 and (100 * tChanged / tEvals) or 0;
			tDupPct = tEvals > 0 and (100 * tDuplicates / tEvals) or 0;
			tSecretPct = tEvals > 0 and (100 * tSecretForced / tEvals) or 0;
			tSecretSkipPct = tEvals > 0 and (100 * tSecretSkipped / tEvals) or 0;
			tMerged = tRowStats["merged"] or 0;

			if tSecretSkipMismatch > 0 then
				VUHDO_Msg(format("|cff98FB98Bouquet[%s]:|r E=%d, Chg=%.1f%%, Secret=%.1f%%, SecretSkip=%.1f%%, SkipMismatch=%d, Dup=%.1f%%, Merged=%d, Total=%s",
					tRowName, tEvals, tChangedPct, tSecretPct, tSecretSkipPct, tSecretSkipMismatch, tDupPct, tMerged, VUHDO_formatTime(tTotalUs)));
			else
				VUHDO_Msg(format("|cff98FB98Bouquet[%s]:|r E=%d, Chg=%.1f%%, Secret=%.1f%%, SecretSkip=%.1f%%, Dup=%.1f%%, Merged=%d, Total=%s",
					tRowName, tEvals, tChangedPct, tSecretPct, tSecretSkipPct, tDupPct, tMerged, VUHDO_formatTime(tTotalUs)));
			end

			tDupEventTypePairs = tRowStats["dupEventTypePairs"];

			if tDupEventTypePairs then
				tDupLine = VUHDO_formatBouquetDupEventTypesLine(tDupEventTypePairs);

				if tDupLine then
					VUHDO_Msg("    |cff98FB98" .. tDupLine .. "|r");
				end
			end

			tDupCallers = tRowStats["dupCallers"];

			if tDupCallers then
				tDupLine = VUHDO_formatBouquetDupCallersLine(tDupCallers);

				if tDupLine then
					VUHDO_Msg("    |cff98FB98" .. tDupLine .. "|r");
				end
			end

			tEvalTailMeans = tEvalTracker and tEvalTracker:getTailMeans() or VUHDO_getEmptyTailMeans();

			VUHDO_printBouquetTailMeanLine("Eval:", tEvalTailMeans);

			if tChanged > 0 and tDelegateTracker then
				tDelegateTailMeans = tDelegateTracker:getTailMeans();

				VUHDO_printBouquetTailMeanLine("Delegates:", tDelegateTailMeans);
			end
		end

		return;

	end
end



do
	--
	local tPendingEvalMetrics;
	local tPendingPairTailMeans;
	local tPendingTimeTailMeans;
	function VUHDO_printPendingBouquetEvals(aMetrics)

		tPendingEvalMetrics = aMetrics["pendingEvals"];

		if tPendingEvalMetrics and tPendingEvalMetrics["calls"] > 0 then
			VUHDO_Msg(format("|cffFFA500** Pending bouquet evals:|r Calls=%d, Pairs=%d",
				tPendingEvalMetrics["calls"], tPendingEvalMetrics["pairs"]));

			tPendingPairTailMeans = tPendingEvalMetrics["pairTracker"] and tPendingEvalMetrics["pairTracker"]:getTailMeans() or VUHDO_getEmptyTailMeans();

			VUHDO_printBouquetTailMeanLine("Pairs:", tPendingPairTailMeans);

			tPendingTimeTailMeans = tPendingEvalMetrics["timeTracker"] and tPendingEvalMetrics["timeTracker"]:getTailMeans() or VUHDO_getEmptyTailMeans();

			VUHDO_printBouquetTailMeanLine("Time:", tPendingTimeTailMeans);
		end

		return;

	end
end



do
	--
	local function VUHDO_sortBouquetEventRows(aRow, anotherRow)

		if aRow["totalUs"] == anotherRow["totalUs"] then
			return aRow["eventType"] < anotherRow["eventType"];
		end

		return aRow["totalUs"] > anotherRow["totalUs"];

	end



	--
	local tRowStats;
	local tCalls;
	local tInterestedCount;
	local tInterestedPerCall;
	local tCallTracker;
	local tTotalUs;
	local tCallTailMeans;
	function VUHDO_printBouquetEventRows(aMetrics)

		twipe(sEventRows);

		for tEventType, tEventStats in pairs(aMetrics["events"]) do
			tCallTracker = tEventStats["callTracker"];
			tTotalUs = tCallTracker and tCallTracker:getCumulativeTotal() or 0;
			tCalls = tCallTracker and tCallTracker["totalCount"] or 0;

			tinsert(sEventRows, {
				["eventType"] = tEventType,
				["totalUs"] = tTotalUs,
				["calls"] = tCalls,
				["interestedBouquets"] = tEventStats["interestedBouquets"] or 0,
				["stats"] = tEventStats,
			});
		end

		tsort(sEventRows, VUHDO_sortBouquetEventRows);

		VUHDO_Msg("|cffFFA500** Events (by VUHDO_updateBouquetsForEvent wall time):|r");

		for _, tRow in ipairs(sEventRows) do
			tRowStats = tRow["stats"];
			tCalls = tRow["calls"];
			tInterestedCount = tRow["interestedBouquets"];
			tInterestedPerCall = tCalls > 0 and (tInterestedCount / tCalls) or 0;
			tCallTracker = tRowStats["callTracker"];
			tTotalUs = tCallTracker and tCallTracker:getCumulativeTotal() or 0;

			VUHDO_Msg(format("|cff98FB98Mode[%d]:|r Calls=%d, Bouquets=%d, Bouquets/Call=%.1f, Total=%s",
				tRow["eventType"], tCalls, tInterestedCount, tInterestedPerCall, VUHDO_formatTime(tTotalUs)));

			tCallTailMeans = tCallTracker and tCallTracker:getTailMeans() or VUHDO_getEmptyTailMeans();

			VUHDO_printBouquetTailMeanLine("Call:", tCallTailMeans);
		end

		return;

	end
end



do
	--
	local tMetrics;
	local tSessionSecs;
	local tSessionUs;
	local tEventCallTotalUs;
	local tWallSharePct;
	local tCallTracker;
	function VUHDO_printBouquetMetrics()

		if not VUHDO_BOUQUET_PROFILING_ENABLED then
			VUHDO_Msg("Bouquet profiling is currently disabled.");
			return;
		end

		tMetrics = VUHDO_BOUQUET_METRICS;
		tSessionSecs = (tMetrics["startTime"] or 0) > 0 and (GetTime() - tMetrics["startTime"]) or 0;
		tSessionUs = tSessionSecs * 1000000;
		tEventCallTotalUs = 0;

		for _, tEventStats in pairs(tMetrics["events"]) do
			tCallTracker = tEventStats["callTracker"];

			if tCallTracker then
				tEventCallTotalUs = tEventCallTotalUs + tCallTracker:getCumulativeTotal();
			end
		end

		tWallSharePct = tSessionUs > 0 and (100 * tEventCallTotalUs / tSessionUs) or 0;

		VUHDO_Msg("|cffFFD100--- Bouquet Metrics ---|r");

		if VUHDO_BOUQUET_CALLER_TRACE_ENABLED then
			VUHDO_Msg("|cffFFA500** Note:|r caller trace on; eval timings inflated by debugstack.");
		end

		VUHDO_Msg(format("|cffFFA500** Session:|r %.1f s, event-call time %s (%.2f%% wall)",
			tSessionSecs, VUHDO_formatTime(tEventCallTotalUs), tWallSharePct));

		VUHDO_printBouquetRows(tMetrics);
		VUHDO_printPendingBouquetEvals(tMetrics);
		VUHDO_printBouquetEventRows(tMetrics);

		VUHDO_Msg("|cffFFD100--- End of Metrics ---|r");

		return;

	end
end