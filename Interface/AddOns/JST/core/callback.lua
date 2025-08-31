local T, C, L, G = unpack(select(2, ...))

----------------------------------------------------------
---------------[[        Callbacks        ]]--------------
----------------------------------------------------------

do
	local callbacks = {}

	function fireEvent(event, ...)
		if not callbacks[event] then return end
		for _, v in ipairs(callbacks[event]) do
		    securecall(v, event, ...)
		end
	end

	T.FireEvent = function(event, ...)
		fireEvent(event, ...)
	end

	T.IsCallbackRegistered = function (event, f)
		if not event or type(f) ~= "function" then
			error("Usage: IsCallbackRegistered(event, callbackFunc)", 2)
		end
		if not callbacks[event] then return end
		for i = 1, #callbacks[event] do
			if callbacks[event][i] == f then return true end
		end
		return false
	end

	T.RegisterCallback = function(event, f)
		if not event or type(f) ~= "function" then
			error("Usage: T.RegisterCallback(event, callbackFunc)", 2)
		end
		callbacks[event] = callbacks[event] or {}
		tinsert(callbacks[event], f)
		return #callbacks[event]
	end

	T.UnregisterCallback = function(event, f)
		if not event or not callbacks[event] then return end
		if f then
			if type(f) ~= "function" then
				error("Usage: T.UnregisterCallback(event, callbackFunc)", 2)
			end
			--> checking from the end to start and not stoping after found one result in case of a func being twice registered.
			for i = #callbacks[event], 1, -1 do
				if callbacks[event][i] == f then
					tremove(callbacks[event], i)
				end
			end
		else
			error("Usage: T.UnregisterCallback(event, callbackFunc)", 2)
		end
	end
end

----------------------------------------------------------
----------------------[[    API    ]]---------------------
----------------------------------------------------------

local CallbackEvents = {
	["TIMELINE_START"] = true,
	["TIMELINE_STOP"] = true,
	["TIMELINE_PASSED"] = true,
	["ENCOUNTER_PHASE"] = true,
	["ADDON_MSG"] = true,
	["JST_CUSTOM"] = true,
	["JST_SPELL_ASSIGN"] = true,
	["DATA_ADDED"] = true,
	["DATA_REMOVED"] = true,
	["DB_UPDATE"] = true,
	["GROUP_INFO_UPDATE"] = true,
	["GROUP_INFO_REMOVED"] = true,
	["GROUP_SPELL_COOLDOWN_UPDATE"] = true,
	["UNIT_ENTERING_COMBAT"] = true,
	["GROUP_LEAVING_COMBAT"] = true,
	["UNIT_AURA_ADD"] = true,
	["UNIT_AURA_UPDATE"] = true,
	["UNIT_AURA_REMOVED"] = true,
	["ENCOUNTER_ENGAGE_UNIT"] = true,
	["ENCOUNTER_SHOW_BOSS_UNIT"] = true,
	["ENCOUNTER_HIDE_BOSS_UNIT"] = true,
	["UNIT_RAID_BOSS_WHISPER"] = true,
	["JST_UNIT_ALIVE"] = true,
	["JST_MACRO_PRESSED"] = true,
	["JST_PRIVATE_AURA_EVENT"] = true,
	["JST_PRIVATE_AURA_CANCEL_EVENT"] = true,
	["JST_DISPEL_EVENT"] = true,
	["JST_CooldownListUpdate"] = true,
	["JST_CooldownListWipe"] = true,
	["JST_CooldownUpdate"] = true,
	["JST_CooldownAdded"] = true,
	["JST_GROUP_CD_UPDATE"] = true,
	["JST_GROUP_CC_NEXT"] = true,
}

T.RegisterEventAndCallbacks = function(frame, events, update)
	if events then
		for event, units in pairs(events) do
			if CallbackEvents[event] then
				if not frame.CallbackRegisted then
					frame.CallbackRegisted = {}
				end
				if not frame.CallbackRegisted[event] then
					frame.CallbackRegisted[event] = function(...)
						frame:GetScript("OnEvent")(frame, ...)
					end
					T.RegisterCallback(event, frame.CallbackRegisted[event])
				end
			else
				if type(units) == "table" then
					frame:RegisterUnitEvent(event, unpack(units))
				else
					frame:RegisterEvent(event)
				end
			end
		end
	end
end

T.UnregisterEventAndCallbacks = function(frame, events)
	if events then
		for event in pairs(events) do
			if CallbackEvents[event] then
				if frame.CallbackRegisted and frame.CallbackRegisted[event] then
					T.UnregisterCallback(event, frame.CallbackRegisted[event])
					frame.CallbackRegisted[event] = nil
				end
			else
				frame:UnregisterEvent(event)
			end
		end
	end
end

----------------------------------------------------------
------------------[[     自定义事件    ]]-----------------
----------------------------------------------------------

local eventframe = CreateFrame("Frame", nil, UIParent)

eventframe.engaged = {}
eventframe.active = {}

eventframe:SetScript("OnEvent", function(self, event, ...)
	if event == "CHAT_MSG_ADDON" then
		local prefix, message, channel, sender = ...
		if prefix == "jstpaopao" then
			local GUID, MSG_TYPE, msg = string.split(",", message)
			
			if MSG_TYPE == "boss_whisper" then
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("UNIT_RAID_BOSS_WHISPER", unit, GUID, msg)
				
			elseif MSG_TYPE == "unit_alive" then
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("JST_UNIT_ALIVE", unit, GUID)
				
			elseif MSG_TYPE == "target_me" then
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("JST_PRIVATE_AURA_EVENT", unit, GUID)
				
			elseif string.match(MSG_TYPE, "target_me(%d+)") then
				local index = string.match(MSG_TYPE, "target_me(%d+)")
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("JST_PRIVATE_AURA_EVENT", unit, GUID, tonumber(index))
				
			elseif MSG_TYPE == "remove_me" then
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("JST_PRIVATE_AURA_CANCEL_EVENT", unit, GUID)
				
			elseif string.match(MSG_TYPE, "remove_me(%d+)") then
				local index = string.match(MSG_TYPE, "remove_me(%d+)")
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("JST_PRIVATE_AURA_CANCEL_EVENT", unit, GUID, tonumber(index))
				
			elseif MSG_TYPE == "dispel_event" then
				local spellID = tonumber(msg)
				local unit = T.GUIDToUnit(GUID)
				T.FireEvent("JST_DISPEL_EVENT", unit, GUID, spellID)
				
			else
				T.FireEvent("ADDON_MSG", channel, sender, string.split(",", message))
			end
			
		end
	elseif event == "CHAT_MSG_RAID_BOSS_WHISPER" then
		local msg = ...
		T.addon_msg("boss_whisper,"..msg, "GROUP")
		
	elseif event == "PLAYER_ALIVE" then
		T.addon_msg("unit_alive", "GROUP")
		
	elseif event == "ENCOUNTER_START" then
		self.engaged = table.wipe(self.engaged)
		self.active = table.wipe(self.active)
		
	elseif event == "INSTANCE_ENCOUNTER_ENGAGE_UNIT" then
		C_Timer.After(.5, function()
			for GUID in pairs(self.active) do
				local unit = UnitTokenFromGUID(GUID)
				if not unit then
					self.active[GUID] = nil
					T.FireEvent("ENCOUNTER_HIDE_BOSS_UNIT", GUID)
				end
			end
			for unit in T.IterateBoss() do
				local GUID = UnitGUID(unit)
				if not self.engaged[GUID] then
					self.engaged[GUID] = true
					T.FireEvent("ENCOUNTER_ENGAGE_UNIT", unit, GUID)
				end
				if not self.active[GUID] then
					self.active[GUID] = true
					T.FireEvent("ENCOUNTER_SHOW_BOSS_UNIT", unit, GUID)
				end
			end
		end)
	end
end)

eventframe:RegisterEvent("CHAT_MSG_ADDON")
eventframe:RegisterEvent("CHAT_MSG_RAID_BOSS_WHISPER")
eventframe:RegisterEvent("PLAYER_ALIVE")
eventframe:RegisterEvent("ENCOUNTER_START")
eventframe:RegisterEvent("INSTANCE_ENCOUNTER_ENGAGE_UNIT")

----------------------------------------------------------
-----------------[[    队伍技能事件    ]]-----------------
----------------------------------------------------------
local LibOpenRaid = LibStub:GetLibrary("LibOpenRaid-1.0", true)

local callbacks = {
    CooldownListUpdate = function(...)
		T.FireEvent("JST_CooldownListUpdate", ...) 
	end,
    CooldownListWipe = function(...) 
		T.FireEvent("JST_CooldownListWipe", ...)
	end,
    CooldownUpdate = function(...)
		T.FireEvent("JST_CooldownUpdate", ...)
	end,
    CooldownAdded = function(...)
		T.FireEvent("JST_CooldownAdded", ...)
	end
}

LibOpenRaid.RegisterCallback(callbacks, "CooldownListUpdate", "CooldownListUpdate")
LibOpenRaid.RegisterCallback(callbacks, "CooldownListWipe", "CooldownListWipe")
LibOpenRaid.RegisterCallback(callbacks, "CooldownUpdate", "CooldownUpdate")
LibOpenRaid.RegisterCallback(callbacks, "CooldownAdded", "CooldownAdded")

G.GroupTrackedSpellsbySpellID = {}
G.GroupTrackedSpellsbyName = {}
G.GroupTrackedSpellsbyIndex = {
	-- 控制
	372048, -- Oppressing Roar
    368970, -- Tail Swipe
    358385, -- Landslide
    108199, -- Gorefiend's Grasp
    179057, -- Chaos Nova
    202138, -- Sigil of Chains
    207684, -- Sigil of Misery
    119381, -- Leg Sweep
    116844, -- Ring of Peace
    102793, -- Ursol's Vortex
    102359, -- Mass Entanglement
    192058, -- Capacitor Totem
    30283, -- Shadowfury
    109248, -- Binding Shot
    46968, -- Shockwave
	-- 免疫
	45438, -- Ice Block
    196555, -- Netherwalk
    186265, -- Turtle
    642, -- Divine Shield
    31224, -- Cloak of Shadows
	-- 减伤
	47585, -- Dispersion
	22812, -- 树皮术
}

for index, spellID in pairs(G.GroupTrackedSpellsbyIndex) do
	G.GroupTrackedSpellsbySpellID[spellID] = index
	
	local spell = C_Spell.GetSpellName(spellID)
	G.GroupTrackedSpellsbyName[spell] = spellID
end

local GSFrame = CreateFrame("Frame", nil, UIParent)

GSFrame.entries = {}

function GSFrame:GetEntry(GUID, spellID)
	for _, entry in ipairs(self.entries) do
        if entry.GUID == GUID and entry.spellID == spellID then
            return entry
        end
    end
end

function GSFrame:UpdateEntry(GUID, spellID, cooldownInfo)
    if not GUID or not cooldownInfo or not spellID or not G.GroupTrackedSpellsbySpellID[spellID] then return false end
    
    local entry = self:GetEntry(GUID, spellID)
    
    -- If no entry for this GUID/spellID combination exists, create it
    if not entry then
        local spellInfo = C_Spell.GetSpellInfo(spellID)
        
        table.insert(self.entries,
            {
                GUID = GUID,
                spellID = spellID,
                spellName = spellInfo.name,
                spellIcon = spellInfo.iconID,
            }
        )
        
        entry = self.entries[#self.entries]
    end
    
    -- Update expirationTime/duration for the entry
    local _, _, timeLeft, charges, _, _, _, duration = LibOpenRaid.GetCooldownStatusFromCooldownInfo(cooldownInfo)
    local expirationTime = charges >= 1 and 0 or GetTime() + timeLeft
	
    entry.charges = charges
    entry.duration = duration
    entry.expirationTime = expirationTime
end

function GSFrame:UpdateAllEntries()
    -- Wipe all info
    self.entries = table.wipe(self.entries)
    
    -- Update entries
    local allUnitsCooldown = LibOpenRaid.GetAllUnitsCooldown()
    
    if allUnitsCooldown then
        for unit, unitCooldowns in pairs(allUnitsCooldown) do
            local GUID = UnitGUID(unit)

			for spellID, cooldownInfo in pairs(unitCooldowns) do
				self:UpdateEntry(GUID, spellID, cooldownInfo)
			end
        end
    end
    
    -- Sort entries
    table.sort(self.entries,
        function(entryA, entryB)
            local spellA = entryA.spellID
            local spellB = entryB.spellID
            
            local indexA = G.GroupTrackedSpellsbySpellID[spellA]
            local indexB = G.GroupTrackedSpellsbySpellID[spellB]
            
            if indexA ~= indexB then
                return indexA < indexB
            end
            
			if entryA.GUID and entryB.GUID then
				return entryA.GUID < entryB.GUID
			end
        end
    )
    
    LibOpenRaid.RequestAllData()
end

function GSFrame:Notify()
    T.FireEvent("JST_GROUP_CD_UPDATE", self.entries)
end

GSFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "JST_CooldownListUpdate" then
        local unit, unitCooldowns = ...  
        local GUID = UnitGUID(unit)
        
        if unitCooldowns then
            for spellID, cooldownInfo in pairs(unitCooldowns) do
                self:UpdateEntry(GUID, spellID, cooldownInfo)
            end
        end 
        self:Notify()
		
    elseif event == "JST_CooldownListWipe" then
	
        self:UpdateAllEntries()
        self:Notify()
		
    elseif event == "JST_CooldownUpdate" or event == "JST_CooldownAdded" then
        local unit, spellID, cooldownInfo = ...
        local GUID = UnitGUID(unit)
        
        self:UpdateEntry(GUID, spellID, cooldownInfo)
        self:Notify()
		
    elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
        local _, subEvent, _, _, _, _, _, destGUID = ...
        
        if subEvent == "UNIT_DIED" and T.GUIDToUnit(destGUID) then
            self:UpdateAllEntries()
            self:Notify()
        end
		
    elseif event == "JST_UNIT_ALIVE" then
        self:UpdateAllEntries()
        self:Notify()
		
    elseif event == "ENCOUNTER_START" then
        self:UpdateAllEntries()
        self:Notify()
		
	elseif event == "PLAYER_ENTERING_WORLD" then
        self:UpdateAllEntries()
        self:Notify()
		
    end
end)

T.RegisterEventAndCallbacks(GSFrame, {
	["JST_CooldownListUpdate"] = true,
	["JST_CooldownListWipe"] = true,
	["JST_CooldownUpdate"] = true,
	["JST_CooldownAdded"] = true,
	["COMBAT_LOG_EVENT_UNFILTERED"] = true,	
	["JST_UNIT_ALIVE"] = true,
	["ENCOUNTER_START"] = true,
	["PLAYER_ENTERING_WORLD"] = true,
})

T.GroupSpellForceUpdate = function()
	GSFrame:UpdateAllEntries()
	GSFrame:Notify()
end

T.GetGroupCooldown = function(GUID, spellID)
	local entry = GSFrame:GetEntry(GUID, spellID)

	if entry then
		local exp_time = entry.expirationTime
		local duration = entry.duration
		local start = exp_time - duration
		local remain = exp_time - GetTime()
		local charges = entry.charges
		local ready = remain <= 0 and true or false
		
		return ready, exp_time, duration, remain, start, charges
	end
end

--引力失效
LIB_OPEN_RAID_COOLDOWNS_INFO[449700] = {
    cooldown = 40,
    duration = 3,
    specs = {62, 63, 64},
    talent = false,
    charges = 1,
    class = "MAGE",
    type = 8
}

----------------------------------------------------------
----------------[[    怪物进战斗事件    ]]----------------
----------------------------------------------------------

G.engage_watched_npcs = {}
local engagedGUIDs = {}
local activeNameplates = {}
local GetNamePlates = C_NamePlate.GetNamePlates

local activeNameplateUtilityFrame = CreateFrame("Frame")
activeNameplateUtilityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")
activeNameplateUtilityFrame:RegisterEvent("NAME_PLATE_UNIT_ADDED")

local inactiveNameplateUtilityFrame = CreateFrame("Frame")
inactiveNameplateUtilityFrame:RegisterEvent("NAME_PLATE_UNIT_REMOVED")

local nameplateWatcher = activeNameplateUtilityFrame:CreateAnimationGroup()
nameplateWatcher:SetLooping("REPEAT")
local nameplateanim = nameplateWatcher:CreateAnimation()
nameplateanim:SetDuration(0.5)

activeNameplateUtilityFrame:SetScript("OnEvent", function(self, event, unit)
	if event == "NAME_PLATE_UNIT_ADDED" then
		activeNameplates[unit] = true
	elseif event == "PLAYER_ENTERING_WORLD" then
		local _, instanceType = GetInstanceInfo()
		if instanceType ~= "none" then
			if not nameplateWatcher:IsPlaying() then	
				local nameplates = GetNamePlates()
				for i = 1, #nameplates do
					local nameplateFrame = nameplates[i]
					if nameplateFrame.namePlateUnitToken and UnitCanAttack("player", nameplateFrame.namePlateUnitToken) then
						activeNameplates[nameplateFrame.namePlateUnitToken] = true
					end
				end
				nameplateWatcher:Play()
			end
		else
			nameplateWatcher:Stop()
			G.engage_watched_npcs = table.wipe(G.engage_watched_npcs)
		end
	end
end)

inactiveNameplateUtilityFrame:SetScript("OnEvent", function(self, event, unit)
	activeNameplates[unit] = nil
end)

nameplateWatcher:SetScript("OnLoop", function()
	for unit in next, activeNameplates do
		local guid = UnitGUID(unit)
		local engaged = engagedGUIDs[guid]
		if not engaged and UnitAffectingCombat(unit) then
			engagedGUIDs[guid] = true
			local npcID = select(6, strsplit("-", guid))
			if npcID and G.engage_watched_npcs[npcID] then
				T.FireEvent("UNIT_ENTERING_COMBAT", unit, guid, npcID)
			end
		elseif engaged and not UnitAffectingCombat(unit) then
			engagedGUIDs[guid] = nil
		end
	end
end)

T.IsMobEngaged = function(guid)
	return engagedGUIDs[guid] and true or false
end

T.RegisterMobEngage = function(npcID)
	G.engage_watched_npcs[npcID] = true
end

----------------------------------------------------------
----------------[[    队伍进战斗事件    ]]----------------
----------------------------------------------------------

local groupUtilityFrame = CreateFrame("Frame")
groupUtilityFrame:RegisterEvent("PLAYER_REGEN_DISABLED")
groupUtilityFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
groupUtilityFrame:RegisterEvent("PLAYER_ENTERING_WORLD")

local groupWatcher = groupUtilityFrame:CreateAnimationGroup()
groupWatcher:SetLooping("REPEAT")
local groupanim = groupWatcher:CreateAnimation()
groupanim:SetDuration(0.5)
local group_in_combat

local GetGroupCombatStatus = function()
	local combat = false
	
	for unit in T.IterateGroupMembers() do
		if UnitAffectingCombat(unit) then
			combat = true
			break
		end
	end
	
	return combat
end

groupUtilityFrame:SetScript("OnEvent", function(self, event, unit)
	if event == "PLAYER_ENTERING_WORLD" then
		if InCombatLockdown() then
			groupWatcher:Stop()
			group_in_combat = true
		else
			groupWatcher:Play()
		end
	elseif event == "PLAYER_REGEN_ENABLED" then
		groupWatcher:Play()
	elseif event == "PLAYER_REGEN_DISABLED" then
		groupWatcher:Stop()
		group_in_combat = true
	end
end)

groupWatcher:SetScript("OnLoop", function()
	if GetGroupCombatStatus() then
		group_in_combat = true
	else
		if group_in_combat then
			T.FireEvent("GROUP_LEAVING_COMBAT")
		end
		group_in_combat = false
	end
end)

----------------------------------------------------------
---------------[[    重要单位光环事件    ]]---------------
----------------------------------------------------------
local auraUtilityFrame = CreateFrame("Frame")
auraUtilityFrame:RegisterEvent("UNIT_AURA")

local aura_cache = {}
local aura_event_spellIDs = {
	[404468] = true,
}

T.RegisterWatchAuraSpellID = function(spellID)
	aura_event_spellIDs[spellID] = true
end

T.UnregisterWatchAuraSpellID = function(spellID)
	aura_event_spellIDs[spellID] = nil
end

auraUtilityFrame:SetScript("OnEvent", function(self, event, ...)
	if event == "UNIT_AURA" then
		local unit, updateInfo = ...
		if unit and T.FilterAuraUnit(unit) then
			local GUID = UnitGUID(unit)				
			if not GUID then return end
			
			if not aura_cache[GUID] then
				aura_cache[GUID] = {}
			end
			
			if updateInfo == nil or updateInfo.isFullUpdate then
				for _, auraType in pairs({"HELPFUL", "HARMFUL"}) do
					AuraUtil.ForEachAura(unit, auraType, nil, function(aura_data)
						local spellID = aura_data.spellId
						if aura_event_spellIDs[spellID] then
							local auraID = aura_data.auraInstanceID
							if not aura_cache[GUID][auraID] then
								aura_cache[GUID][auraID] = spellID
								T.FireEvent("UNIT_AURA_ADD", unit, spellID, auraID)
							end
						end
					end, true)
				end
			else
				if updateInfo.addedAuras ~= nil then
					for _, aura_data in pairs(updateInfo.addedAuras) do
						local spellID = aura_data.spellId
						if aura_event_spellIDs[spellID] then
							local auraID = aura_data.auraInstanceID
							if not aura_cache[GUID][auraID] then
								aura_cache[GUID][auraID] = spellID
								T.FireEvent("UNIT_AURA_ADD", unit, spellID, auraID)
							end
						end
					end
				end
				if updateInfo.updatedAuraInstanceIDs ~= nil then
					for _, auraID in pairs(updateInfo.updatedAuraInstanceIDs) do
						local spellID = aura_cache[GUID][auraID]
						if spellID then
							T.FireEvent("UNIT_AURA_UPDATE", unit, spellID, auraID)
						end
					end
				end
				if updateInfo.removedAuraInstanceIDs ~= nil then
					for _, auraID in pairs(updateInfo.removedAuraInstanceIDs) do
						local spellID = aura_cache[GUID][auraID]
						if spellID then
							aura_cache[GUID][auraID] = nil
							T.FireEvent("UNIT_AURA_REMOVED", unit, spellID, auraID)
						end
					end
				end
			end
		end
	end
end)

