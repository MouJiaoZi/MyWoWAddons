local T, C, L, G = unpack(select(2, ...))

local addon_name = G.addon_name

----------------------------------------------------------
-----------------[[    Frame Holder    ]]-----------------
----------------------------------------------------------
local FrameHolder = _G[addon_name.."FrameHolder"]

local update_rate = .05
local tl_update_rate = .5

----------------------------------------------------------
----------------------[[    API    ]]---------------------
----------------------------------------------------------
-- IsSpellKnownOrOverridesKnown
local function MySpellCheck(spellID)
	if not IsPlayerSpell(spellID) then
		return
	end
	
	local charges = C_Spell.GetSpellCharges(spellID)	
	if charges and charges.currentCharges > 0 then
		return true, charges.currentCharges
	else
		local cd_info = C_Spell.GetSpellCooldown(spellID)
		local start, dur = cd_info.startTime, cd_info.duration
		if start and dur < 2 then
			return true, 1
		end
	end
end

local function MyItemCheck(itemID)
	local itemType = select(6, C_Item.GetItemInfoInstant(itemID))
	if itemType == 2 or itemType == 4 then -- 武器或护甲
		if IsEquippedItem(itemID) then
			local start, duration, enable = GetItemCooldown(itemID)
			if enable == 1 and start and duration < 2 then
				return true
			end
		end
	elseif itemType == 0 then -- 消耗品
		if GetItemCount(itemID) > 0 then
			local start, duration, enable = GetItemCooldown(itemID)
			if enable == 1 and start and duration < 2 then
				return true
			end
		end
	end
end

local function CreateSpellLineFrame(name, text, size, dir, anchor, x, y)
	local frame = CreateFrame("Frame", addon_name..name, FrameHolder)
	
	local width, height
	if dir == "vertical" then
		width = size
		height = size*5 + 5*4
	else
		width = size*5 + 5*4
		height = size
	end
	frame:SetSize(width, height)
	
	frame.movingname = text
	frame.point = { a1 = anchor, a2 = "CENTER", x = x, y = y}
	T.CreateDragFrame(frame)
	
	frame.active_byindex = {}
	
	return frame
end

local function CreateSpellIconBase(parent, tag)
	local icon = CreateFrame("Frame", nil, parent)
	icon:SetSize(40, 40)
	icon:Hide()
	
	T.createborder(icon)
	
	icon.texture = icon:CreateTexture(nil, "BORDER", nil, 1)
	icon.texture:SetTexCoord( .1, .9, .1, .9)
	icon.texture:SetAllPoints()
	
	icon.charge_text = T.createtext(icon, "OVERLAY", 20, "OUTLINE", "RIGHT") -- 层数
	icon.charge_text:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 2)
	icon.charge_text:SetHeight(12)
	icon.charge_text:SetTextColor(0, 1, 1)
	
	icon:HookScript("OnShow", function(self)
		parent:lineup()
	end)
	
	icon:HookScript("OnHide", function(self)
		parent:lineup()
	end)
	
	table.insert(parent.active_byindex, icon)
	
	icon.tag = tag
	
	return icon
end

local function InRangeOfUnit(unit)
	if UnitIsUnit(unit, "player") then
		return true
	else
		local class = select(2, UnitClass(unit))
		if class == "EVOKER" then
			if G.myClass == "EVOKER" then
				return UnitInRange(unit)
			else
				return C_Item.IsItemInRange(1180, unit) --30
			end
		else
			if G.myClass == "EVOKER" then
				return C_Item.IsItemInRange(34471, unit) -- 40
			else
				return UnitInRange(unit)
			end
		end
	end
end

----------------------------------------------------------
---------------------[[    Data    ]]---------------------
----------------------------------------------------------
local ClassShareSpellData = {
	PRIEST = {
		[33206] = "protect", -- 痛苦压制
		[47788] = "protect", -- 守护之魂
		[73325] = "rescue", -- 信仰飞跃
		[194509] = "protect", -- TEST
	},
	DRUID = {
		[102342] = "protect", -- 铁木树皮
	},
	SHAMAN = { 
	},
	PALADIN = {
		[633] = "misc", -- 圣疗术
		[1022] = "misc", -- 保护祝福
		[6940] = "protect", -- 牺牲祝福
		[1044] = "misc", -- 自由祝福	
		[642] = "immunity", -- 圣盾术
		[204018] = "immunity", -- 破咒祝福
	},
	WARRIOR = { 
	},
	MAGE = {
		[45438] = "immunity", -- 寒冰屏障
	},
	WARLOCK = { 
	},
	HUNTER = { 	
		[186265] = "immunity", -- 龟壳
	},
	ROGUE = { 
		[31224] = "immunity", -- 斗篷
	},
	DEATHKNIGHT = {
	},
	MONK = {
		[116849] = "protect", -- 作茧缚命
	},
	DEMONHUNTER = {
		[196555] = "immunity", -- 虚空行走
	},
	EVOKER = {
		[357170] = "protect", -- 时间膨胀
		[370665] = "rescue", -- 营救
	},
}
G.ClassShareSpellData = ClassShareSpellData

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

-- 所有同步CD信息法术
local ClassShareSpellDatabySpell = {}
for Class, spells in pairs(ClassShareSpellData) do
	for spellID in pairs(spells) do
		ClassShareSpellDatabySpell[spellID] = true
	end
end

-- 玩家同步CD信息的法术
local playerShareSpellData = ClassShareSpellData[G.myClass]

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
for Class, spells in pairs(ClassShareSpellData) do
	for spellID in pairs(spells) do
		playerPersonalBuffData[spellID] = true
		T.RegisterWatchAuraSpellID(spellID)
	end
end

-- 消耗品
local playerPersonalItemData = {
	[5512] = {5512}, -- 治疗石
	[211878] = {211878, 211879, 211880}, -- 阿加治疗药水
}

local SameNameItemData = {
	[211878] = 211878, -- 阿加治疗药水1
	[211879] = 211878, -- 阿加治疗药水2
	[211880] = 211878, -- 阿加治疗药水3
}
---------------------------------------------------------
----------------[[    法术请求按钮    ]]------------------
----------------------------------------------------------
local ASFrame = CreateFrame("Frame", addon_name.."ASFrame", FrameHolder)
ASFrame.text_frames = {
	send = {},
	receive = {},
}

function ASFrame:CreateTextFrame(tag)
	local ind = #self.text_frames[tag] + 1
	local group = tag == "send" and 1 or 2
	
	local frame = T.CreateAlertTextShared("ASFrame"..tag..ind, group)

	frame:HookScript("OnHide", function(self)
		self.active = false
	end)
	
	self.text_frames[tag][ind] = frame

	return frame
end

function ASFrame:GetAvailableTextFrame(tag)
	for i, frame in pairs(self.text_frames[tag]) do
		if not frame.active then
			frame.active = true
			return frame
		end
	end
	
	local new_frame = self:CreateTextFrame(tag)
	new_frame.active = true
	return new_frame
end

local Play_askspell_sound = function(player, spell)
	if C.DB["GeneralOption"]["cs_sound"] ~= "none" then
		if C.DB["GeneralOption"]["cs_sound"] ~= "speak" then
			T.PlaySound(C.DB["GeneralOption"]["cs_sound"])
		else
			T.SpeakText(spell..player)
		end
	end
end
T.Play_askspell_sound = Play_askspell_sound

local FormatAskedSpell = function(GUID, spellID, dur)
	local info = T.GetGroupInfobyGUID(GUID)
	local spell_name = C_Spell.GetSpellName(spellID)
	local spell_icon = C_Spell.GetSpellTexture(spellID)
	
	if info then
		Play_askspell_sound(T.GetNameByGUID(GUID), spell_name)
		
		local str = string.format("%s %s %s", T.GetTextureStr(spell_icon), info.format_name, T.GetTextureStr(spell_icon))
		
		local text_frame = ASFrame:GetAvailableTextFrame("receive")
		T.Start_Text_Timer(text_frame, dur, str)
	
		T.GlowRaidFramebyUnit_Show("proc", "asspell", info.unit, {0, 1, 0}, dur) -- 团队框架动画
	end
end
T.FormatAskedSpell = FormatAskedSpell

local HideAskedSpell = function(GUID)
	if GUID then
		local info = T.GetGroupInfobyGUID(GUID)
		if info then
			T.GlowRaidFramebyUnit_Hide("proc", "asspell", info.unit)
		end
	else
		T.GlowRaidFrame_HideAll("proc", "asspell")
	end
	T.Stop_Text_Timer(ASFrame.text_frame)
end
T.HideAskedSpell = HideAskedSpell

local SendSpellRequest = function(target, format_name, spellID)
	local spell_name = T.GetIconLink(spellID)
	
	T.addon_msg("AskSpell,"..spellID, "WHISPER", target)
	T.msg(string.format(L["法术请求已发送完整"], format_name, spell_name))
	
	local spell_icon = T.GetSpellIcon(spellID)
	local text_frame = ASFrame:GetAvailableTextFrame("send")
	T.Start_Text_Timer(text_frame, 3, string.format(L["法术请求已发送简略"], format_name, spell_icon))
end
T.SendSpellRequest = SendSpellRequest

local function UpdateAskSpell(event, ...)
	local channel, sender, GUID, message, spell = ...
	if message == "AskSpell" and spell then
		local spellID = tonumber(spell)
		local info = T.GetGroupInfobyGUID(GUID)
		if info and spellID and C_Spell.GetSpellName(spellID) then
			T.msg(string.format(L["收到法术请求"], info.format_name, T.GetIconLink(spellID)))
			FormatAskedSpell(GUID, spellID, 3)
		end
	end
end

T.EditASFrame = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["cs"] then
			if not ASFrame.registed then
				T.RegisterCallback("ADDON_MSG", UpdateAskSpell)
				ASFrame.registed = true
			end
		else
			if ASFrame.registed then
				T.UnregisterCallback("ADDON_MSG", UpdateAskSpell)
				ASFrame.registed = nil
			end
		end
	end
end

----------------------------------------------------------
------------------[[    技能CD同步    ]]------------------
----------------------------------------------------------
local GroupSpellEventFrame = CreateFrame("Frame")

local group_cd_states, my_cd_states = {}, {}
local last_group_update, last_cd_update = 0, 0

local function UpdateMySpellReadyState(all)
	for spellID, spell_type in pairs(playerShareSpellData) do
		local usable, charge = MySpellCheck(spellID)
		if usable then
			local info = my_cd_states[spellID]
			local changed
			
			if not info then
				my_cd_states[spellID] = {
					charge = charge,
					spell_type = spell_type,
				}
				changed = true
			elseif info.charge ~= charge then
				info.charge = charge
				changed = true
			end

			if changed then
				T.addon_msg("ShareSpellState,"..spell_type..","..spellID..","..charge, "GROUP")
			end
		end
	end

	if all then
		for spellID, info in pairs(my_cd_states) do
			T.addon_msg("ShareSpellState,"..info.spell_type..","..spellID..","..info.charge, "GROUP")
		end
	end
end

local function DelayUpdateMySpellState(all)
	if GetTime() - last_cd_update >= 1 then
		UpdateMySpellReadyState(all)
		last_cd_update = GetTime()
	else
		T.DelayFunc(1, function()
			UpdateMySpellReadyState(all)
		end)
	end
end

GroupSpellEventFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_LOGIN" or event == "GROUP_FORMED" then
		T.addon_msg("RequestSpellState", "GROUP")
		DelayUpdateMySpellState(true)
	elseif event == "ADDON_MSG" then
		local channel, sender, GUID, message = ...
		if message == "RequestSpellState" then
			DelayUpdateMySpellState(true)
		elseif message == "ShareSpellState" then
			local spell_type, spellID, charge = select(5, ...)
			
			spellID = tonumber(spellID)
			charge = tonumber(charge)
			
			if spell_type and spellID and charge then
				if not group_cd_states[GUID] then
					group_cd_states[GUID] = {}
				end
				
				if not group_cd_states[GUID][spellID] then
					group_cd_states[GUID][spellID] = {}
				end
				
				group_cd_states[GUID][spellID].charge = charge
				group_cd_states[GUID][spellID].spell_type = spell_type
				
				T.FireEvent("GROUP_SPELL_COOLDOWN_UPDATE", GUID, spell_type, spellID, charge)
			end
		end
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, sub_event, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		if sub_event == "SPELL_CAST_SUCCESS" and ClassShareSpellDatabySpell[spellID] then
			local my_info = my_cd_states[spellID]
			if my_info then
				my_info.charge = my_info.charge - 1
			end
			
			local info = group_cd_states[sourceGUID] and group_cd_states[sourceGUID][spellID]
			if info then
				info.charge = info.charge - 1
				T.FireEvent("GROUP_SPELL_COOLDOWN_UPDATE", sourceGUID, info.spell_type, spellID, info.charge)
			end
		end
	end
end)

GroupSpellEventFrame.t = 0
GroupSpellEventFrame:SetScript("OnUpdate", function(self, e)
	self.t = self.t + e
	if self.t > .05 then
		if GetTime() - last_cd_update >= 1 then
			DelayUpdateMySpellState()
		end
		self.t = 0
	end
end)

local spell_cd_events = {
	["PLAYER_LOGIN"] = true,
	["GROUP_FORMED"] = true,
	["ADDON_MSG"] = true,
	["COMBAT_LOG_EVENT_UNFILTERED"] = true,	
}

T.RegisterEventAndCallbacks(GroupSpellEventFrame, spell_cd_events)

----------------------------------------------------------
------------------[[    团队减伤分配    ]]------------------
----------------------------------------------------------
local DefenseSpellPrority = {
	357170, -- 时间膨胀
	116849, -- 作茧缚命
	33206, -- 痛苦压制
	47788, -- 守护之魂	
	102342, -- 铁木树皮
	6940, -- 牺牲祝福	
}

local DefenseSpellProrityBySpell = {}
for pro, spellID in pairs(DefenseSpellPrority) do
	DefenseSpellProrityBySpell[spellID] = pro
end

local function SortBySpellPrority(t)
	table.sort(t, function(a, b)
		local pro_a = DefenseSpellProrityBySpell[a.spellID]
		local pro_b = DefenseSpellProrityBySpell[b.spellID]
		if pro_a < pro_b then
			return true
		elseif pro_a == pro_b then
			return a.GUID < b.GUID
		end
	end)
end

local GroupSpellFrame = CreateSpellLineFrame("GroupSpellFrame", L["团队单体减伤技能监控和分配"], 40, "horizontal", "TOPLEFT", 450, 0)

function GroupSpellFrame:lineup()
	SortBySpellPrority(self.active_byindex)
	
	local lastframe		
	for index, icon in pairs(self.active_byindex) do
		if icon:IsShown() then
			icon:ClearAllPoints()
			if not lastframe then
				icon:SetPoint("LEFT", self, "LEFT", 0, 0)
			else
				icon:SetPoint("LEFT", lastframe, "RIGHT", 5, 0)	
			end
			lastframe = icon
		end
	end
end

local function CreateGroupSpellIcon(updater, group, tag)
	local icon = CreateSpellIconBase(GroupSpellFrame, tag)
	
	icon.source_text = T.createtext(icon, "OVERLAY", 12, "OUTLINE", "CENTER") -- 玩家名字
	icon.source_text:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, -2)
	icon.source_text:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 2, -2)
	icon.source_text:SetHeight(12)
	
	icon.target_text = T.createtext(icon, "OVERLAY", 12, "OUTLINE", "CENTER") -- 玩家名字
	icon.target_text:SetPoint("BOTTOMLEFT", icon, "TOPLEFT", -2, -2)
	icon.target_text:SetPoint("BOTTOMRIGHT", icon, "TOPRIGHT", 2, -2)
	icon.target_text:SetHeight(12)
	
	function icon:update_onedit(option)
		if option == "all" or option == "icon_size" then
			self:SetSize(C.DB["GeneralOption"]["group_spell_size"], C.DB["GeneralOption"]["group_spell_size"])
		end
	end
	
	function icon:update_charge()
		local used_charge = #self.targets
		local available_charge = self.charge - used_charge
		if used_charge == 0 then
			self.charge_text:SetText(self.charge)
		else
			self.charge_text:SetText(string.format("%d(%d)", self.charge, available_charge))
		end
		if available_charge == 0 then
			self.texture:SetDesaturated(true)
		else
			self.texture:SetDesaturated(false)
		end
	end
	
	function icon:update_target()
		local str = ""
		for index, GUID in pairs(self.targets) do
			if index > 1 then
				str = str.."\n"
			end
			str = str..T.ColorNickNameByGUID(GUID)
		end
		self.target_text:SetText(str)
	end
	
	function icon:update_range()
		local unit = T.GetGroupInfobyGUID(self.GUID)["unit"]
		if InRangeOfUnit(unit) then
			icon:SetAlpha(1)
		else
			icon:SetAlpha(.5)
		end
	end
	
	function icon:init_display(GUID, spellID, charge)
		self.GUID = GUID
		self.spellID = spellID
		self.charge = charge
		self.targets = table.wipe(self.targets)
		
		self.texture:SetTexture(C_Spell.GetSpellTexture(spellID))
		self.source_text:SetText(T.ColorNickNameByGUID(GUID))
		self:update_charge()
		self:update_target()
		self:update_range()
		
		self:update_onedit("all")
		self:Show()
	end
	
	function icon:cancel()
		self:Hide()
		self.texture:SetDesaturated(false)
	end
	
	icon.targets = {}
	
	updater.actives_bytag[tag] = icon
	
	return icon
end

local GroupSpell_Updater = T.CreateUpdater(CreateGroupSpellIcon, GroupSpellFrame)

GroupSpell_Updater.sort_cache = {}
GroupSpell_Updater.active_byGUID = {}

function GroupSpell_Updater:GetGroupSpellIcon(filter)	
	self.sort_cache = table.wipe(self.sort_cache)
	
	for _, icon in pairs(self.actives_bytag) do
		table.insert(self.sort_cache, icon)
	end
	
	SortBySpellPrority(self.sort_cache)
	
	for _, icon in pairs(self.sort_cache) do
		local used_charge = #icon.targets
		local available_charge = icon.charge - used_charge
		if filter then -- 过滤自身技能
			if icon.GUID ~= G.PlayerGUID then
				if available_charge > 0 then
					local unit = T.GetGroupInfobyGUID(icon.GUID)["unit"]
					if InRangeOfUnit(unit) then
						return icon
					end
				end
			end
		else -- 不过滤自身技能
			if available_charge > 0 then
				local unit = T.GetGroupInfobyGUID(icon.GUID)["unit"]
				if InRangeOfUnit(unit) then
					return icon
				end
			end
		end
	end
end

function GroupSpell_Updater:DelayReleaseTarget(tag, GUID)
	C_Timer.After(5, function()
		local icon = self.actives_bytag[tag]
		if icon then
			local index = tIndexOf(icon.targets, GUID)
			if index then
				table.remove(icon.targets, index)
				icon:update_charge()
				icon:update_target()
			end
		end
	end)
end

function GroupSpell_Updater:SetIconAlphaByGUID(GUID, alpha)
	for spellID, icon in pairs(self.active_byGUID[GUID]) do
		icon:SetAlpha(alpha)
	end
end

GroupSpell_Updater:SetScript("OnEvent", function(self, event, ...)	
	if event == "GROUP_SPELL_COOLDOWN_UPDATE" then
		local GUID, spell_type, spellID, charge = ...
		if DefenseSpellProrityBySpell[spellID] then
			local tag = GUID.."-"..spellID
			if charge > 0 then
				if not self.actives_bytag[tag] then
					local icon = self:GetAlert(1, tag)
					icon:init_display(GUID, spellID, charge)
					
					if not self.active_byGUID[GUID] then
						self.active_byGUID[GUID] = {}
					end
					
					self.active_byGUID[GUID][spellID] = icon
				else
					local icon = self.actives_bytag[tag]
					icon.charge = charge
					icon:update_charge()
				end
			else
				local icon = self.actives_bytag[tag]
				if icon then
					self:RemoveAlert(icon.tag)
					self.active_byGUID[icon.GUID][icon.spellID] = nil
				end
			end
		end
	elseif event == "UNIT_IN_RANGE_UPDATE" then
		local unit, isInRange = ...
		if G.myClass ~= "EVOKER" and T.FilterGroupUnit(unit) then
			local GUID = UnitGUID(unit)
			if self.active_byGUID[GUID] then
				local class = select(2, UnitClass(unit))
				if class ~= "EVOKER" then
					if isInRange then
						self:SetIconAlphaByGUID(GUID, 1)
					else
						self:SetIconAlphaByGUID(GUID, .5)
					end
				end
			end
		end
	elseif event == "GROUP_INFO_REMOVED" then
		local GUID = ...
		if self.active_byGUID[GUID] then
			for spellID, icon in pairs(self.active_byGUID[GUID]) do
				self:RemoveAlert(icon.tag)
			end
		end
		self.active_byGUID[GUID] = nil
	elseif event == "GROUP_LEFT" then
		for _, icon in pairs(self.actives_bytag) do
			self:RemoveAlert(icon.tag)
		end
		self.active_byGUID = table.wipe(self.active_byGUID)
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
		local _, sub_event, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
		if sub_event == "SPELL_CAST_SUCCESS" and ClassShareSpellDatabySpell[spellID] then
			local tag = sourceGUID.."-"..spellID
			local icon = self.actives_bytag[tag]
			if icon then
				local index = tIndexOf(icon.targets, destGUID)
				if index then
					table.remove(icon.targets, index)
					icon:update_charge()
					icon:update_target()
				end
			end
		end
	elseif event == "ADDON_MSG" then
		local channel, sender, GUID, message = ...
		if message == "ProtectMe" then
			local tag = select(5, ...)
			local icon = self.actives_bytag[tag]
			if icon then
				table.insert(icon.targets, GUID)
				icon:update_charge()
				icon:update_target()
				
				self:DelayReleaseTarget(tag, GUID)				
			end
		end
	end
end)

-- 唤魔师距离监控
GroupSpell_Updater.t = 0
GroupSpell_Updater:SetScript("OnUpdate", function(self, e)
	self.t = self.t + e
	if self.t > .5 then
		-- 自己是唤魔师
		if G.myClass == "EVOKER" then
			for GUID, icons in pairs(self.active_byGUID) do
				local unit = T.GetGroupInfobyGUID(GUID)["unit"]				
				if InRangeOfUnit(unit) then
					self:SetIconAlphaByGUID(GUID, 1)
				else
					self:SetIconAlphaByGUID(GUID, .5)
				end
			end
		else
		-- 团队里的唤魔师
			for GUID, icons in pairs(self.active_byGUID) do
				local class = T.GetGroupInfobyGUID(GUID)["class"]
				if class == "EVOKER" then
					local unit = T.GetGroupInfobyGUID(GUID)["unit"]
					if InRangeOfUnit(unit) then
						self:SetIconAlphaByGUID(GUID, 1)
					else
						self:SetIconAlphaByGUID(GUID, .5)
					end
				end
			end
		end
		self.t = 0
	end
end)
	
local last_ask = 0
T.RequestGroupDefenseSpell = function(filter, spellStr)
	if spellStr then
		local spell_str = string.gsub(spellStr, "，", ",") -- 替换中文逗号
		local spell_names = {string.split(",", spell_str)}
		for _, spell_name in pairs(spell_names) do
			local spell_info = C_Spell.GetSpellInfo(spell_name)
			if spell_info then
				local spellID = spell_info.spellID
				if MySpellCheck(spellID) then
					if C.DB["GeneralOption"]["group_spell_msg"] then
						T.msg(string.format(L["技能可以用忽略技能请求"], T.GetIconLink(spellID)))
					end
					return
				end
			end
		end
	end
	
	local passed = GetTime() - last_ask
	if passed >= 5 then
		local icon = GroupSpell_Updater:GetGroupSpellIcon(filter)
		if icon then
			T.addon_msg("ProtectMe,"..icon.tag, "GROUP")
			
			local info = T.GetGroupInfobyGUID(icon.GUID)
			local target = Ambiguate(info.full_name, "none")			
			T.SendSpellRequest(target, info.format_name, icon.spellID)
			last_ask = GetTime()
		else		
			if C.DB["GeneralOption"]["group_spell_msg"] then
				T.msg(L["当前没有可用的单体减伤技能"])
			end
		end		
	else
		if C.DB["GeneralOption"]["group_spell_msg"] then
			T.msg(string.format(L["请稍后再请求单体减伤"], ceil(5 - passed)))
		end
	end
end

local group_cd_events = {	
	["GROUP_SPELL_COOLDOWN_UPDATE"] = true,
	["GROUP_INFO_REMOVED"] = true,
	["UNIT_IN_RANGE_UPDATE"] = true,
	["GROUP_LEFT"] = true,
	["COMBAT_LOG_EVENT_UNFILTERED"] = true,
	["ADDON_MSG"] = true,
}

T.EditGroupSpellFrame = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["group_spell_enable"] then
			T.RegisterEventAndCallbacks(GroupSpell_Updater, group_cd_events)
			T.addon_msg("RequestSpellState", "GROUP")
			
			T.RestoreDragFrame(GroupSpellFrame)
			GroupSpellFrame:Show()
		else
			T.UnregisterEventAndCallbacks(GroupSpell_Updater, group_cd_events)
			
			T.ReleaseDragFrame(GroupSpellFrame)
			GroupSpellFrame:Hide()
		end
	end
	if option == "all" or option == "icon_size" then
		GroupSpellFrame:SetSize(C.DB["GeneralOption"]["group_spell_size"]*4+20, C.DB["GeneralOption"]["group_spell_size"])
	end		
	for _, icon in pairs(GroupSpellFrame.active_byindex) do
		icon:update_onedit(option)
	end
end

----------------------------------------------------------
------------------[[    个人减伤提示    ]]------------------
----------------------------------------------------------
local almost_ready_dur = 3
local checking_hp_tags = {}

local PersonalSpellFrame = CreateSpellLineFrame("PersonalSpellFrame", L["玩家自保技能提示"],  40, "horizontal", "CENTER", 0, 100)
PersonalSpellFrame:Hide()

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
	local passed
	for tag, threshold in pairs(checking_hp_tags) do
		if perc < threshold + 10 then
			 passed = true
			 return
		end
	end
	if not passed then
		return true
	end
end

T.Play_personlspell_sound = function()
	if C.DB["GeneralOption"]["personal_spell_sound"] ~= "none" then	
		T.PlaySound(C.DB["GeneralOption"]["personal_spell_sound"])
	end
end

function PersonalSpellFrame:Update()
	if UnitIsDead("player") then
		if self:IsShown() then
			self:Hide()
		end
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
	local icon = CreateSpellIconBase(PersonalSpellFrame, tag)
	
	icon.dur_text = T.createtext(icon, "OVERLAY", 14, "OUTLINE", "CENTER")
	icon.dur_text:SetPoint("TOP", icon, "BOTTOM", 0, -2)
	icon.dur_text:SetTextColor(1, 1, 0)
	icon.dur_text:SetHeight(12)
	
	icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	icon.cooldown:SetAllPoints()
	icon.cooldown:SetDrawEdge(false)
	icon.cooldown:SetFrameLevel(icon:GetFrameLevel())
	icon.cooldown:SetReverse(true)
	
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

T.EditPersonalSpellFrame = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["personal_spell_enable"] then
			T.RestoreDragFrame(PersonalSpellFrame)
			T.RegisterEventAndCallbacks(PersonalSpellFrame, PersonalSpellFrame.events)
		else
			T.ReleaseDragFrame(PersonalSpellFrame)
			T.UnregisterEventAndCallbacks(PersonalSpellFrame, PersonalSpellFrame.events)
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

----------------------------------------------------------
----------------[[    获得团队标记提醒    ]]-----------------
----------------------------------------------------------
local RMFrame = CreateFrame("Frame", addon_name.."RMFrame", FrameHolder)

T.EditRMFrame = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["rm"] then		
			RMFrame:RegisterEvent("RAID_TARGET_UPDATE")
		else
			RMFrame:UnregisterEvent("RAID_TARGET_UPDATE")
		end
	end
end

RMFrame:SetScript("OnEvent", function(self, event)
	if C.DB["GeneralOption"]["rm"] then
		local index = GetRaidTargetIndex("player")
		if index and self.old ~= index then
			self.old = index
			self.text_frame = T.CreateAlertTextShared("RMFrame", 2)
			T.Start_Text_Timer(self.text_frame, 3, string.format(L["当前标记"], T.FormatRaidMark(index)))
		elseif not index then	
			self.old = 0
			T.Stop_Text_Timer(self.text_frame)
		end
	else
		self.old = 0
		T.Stop_Text_Timer(self.text_frame)
	end
end)

----------------------------------------------------------
-------------------[[    转阶段监控    ]]-------------------
----------------------------------------------------------
local PhaseTrigger = CreateFrame("Frame", nil, FrameHolder)

local phase_data = {} -- 所有首领的转阶段数据
local current_engageID -- 当前战斗
local current_diffcultyID -- 当前难度
local current_phase -- 当前阶段
local current_phase_data = {} -- 当前战斗的转阶段计数
local engaged_npc = {} -- 转阶段监控：记录BOSS加入战斗
local spell_count = {} -- 转阶段监控：记录技能次数

function PhaseTrigger:outputMsg()
	if G.Timeline.time_offset == 0 then
		T.msg(string.format(L["阶段转换"].." P%s %s", current_phase, date("%M:%S", G.Timeline.passed)))
	else
		T.msg(string.format(L["阶段转换"].." P%s %s ["..L["运行时间"].." %s]", current_phase, date("%M:%S", G.Timeline.passed), date("%M:%S", G.Timeline.fake_passed)))
	end
end

local function AddCurrentData(tag, ...)
	if G.Encounter_Data[tag] then
		for category, data in pairs(G.Encounter_Data[tag]) do
			for alert_type, alert_data in pairs(data) do
				for key, args in pairs(alert_data) do
					if T.CheckRole(args.ficon) and not G.Current_Data[category][alert_type][key] then
						if string.find(tag, "engage") then -- 首领战斗
							if T.CheckDifficulty(args.ficon, current_diffcultyID) then
								G.Current_Data[category][alert_type][key] = args
								G.Current_Data[category][alert_type][key].IsEncounterData = true
							end
							--print("ecnounter add", tag, category, alert_type, key, "ignore dif")
						else -- 杂兵
							G.Current_Data[category][alert_type][key] = args
							--print("instance add", tag, category, alert_type, key)
						end
					end
				end
			end
		end
		T.FireEvent("DATA_ADDED", ...)
	end
end

local function WipeCurrentData(event)
	for category, data in pairs(G.Current_Data) do
		for alert_type, alert_data in pairs(data) do
			for key, args in pairs(alert_data) do
				if event == "ENCOUNTER_END" then
					if args.IsEncounterData then
						G.Current_Data[category][alert_type][key] = nil
						--print("ecnounter remove", category, alert_type, key)
					end
				else
					G.Current_Data[category][alert_type][key] = nil
					--print("all remove", category, alert_type, key)
				end
			end
		end
	end
	T.FireEvent("DATA_REMOVED", event)
end

local function UpdateAllData()
	WipeCurrentData()
	
	local mapID = select(8, GetInstanceInfo())
	AddCurrentData("map"..mapID)
	
	if current_engageID and current_diffcultyID then
		AddCurrentData("engage"..current_engageID)
	end
end
T.UpdateAllData = UpdateAllData

PhaseTrigger:SetScript("OnEvent", function(self, event, ...)
	if event == "PLAYER_SPECIALIZATION_CHANGED" then
		UpdateAllData()
	elseif event == "PLAYER_ENTERING_WORLD" then
		if IsEncounterInProgress() then
			for unit in T.IterateBoss() do
				local npcID = T.GetUnitNpcID(unit)
				local engageID = G.npcIDtoengageID[npcID]
				if engageID then
					current_engageID = engageID
					break
				end
			end
			
			current_diffcultyID = select(3, GetInstanceInfo())
		end
		
		UpdateAllData()
	elseif event == "ENCOUNTER_START" then
		local engageID, _, difficultyID = ...
		
		current_engageID = engageID
		current_diffcultyID = difficultyID
		current_phase = 1
		
		AddCurrentData("engage"..current_engageID, event, ...)
		
		if phase_data[engageID] then
			if phase_data[engageID].CLEU then
				for i, data in pairs(phase_data[engageID].CLEU) do
					if not data.ficon or T.CheckDifficulty(data.ficon, difficultyID) then
						current_phase_data[data.phase] = 0
					end
				end
			end
			if phase_data[engageID].UNIT then
				for i, data in pairs(phase_data[engageID].UNIT) do
					if not data.ficon or T.CheckDifficulty(data.ficon, difficultyID) then
						current_phase_data[data.phase] = 0
					end
				end
			end
		end
		
	elseif event == "ENCOUNTER_END" then
		WipeCurrentData(event)
		
		current_engageID = nil
		current_diffcultyID = nil
		current_phase = nil
		
		engaged_npc = table.wipe(engaged_npc)
		spell_count = table.wipe(spell_count)
		current_phase_data = table.wipe(current_phase_data)
		
	elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then		
		local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID, _, _, extraSpellID = CombatLogGetCurrentEventInfo()
		
		if not current_engageID or not phase_data[current_engageID] or not phase_data[current_engageID].CLEU then return end
		
		for i, data in pairs(phase_data[current_engageID].CLEU) do
			if sub_event == data.sub_event and data.count and (not data.ficon or T.CheckDifficulty(data.ficon, current_diffcultyID)) then -- 记录次数
				if data.spellID then
					if data.spellID == spellID then
						local tag = string.format("%s:%s", sub_event, spellID)
						if not spell_count[tag] then
							spell_count[tag] = 1
						else
							spell_count[tag] = spell_count[tag] + 1
						end
						break
					end
				elseif data.extraSpellID then
					if data.extraSpellID == extraSpellID then
						local tag = string.format("%s:%s", sub_event, extraSpellID)
						if not spell_count[tag] then
							spell_count[tag] = 1
						else
							spell_count[tag] = spell_count[tag] + 1
						end
						break
					end
				end
			end
		end
		
		for i, data in pairs(phase_data[current_engageID].CLEU) do
			if sub_event == data.sub_event and (not data.ficon or T.CheckDifficulty(data.ficon, current_diffcultyID)) then
				if data.spellID then
					if data.spellID == spellID then
						if data.count then
							local tag = string.format("%s:%s", sub_event, spellID)
							if spell_count[tag] == data.count then
								current_phase = data.phase
								current_phase_data[current_phase] = current_phase_data[current_phase] + 1
								T.FireEvent("ENCOUNTER_PHASE", current_phase, current_phase_data[current_phase])
								self:outputMsg()
							end
						else
							current_phase = data.phase
							current_phase_data[current_phase] = current_phase_data[current_phase] + 1
							T.FireEvent("ENCOUNTER_PHASE", current_phase, current_phase_data[current_phase])
							self:outputMsg()
						end
					end
				elseif data.extraSpellID then
					if data.extraSpellID == extraSpellID then
						if data.count then
							local tag = string.format("%s:%s", sub_event, extraSpellID)
							if spell_count[tag] == data.count then
								current_phase = data.phase
								current_phase_data[current_phase] = current_phase_data[current_phase] + 1
								T.FireEvent("ENCOUNTER_PHASE", current_phase, current_phase_data[current_phase])
								self:outputMsg()
							end
						else
							current_phase = data.phase
							current_phase_data[current_phase] = current_phase_data[current_phase] + 1
							T.FireEvent("ENCOUNTER_PHASE", current_phase, current_phase_data[current_phase])
							self:outputMsg()
						end
					end
				end
			end
		end
	elseif event == "ENCOUNTER_ENGAGE_UNIT" then
		if not current_engageID or not phase_data[current_engageID] or not phase_data[current_engageID].UNIT then return end
		local unit = ...
		local npcID = T.GetUnitNpcID(unit)
		if not engaged_npc[npcID] then -- 有新的NPC加入战斗
			engaged_npc[npcID] = true
			
			for i, data in pairs(phase_data[current_engageID].UNIT) do
				if data.npcID == npcID and (not data.ficon or T.CheckDifficulty(data.ficon, current_diffcultyID)) then
					current_phase = data.phase
					current_phase_data[current_phase] = current_phase_data[current_phase] + 1
					T.FireEvent("ENCOUNTER_PHASE", current_phase, current_phase_data[current_phase])
					self:outputMsg()
				end
			end
		end
	elseif event == "ADDON_LOADED" then
		local addon = ...
		if C_AddOns.GetAddOnMetadata(addon, "X-JST-InstanceType") then
			for _, data in pairs(G.Encounters) do
				if data.engage_id and not phase_data[data.engage_id] then -- 只针对首领战斗
					for _, section_data in pairs(data.alerts) do
						if section_data.title and section_data.title == L["阶段转换"] then
							phase_data[data.engage_id] = {}
							for _, args in pairs(section_data.options) do
								if not phase_data[data.engage_id][args.type] then
									phase_data[data.engage_id][args.type] = {}
								end
								if args.type == "CLEU" then
									table.insert(phase_data[data.engage_id][args.type], {
										phase = args.phase,
										sub_event = args.sub_event,
										spellID = args.spellID,
										extraSpellID = args.extraSpellID,
										count = args.count,
										ficon = args.ficon,
									})
								elseif args.type == "UNIT" then
									table.insert(phase_data[data.engage_id][args.type], {
										phase = args.phase,
										npcID = args.npcID,
										ficon = args.ficon,
									})
								end	
							end
							break
						end
					end
				end
			end
		end
	end
end)

T.GetCurrentEngageID = function()
	return current_engageID, current_diffcultyID
end

T.GetCurrentPhase = function()
	return current_phase
end

T.RegisterEventAndCallbacks(PhaseTrigger, {
	["PLAYER_SPECIALIZATION_CHANGED"] = true,
	["PLAYER_ENTERING_WORLD"] = true,
	["ENCOUNTER_START"] = true,
	["ENCOUNTER_END"] = true,
	["ENCOUNTER_ENGAGE_UNIT"] = true,
	["COMBAT_LOG_EVENT_UNFILTERED"] = true,
	["ADDON_LOADED"] = true,
})
----------------------------------------------------------
-------------------[[    动态战术板    ]]-----------------
----------------------------------------------------------
local Spec_Pos = {
	-- Death Knight
	[250] = "MELEE", -- Blood (Tank)
	[251] = "MELEE", -- Frost (DPS)
	[252] = "MELEE", -- Unholy (DPS)
	-- Demon Hunter
	[577] = "MELEE", -- Havoc (DPS)
	[581] = "MELEE", -- Vengeance (Tank)
	-- Druid
	[102] = "RANGED", -- Balance (DPS Owl)
	[103] = "MELEE", -- Feral (DPS Cat)
	[104] = "MELEE", -- Guardian (Tank Bear)
	[105] = "RANGED", -- Restoration (Heal)
	-- Evoker
	[1467] = "RANGED", -- Devastation (DPS)
	[1468] = "RANGED", -- Preservation (Heal)
	[1473] = "RANGED", -- Augmentation (DPS)
	-- Hunter
	[253] = "RANGED", -- Beast Mastery
	[254] = "RANGED", -- Marksmanship
	[255] = "MELEE", -- Survival
	-- Mage
	[62] = "RANGED", -- Arcane
	[63] = "RANGED", -- Fire
	[64] = "RANGED", -- Frost
	-- Monk
	[268] = "MELEE", -- Brewmaster (Tank)
	[269] = "MELEE", -- Windwalker (DPS)
	[270] = "MELEE", -- Mistweaver (Heal)
	-- Paladin
	[65] = "MELEE", -- Holy (Heal)
	[66] = "MELEE", -- Protection (Tank)
	[70] = "MELEE", -- Retribution (DPS)
	-- Priest
	[256] = "RANGED", -- Discipline (Heal)
	[257] = "RANGED", -- Holy (Heal)
	[258] = "RANGED", -- Shadow (DPS)
	-- Rogue
	[259] = "MELEE", -- Assassination
	[260] = "MELEE", -- Outlaw
	[261] = "MELEE", -- Subtlety
	-- Shaman
	[262] = "RANGED", -- Elemental (DPS)
	[263] = "MELEE", -- Enhancement (DPS)
	[264] = "RANGED", -- Restoration (Heal)
	-- Warlock
	[265] = "RANGED", -- Affliction
	[266] = "RANGED", -- Demonology
	[267] = "RANGED", -- Destruction
	-- Warrior
	[71] = "MELEE", -- Arms (DPS)
	[72] = "MELEE", -- Fury (DPS)
	[73] = "MELEE", -- Protection (Tank)
}
G.Spec_Pos = Spec_Pos

Mrt_Roles = {
	HEALER = L["治疗"],
	DAMAGER = L["输出"],
	TANK = L["坦克"],
}

Mrt_Positions = {
	RANGED = L["远程"],
	MELEE = L["近战"],
}

local function FormatSec(remain)
	local str
	if remain < 0 then
		str = string.format("|cffC0C0C0------|r")
	elseif remain < 3 then
		str = string.format("|cffFF0000%.1f|r", remain)
	elseif remain < 5 then
		str = string.format("|cffFFD700%d|r", remain)
	elseif remain < 10 then 
		str = string.format("|cff00FF00%d|r", remain)
	else
		str = date("|cff40E0D0%M:%S|r", remain)
	end
	return str
end

local function GetMyScript(str)
    local my_str, my_script = "", ""
	local org_str = str:gsub("%d+:%d+", "")
	
	org_str = org_str:gsub("@|c%x%x([^|]+)|r", function(a) return string.format("{target:%s}", a) end) -- 剔除目标	
	org_str = org_str:gsub("|c%x%x%x%x%x%x%x%x", " "):gsub("|r", " ") -- 去掉颜色
    
	for word in org_str:gmatch("%S+") do
        if T.GetGroupInfobyName(word) then
			local pattern = gsub(word, "%p", "%%p")
			org_str = org_str:gsub(pattern, function(a) return string.format("|cffff0000%s|r", a) end) -- 名字
		end
    end
	
	org_str = org_str:gsub(" ", "") -- 去掉空格
	
	local my_spec_index = GetSpecialization()
	local my_spec_ID = GetSpecializationInfo(my_spec_index)
	
    local my_class = string.format("{%s}", G.myClassLocal)
    local my_role = string.format("{%s}", Mrt_Roles[GetSpecializationRole(my_spec_index)])
	local my_pos = string.format("{%s}", Mrt_Positions[Spec_Pos[my_spec_ID]])
    local all = string.format("{%s}", L["所有人"])	
	local party = string.format("{%s}", L["队伍"])
	
    org_str = gsub(org_str, my_class, "|cffffffffFS_CLASS|r") -- 添加职业
    org_str = gsub(org_str, my_role, "|cffffffffFS_ROLE|r") -- 添加职责
    org_str = gsub(org_str, my_pos, "|cffffffffFS_POS|r") -- 添加站位
	org_str = gsub(org_str, all, "|cffffffffFS_ALL|r") -- 添加所有人
    org_str = gsub(org_str, party, function(a) return string.format("|cffffffffPARTY_%d|r", a) end) -- 添加小队
	
    local info = {}    
    local filtered_str = ""
    
    for name, str in org_str:gmatch("|c%x%x%x%x%x%x%x%x([^|]+)|r([^|]+)") do
        table.insert(info, {n = name, str = str})
    end
    
    for index, v in pairs(info) do
        if T.GetGroupGUIDbyName(v.n) == G.PlayerGUID then
            filtered_str = filtered_str..v.str
        elseif C.DB["GeneralOption"]["tl_filter_class"] and v.n == "FS_CLASS" then
            filtered_str = filtered_str..v.str
        elseif C.DB["GeneralOption"]["tl_filter_role"] and v.n == "FS_ROLE" then
            filtered_str = filtered_str..v.str
		elseif C.DB["GeneralOption"]["tl_filter_pos"] and v.n == "FS_POS" then
            filtered_str = filtered_str..v.str	
        elseif C.DB["GeneralOption"]["tl_filter_all"] and v.n == "FS_ALL" then
            filtered_str = filtered_str..v.str
		elseif C.DB["GeneralOption"]["tl_filter_party"] and string.find(v.n, "PARTY_") and UnitInRaid("player") then
			local sub_group = select(3, GetRaidRosterInfo(UnitInRaid("player")))
			if string.find(v.n, sub_group) then
				filtered_str = filtered_str..v.str
			end
        end
    end
    
    my_str = filtered_str:gsub("{spell:(%d+)}", T.GetSpellIcon):gsub("{target:([^}]+)}", function(a) return string.format("@|cff%s|r", a) end):gsub("%[#([^%]]+)%]", "%1")
    my_script = filtered_str:gsub("{spell:(%d+)}", C_Spell.GetSpellName):gsub("{target:%x%x%x%x%x%x([^}]+)}", "%1")
	
    return my_str, my_script
end

local TTS_failed_type = {
	"无效的朗读引擎类型", -- 1
	"朗读引擎分配失败", -- 2
	"不支持", -- 3
	"超过最大字符数", -- 4
	"持续时间过短", -- 5
	"进入朗读等候队列", -- 6
	"SDK未初始化", -- 7
	"朗读等候队列满", -- 8
	"无需加入朗读队列", -- 9
	"未找到语音", -- 10
	"未找到发音人", -- 11
	"无效的参数", -- 12
	"内部错误", -- 13
}

local Timeline = CreateFrame("Frame", addon_name.."TLFrame", FrameHolder)
Timeline:SetSize(600,100)
Timeline:Hide()

Timeline.title = CreateFrame("Frame", nil, Timeline) 
Timeline.title:SetSize(100, 40)
Timeline.title:SetPoint("TOPLEFT", Timeline, "TOPLEFT", 0, 0)

Timeline.clock = T.createtext(Timeline.title, "OVERLAY", 20, "OUTLINE", "LEFT")
Timeline.clock:SetPoint("LEFT", Timeline.title, "LEFT", 5, 0)	

Timeline.movingname = L["动态战术板"]
Timeline.point = { a1 = "TOPLEFT", a2 = "TOPLEFT", x = 225, y = -20}
T.CreateDragFrame(Timeline)

G.Timeline = Timeline

local timeicon = "|T134376:12:12:0:0:64:64:4:60:4:60|t"
local tl_test

Timeline.t = 0
Timeline.tl_dur = 5 -- 到时间点后保留显示的时间
Timeline.start = 0 -- 战斗开始时间
Timeline.time_offset = 0 -- 校准时间偏移量
Timeline.assignment_cd = {} -- 当前战斗战术板条目
Timeline.phase_cd = {} -- 当前战斗战术板转阶段条目

Timeline.Lines = {} -- 条目
Timeline.ActiveLines = {} -- 活跃条目

Timeline.events = {
	["ENCOUNTER_START"] = true,
	["ENCOUNTER_END"] = true,
	["ENCOUNTER_PHASE"] = true,
	["TIMELINE_START"] = true,
	["TIMELINE_STOP"] = true,
	["TIMELINE_PASSED"] = true,
	["VOICE_CHAT_TTS_PLAYBACK_STARTED"] = true,
	["VOICE_CHAT_TTS_PLAYBACK_FINISHED"] = true,
	["VOICE_CHAT_TTS_PLAYBACK_FAILED"] = true,
	["VOICE_CHAT_TTS_SPEAK_TEXT_UPDATE"] = true,
}

T.EditTimeline = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["tl"] then			
			T.RegisterEventAndCallbacks(Timeline, Timeline.events)
			T.RestoreDragFrame(Timeline)
		else
			T.UnregisterEventAndCallbacks(Timeline, Timeline.events)
			T.ReleaseDragFrame(Timeline)
			Timeline:Hide()
		end
	end
	
	if option == "all" or option == "enable" or option == "bar" then
		if not (C.DB["GeneralOption"]["tl"] and C.DB["GeneralOption"]["tl_bar"]) then
			for key, line in pairs(Timeline.Lines) do
				line.bar:Hide()
			end
		end
	end
	
	if option == "all" or option == "enable" or option == "text" then	
		if not (C.DB["GeneralOption"]["tl"] and C.DB["GeneralOption"]["tl_text"]) then
			for key, line in pairs(Timeline.Lines) do
				line.text_frame:Hide()
			end
		end
	end
	
	if option == "all" or option == "font_size" then
		Timeline.title:SetSize(10*C.DB["GeneralOption"]["tl_font_size"], C.DB["GeneralOption"]["tl_font_size"]+6)
		Timeline.clock:SetFont(G.Font, C.DB["GeneralOption"]["tl_font_size"], "OUTLINE")	
	end
	
	for k, line in pairs(Timeline.Lines) do
		line:update_onedit(option)
	end
end

local function Timeline_LineUpLines()
	local t = {}
	for i, line in pairs(Timeline.ActiveLines) do
		if line and line:IsVisible() then
			table.insert(t, line)
		end
	end
	if #t > 1 then
		table.sort(t, function(a, b) 
			if a.row_time < b.row_time then
				return true
			elseif a.row_time == b.row_time and a.ind < b.ind then
				return true
			end
		end)
	end
	local lastline
	for i, line in pairs(t) do
		line:ClearAllPoints()
		if line:IsVisible() then
			if not lastline then
				line:SetPoint("TOPLEFT", Timeline.title, "BOTTOMLEFT", 0, -5)
				lastline = line
			else
				line:SetPoint("TOPLEFT", lastline, "BOTTOMLEFT", 0, -5)
				lastline = line
			end
		end
	end
end

local function Timeline_QueueLine(frame)	
	frame:HookScript("OnShow", function(self)
		Timeline.ActiveLines[self.frame_key] = self
		Timeline_LineUpLines()
	end)
	
	frame:HookScript("OnHide", function(self)
		Timeline.ActiveLines[self.frame_key] = nil
		Timeline_LineUpLines()
	end)
end

local function Timeline_CreateLine(ind)
	local frame = CreateFrame("Frame", nil, Timeline)
	frame:SetSize(1000, C.DB["GeneralOption"]["tl_font_size"])
	frame:Hide()
	
	local fs = C.DB["GeneralOption"]["tl_font_size"] - 5
	
	frame.left = T.createtext(frame, "OVERLAY", fs, "OUTLINE", "LEFT")
	frame.left:SetPoint("LEFT", frame, "LEFT", 0, 0)
	frame.left:SetSize(60, fs)
	
	frame.right = T.createtext(frame, "OVERLAY", fs, "OUTLINE", "LEFT")
	frame.right:SetPoint("LEFT", frame.left, "RIGHT", 0, 0)
	frame.right:SetSize(940, fs)
	
	frame:HookScript("OnSizeChanged", function(self, width, height)
		self.left:SetFont(G.Font, height-5, "OUTLINE")
		self.right:SetFont(G.Font, height-5, "OUTLINE")
	end)
	
	frame.t = 0
	frame.ind = ind
	frame.frame_key = "timeline"..ind	
	frame.target_glow_enabled = true
	frame.script_play_enabled = true
	frame.sounds = {}
	frame.targets = {}
	
	frame.bar = T.CreateAlertBarShared(1, "timeline"..ind, 134376, "", {0, 1, .7})
	frame.text_frame = T.CreateAlertTextShared("timeline"..ind, 2)
	
	function frame:update_onedit(option)
		if option == "all" or option == "font_size" then
			self:SetHeight(C.DB["GeneralOption"]["tl_font_size"])
		end
	end
	
	function frame:reset()
		self:Hide()
		self:SetScript("OnUpdate", nil)
		
		self.bar:Hide()
		self.text_frame:Hide()
		
		self.target_glow_enabled = nil
		self.script_play_enabled = nil
	end	
	
	function frame:glow_target()
		if self.target_glow_enabled then
			for name in self.my_str:gmatch("@|c%x%x%x%x%x%x%x%x([^|]+)|r") do -- 识别指向技能及目标
				local info = T.GetGroupInfobyName(name)
				if info then
					T.GlowRaidFramebyUnit_Show("proc", "timelinetarget", info.unit, {1, 1, 1}, 3)
				end
			end
			self.target_glow_enabled = nil
		end
	end
	
	function frame:play_script()
		if self.script_play_enabled then
			self.sounds = table.wipe(self.sounds)
			
			for v in self.my_script:gmatch("%[#([^%]]+)%]") do -- 识别语音文件
				table.insert(self.sounds, v)
			end
			
			if #self.sounds > 0 then -- 用语音文件
				local ticker = C_Timer.NewTicker(0.5, function(s)
					s.ind = s.ind + 1
					T.PlaySound("custom\\"..self.sounds[s.ind]) 
				end, #self.sounds)
				ticker.ind = 0
			else
				T.SpeakText(self.my_script)
			end
			
			self.script_play_enabled = nil
		end
	end
	
	Timeline.Lines[frame.frame_key] = frame
	
	Timeline_QueueLine(frame)
end

local function Timeline_UpdateLine(frame, str, row_time, exp_time)
	frame.row_time = row_time
	frame.exp_time = exp_time
	
	frame.right:SetText(str:gsub("%d+:%d+", ""):gsub("{spell:(%d+)}", T.GetSpellIcon):gsub("%[#([^%]]+)%]", "%1"))
	
	frame.my_str, frame.my_script = GetMyScript(str)
	
	if frame.my_str ~= "" then
		frame.text_frame.text:SetText(frame.my_str)
		
		frame.bar.left:SetText(frame.my_str)
		frame.bar:SetMinMaxValues(0, C.DB["GeneralOption"]["tl_bar_dur"])
		frame.bar:SetValue(0)
		
		frame.target_glow_enabled = true
		frame.script_play_enabled = true
	end
	
	frame:SetScript("OnUpdate", function(self, e)
		self.t = self.t + e
		if self.t > update_rate then
			self.remain = self.exp_time - GetTime()
			if self.remain > 0 then
				self.event_remain = self.remain - Timeline.tl_dur
				self.left:SetText(FormatSec(self.event_remain))
				
				if self.my_str ~= "" then
					if self.event_remain > 0 then
						if C.DB["GeneralOption"]["tl_glowtarget"] and self.event_remain < 3 then
							self:glow_target()  -- 团队框架动画
						end
						
						if C.DB["GeneralOption"]["tl_sound"] and self.event_remain < C.DB["GeneralOption"]["tl_sound_dur"] then
							self:play_script() -- 声音提示
						end
						
						if C.DB["GeneralOption"]["tl_text"] and self.event_remain < C.DB["GeneralOption"]["tl_text_dur"] then
							if not self.text_frame:IsShown() then
								self.text_frame:Show() -- 文字提示
							end
							if C.DB["GeneralOption"]["tl_text_show_dur"] then
								self.text_frame.text:SetText(string.format("%s %.1f", self.my_str, self.event_remain))
							end
						end
						
						if C.DB["GeneralOption"]["tl_bar"] and self.event_remain < C.DB["GeneralOption"]["tl_bar_dur"] then
							if not self.bar:IsShown() then
								self.bar:Show() -- 计时条提示
							end
							self.bar.right:SetText(T.FormatTime(self.event_remain))
							self.bar:SetValue(C.DB["GeneralOption"]["tl_bar_dur"] - self.event_remain)
						end
					else
						if C.DB["GeneralOption"]["tl_text"] and self.text_frame:IsShown() then
							self.text_frame:Hide()
						end
						if C.DB["GeneralOption"]["tl_bar"] and self.bar:IsShown() then
							self.bar:Hide()
						end
					end
				end
			else
				self:reset()
			end
			self.t = 0
		end
	end)
	
	frame:Show()
end

local ToggleTimelineTest = function()
	if not tl_test then
		if Timeline.start == 0 then
			tl_test = true
			T.FireEvent("TIMELINE_START")		
			JSTtimelineScrollAnchor.tl_test:SetText(L["动态战术板测试"].." "..L["停止"])
			T.msg(L["动态战术板测试"].." "..L["开始"])
		else
			T.msg(L["战斗中无法开始测试"])
		end
	else
		tl_test = false
		T.FireEvent("TIMELINE_STOP")
		JSTtimelineScrollAnchor.tl_test:SetText(L["动态战术板测试"].." "..L["开始"])
		T.msg(L["动态战术板测试"].." "..L["停止"])
	end
end
T.ToggleTimelineTest = ToggleTimelineTest

local StopTimelineTest = function()
	Timeline.time_offset = 0
	Timeline.assignment_cd = table.wipe(Timeline.assignment_cd)
	Timeline.phase_cd = table.wipe(Timeline.phase_cd)
	
	if C.DB["GeneralOption"]["tl_glowtarget"] then -- 隐藏高亮
		T.GlowRaidFrame_HideAll("proc", "timelinetarget")
	end
	
	for _, line in pairs(Timeline.ActiveLines) do  
		line:reset()
	end

	tl_test = false
	JSTtimelineScrollAnchor.tl_test:SetText(L["动态战术板测试"].." "..L["开始"])
	T.msg(L["动态战术板测试"].." "..L["停止"])
end

Timeline:SetScript("OnUpdate", function(self, e)
	self.t = self.t + e
	if self.t > tl_update_rate then
		self.dur = GetTime() - self.start
		self.passed = floor(self.dur)
		self.fake_passed = floor(self.dur + self.time_offset) 
		if self.last ~= self.passed then	
			T.FireEvent("TIMELINE_PASSED", self.fake_passed)
			self.last = self.passed
		end
		
		if self.time_offset == 0 then
			self.clock:SetText(string.format("%s %s", timeicon, date("%M:%S", self.passed)))
		else
			self.clock:SetText(string.format("%s %s [%s %s]", timeicon, date("%M:%S", self.passed), L["运行时间"], date("%M:%S", self.fake_passed)))
		end
		
		if tl_test and GetTime() > self.test_exp then
			ToggleTimelineTest()
		end
		
		self.t = 0
	end
end)

local function GetPhaseInfo(str)
	local phase_str, reset_m_str, reset_s_str = string.match(str, "P(.+) (%d+):(%d+)")
	if not (phase_str and reset_m_str and reset_s_str) then return end
	
	local phase = tonumber(phase_str)
	local minute = tonumber(reset_m_str)
	local second = tonumber(reset_s_str)
	
	if phase and minute and second then
		local dur = 60*minute + second
		return phase, dur
	end
end

local function filterDiffculty(line, engageID, difficultyID)
	local ID = string.match(line, "JST(%d+)")
	if tonumber(ID) == engageID then
		local difficultyTag = string.match(line, "JST"..ID.."(%a)")
		if difficultyTag then
			if string.lower(difficultyTag) == "h" then
				return difficultyID == 15
			elseif string.lower(difficultyTag) == "m" then
				return difficultyID == 16
			else
				return true
			end
		else
			return true
		end
	end
end

Timeline:SetScript("OnEvent", function(self, event, ...)
	if event == "ENCOUNTER_START" or event == "TIMELINE_START" then		
		
		if event == "ENCOUNTER_START" and tl_test then
			StopTimelineTest()
		end

		self.test_dur = 10
		self.start = GetTime()
		self:Show()
		
        if C_AddOns.IsAddOnLoaded("MRT") and _G.VExRT.Note then
			if C.DB["GeneralOption"]["tl_use_raid"] and _G.VExRT.Note.Text1 then
				local text = _G.VExRT.Note.Text1
				local betweenLine = false
				for line in text:gmatch('[^\r\n]+') do
					if line:match(L["战斗结束"]) then
						betweenLine = false
					end
					
					if betweenLine then                
						local str = line:gsub("||", "|")					
						if string.match(str, "P(.+) (%d+):(%d+)") then
							local phase, dur = GetPhaseInfo(str)
							if phase and dur then								
								if not self.phase_cd[phase] then
									self.phase_cd[phase] = {}
								end
								table.insert(self.phase_cd[phase], dur)
							end
						else
							local m, s = string.match(str, "(%d+):(%d+)")
							if m and s then
								local r = tonumber(m)*60+tonumber(s)
								local t = max(r - C.DB["GeneralOption"]["tl_advance"], 0)
								local exp_time = r + self.tl_dur
								local info = {
									cd_str = str,
									row_time = r,
									show_time = t,
									hide_time = exp_time,
								}
								table.insert(self.assignment_cd, info)
								self.test_dur = max(self.test_dur, exp_time)
							end
						end
					end
					
					if event == "TIMELINE_START" then
						if line:match(L["时间轴"]) then
							betweenLine = true
						end
					elseif event == "ENCOUNTER_START" then
						local engageID, _, difficultyID = ...
						if string.find(line, L["时间轴"]) and filterDiffculty(line, engageID, difficultyID) then	
							betweenLine = true
						end
					end
				end    
			end
			if C.DB["GeneralOption"]["tl_use_self"] and _G.VExRT.Note.SelfText then		
				local text = _G.VExRT.Note.SelfText
				local betweenLine = false
				local phase_cd_cache = {}
				
				for line in text:gmatch('[^\r\n]+') do
					if line:match(L["战斗结束"]) then
						betweenLine = false
					end
					
					if betweenLine then                
						local str = line:gsub("||", "|")
						if string.match(str, "P(.+) (%d+):(%d+)") then
							local phase, dur = GetPhaseInfo(str)
							if phase and dur then
								if not phase_cd_cache[phase] then
									phase_cd_cache[phase] = {}
								end
								table.insert(phase_cd_cache[phase], dur)		
							end
						else
							local m, s = string.match(str, "(%d+):(%d+)")
							if m and s then
								local r = tonumber(m)*60+tonumber(s)
								local t = max(r - C.DB["GeneralOption"]["tl_advance"], 0)
								local exp_time = r + self.tl_dur
								local info = {
									cd_str = str,
									row_time = r,
									show_time = t,
									hide_time = exp_time,
								}
								table.insert(self.assignment_cd, info)
								self.test_dur = max(self.test_dur, exp_time)
							end
						end
					end
					
					if event == "TIMELINE_START" then
						if line:match(L["时间轴"]) then
							betweenLine = true
						end
					elseif event == "ENCOUNTER_START" then
						local engageID, _, difficultyID = ...
						if string.find(line, L["时间轴"]) and filterDiffculty(line, engageID, difficultyID) then	
							betweenLine = true
						end
					end
				end
				-- 覆盖转阶段信息
				for phase, info in pairs(phase_cd_cache) do
					if not self.phase_cd[phase] then
						self.phase_cd[phase] = {}
					end
					for index, dur in pairs(phase_cd_cache[phase]) do
						self.phase_cd[phase][index] = dur
					end
				end
			end
		end
		
		self.test_exp = GetTime() + self.test_dur
    elseif event == "ENCOUNTER_END" or event == "TIMELINE_STOP" then
		self.start = 0
		self.time_offset = 0
		self.assignment_cd = table.wipe(self.assignment_cd)
		self.phase_cd = table.wipe(self.phase_cd)
		
		if C.DB["GeneralOption"]["tl_glowtarget"] then -- 隐藏高亮
			T.GlowRaidFrame_HideAll("proc", "timelinetarget")
		end
		
		for _, line in pairs(self.ActiveLines) do  
			line:reset()
		end
		
		self:Hide()
	elseif event == "TIMELINE_PASSED" then
		local fake_passed = ...
		for i, t in pairs (self.assignment_cd) do
			if t.show_time <= fake_passed and t.hide_time > fake_passed then
				if not Timeline.Lines["timeline"..i] then
					Timeline_CreateLine(i)
				end
				if not Timeline.Lines["timeline"..i]:IsShown() then
					Timeline_UpdateLine(Timeline.Lines["timeline"..i], t.cd_str, t.row_time, self.start + t.row_time + self.tl_dur - self.time_offset)
				end
			elseif Timeline.Lines["timeline"..i] and Timeline.Lines["timeline"..i]:IsShown() then
				Timeline.Lines["timeline"..i]:reset()
			end			
		end	
	elseif event == "ENCOUNTER_PHASE" then
		local phase, count = ...
		local to_time = self.phase_cd[phase] and self.phase_cd[phase][count]
		if to_time then			
			self.time_offset = to_time - (GetTime() - self.start)
		
			for _, frame in pairs(self.ActiveLines) do
				frame.exp_time = self.start + frame.row_time + self.tl_dur - self.time_offset
			end
		end
	elseif string.find(event, "VOICE_CHAT") then
		if event == "VOICE_CHAT_TTS_PLAYBACK_FAILED" or event == "VOICE_CHAT_TTS_SPEAK_TEXT_UPDATE" then
			local status, utteranceID = ...
			if TTS_failed_type[status] then
				T.msg(string.format(L["朗读失败"], TTS_failed_type[status]))
			end
		end
    end
end)

local mrt_eg = [[%1$s
0:10 %2$s {spell:31884}
0:20 %2$s {spell:33206}@%2$s
0:30 %2$s %3$s
0:40 %2$s %4$s@%2$s
%5$s]]

T.CopyTimeline = function()
	local name = T.GetNameByGUID(G.PlayerGUID)
	local button = JSTtimelineScrollAnchor.tl_copy
	T.DisplayCopyString(button, string.format(mrt_eg, L["时间轴"], name, L["注意自保"], L["注意治疗"], L["战斗结束"]), L["MRT时间轴模板"].." "..L["复制粘贴"])
end
----------------------------------------------------------
-----------------[[    团队私人光环    ]]-------------------
----------------------------------------------------------
local raid_pa_tag = "#jst_pa_start"

local RaidPAFrame = CreateFrame("Frame", addon_name.."PAFrame", FrameHolder)
RaidPAFrame:SetSize(200, 200)
RaidPAFrame.unitframes = {}

RaidPAFrame.movingname = L["团队PA光环"]
RaidPAFrame.point = { a1 = "TOPLEFT", a2 = "TOPLEFT", x = 20, y = -20}
T.CreateDragFrame(RaidPAFrame)

function RaidPAFrame:PreviewShow()
	RaidPAFrame.generate_all()
end

function RaidPAFrame:PreviewHide()
	RaidPAFrame.release_all()
end

T.GetMrtForPrivateAuraRaidFrame = function()		
	local raidlist = ""
	local i = 0
	
	for unit in T.IterateGroupMembers() do
		i = i + 1
		local name = UnitName(unit)
		if i == 1 then
			raidlist = raidlist..string.format("[%d] ", ceil(i/5))..T.ColorNameForMrt(name).." "
		elseif mod(i, 5) == 1 then
			raidlist = raidlist.."\n"..string.format("[%d] ", ceil(i/5))..T.ColorNameForMrt(name).." "
		else
			raidlist = raidlist..T.ColorNameForMrt(name).." "
		end
	end
	
	raidlist = string.format("%s\n%s\nend", raid_pa_tag, raidlist).."\n"
	
	local button = _G[G.addon_name.."toolsScrollAnchor"].pa_copy_mrt		
	T.DisplayCopyString(button, raidlist)
end

local function Hook_PrivateAura_Anchor(uf)
	for i = 1, 4 do
		if not uf["auraAnchorID"..i] then
			uf["auraAnchorID"..i] = C_UnitAuras.AddPrivateAuraAnchor({
				unitToken = uf.unit,
				auraIndex = i,
				parent = uf,
				showCountdownFrame = true,
				showCountdownNumbers = false,
				iconInfo = {
					iconWidth = C.DB["GeneralOption"]["raid_pa_height"],
					iconHeight = C.DB["GeneralOption"]["raid_pa_height"],
					iconAnchor = {
						point = "LEFT",
						relativeTo = uf,
						relativePoint = "RIGHT",
						offsetX = 2+(i-1)*(C.DB["GeneralOption"]["raid_pa_height"]+2),
						offsetY = 0,
					},
				},
			})
		end
	end
end

local function Remove_PrivateAura_Anchor(uf)
	for i = 1, 4 do
		if uf["auraAnchorID"..i] then
			C_UnitAuras.RemovePrivateAuraAnchor(uf["auraAnchorID"..i])
			uf["auraAnchorID"..i] = nil
		end
	end
end

local function Create_PrivateAura_UF(GUID, w, h, font_size, icon_num, frame_num, num)
	local info = T.GetGroupInfobyGUID(GUID)
	local uf = CreateFrame("Frame", nil, RaidPAFrame)
	local uf_width = w+2+icon_num*(h+2) -- 框架+图标宽度
	
	uf:SetSize(w, h)
	uf:SetPoint("TOPLEFT", RaidPAFrame, "TOPLEFT", (frame_num-1)*(uf_width+5), -(num-1)*(h+3))
	
	uf.text = T.createtext(uf, "OVERLAY", font_size, "OUTLINE", "CENTER")
	uf.text:SetPoint("LEFT", uf, "LEFT", 3, 0)
	uf.text:SetText(info.format_name)
	
	T.createborder(uf, .3, .3, .3)
	
	if UnitIsUnit(info.unit, "player") then
		uf.sd:SetBackdropColor(0, 1, 0)
	end
	
	uf.Update = function()
		local w, h, font_size, icon_num = C.DB["GeneralOption"]["raid_pa_width"], C.DB["GeneralOption"]["raid_pa_height"], C.DB["GeneralOption"]["raid_pa_fsize"], C.DB["GeneralOption"]["raid_pa_icon_num"]
		local uf_width = w+2+icon_num*(h+2)
		uf:SetSize(w, h)
		uf.text:SetFont(G.Font, font_size, "OUTLINE")
		uf:ClearAllPoints()
		uf:SetPoint("TOPLEFT", RaidPAFrame, "TOPLEFT", (frame_num-1)*(uf_width+5), -(num-1)*(h+3))
	end
	
	uf.unit = info.unit
	Hook_PrivateAura_Anchor(uf)	
	
	table.insert(RaidPAFrame.unitframes, uf)
end

T.EditRaidPAFrame = function(option)
	if option == "all" or option == "enable" then
		if C.DB["GeneralOption"]["raid_pa"] then
			T.RestoreDragFrame(RaidPAFrame)
			RaidPAFrame:RegisterEvent("ENCOUNTER_START")
			RaidPAFrame:RegisterEvent("ENCOUNTER_END")
		else
			T.ReleaseDragFrame(RaidPAFrame)
			RaidPAFrame:UnregisterEvent("ENCOUNTER_START")
			RaidPAFrame:RegisterEvent("ENCOUNTER_END")
			RaidPAFrame.release_all()
		end
	end
	
	if option == "all" or option == "size" then
		local w, h, font_size, icon_num = C.DB["GeneralOption"]["raid_pa_width"], C.DB["GeneralOption"]["raid_pa_height"], C.DB["GeneralOption"]["raid_pa_fsize"], C.DB["GeneralOption"]["raid_pa_icon_num"]
		local uf_width = w+2+icon_num*(h+2)
		if C_AddOns.IsAddOnLoaded("MRT") and _G.VExRT.Note and _G.VExRT.Note.Text1 then
			local text = _G.VExRT.Note.Text1
			local betweenLine = false
			local frame_num, frame_num_each = 0, 0
						
			for line in text:gmatch('[^\r\n]+') do
				if line == "end" then
					betweenLine = false
				end
				if betweenLine then
					local num = 0
					for name in line:gmatch("|c%x%x%x%x%x%x%x%x([^|]+)|") do						
						num = num + 1
					end
					frame_num_each = max(frame_num_each, num) -- 最大单列人数
					if num > 0 then
						frame_num = frame_num + 1 -- 增加列数
					end
				end
				if line:match(raid_pa_tag) then
					betweenLine = true
				end
			end
			
			for i, uf in pairs(RaidPAFrame.unitframes) do
				uf:Update()
			end
			
			if frame_num > 0 and frame_num_each > 0 then
				RaidPAFrame:SetSize(frame_num*uf_width+(frame_num-1)*5, frame_num_each*(h+3)-3)
			else
				RaidPAFrame:SetSize(2*uf_width+5, 5*(h+3)-3)
			end
		else
			-- 没写战术板时2*10
			RaidPAFrame:SetSize(2*uf_width+5, 5*(h+3)-3)
		end
	end
end

RaidPAFrame.generate_all = function()
	if C_AddOns.IsAddOnLoaded("MRT") and _G.VExRT.Note and _G.VExRT.Note.Text1 then		
		local text = _G.VExRT.Note.Text1
		local GUIDs = {}
		local betweenLine = false
		local group_index = 0
		local frame_num_each = 0
		
		for line in text:gmatch('[^\r\n]+') do
			if line == "end" then
				betweenLine = false
			end
			if betweenLine then
				group_index = group_index + 1
				GUIDs[group_index] = T.LineToGUIDArray(line)
			end
			if line:match(raid_pa_tag) then
				betweenLine = true
			end
		end
		
		local w = C.DB["GeneralOption"]["raid_pa_width"]
		local h = C.DB["GeneralOption"]["raid_pa_height"]
		local font_size = C.DB["GeneralOption"]["raid_pa_fsize"]
		local icon_num = C.DB["GeneralOption"]["raid_pa_icon_num"]
		local uf_width = w+2+icon_num*(h+2)

		for ind, group in pairs(GUIDs) do
			for i, GUID in pairs(group) do
				Create_PrivateAura_UF(GUID, w, h, font_size, icon_num, ind, i)
			end
			frame_num_each = max(frame_num_each, #group)		
		end
				
		if group_index > 0 and frame_num_each > 0 then
			RaidPAFrame:SetSize(group_index*uf_width+(group_index-1)*5, frame_num_each*(h+3)-3)
		else
			RaidPAFrame:SetSize(2*uf_width+5, 5*(h+3)-3)
		end
		
		RaidPAFrame:Show()
	end
end

RaidPAFrame.release_all = function()
	for i, uf in pairs(RaidPAFrame.unitframes) do
		uf:Hide()
		Remove_PrivateAura_Anchor(uf)
	end
	RaidPAFrame.unitframes = table.wipe(RaidPAFrame.unitframes)
	RaidPAFrame:Hide()
end

RaidPAFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
RaidPAFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "ENCOUNTER_START" then
		local _, _, _, groupSize = ...
		if groupSize > 5 then
			self.generate_all()
		end
	elseif event == "ENCOUNTER_END" then
		self.release_all()
	end
end)

----------------------------------------------------------
-------------------[[    控制链    ]]---------------------
----------------------------------------------------------
local group_spell_tag = "JSTSpells"

local ControlSpellFrame = CreateSpellLineFrame("GroupSpellFrame", L["团队技能监控"], 40, "vertical", "TOPLEFT", -300, 200)
ControlSpellFrame:Hide()

ControlSpellFrame.data = {}

function ControlSpellFrame:PreviewShow()
	self:generate_all()
end

function ControlSpellFrame:lineup()
	local lastframe		
	for index, icon in pairs(self.active_byindex) do
		if icon:IsShown() then
			icon:ClearAllPoints()
			if not lastframe then
				icon:SetPoint("TOPLEFT", self, "TOPLEFT", 0, 0)
			else
				icon:SetPoint("TOPLEFT", lastframe, "BOTTOMLEFT", 0, -5)	
			end
			lastframe = icon
		end
	end
end

local function CreateControlSpellIcon(updater, group, tag)	
	local icon = CreateSpellIconBase(ControlSpellFrame, tag)
	
	icon.source_text = T.createtext(icon, "OVERLAY", 12, "OUTLINE", "CENTER") -- 玩家名字
	icon.source_text:SetPoint("LEFT", icon, "RIGHT", 2, 0)
	
	function icon:update_onedit(option)
		if option == "all" or option == "icon_size" then
			self:SetSize(C.DB["GeneralOption"]["control_spell_size"], C.DB["GeneralOption"]["control_spell_size"])
		end
	end
	
	function icon:init_display(GUID, spellID, charge)
		self.GUID = GUID
		self.spellID = spellID
		self.charge = charge
		
		self.texture:SetTexture(C_Spell.GetSpellTexture(spellID))
		self.source_text:SetText(T.ColorNickNameByGUID(GUID))
		self:update_charge()
		
		self:update_onedit("all")
		self:Show()
	end
	
	function icon:cancel()
		self:Hide()
		self.texture:SetDesaturated(false)
	end
	
	updater.actives_bytag[tag] = icon
	
	return icon
end

local ControlSpell_Updater = T.CreateUpdater(CreateControlSpellIcon, ControlSpellFrame)

ControlSpell_Updater.active_byGUID = {}

function ControlSpellFrame:get_assignment()
	
end

function ControlSpellFrame:generate_all()
	
end

ControlSpell_Updater:SetScript("OnEvent", function(self, event, ...)	
	
end)