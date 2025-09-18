local T, C, L, G = unpack(select(2, ...))

--【重要打断计时条】
--[[
	T.Temp_ImportantInterruptBar(spellID, { -- 
		show_tar = true,
		ficon = "14",
		spellIDs = {spellID},
	}),
]]

T.Temp_ImportantInterruptBar = function(spellID, args)
	if args then
		local t = {
			category = "AlertTimerbar",
			type = "cast",
			spellID = spellID,
			ficon = "6",
			group = 1,
			glow = true,
			show_rm = true,
		}	
		MergeTable(t, args)	
		return t
	else
		return {
			category = "AlertTimerbar",
			type = "cast",
			spellID = spellID,
			ficon = "6",
			group = 1,
			glow = true,
			show_rm = true,
		}
	end
end

--【一般打断计时条】
--[[	
	T.Temp_NormalInterruptBar(spellID, { -- 
		show_tar = true,
		ficon = "14",
		spellIDs = {spellID},
	}),
]]
 
T.Temp_NormalInterruptBar = function(spellID, args)
	if args then
		local t = {
			category = "AlertTimerbar",
			type = "cast",
			spellID = spellID,
			ficon = "6",
			sub_group = 2,
			show_rm = true,
		}
		MergeTable(t, args)
		return t
	else
		return {
			category = "AlertTimerbar",
			type = "cast",
			spellID = spellID,
			ficon = "6",
			sub_group = 2,
			show_rm = true,
		}
	end
end

--【次级打断计时条】
--[[
	T.Temp_SubInterruptBar(spellID, { -- 
		show_tar = true,
		ficon = "14",
		spellIDs = {spellID},
	}),
]]

T.Temp_SubInterruptBar = function(spellID, args)
	if args then
		local t = {
			category = "AlertTimerbar",
			type = "cast",
			spellID = spellID,
			ficon = "6",
			sub_group = 2,
			enable_tag = "disable",
			show_rm = true,
		}
		MergeTable(t, args)
		return t
	else
		return {
			category = "AlertTimerbar",
			type = "cast",
			spellID = spellID,
			ficon = "6",
			sub_group = 2,
			enable_tag = "disable",
			show_rm = true,
		}
	end
end