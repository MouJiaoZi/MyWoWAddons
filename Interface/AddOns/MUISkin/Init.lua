---@diagnostic disable-next-line: deprecated, undefined-global
local ElvUI, _, V, P, G = unpack(ElvUI)
local E = ElvUI
local L = E.Libs.ACL:GetLocale("ElvUI", ElvUI.global.general.locale)
local AceAddon = ElvUI.Libs.AceAddon
---@diagnostic disable-next-line: undefined-global
local GetAddOnMetadata = C_AddOns.GetAddOnMetadata
local addon, Engine = ...

-- local LSM = LibStub("LibSharedMedia-3.0")

-- if LSM == nil then return end

-- LSM:Register("statusbar","MUI_MER_Stripes", [[Interface\AddOns\MUISkin\MER_Stripes.tga]])


local thisAddon = AceAddon:NewAddon(addon, "AceConsole-3.0", "AceEvent-3.0", "AceHook-3.0", "AceTimer-3.0")
--Setting up table to unpack.
V.mui = {}
P.mui = {}
G.mui = {}

local F = {}
local I = {}

Engine[1] = thisAddon
Engine[2] = F
Engine[3] = ElvUI
Engine[4] = I
Engine[5] = V.mui
Engine[6] = P.mui
Engine[7] = G.mui
Engine[8] = L
_G[addon] = Engine

thisAddon.Modules = {}
thisAddon.Modules.Style = thisAddon:NewModule("MER_Style", "AceHook-3.0")

function thisAddon:Initialize()
    local function onAllEvents()
        F.Event.ContinueAfterElvUIUpdate(function()
            -- Set initialized
            self.initialized = true
            F.Event.TriggerEvent("MER.Initialized")

            F.Event.RunNextFrame(function()
                self.DelayedWorldEntered = true

                -- F.Developer.PrintDelayedMessages()
            end, 5)

            F.Event.ContinueOutOfCombat(function()
                self.initializedSafe = true
                F.Event.TriggerEvent("MER.InitializedSafe")
            end)
        end)
    end

    local events = { "PLAYER_ENTERING_WORLD" }
    table.insert(events, "FIRST_FRAME_RENDERED")

    F.Event.ContinueAfterAllEvents(onAllEvents, F.Table.SafeUnpack(events))
end

local EP = E.Libs.EP
EP:HookInitialize(thisAddon, thisAddon.Initialize)


function F.Enum(tbl)
    local length = #tbl
    for i = 1, length do
        local v = tbl[i]
        tbl[v] = i
    end

    return tbl
end
