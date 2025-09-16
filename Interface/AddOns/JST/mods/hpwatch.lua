local T, C, L, G = unpack(select(2, ...))
local addon_name = G.addon_name

-- 消耗品
local playerPersonalItemData = {
	[5512] = {5512}, -- 治疗石
	[244837] = {244837, 244838, 244839}, -- 焕生治疗药水
}

local SameNameItemData = {
	[244837] = 244837, -- 焕生治疗药水1
	[244838] = 244837, -- 焕生治疗药水2
	[244839] = 244837, -- 焕生治疗药水3
}

local PersonalSpell_class = {
	PRIEST = { 
        19236, -- 绝望祷言
		33206, -- 痛苦压制
		47788, -- 守护之魂
		47585, -- 消散
	},
	DRUID = {
		22812, -- 树皮术
	    102342, -- 铁木树皮
		61336, -- 生存本能
		22842, -- 狂暴回复
	},
	SHAMAN = { 
		108271, -- 星界转移
	},
	PALADIN = {
        498, -- 圣佑术
		642, -- 圣盾术
	},
	WARRIOR = { 
		12975, -- 破釜沉舟
		871, -- 盾墙
		184364, -- 狂怒回复
		118038, -- 剑在人在
	},
	MAGE = { 
		45438, -- 寒冰屏障
	},
	WARLOCK = { 
		104773, -- 不灭决心
	},
	HUNTER = { 
		186265, -- 灵龟守护
	},
	ROGUE = { 
		31224, -- 暗影斗篷
		1966, -- 佯攻
	},
	DEATHKNIGHT = {
		48707, -- 反魔法护罩
		48792, -- 冰封之韧
	},
	MONK = {
		116849, -- 作茧缚命
		115203, -- 壮胆酒
		122470, -- 业报之触
		122783, -- 散魔功
	},
	DEMONHUNTER = {
		196555, -- 虚空行走
		187827, -- 恶魔变形
		212084, -- 邪能毁灭
		204021, -- 烈火烙印
		203720, -- 恶魔尖刺
	},
	EVOKER = {
		363916, -- 黑曜鳞片
		374348, -- 新生光焰
	},
}

-- 个人减伤法术
local playerPersonalSpellData = {}
for _, spellID in pairs(PersonalSpell_class[G.myClass]) do
	playerPersonalSpellData[spellID] = true	
end

-- 个人减伤光环
local playerPersonalBuffData = {}
for _, spellID in pairs(PersonalSpell_class[G.myClass]) do
	playerPersonalBuffData[spellID] = true
	T.RegisterWatchAuraSpellID(spellID)
end

for Class, spells in pairs(G.ClassShareSpellData) do
	for spellID in pairs(spells) do
		playerPersonalBuffData[spellID] = true
		T.RegisterWatchAuraSpellID(spellID)
	end
end
----------------------------------------------------------
-----------------[[    个人减伤提示    ]]-----------------
----------------------------------------------------------
local almost_ready_dur = 3
local checking_hp_tags = {}

local PersonalSpellFrame = T.CreateSpellLineFrame("PersonalSpellFrame", L["玩家自保技能提示"],  40, "CENTER", 0, 100)

PersonalSpellFrame.text = T.createtext(PersonalSpellFrame, "OVERLAY", 30, "OUTLINE", "LEFT")
PersonalSpellFrame.text:SetPoint("LEFT", PersonalSpellFrame, "LEFT", 0, 0)

PersonalSpellFrame.events = {
	["UNIT_HEALTH"] = true,
	["PLAYER_DEAD"] = true,
	["PLAYER_ALIVE"] = true,
}
		
local typePrority = {	
	["buff"] = 1,
	["spell"] = 2,
	["item"] = 3,
	["none"] = 4,
}

function PersonalSpellFrame:lineup()
	sort(self.active_byindex, function(a, b)		
		local pro_a = typePrority[a.type]
		local pro_b = typePrority[b.type]
		if pro_a < pro_b then
			return true
		elseif pro_a == pro_b then
			if a.spellID and b.spellID then
				return a.spellID < b.spellID
			elseif a.itemID and b.itemID then
				return a.itemID < b.itemID
			end
		end
	end)
	
	local lastframe
	for index, icon in pairs(self.active_byindex) do
		if icon:IsShown() then
			icon:ClearAllPoints()
			if not lastframe then
				icon:SetPoint("LEFT", self.text, "RIGHT", 5, 0)
			else
				icon:SetPoint("LEFT", lastframe, "RIGHT", 5, 0)	
			end
			lastframe = icon
		end
	end
end

function PersonalSpellFrame:ShowCheck(perc)	
	for tag, threshold in pairs(checking_hp_tags) do
		if perc <= threshold then
			return true
		end
	end
end

function PersonalSpellFrame:HideCheck(perc)
	local should_show
	for tag, threshold in pairs(checking_hp_tags) do
		if perc < threshold + 10 then
			 should_show = true
			 break
		end
	end
	return not should_show
end

T.Play_personlspell_sound = function()
	if C.DB["GeneralOption"]["personal_spell_sound"] ~= "none" then	
		T.PlaySound(C.DB["GeneralOption"]["personal_spell_sound"])
	end
end

function PersonalSpellFrame:Update()
	if UnitIsDeadOrGhost("player") then
		self:Hide()
	else
		local hp = UnitHealth("player")
		local max_hp = UnitHealthMax("player")
		if hp and max_hp then
			local perc = hp/max_hp*100
			self.text:SetTextColor(1, perc/100, 0)
			self.text:SetText(string.format("%d%%", perc))
			
			if not self:IsShown() then
				if self:ShowCheck(perc) then
					self:Show()
					T.Play_personlspell_sound()
				end
			else
				if self:HideCheck(perc) then
					self:Hide()
				end
			end
		end
	end
end

PersonalSpellFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_HEALTH" then
		local unit = ...
		if unit == "player" then
			self:Update()
		end
	elseif event == "PLAYER_DEAD" or event == "PLAYER_ALIVE" then
		self:Update()
	end
end)

PersonalSpellFrame.t = 0
PersonalSpellFrame:SetScript("OnUpdate", function(self, e)
	self.t = self.t + e
	if self.t > .5 then
		self:Update()
		self.t = 0
	end
end)

T.AddPersonalSpellCheckTag = function(tag, perc, ignore_roles)
	if ignore_roles and type(ignore_roles) == "table" then 
		local my_role = T.GetMyRole()
		if my_role and not tContains(ignore_roles, my_role) then
			checking_hp_tags[tag] = perc
			PersonalSpellFrame:Update()
		end
	else
		checking_hp_tags[tag] = perc
		PersonalSpellFrame:Update()
	end
end

T.RemovePersonalSpellCheckTag = function(tag)
	checking_hp_tags[tag] = nil
	PersonalSpellFrame:Update()
end

T.AddGeneralHPCheck = function()	
	if C.DB["GeneralOption"]["personal_spell_low_hp"] then
		local threshold = C.DB["GeneralOption"]["personal_spell_low_hp_value"]
		T.AddPersonalSpellCheckTag("general", threshold)
	else
		T.RemovePersonalSpellCheckTag("general")
	end
end

local function CreatePersonalSpellIcon(updater, group, tag)
	local icon = T.CreateSpellIconBase(PersonalSpellFrame, tag)

	icon.dur_text = T.createtext(icon, "OVERLAY", 14, "OUTLINE", "CENTER") -- 持续时间
	icon.dur_text:SetPoint("TOP", icon, "BOTTOM", 0, -2)
	icon.dur_text:SetTextColor(1, 1, 0)
	icon.dur_text:SetHeight(12)
	
	function icon:update_onedit(option)
		if option == "all" or option == "icon_size" then
			self:SetSize(C.DB["GeneralOption"]["personal_spell_size"], C.DB["GeneralOption"]["personal_spell_size"])
		end
	end
	
	function icon:display_charge(charge)
		if charge and charge > 1 then
			self.charge_text:SetText(charge)
		else
			self.charge_text:SetText("")
		end
	end
	
	function icon:display_cd(start, dur)
		if start and dur then
			self.cooldown:SetCooldown(start, dur)
			self.texture:SetDesaturated(true)
		else
			self.cooldown:SetCooldown(0, 0)
			self.texture:SetDesaturated(false)
		end
	end
	
	function icon:display_dur(exp_time)
		if exp_time then
			self.t = 0
			self.exp_time = exp_time
			
			self:SetScript("OnUpdate", function(s, e)
				s.t = s.t + e
				if s.t > .05 then
					local remain = s.exp_time - GetTime()
					if remain > 0 then
						s.dur_text:SetText(T.FormatTime(remain))
					else
						s.dur_text:SetText("")
						s:SetScript("OnUpdate", nil)
					end
					s.t = 0
				end
			end)
		else
			self:SetScript("OnUpdate", nil)
			self.dur_text:SetText("")
		end
	end
	
	function icon:display_glow(show)
		if show then
			T.PixelGlow_Start(self, {1, 1, 0}, 12, .25, nil, 3, 0, 0, true, "active_buff")
		else
			T.PixelGlow_Stop(self, "active_buff")
		end
	end
	
	function icon:init_spell_display(spellID, charge, start, dur)
		self.type = "spell"
		self.spellID = spellID
		
		self.texture:SetTexture(C_Spell.GetSpellTexture(spellID))
		
		self:display_charge(charge)
		self:display_cd(start, dur)
		
		self:update_onedit("all")
		self:Show()
	end
	
	function icon:init_item_display(itemID, start, dur)
		self.type = "item"
		self.itemID = itemID
		
		self.texture:SetTexture(select(5, C_Item.GetItemInfoInstant(itemID)))
		self:display_cd(start, dur)
		
		self:update_onedit("all")
		self:Show()
	end
	
	function icon:init_buff_display(spellID, exp_time)
		self.type = "buff"
		self.spellID = spellID		
		
		self.texture:SetTexture(C_Spell.GetSpellTexture(spellID))
		self:display_dur(exp_time)
		self:display_glow(true)
		
		self:update_onedit("all")
		self:Show()
	end
	
	function icon:cancel()
		self.type = "none"
		self:display_charge()
		self:display_cd()
		self:display_dur()
		self:display_glow(false)
		
		self:Hide()
	end
	
	updater.actives_bytag[tag] = icon
	
	return icon
end

-- 技能
local PersonalSpell_Updater = T.CreateUpdater(CreatePersonalSpellIcon, PersonalSpellFrame)

local function IsSpellAlmostReady(spellID)
	if not IsPlayerSpell(spellID) then
		return
	end
	
	local charge_info = C_Spell.GetSpellCharges(spellID)	
	if charge_info then
		if charge_info.currentCharges > 0 then
			return charge_info.currentCharges
		else
			local start = charge_info.cooldownStartTime
			local dur = charge_info.cooldownDuration
			local remain = start + dur - GetTime()
			if remain < almost_ready_dur then
				return 0, start, dur
			end
		end
	else
		local cd_info = C_Spell.GetSpellCooldown(spellID)
		local start = cd_info.startTime
		local dur = cd_info.duration
		if start and dur < 2 then
			return 1
		else
			local remain = start + dur - GetTime()
			if remain < almost_ready_dur then
				return 0, start, dur
			end 
		end
	end
end

PersonalSpell_Updater.last_update = 0
PersonalSpell_Updater:SetScript("OnEvent", function(self, event, ...)
	if event == "SPELLS_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" or event == "SPELL_UPDATE_CHARGES" then
		if GetTime() - self.last_update > .5 then
			self.last_update = GetTime()
			
			for tag, icon in pairs(self.actives_bytag) do
				if not IsSpellAlmostReady(icon.spellID) then
					self:RemoveAlert(icon.tag)
				end
			end
			
			for spellID in pairs(playerPersonalSpellData) do	
				local charge, start, dur = IsSpellAlmostReady(spellID)
				if charge then
					if not self.actives_bytag[spellID] then
						local icon = self:GetAlert(1, spellID)
						icon:init_spell_display(spellID, charge, start, dur)
					else
						local icon = self.actives_bytag[spellID]
						icon:display_charge(charge)
						icon:display_cd(start, dur)						
					end
				end
			end
		end
	end
end)

local personal_spell_events = {
	["SPELLS_CHANGED"] = true,
	["SPELL_UPDATE_COOLDOWN"] = true,
	["SPELL_UPDATE_CHARGES"] = true,
}

T.RegisterEventAndCallbacks(PersonalSpell_Updater, personal_spell_events)

-- 消耗品
local PersonalItem_Updater = T.CreateUpdater(CreatePersonalSpellIcon, PersonalSpellFrame)

local function IsItemAlmostReady(itemID)
	-- 数量
	local items = playerPersonalItemData[itemID]
	local count = 0
	for _, key in pairs(items) do
		count = count + C_Item.GetItemCount(key)
	end	
	if count == 0 then
		return
	end
	
	-- 冷却
	local start, dur, enable = C_Container.GetItemCooldown(itemID)
	if enable == 0 then
		return
	elseif start == 0 then
		return 1
	else		
		local remain = start + dur - GetTime()
		if remain < almost_ready_dur then
			return 0, start, dur
		end
	end
end

PersonalItem_Updater.last_update = 0
PersonalItem_Updater:SetScript("OnEvent", function(self, event, ...)
	if event == "ITEM_COUNT_CHANGED" then
		local real_itemID = ...
		local itemID = SameNameItemData[real_itemID] or real_itemID
		if playerPersonalItemData[itemID] then
			local charge, start, dur = IsItemAlmostReady(itemID)
			if charge then
				if not self.actives_bytag[itemID] then
					local icon = self:GetAlert(1, itemID)
					icon:init_item_display(itemID, start, dur)
				else
					local icon = self.actives_bytag[itemID]
					icon:display_cd(start, dur)						
				end
			elseif self.actives_bytag[itemID] then
				local icon = self.actives_bytag[itemID]
				self:RemoveAlert(icon.tag)
			end
		end
	elseif event == "BAG_UPDATE_COOLDOWN" then
		if GetTime() - self.last_update > .5 then
			self.last_update = GetTime()
			
			for tag, icon in pairs(self.actives_bytag) do
				if not IsItemAlmostReady(icon.itemID) then
					self:RemoveAlert(icon.tag)
				end
			end
			
			for itemID in pairs(playerPersonalItemData) do	
				local charge, start, dur = IsItemAlmostReady(itemID)
				if charge then
					if not self.actives_bytag[itemID] then
						local icon = self:GetAlert(1, itemID)
						icon:init_item_display(itemID, start, dur)
					else
						local icon = self.actives_bytag[itemID]
						icon:display_cd(start, dur)						
					end
				end
			end
		end
	end
end)

local personal_item_events = {	
	["ITEM_COUNT_CHANGED"] = true,
	["BAG_UPDATE_COOLDOWN"] = true,
}

T.RegisterEventAndCallbacks(PersonalItem_Updater, personal_item_events)

-- 光环
local PersonalBuff_Updater = T.CreateUpdater(CreatePersonalSpellIcon, PersonalSpellFrame)

PersonalBuff_Updater:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_AURA_ADD" then
		local unit, spellID, auraID = ...
		if unit == "player" and playerPersonalBuffData[spellID] then
			if not self.actives_bytag["buff"..auraID] then
				local icon = self:GetAlert(1, "buff"..auraID)
				local aura_data = C_UnitAuras.GetAuraDataByAuraInstanceID("player", auraID)
				icon:init_buff_display(spellID, aura_data.expirationTime)
			end
		end
	elseif event == "UNIT_AURA_UPDATE" then
		local unit, spellID, auraID = ...
		if unit == "player" and auraID and self.actives_bytag["buff"..auraID] then
			local icon = self.actives_bytag["buff"..auraID]
			local aura_data = C_UnitAuras.GetAuraDataByAuraInstanceID("player", auraID)
			if aura_data then
				icon:display_dur(aura_data.expirationTime)
			end
		end
	elseif event == "UNIT_AURA_REMOVED" then
		local unit, spellID, auraID = ...
		if unit == "player" and self.actives_bytag["buff"..auraID] then
			local icon = self.actives_bytag["buff"..auraID]			
			self:RemoveAlert("buff"..auraID)
		end
	end
end)

local personal_buff_events = {
	["UNIT_AURA_ADD"] = true,
	["UNIT_AURA_UPDATE"] = true,
	["UNIT_AURA_REMOVED"] = true,	
}

T.RegisterEventAndCallbacks(PersonalBuff_Updater, personal_buff_events)

local HPWatchFrames = {}
local HPWatchAlertMultiSpellData = {}
local HPWatchTrigger = CreateFrame("Frame", addon_name.."HPWatchTrigger")
G.HPWatchTrigger = HPWatchTrigger

HPWatchTrigger.events = {
	["COMBAT_LOG_EVENT_UNFILTERED"] = true,
	["UNIT_AURA"] = true,
}
HPWatchTrigger.WatchedAuraTypes = {"HARMFUL"} -- 只检查debuff
HPWatchTrigger.WatchedAuraIDs = {}

function HPWatchTrigger:ActiveCheck(alert_type, spellID)
	if not HPWatchFrames[alert_type][spellID].check then
		local info = HPWatchFrames[alert_type][spellID]
		info.check = true
		local tag = string.format("hpwatch-%s-%d", alert_type, spellID)
		local threshold = C.DB["HPWatch"][alert_type][spellID]["hp_perc_sl"]
		T.AddPersonalSpellCheckTag(tag, threshold, info.ignore_roles)
	end
end

function HPWatchTrigger:RemoveCheck(alert_type, spellID)
	if HPWatchFrames[alert_type][spellID].check then
		local info = HPWatchFrames[alert_type][spellID]
		info.check = false
		local tag = string.format("hpwatch-%s-%d", alert_type, spellID)
		T.RemovePersonalSpellCheckTag(tag)
	end
end

function HPWatchTrigger:AuraFullCheck()
	for _, auraType in pairs(self.WatchedAuraTypes) do
		AuraUtil.ForEachAura("player", auraType, nil, function(aura_data)
			local spellID = HPWatchAlertMultiSpellData[aura_data.spellId] or aura_data.spellId
			local info = T.ValueFromPath(HPWatchFrames, {"Aura", spellID})
			if info then							
				local enable = T.ValueFromDB({"HPWatch", "Aura", spellID, "enable"})
				if enable then
					self.WatchedAuraIDs[aura_data.auraInstanceID] = spellID
					
					if info.amount == 0 then
						self:ActiveCheck("Aura", spellID)
					else
						if aura_data.applications >= info.amount then
							self:ActiveCheck("Aura", spellID)
						end
					end
				else
					self:RemoveCheck("Aura", spellID)
				end
			end
		end, true)
	end
end

HPWatchTrigger:SetScript("OnEvent", function(self, event, ...)	
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		local config_spellID = HPWatchAlertMultiSpellData[spellID] or spellID
		if HPWatchFrames.CLEU and HPWatchFrames.CLEU[config_spellID] and HPWatchFrames.CLEU[config_spellID].event == sub_event then
			local enable = T.ValueFromDB({"HPWatch", "CLEU", config_spellID, "enable"})
			
			if not enable then return end
			
			local info = HPWatchFrames.CLEU[config_spellID]			
			if not info.target_me or G.PlayerGUID == destGUID then
				self:ActiveCheck("CLEU", config_spellID)
				
				C_Timer.After(info.dur, function()
					self:RemoveCheck("CLEU", config_spellID)
				end)
			end
		end
	elseif event == "UNIT_AURA" then
		local unit, updateInfo = ...		
		if unit ~= "player" then return end
		
		if updateInfo == nil or updateInfo.isFullUpdate then			
			self:AuraFullCheck()
		else
			if updateInfo.addedAuras ~= nil then
				for _, aura_data in pairs(updateInfo.addedAuras) do
					local spellID = HPWatchAlertMultiSpellData[aura_data.spellId] or aura_data.spellId
					local info = T.ValueFromPath(HPWatchFrames, {"Aura", spellID})
					if info then
						local enable = T.ValueFromDB({"HPWatch", "Aura", spellID, "enable"})
						if enable then
							self.WatchedAuraIDs[aura_data.auraInstanceID] = spellID
							
							local check_stack = info.amount
							if check_stack == 0 then
								self:ActiveCheck("Aura", spellID)
							else
								if aura_data.applications >= check_stack then
									self:ActiveCheck("Aura", spellID)
								end
							end
						end
					end
				end
			end
			if updateInfo.updatedAuraInstanceIDs ~= nil then
				for _, auraID in pairs(updateInfo.updatedAuraInstanceIDs) do
					if self.WatchedAuraIDs[auraID] then
						local aura_data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraID)
						if aura_data then
							local spellID = HPWatchAlertMultiSpellData[aura_data.spellId] or aura_data.spellId
							local info = T.ValueFromPath(HPWatchFrames, {"Aura", spellID})
							if info and info.amount > 0 then
								local enable = T.ValueFromDB({"HPWatch", "Aura", spellID, "enable"})
								if enable then
									if aura_data.applications >= info.amount then
										self:ActiveCheck("Aura", spellID)
									end
								end
							end
						end
					end
				end
			end
			if updateInfo.removedAuraInstanceIDs ~= nil then
				for _, auraID in pairs(updateInfo.removedAuraInstanceIDs) do
					local spellID = self.WatchedAuraIDs[auraID]
					if spellID then
						self:RemoveCheck("Aura", spellID)
						self.WatchedAuraIDs[auraID] = nil
					end
				end
			end
		end
		
	elseif event == "OPTION_EDIT" then
		self:AuraFullCheck()
	end
end)

T.CreateHPWatchAlert = function(option_page, category, args)
	local details = {
		hp_perc_sl = args.threshold
	}
	
	local detail_options = {
		{
			key = "hp_perc_sl",
			text = L["血量阈值百分比"],
			default = args.threshold or 65,
			min = 20,
			max = 100,
		}
	}
	
	local path = {category, args.type, args.spellID}
	T.InitSettings(path, args.enable_tag, args.ficon, details)
	T.Create_HPWatch_Options(option_page, category, path, args, detail_options)
	
	if not HPWatchFrames[args.type] then
		HPWatchFrames[args.type] = {}
	end
	
	if HPWatchFrames[args.type][args.spellID] then
		T.msg("HPWatch", args.type, args.spellID, "标签重复")
	end
	
	HPWatchFrames[args.type][args.spellID] = {
		ignore_roles = args.ignore_roles or {"TANK"},
	}
	
	if args.spellIDs then
		for _, spellID in pairs(args.spellIDs) do
			HPWatchAlertMultiSpellData[spellID] = args.spellID
		end
	end
	
	if args.type == "CLEU" then
		HPWatchFrames[args.type][args.spellID].event = args.event
		HPWatchFrames[args.type][args.spellID].dur = args.dur
		HPWatchFrames[args.type][args.spellID].target_me = args.target_me
	elseif args.type == "Aura" then
		HPWatchFrames[args.type][args.spellID].amount = args.amount or 0
		HPWatchFrames[args.type][args.spellID].spellIDs = args.spellIDs
	end
end

T.EditPersonalSpellFrame = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["personal_spell_enable"] then
			T.RestoreDragFrame(PersonalSpellFrame)
			T.RegisterEventAndCallbacks(PersonalSpellFrame, PersonalSpellFrame.events)
			T.RegisterEventAndCallbacks(HPWatchTrigger, HPWatchTrigger.events)
		else
			T.ReleaseDragFrame(PersonalSpellFrame)
			T.UnregisterEventAndCallbacks(PersonalSpellFrame, PersonalSpellFrame.events)
			T.UnregisterEventAndCallbacks(HPWatchTrigger, HPWatchTrigger.events)
			PersonalSpellFrame:Hide()
		end
	end
	if option == "all" or option == "icon_size" then
		PersonalSpellFrame:SetSize(C.DB["GeneralOption"]["personal_spell_size"]*4+20, C.DB["GeneralOption"]["personal_spell_size"])
	end
	for _, icon in pairs(PersonalSpellFrame.active_byindex) do
		icon:update_onedit(option)
	end
end
