local T, C, L, G = unpack(select(2, ...))

local NickNameInfo = {}
local CharNameInfo = {}
local FullNameInfo = {}
local GroupInfo = {}

local UnitFrames = {}

local newest = G.Version
local last_scan = 0

local LS = LibStub:GetLibrary("LibSpecializationEdit")
local LGF = LibStub("LibGetFrame-1.0")
local My_mrtNoteHash, My_ilvl, My_raidBuff = 0, 0, 0
local mrtUpdateTimer, equipmentUpdateTimer, raidBuffUpdateTimer
--====================================================--
--[[                 -- API --                      ]]--
--====================================================--

local function IsTalentSpellKnown(importText, spellID)
	local importStream = ExportUtil.MakeImportDataStream(importText)
	local headerValid, serializationVersion, specID = PlayerSpellsFrame.TalentsFrame:ReadLoadoutHeader(importStream)
	
	local configID = Constants.TraitConsts.VIEW_TRAIT_CONFIG_ID
	local treeID = C_ClassTalents.GetTraitTreeForSpec(specID)

	local loadoutContent = PlayerSpellsFrame.TalentsFrame:ReadLoadoutContent(importStream, treeID)
	local loadoutEntryInfo = PlayerSpellsFrame.TalentsFrame:ConvertToImportLoadoutEntryInfo(configID, treeID, loadoutContent)
	
	for i, info in pairs(loadoutEntryInfo) do
		local EntryInfo = C_Traits.GetEntryInfo(configID, info.selectionEntryID)
		if EntryInfo and EntryInfo.definitionID then
			local DefinitionInfo = C_Traits.GetDefinitionInfo(EntryInfo.definitionID)
			if DefinitionInfo and DefinitionInfo.spellID and DefinitionInfo.spellID == spellID then
				return true
			end
		end			
	end
end

-- Calculates checksum for the player's public MRT note
-- Original code by Mikk (https://warcraft.wiki.gg/wiki/StringHash)
local function GetMRTNoteHash()
    local text = VMRT and VMRT.Note.Text1

    if not text then return end

    local counter = 1
    local len = string.len(text)

    for i = 1, len, 3 do 
        counter = math.fmod(counter * 8161, 4294967279) + (string.byte(text, i) * 16776193) + ((string.byte(text, i + 1) or (len - i + 256)) * 8372226) + ((string.byte(text, i + 2) or (len - i + 256)) * 3932164)
    end

    return math.fmod(counter, 4294967291)
end

local function UpdateMRTNoteHash()
    if not C_AddOns.IsAddOnLoaded("MRT") then return end

    local foundNew = false
    local hash = GetMRTNoteHash() or 0
	
    if My_mrtNoteHash ~= hash then
        foundNew = true
    end
	
    My_mrtNoteHash = hash
	
    return foundNew
end

local function UpdateEquipmentLevel()
	local foundNew = false
    local _, avgItemLevelEquipped = GetAverageItemLevel()

    if My_ilvl ~= avgItemLevelEquipped then
        foundNew = true
    end
	
    My_ilvl = avgItemLevelEquipped
	
    return foundNew
end

local function UpdateRaidBuffValue()
	local foundNew = false
    local BuffPerc = select(16, AuraUtil.FindAuraBySpellID(1237913, "player", "HELPFUL")) or 0

    if My_raidBuff ~= BuffPerc then
        foundNew = true
    end
	
    My_raidBuff = BuffPerc
	
    return foundNew
end
----------------------------------------------------------
---------------------[[     API     ]]--------------------
----------------------------------------------------------
-- 比较版本
local MaxVer = function(ver1, ver2)
	local value1 = tonumber(string.match(ver1, "(%d*%.?%d+)"))
	local value2 = tonumber(string.match(ver2, "(%d*%.?%d+)"))
	if value1 >= value2 then
		return ver1
	else
		return ver2
	end
end

-- 比较MRT战术板内容
local GetMrtDifferent = function(mrtHash)
	local my_value = tonumber(My_mrtNoteHash)
	local value = tonumber(mrtHash)
	if value == 0 then
		return string.format("|cffffff00%s|r", L["无信息"])
	elseif my_value - value == 0 then
		return string.format("|cff00ff00%s|r", L["相同"])
	else
		return string.format("|cffff0000%s|r", L["不同"])
	end
end

-- 版本染色
local FormatVersionText = function(ver)
	if not ver then return end
	if ver == newest then
		return ver
	elseif ver == "NO ADDON" then
		return string.format("|cffFF0000%s|r", ver) 
	else
		return string.format("|cffFFA500%s|r", ver)
	end
end

-- 根据职业染色文本
local ColorNameText = function(name_text, player)
	local class = select(2, UnitClass(player))
	local colorstr = class and G.Ccolors[class]["colorStr"] or "ffffffff"
	local str = string.format("|c%s%s|r", colorstr, name_text)
	return str
end
T.ColorNameText = ColorNameText

-- 生成用于MRT战术板的名字格式
local ColorNameForMrt = function(name)
	local str = ColorNameText(name, name)
	local mrt_str = string.gsub(str, "|", "||")
	return mrt_str
end
T.ColorNameForMrt = ColorNameForMrt

----------------------------------------------------------
-----------------[[     团队信息 API     ]]---------------
----------------------------------------------------------
-- 获取队伍成员列表
local IterateGroupMembers = function(reversed, forceParty)
  local unit = (not forceParty and IsInRaid()) and 'raid' or 'party'
  local numGroupMembers = unit == 'party' and GetNumSubgroupMembers() or GetNumGroupMembers()
  local i = reversed and numGroupMembers or (unit == 'party' and 0 or 1)
  return function()
    local ret
    if i == 0 and unit == 'party' then
      ret = 'player'
    elseif i <= numGroupMembers and i > 0 then
      ret = unit .. i
    end
    i = i + (reversed and -1 or 1)
    return ret
  end
end
T.IterateGroupMembers = IterateGroupMembers

-- 获取坦克成员
local IterateCoTank = function(exclude_me)
  local unit = 'raid'
  local numGroupMembers = GetNumGroupMembers()
  local i = 1
  return function()
    local ret
    if i <= numGroupMembers then
      ret = unit .. i
    end
    i = i + 1
	if UnitGroupRolesAssigned(ret) == "TANK" and (not exclude_me or not UnitIsUnit(ret, "player")) then
		return ret
	end
  end
end
T.IterateCoTank = IterateCoTank

-- 队伍在战斗中
local IsGroupInCombat = function()
	for unit in IterateGroupMembers() do
		if UnitAffectingCombat(unit) then
			return true
		end
	end
end
T.IsGroupInCombat = IsGroupInCombat

-- 获取玩家昵称或名字
local GetNameByGUID = function(GUID)
	local info = GroupInfo[GUID]
	if info then
		if C.DB.GeneralOption.name_format == "nickname" and info.nick_name then
			return info.nick_name
		else
			return info.real_name
		end
	end
end
T.GetNameByGUID = GetNameByGUID

-- 获取队伍信息
--[[
	unit
	GUID
	real_name
	full_name
	format_name
	nick_name
	role
	class
	spec_id
	spec_icon
	pos
	ver
	ilvl
	buff
]]

-- 获取队友信息
local GetGroupInfobyGUID = function(GUID)
	local info = GUID and GroupInfo[GUID]
	if info then
		return info
	end
end
T.GetGroupInfobyGUID = GetGroupInfobyGUID

-- 获取队友单位
local GUIDToUnit = function(GUID)
	return GUID and GroupInfo[GUID] and GroupInfo[GUID].unit
end
T.GUIDToUnit = GUIDToUnit

-- 生成染色的队友昵称
local ColorNickNameByGUID = function(GUID)
	local unit = GUID and GroupInfo[GUID] and GroupInfo[GUID].unit
	if unit then
		return ColorNameText(GetNameByGUID(GUID), unit)
	end
end
T.ColorNickNameByGUID = ColorNickNameByGUID

-- 根据昵称/名字获取队伍信息
local GetGroupInfobyName = function(name)	
	if string.find(name, "-") then
		local GUID = FullNameInfo[name]
		if GUID and GroupInfo[GUID] then
			return GroupInfo[GUID]
		end
	elseif CharNameInfo[name] then
		local GUID = CharNameInfo[name] and CharNameInfo[name][1]
		if GUID and GroupInfo[GUID] then
			return GroupInfo[GUID]
		end
	elseif NickNameInfo[name] then
		local GUID = NickNameInfo[name] and NickNameInfo[name][1]
		if GUID and GroupInfo[GUID] then
			return GroupInfo[GUID]
		end
	end
end
T.GetGroupInfobyName = GetGroupInfobyName

-- 根据昵称/名字获取队伍信息
local GetGroupGUIDbyName = function(name)	
	if string.find(name, "-") then
		local GUID = FullNameInfo[name]
		if GUID then
			return GUID
		end
	elseif CharNameInfo[name] then
		local GUID = CharNameInfo[name] and CharNameInfo[name][1]
		if GUID then
			return GUID
		end
	elseif NickNameInfo[name] then
		local GUID = NickNameInfo[name] and NickNameInfo[name][1]
		if GUID then
			return GUID
		end
	end
end
T.GetGroupGUIDbyName = GetGroupGUIDbyName

-- 朗读文本中获取玩家名字
local GetNameByName = function(name)
	local info = GetGroupInfobyName(name)
	if info then
		if C.DB.GeneralOption.name_format == "nickname" and info.nick_name then
			return info.nick_name
		else
			return info.real_name
		end
	else
		return name
	end
end
T.GetNameByName = GetNameByName

----------------------------------------------------------
-------------------[[     排序 API     ]]-----------------
----------------------------------------------------------

-- 排序
-- sortRoles = "TDH" TANK > DAMAGER > HEALER
-- sortRoles = "THD" TANK > HEALER > DAMAGER
-- sortRoles = "DHT" DAMAGER > HEALER > TANK
-- sortRoles = "HDT" HEALER > DAMAGER > TANK

local role_order_data = {}
local role_orders = {
	TDH = {"TANK", "DAMAGER", "HEALER"},
	THD = {"TANK", "HEALER", "DAMAGER"},
	DHT = {"DAMAGER", "HEALER", "TANK"},
	HDT = {"HEALER", "DAMAGER", "TANK"},	
}

for key, line in pairs(role_orders) do
	role_order_data[key] = {}
	for i, role in pairs(line) do
		role_order_data[key][role] = i
	end
end

T.SortTable = function(t, rangedFirst, sortRoles)
    table.sort(
        t,
        function (GUID1, GUID2)
            if not GUID1 then return false end
            if not GUID2 then return true end
            
			local info1 = GetGroupInfobyGUID(GUID1)
			local info2 = GetGroupInfobyGUID(GUID2)
			
            local type1, spec1, role1 = info1.pos, info1.spec_id, info1.role
            local type2, spec2, role2 = info2.pos, info2.spec_id, info2.role
            
			if sortRoles and role_order_data[sortRoles] then
				if role1 ~= role2 then
                    return role1 < role2
                end
			end
            
            if type1 and type2 and type1 ~= type2 then
                return type1 == (rangedFirst and "RANGED" or "MELEE")
            elseif spec1 and spec2 and spec1 ~= spec2 then
                return spec1 < spec2 -- For consistency's sake
            else
                return GUID1 < GUID2
            end
        end
    )
end

-- 根据移动能力排序
local classMobility = {
    PRIEST = 1,
    DEATHKNIGHT = 2,
    WARLOCK = 3,
    PALADIN = 4,
    DRUID = 5,
    HUNTER = 6,
    SHAMAN = 7,
    ROGUE = 8,
    EVOKER = 9,
    WARRIOR = 10,
    DEMONHUNTER = 11,
    MONK = 12,
    MAGE = 13
}
G.classMobility = classMobility

T.SortTableMobility = function(t, reverse)
    table.sort(
        t,
        function (GUID1, GUID2)
            if not GUID1 then return false end
            if not GUID2 then return true end
            
            local info1 = GetGroupInfobyGUID(GUID1)
			local info2 = GetGroupInfobyGUID(GUID2)
            
            local class1 = info1.class
            local class2 = info2.class
            
            local mobility1 = classMobility[class1]
            local mobility2 = classMobility[class2]
            
            if reverse then
                if mobility1 ~= mobility2 then
                    return mobility1 > mobility2
                else
                    return GUID1 > GUID2
                end
            else
                if mobility1 ~= mobility2 then
                    return mobility1 < mobility2
                else
                    return GUID1 < GUID2
                end
            end
        end
    )
end

----------------------------------------------------------
---------------------[[     GUI     ]]--------------------
----------------------------------------------------------
local OP = G.raid_options
local player_lines = {}

local function FormatNickNames(GUID)
	local info = GroupInfo[GUID]
	if info and info.nick_name then
		if #NickNameInfo[info.nick_name] > 1 then
			return string.format("|cffFF0000%s|r", info.nick_name)
		else
			return info.nick_name
		end
	else
		return ""
	end
end

local function LineUpRaidInfoLines()
	local num = 1
	for i, frame in pairs(player_lines) do
		frame:ClearAllPoints()
		if frame:IsShown() then
			frame:SetPoint("TOPLEFT", 20, -45-num*25)
			num = num + 1
		end
	end
end

local function CreateRefreshButton(frame)
	local btn = CreateFrame("Button", nil, frame, "BigRedRefreshButtonTemplate")
	
	btn:SetPoint("RIGHT", frame, "RIGHT", 0, 0)
	btn:SetSize(20, 20)
	btn.tooltipText = L["刷新版本和昵称"]
	
	btn:SetScript("OnClick", function(self)
		if not frame.playerGUID then return end
		
		local GUID = frame.playerGUID
		
		GroupInfo[GUID].mrtHash = 0
		GroupInfo[GUID].ilvl = 0
		GroupInfo[GUID].buff = 0
		GroupInfo[GUID].nick_name = nil
		GroupInfo[GUID].ver = "NO ADDON"
		
		frame.str2:SetText("...")
		frame.str4:SetText("...")
		frame.str5:SetText("...")
		frame.str6:SetText("...")
		
		self:Disable()
		T.addon_msg("ver", "WHISPER", Ambiguate(GroupInfo[GUID].full_name, "none"))

		C_Timer.After(2, function()
			local info = GetGroupInfobyGUID(GUID)
			frame.str2:SetText(string.format("%.1f (%d%%)", info.ilvl, info.buff))
			frame.str4:SetText(FormatNickNames(GUID))
			frame.str5:SetText(FormatVersionText(info.ver))
			frame.str6:SetText(GetMrtDifferent(info.mrtHash))
			self:Enable()
		end)
	end)
	
	return btn
end

local function CreateRaidInfoLine(istitle)
	local frame = CreateFrame("Frame", nil, OP.sfa)
	frame:SetSize(850, 20)

	frame.str1 = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.str1:SetPoint("LEFT", frame, "LEFT", 0, 0)
	frame.str1:SetWidth(150)
	
	frame.str2 = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.str2:SetPoint("LEFT", frame.str1, "RIGHT", 0, 0)
	frame.str2:SetWidth(120)
	
	frame.str3 = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.str3:SetPoint("LEFT", frame.str2, "RIGHT", 0, 0)
	frame.str3:SetWidth(80)
	
	frame.str4 = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.str4:SetPoint("LEFT", frame.str3, "RIGHT", 0, 0)
	frame.str4:SetWidth(80)
	
	frame.str5 = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.str5:SetPoint("LEFT", frame.str4, "RIGHT", 0, 0)
	frame.str5:SetWidth(80)
	
	frame.str6 = T.createtext(frame, "OVERLAY", 14, "OUTLINE", "LEFT")
	frame.str6:SetPoint("LEFT", frame.str5, "RIGHT", 0, 0)
	frame.str6:SetWidth(150)
	
	if not istitle then
		frame:Hide()
		frame.refresh_btn = CreateRefreshButton(frame)	
		table.insert(player_lines, frame)
	end
	
	return frame
end

local function GetAvailableRaidInfoLine()
	local available
	for i, frame in pairs(player_lines) do
		if not frame.playerGUID then
			available = frame
			break
		end
	end
	if not available then
		available = CreateRaidInfoLine()
	end
	return available
end

local function GetRaidInfoLineForPlayerGUID(GUID)
	for i, frame in pairs(player_lines) do
		if frame.playerGUID == GUID then
			return frame
		end
	end
end

local function UpdateRaidInfoLineByPlayerGUID(GUID)
	if not OP:IsShown() then return end
	local frame = GetRaidInfoLineForPlayerGUID(GUID) or GetAvailableRaidInfoLine()
	local info = GetGroupInfobyGUID(GUID)
	
	frame.str1:SetText(ColorNameText(info.real_name, info.unit))
	frame.str2:SetText(string.format("%.1f (%d%%)", info.ilvl, info.buff))
	frame.str3:SetText(info.spec_icon and T.GetTextureStr(info.spec_icon) or "")
	frame.str4:SetText(FormatNickNames(info.GUID)) -- 冲突染色
	frame.str5:SetText(FormatVersionText(info.ver))
	frame.str6:SetText(GetMrtDifferent(info.mrtHash))
	
	frame.playerGUID = GUID
	if not frame:IsShown() then
		frame:Show()
		LineUpRaidInfoLines()
	end
end

local function UpdateLinesByNickName(nick_name)
	for _, GUID in pairs(NickNameInfo[nick_name]) do
		UpdateRaidInfoLineByPlayerGUID(GUID)
	end
	if #NickNameInfo[nick_name] > 1 then
		local str = ""
		for _, GUID in pairs(NickNameInfo[nick_name]) do
			local info = GroupInfo[GUID]
			str = str.." "..ColorNameText(info.real_name, info.unit)
		end
		T.msg(string.format(L["昵称冲突"], nick_name, str))
	end
end

local function RemoveRaidInfoLineByPlayerGUID(GUID)
	if not OP:IsShown() then return end
	local frame = GetRaidInfoLineForPlayerGUID(GUID)
	if frame then
		if frame:IsShown() then
			frame:Hide()
			LineUpRaidInfoLines()
		end
		frame.playerGUID = nil
	end
end

local function RemoveAllRaidInfoLine()
	if not OP:IsShown() then return end
	for i, frame in pairs(player_lines) do	
		frame:Hide()
		frame.playerGUID = nil
	end
end

-- 刷新按钮
local refresh_btn = T.ClickButton(OP.sfa, 80, {"TOPRIGHT", OP.sfa, "TOPRIGHT", -5, -2}, L["刷新"])

refresh_btn:SetScript("OnShow", function()
	RemoveAllRaidInfoLine()
	for GUID in pairs(GroupInfo) do
		UpdateRaidInfoLineByPlayerGUID(GUID)
	end
end)

refresh_btn:SetScript("OnClick", function()
	refresh_btn:SetText("...")
	refresh_btn:Disable()

	if IsInGroup() then
		RemoveAllRaidInfoLine()
		
		for GUID, info in pairs(GroupInfo) do
			info.ver = "NO ADDON"
			info.mrtHash = 0
			info.ilvl = 0
			info.buff = 0
			info.nick_name = nil
			UpdateRaidInfoLineByPlayerGUID(GUID)
		end
		
		LS:RequestSpecialization()
		T.addon_msg("ver", "GROUP")
	end
	
	C_Timer.After(2, function()
		refresh_btn:SetText(L["刷新"])
		refresh_btn:Enable()
	end)
end)

-- 标题行
local title = CreateRaidInfoLine(true)
title:SetPoint("TOPLEFT", OP.sfa, "TOPLEFT", 20, -45)

title.str1:SetText(L["角色名"])
title.str2:SetText(L["装等/团本BUFF"])
title.str3:SetText(L["专精"])
title.str4:SetText(L["昵称"])
title.str5:SetText(L["JST版本"])
title.str6:SetText(L["MRT战术板对比"])

----------------------------------------------------------
--------------------[[     Event     ]]-------------------
----------------------------------------------------------
local function UpdateNickNameByPlayerGUID(GUID, nick_name_str)
	GroupInfo[GUID].nick_name = nil
	
	for nick_name, GUIDs in pairs(NickNameInfo) do
		for i, source in pairs(GUIDs) do
			if source == GUID then
				table.remove(NickNameInfo[nick_name], i)
				break
			end
		end
	end
		
	if nick_name_str ~= "" then
		nick_name_str = gsub(nick_name_str, " ", "") -- 去掉空格
		nick_name_str = gsub(nick_name_str, "\n", "") -- 去掉换行符
		
		GroupInfo[GUID].nick_name = nick_name_str

		if not NickNameInfo[nick_name_str] then
			NickNameInfo[nick_name_str] = {}
		end
		
		if not tContains(NickNameInfo[nick_name_str], GUID) then
			table.insert(NickNameInfo[nick_name_str], GUID)
		end
		
		UpdateLinesByNickName(nick_name_str)
	end
	
	GroupInfo[GUID].format_name = ColorNickNameByGUID(GUID)
	
	UpdateRaidInfoLineByPlayerGUID(GUID)
	
	T.FireEvent("GROUP_INFO_UPDATE", GUID)
end

local function SendMyInfo(target)
	if target then
		T.addon_msg("send_ver,"..G.Version..","..C.DB["GeneralOption"]["mynickname"]..","..My_ilvl..","..My_raidBuff..","..My_mrtNoteHash, "WHISPER", target)
	else
		T.addon_msg("send_ver,"..G.Version..","..C.DB["GeneralOption"]["mynickname"]..","..My_ilvl..","..My_raidBuff..","..My_mrtNoteHash, "GROUP")
	end
end

local function UpdateMyInfo()
	GroupInfo[G.PlayerGUID].ver = G.Version
	GroupInfo[G.PlayerGUID].mrtHash = My_mrtNoteHash
	GroupInfo[G.PlayerGUID].ilvl = My_ilvl
	GroupInfo[G.PlayerGUID].buff = My_raidBuff
	UpdateNickNameByPlayerGUID(G.PlayerGUID, C.DB["GeneralOption"]["mynickname"])
	
	local specId, role, position = LS:MySpecialization()
	if specId and role and position then
		GroupInfo[G.PlayerGUID].role = role
		GroupInfo[G.PlayerGUID].spec_id = specId
		GroupInfo[G.PlayerGUID].spec_icon = select(4, GetSpecializationInfoByID(specId))
		GroupInfo[G.PlayerGUID].pos = position
	end
end

local function UpdateMrtNoteForAll()
	for GUID in pairs(GroupInfo) do
		UpdateRaidInfoLineByPlayerGUID(GUID)
	end
end

local function UpdateNameByGUID(GUID)
	local unit = GUID and GroupInfo[GUID] and GroupInfo[GUID].unit
	if unit then
		local name, realm = UnitNameUnmodified(unit)
		realm = realm or GetRealmName()
		
		if name and realm then
			local full_name = string.format("%s-%s", name, realm)
			
			GroupInfo[GUID].real_name = name
			GroupInfo[GUID].full_name = full_name
			GroupInfo[GUID].format_name = ColorNickNameByGUID(GUID)
			
			if not CharNameInfo[name] then
				CharNameInfo[name] = {}
			end
			
			table.insert(CharNameInfo[name], GUID)
			FullNameInfo[full_name] = GUID
			
			T.FireEvent("GROUP_INFO_UPDATE", GUID)
		end
	end
end

local function ScanUnit(unit)
	local GUID = UnitGUID(unit)

	if not GroupInfo[GUID] then
		GroupInfo[GUID] = {}
	end
	
	if not GroupInfo[GUID].ver then
		GroupInfo[GUID].ver = "NO ADDON"
	end
	
	if not GroupInfo[GUID].mrtHash then
		GroupInfo[GUID].mrtHash = 0
	end
	
	if not GroupInfo[GUID].ilvl then
		GroupInfo[GUID].ilvl = 0
	end
	
	if not GroupInfo[GUID].buff then
		GroupInfo[GUID].buff = 0
	end
	
	GroupInfo[GUID].GUID = GUID
	GroupInfo[GUID].unit = unit
	GroupInfo[GUID].class = select(2 ,UnitClass(unit))
	
	UpdateNameByGUID(GUID)
	
	if GUID == G.PlayerGUID then
		UpdateMyInfo()
	end
	
	if not UnitFrames[unit] then
		LGF:ScanForUnitFrames()
		UnitFrames[unit] = true
	end
	
	UpdateRaidInfoLineByPlayerGUID(GUID)
end

local function RemovePlayer(GUID)
	GroupInfo[GUID] = nil
	RemoveRaidInfoLineByPlayerGUID(GUID)
	
	for nick_name, GUIDs in pairs(NickNameInfo) do
		for i, source in pairs(GUIDs) do
			if source == GUID then
				table.remove(NickNameInfo[nick_name], i)
				UpdateLinesByNickName(nick_name)
				break
			end
		end
	end
	
	for real_name, GUIDs in pairs(CharNameInfo) do
		for i, source in pairs(GUIDs) do
			if source == GUID then
				table.remove(CharNameInfo[real_name], i)
				break
			end
		end
	end

	for full_name, source in pairs(FullNameInfo) do	
		if source == GUID then
			FullNameInfo[source] = nil
		end
	end
	
	T.FireEvent("GROUP_INFO_REMOVED", GUID)
end

local function ScanGroupMembers()
	if GetTime() - last_scan >= .5 then
		for GUID, info in pairs(GroupInfo) do
			local unit = UnitTokenFromGUID(GUID)
			if not unit or not UnitInAnyGroup(unit) then
				RemovePlayer(GUID)
			end
		end
	
		for unit in IterateGroupMembers() do
			ScanUnit(unit)
		end
		
		T.addon_msg("ver", "GROUP")
		
		last_scan = GetTime()
	else
		T.DelayFunc(.5, ScanGroupMembers)
	end
end

local eventframe = CreateFrame("Frame")

eventframe:SetScript("OnEvent", function(self, event, ...)
	if event == "GROUP_FORMED" then
		SendMyInfo()
	elseif event == "PLAYER_LOGIN" or event == "GROUP_ROSTER_UPDATE" then
		
		ScanGroupMembers()
		T.DelayFunc(1, function()
			if IsInGroup() and not JST_DB.active_all then
				T.addon_msg("ask_pm", "GROUP")
			end
		end)
	elseif event == "UNIT_NAME_UPDATE" then
		local unit = ...
		local GUID = unit and UnitGUID(unit)
		UpdateNameByGUID(GUID)
	elseif event == "ADDON_MSG" then
		--if InCombatLockdown() then return end
		local channel, sender, GUID, message = ...
		if message == "ver" then
			SendMyInfo(channel == "WHISPER" and Ambiguate(sender, "none"))				
		elseif message == "send_ver" then
			local ver, nick_name_str, item_lvl, buff_value, mrtHash = select(5, ...)
			if ver and nick_name_str and GroupInfo[GUID] then
				newest = MaxVer(newest, ver)				
				GroupInfo[GUID].ver = ver
				GroupInfo[GUID].ilvl = item_lvl
				GroupInfo[GUID].buff = buff_value or 0
				GroupInfo[GUID].mrtHash = mrtHash or 0
				UpdateNickNameByPlayerGUID(GUID, nick_name_str)
			end
		end
	elseif event == "PLAYER_EQUIPMENT_CHANGED" then
		if equipmentUpdateTimer and not equipmentUpdateTimer:IsCancelled() then
			equipmentUpdateTimer:Cancel()
		end
		
		equipmentUpdateTimer = C_Timer.NewTimer(3, function()
			local shouldBroadcast = UpdateEquipmentLevel()
		
			if shouldBroadcast then
				UpdateMyInfo()
				SendMyInfo()
			end
		end)
	elseif event == "UNIT_AURA" then
		if InCombatLockdown() then return end
		
		if raidBuffUpdateTimer and not raidBuffUpdateTimer:IsCancelled() then
			raidBuffUpdateTimer:Cancel()
		end
		
		raidBuffUpdateTimer = C_Timer.NewTimer(3, function()
			local shouldBroadcast = UpdateRaidBuffValue()
		
			if shouldBroadcast then
				UpdateMyInfo()
				SendMyInfo()
			end
		end)
	elseif event == "ADDON_LOADED" then
		local addon = ...
		if addon == G.addon_name then
			UpdateMRTNoteHash()
			UpdateEquipmentLevel()
			
			if MRTNote and MRTNote.text then
				hooksecurefunc(MRTNote.text, "SetText", function()
					if mrtUpdateTimer and not mrtUpdateTimer:IsCancelled() then
						mrtUpdateTimer:Cancel()
					end
		
					mrtUpdateTimer = C_Timer.NewTimer(3, function()
						local shouldBroadcast = UpdateMRTNoteHash()
		
						if shouldBroadcast then
							UpdateMrtNoteForAll()
							SendMyInfo()
						end
					end)
				end)
			end
		end
	end
end)

local update_events = {
	["GROUP_FORMED"] = true,
	["PLAYER_LOGIN"] = true,
	["GROUP_ROSTER_UPDATE"] = true,
	["UNIT_NAME_UPDATE"] = true,
	["ADDON_MSG"] = true,
	["ADDON_LOADED"] = true,
	["PLAYER_EQUIPMENT_CHANGED"] = true,
	["UNIT_AURA"] = true,
}

T.RegisterEventAndCallbacks(eventframe, update_events)

local function GroupSpecUpdate(specId, role, position, GUID)
	if GroupInfo[GUID] then
		GroupInfo[GUID].role = role
		GroupInfo[GUID].spec_id = specId
		GroupInfo[GUID].spec_icon = select(4, GetSpecializationInfoByID(specId))
		GroupInfo[GUID].pos = position
		
		UpdateRaidInfoLineByPlayerGUID(GUID)
	end
end

LS:Register("JST", GroupSpecUpdate)
----------------------------------------------------------
---------------[[     GUI 昵称按钮     ]]-----------------
----------------------------------------------------------
local GUI = G.GUI

GUI.name = T.ClickButton(GUI, 150, {"LEFT", GUI.updatebutton, "RIGHT", 5, 0})
GUI.name:SetScript("OnShow", function(self)
	self:SetText(string.format(L["我的昵称"], C.DB["GeneralOption"]["mynickname"]))
end)

GUI.name:SetScript("OnClick", function(self)	
	StaticPopup_Show(G.addon_name.."Nickname Input")
end)

StaticPopupDialogs[G.addon_name.."Nickname Input"].OnShow = function(self, data)
	local editBox = _G[self:GetName().."EditBox"]
	if editBox then
		editBox:SetText(C.DB["GeneralOption"]["mynickname"])
	end
end

StaticPopupDialogs[G.addon_name.."Nickname Input"].OnAccept = function(self)
	local editBox = _G[self:GetName().."EditBox"]
	if editBox then
		local str = editBox:GetText()
		C.DB["GeneralOption"]["mynickname"] = str
		G.GUI.name:SetText(string.format(L["我的昵称"], str))
		UpdateNickNameByPlayerGUID(G.PlayerGUID, str)
		SendMyInfo()
	end
end	
--====================================================--
--[[               -- 昵称检测 --                   ]]--
--====================================================--
local function GetGroupNickNameInfo()
	local namelist = ""
	local num = 0
	for unit in IterateGroupMembers() do
		local GUID = UnitGUID(unit)
		local name = UnitName(unit)
		if not (GroupInfo[GUID] and GroupInfo[GUID].nick_name) then
			num = num + 1
			if num <= 3 then
				namelist = namelist..ColorNameText(name, unit).." "
			end
		end
	end
	if num == 0 then
		return L["所有昵称已加载"]
	elseif num <= 3 then
		return string.format(L["昵称未加载"], namelist)
	else
		return string.format(L["多人昵称未加载"], namelist, num)
	end
end

local RaidStatusCheckFrame = CreateFrame("Frame", G.addon_name.."RaidStatusCheckFrame", UIParent)
RaidStatusCheckFrame:SetSize(130, 30)

RaidStatusCheckFrame.movingname = L["昵称实时检测"]
RaidStatusCheckFrame.point = { a1 = "CENTER", a2 = "TOP", x = 0, y = -50}
T.CreateDragFrame(RaidStatusCheckFrame)

RaidStatusCheckFrame.refresh_btn = CreateFrame("Button", nil, RaidStatusCheckFrame)
RaidStatusCheckFrame.refresh_btn:SetSize(15, 15)
RaidStatusCheckFrame.refresh_btn:SetPoint("TOPLEFT", RaidStatusCheckFrame, "TOPLEFT", 0, 0)
T.createborder(RaidStatusCheckFrame.refresh_btn)

RaidStatusCheckFrame.refresh_btn:SetNormalTexture("uitools-icon-refresh")

RaidStatusCheckFrame.refresh_btn:SetScript("OnEnter", function(self) 
	GameTooltip:SetOwner(self, "ANCHOR_TOPLEFT", 0, 0)
	GameTooltip:AddLine(L["刷新"])
	GameTooltip:Show()
end)

RaidStatusCheckFrame.refresh_btn:SetScript("OnLeave", function(self)
	GameTooltip:Hide()
end)

RaidStatusCheckFrame.refresh_btn:SetScript("OnClick", function(self)	
	self:GetNormalTexture():SetVertexColor(1, 0, 0)
	self:EnableMouse(false)	
	T.addon_msg("ver", "GROUP")
	
	C_Timer.After(1, function()
		RaidStatusCheckFrame.text:SetText(GetGroupNickNameInfo())
		self:GetNormalTexture():SetVertexColor(1, 1, 1)
		self:EnableMouse(true)
	end)
end)

RaidStatusCheckFrame.text = T.createtext(RaidStatusCheckFrame, "OVERLAY", 16, "OUTLINE", "LEFT")
RaidStatusCheckFrame.text:SetPoint("TOPLEFT", 20, 0)

RaidStatusCheckFrame.t = 15

RaidStatusCheckFrame:SetScript("OnUpdate", function(self, e)
	self.t = self.t + e
	if self.t > 15 then
		self.text:SetText(GetGroupNickNameInfo())
		self.t = 0
	end
end)

T.ToggleNicknameCheck = function()
	if C.DB["GeneralOption"]["nickname_check"] then
		T.RestoreDragFrame(RaidStatusCheckFrame)
		RaidStatusCheckFrame:Show()
	else
		T.ReleaseDragFrame(RaidStatusCheckFrame)
		RaidStatusCheckFrame:Hide()
	end
end
