local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1302\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------
if G.Client == "zhCN" or G.Client == "zhTW" then
	L["标注能量最高的目标"] = "为能量最高的%s显示姓名板标记"
	L["收集装置"] = "收集装置"
	L["血量及击杀倒计时"] = "%s的血量及击杀倒计时"
	L["目标血量低于多少时开始对比"] = "目标血量低于多少时开始对比（百分比）"
	L["血量领先"] = "血量领先 %d%%"
elseif G.Client == "ruRU" then
	L["标注能量最高的目标"] = "Highest energy collector nameplate mark"
	L["收集装置"] = "collector"
	L["血量及击杀倒计时"] = "%s's hp bar and time limit indicator"
	L["目标血量低于多少时开始对比"] = "Compare when target health is below (percentage)"
	L["血量领先"] = "Gap: %d%%"
else
	--L["标注能量最高的目标"] = "Highest energy collector nameplate mark"
	--L["收集装置"] = "collector"
	--L["血量及击杀倒计时"] = "%s's hp bar and time limit indicator"
	--L["目标血量低于多少时开始对比"] = "Compare when target health is below (percentage)"
	--L["血量领先"] = "Gap: %d%%"
end
---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters[2687] = {
	engage_id = 3132,
	npc_id = {"233817"},
	alerts = {
		{ -- 唤动收集者
			spells = {
				{1231720, "5"},--【唤动收集者】
			},
			options = {
				{ -- 文字 召唤奥术收集者 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1231720)..L["倒计时"],
					data = {
						spellID = 1231720,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							[15] = {
								[1] = {9, 44, 44},
								[1.1] = {23.8},
								[1.2] = {23.8},
							},
							[16] = {
								[1] = {9, 44, 44},
								[1.1] = {23.8, 22.0, 44.0},
								[1.2] = {23.8, 22.0, 44.0},
							},
						},
						cd_args = {
							round = true,
						},
					},					
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", {1231720, 1254321}, T.GetIconLink(1231720), self, event, ...)
					end,
				},
				{ -- 计时条 召唤奥术收集者（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1231720,
					spellIDs = {1254321},
					sound = soundfile("1231720cast", "cast"),
				},
				{ -- 首领模块 奥术收集装置 标注能量最高的目标（✓）
					category = "BossMod",
					spellID = 1231720,
					ficon = "3",
					enable_tag = "none",
					name = string.format(L["标注能量最高的目标"], T.GetFomattedNameFromNpcID("240905")),	
					points = {hide = true},
					events = {
						["UNIT_POWER_UPDATE"] = true,
					},
					init = function(frame)
						frame.mob_npcID = "240905"
						frame.old_target = 0
						
						function frame:GetHighestPowerUnit()
							local highestPower = 0
							local highestUnit
							local highestGUID
							
							for unit in T.IterateBoss() do
								local GUID = UnitGUID(unit)
								local npcID = select(6, strsplit("-", GUID))
								local power = UnitPower(unit)
								
								if npcID == self.mob_npcID and power > highestPower then -- 奥术收集装置
									highestPower = power
									highestUnit = unit
									highestGUID = GUID
								end
							end
							
							return highestGUID, highestUnit
						end					
					end,
					update = function(frame, event, ...)
						if event == "UNIT_POWER_UPDATE" then
							local unit = ...
							if string.find(unit, "boss") then
								local highestGUID, highestUnit = frame:GetHighestPowerUnit()
								if highestGUID then
									if frame.old_target ~= highestGUID then
										T.ShowNameplateExtraTex(highestUnit, "check", highestGUID)
										frame.old_target = highestGUID
									end
								else
									if frame.old_target ~= 0 then
										T.HideAllNameplateExtraTex()
										frame.old_target = 0
									end
								end
							end
						elseif event == "ENCOUNTER_START" then
							frame.old_target = 0
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
				{ -- 首领模块 标记 奥术收集装置（✓）
					category = "BossMod",
					spellID = 1254321,
					enable_tag = "rl",
					name = string.format(L["NAME小怪标记"], T.GetFomattedNameFromNpcID("240905"), T.FormatRaidMark("5,6,7")),
					points = {hide = true},
					events = {
						["INSTANCE_ENCOUNTER_ENGAGE_UNIT"] = true,
					},
					init = function(frame)
						frame.start_mark = 5
						frame.end_mark = 7
						frame.mob_npcID = "240905"
						frame.ignore_combat = true
						
						T.InitRaidTarget(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateRaidTarget(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetRaidTarget(frame)
					end,
				},
				{ -- 首领模块 BOSS能量 奥术收集装置（✓）
					category = "BossMod",
					spellID = 1248171,
					enable_tag = "rl",
					name = string.format(L["NAME小怪能量"], T.GetFomattedNameFromNpcID("240905")),
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -300},
					events = {
						["INSTANCE_ENCOUNTER_ENGAGE_UNIT"] = true,
						["UNIT_POWER_UPDATE"] = true,
						["RAID_TARGET_UPDATE"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.npcIDs = {
							["240905"] = { -- 奥术收集装置
								n = L["收集装置"],
								color = {1, 1, .2},
							},
						}
						
						T.InitMobPower(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateMobPower(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobPower(frame)
					end,
				},
			},
		},
		{ -- 星界收割
			npcs = {
				{33707},--【奥术收集装置】
			},
			spells = {
				{1228214, "5"},--【星界收割】
			},
			options = {				
				{ -- 文字 星界收割 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1228213)..L["倒计时"],
					data = {
						spellID = 1228213,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							[15] = {
								[1] = {20.0, 46.0, 8.0, 36.0, 8.0, 8.0},
								[1.1] = {34.7, 8.0, 8.0},
								[1.2] = {34.7, 8.0, 8.0},
							},
							[16] = {
								[1] = {24.0, 46.0, 15.0, 29.5, 15.6, 15.0},
								[1.1] = {38.9, 21.5, 15.5, 29.0, 15.0, 14.5},
								[1.2] = {38.9, 21.5, 15.5, 29.0, 15.0, 14.5},
							},
						},
						cd_args = {
							round = true,
						},
					},					
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1228213, T.GetIconLink(1228213), self, event, ...)
					end,
				},
				{ -- 文字 星界收割出小怪 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["召唤小怪"]..L["倒计时"],
					data = {
						spellID = 1228214,
						events =  {
							["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						},
					},					
					update = function(self, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, _, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_CAST_START" and (spellID == 1228213 or spellID == 1243901) then
								T.Start_Text_Timer(self, 7, L["召唤小怪"], true)
							end
						elseif event == "ENCOUNTER_START" then
							self.round = true
							self.count_down_start = 4
							self.prepare_sound = "add"
						end
					end,
				},
				{ -- 计时条 星界收割（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 1228213,
					text = L["小怪"],
					dur = 7,
					tags = {3},
					sound = soundfile("1228213cast"),
				},
				{ -- 首领模块 星界收割 计时圆圈（✓）
					category = "BossMod",
					spellID = 1228214,
					enable_tag = "none",
					name = T.GetIconLink(1228214)..T.GetIconLink(1243901)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1233979] = { -- 星界收割(点名)
								unit = "player",
								aura_type = "HARMFUL",
								color = {1, .3, 0},
							},
							[1228214] = { -- 星界收割(DOT+出小怪)
								unit = "player",
								aura_type = "HARMFUL",
								color = {.07, 1, 1},
							},
							[1243873] = { -- 虚空收割(点名)
								unit = "player",
								aura_type = "HARMFUL",
								color = {1, .3, 0},
							},
							[1243901] = { -- 虚空收割(DOT+出小怪)
								unit = "player",
								aura_type = "HARMFUL",
								color = {.07, 1, 1},
							},
						}
						T.InitUnitAuraCircleTimers(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateUnitAuraCircleTimers(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetUnitAuraCircleTimers(frame)
					end,
				},
				{ -- 团队框架高亮 星界收割[RRR]（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1233979,
					spellIDs = {1243873},
					color = {1, .3, 0},
				},
				{ -- 团队框架高亮 星界收割[RRR]（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1228214,
					color = {.07, 1, 1},
					spellIDs = {1243901},
				},
			},
		},
		{ -- 虚空裂缝
			spells = {
				{1248171, "12"},--【虚空裂缝】
			},
			options = {
				
			},
		},
		{ -- 奥术具象
			npcs = {
				{33122, "12"},--【奥术具象】
			},
			spells = {
				{1242952},--【黑暗恩赐】
				{1236207},--【星界涌动】
			},
			options = {	
				{ -- 姓名板光环 黑暗恩赐（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1242952,
				},
				{ -- 文字 黑暗恩赐 免疫提醒（史诗待测试）
					category = "TextAlert",
					type = "spell",
					color = {1, 1, 0},
					preview = T.GetIconLink(1242952)..L["免疫"],
					data = {
						spellID = 1242952,
						events =  {
							["PLAYER_TARGET_CHANGED"] = true,
							["UNIT_AURA_ADD"] = true,
							["UNIT_AURA_REMOVED"] = true,
						},					
					},
					update = function(self, event, ...)
						if event == "ENCOUNTER_START" then
							self.text:SetText(L["免疫"])
						elseif event == "PLAYER_TARGET_CHANGED" then
							if UnitExists("target") and AuraUtil.FindAuraBySpellID(1242952, "target", "HELPFUL") then
								self:Show()	
							else
								self:Hide()
							end
						elseif event == "UNIT_AURA_ADD" then
							local unit, spellID = ...
							if spellID == 1242952 and UnitIsUnit(unit, "target") then
								self:Show()
							end
						elseif event == "UNIT_AURA_REMOVED" then
							local unit, spellID = ...
							if spellID == 1242952 and UnitIsUnit(unit, "target") then
								self:Hide()
							end
						end
					end,
				},
				
			},
		},		
		{ -- 首要序列
			spells = {
				{1237322},--【首要序列】
			},
			options = {
				{ -- 计时条 首要序列（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1231567,
					text = L["躲球"],
					sound = "[dodge_ball]cast",
				},
			},
		},
		{ -- 奥术虹吸
			spells = {
				{1228103},--【奥术虹吸】
			},
			options = {
				
			},
		},
		{ -- 奥术屏障
			spells = {
				{1231726},--【奥术屏障】
			},
			options = {
				
			},
		},
		{ -- 奥术抹消
			spells = {
				{1228218, "4"},--【奥术抹消】
			},
			options = {
				{ -- 文字 奥术抹消 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["分担"].."+"..L["大怪"]..L["倒计时"],
					data = {
						spellID = 1228216,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {31, 45},
								[1.1] = {46},
								[1.2] = {46},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1228216, L["分担"].."+"..L["大怪"], self, event, ...)
					end,
				},
				{ -- 计时条 奥术抹消（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228216,
					text = L["分担伤害"],
					show_tar = true,
				},				
				{ -- 首领模块 奥术抹消 MRT轮次分配（✓）
					category = "BossMod",
					spellID = 1228216,
					ficon = "3,12",
					enable_tag = "spell",
					name = string.format(L["NAME技能轮次安排"], T.GetIconLink(1228216)),
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -230},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					custom = {
						{
							key = "hp_perc_sl",
							text = L["血量阈值百分比"],
							default = 65,
							min = 20,
							max = 100,
						},
					},
					init = function(frame)
						frame.sub_event = "SPELL_CAST_START"
						frame.cast_id = 1228216
						
						frame.loop = true
						frame.assign_count = 2
						frame.alert_dur = 6
						frame.raid_glow = "pixel"
						
						function frame:override_action(count, display_count)
							T.PlaySound("sharedmg")
							T.Start_Text_Timer(self.text_frame, 6, string.format("|cff00ff00%s|r", L["分担"]), true)
						
							T.AddPersonalSpellCheckTag("bossmod"..self.config_id, C.DB["BossMod"][self.config_id]["hp_perc_sl"], {"TANK"})
							C_Timer.After(self.alert_dur, function()
								T.RemovePersonalSpellCheckTag("bossmod"..self.config_id)
							end)
						end
						
						function frame:override_action_inactive(count, display_count)
							if UnitGroupRolesAssigned(unit) ~= "TANK" then
								T.PlaySound("dontsharedmg")
								T.Start_Text_Timer(self.text_frame, 6, string.format("|cffff0000%s|r", L["不分担"]), true)
							end
						end
						
						function frame:AutoSplit()
							if not next(self.assignment) then
								self.assignment = table.wipe(self.assignment)
								self.assignment[1] = {}
								self.assignment[2] = {}
								
								local GUIDs = {}
								
								for unit in T.IterateGroupMembers() do
									local visible = UnitIsVisible(unit)
									local online = UnitIsConnected(unit)

									if visible and online and UnitGroupRolesAssigned(unit) ~= "TANK" then
										local GUID = UnitGUID(unit)
										table.insert(GUIDs, GUID)
									end
								end
								
								T.SortTable(GUIDs, true)
								
								for i, GUID in ipairs(GUIDs) do
									if i <= #GUIDs / 2 then
										table.insert(self.assignment[1], GUID)
									else
										table.insert(self.assignment[2], GUID)
									end
								end
							end
						end
						
						T.InitSpellBars(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateSpellBars(frame, event, ...)
						
						if event == "ENCOUNTER_START" then
							 frame:AutoSplit()
						end
					end,
					reset = function(frame, event)
						T.ResetSpellBars(frame)
					end,
				},
				{ -- 图标 奥术抹消（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1232775,
					effect = 1,
					hl = "",
					tip = L["吸收治疗"],
				},
				{ -- 首领模块 奥术抹消 团队框架吸收治疗数值（✓）
					category = "BossMod",
					spellID = 1232775,
					ficon = "2",
					enable_tag = "role",
					name = L["团队框架吸收治疗数值"],
					points = {hide = true},
					events = {
						["UNIT_HEAL_ABSORB_AMOUNT_CHANGED"] = true,
					},
					init = function(frame)
						T.InitRFHealAbsorbValues(frame)			
					end,
					update = function(frame, event, ...)
						T.UpdateRFHealAbsorbValues(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetRFHealAbsorbValues(frame)
					end,
				},
			},
		},
		{ -- 奥能回响
			npcs = {
				{32392},--【奥能回响】
			},
			spells = {
				{1228454, "4"},--【能量印记】
				{1238867},--【回音祈咒】
				{1238874, "7"},--【回音风暴】
			},
			options = {
				{ -- 姓名板光环 能量印记（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1228454,
				},
				{ -- 首领模块 能量印记 移动BOSS（✓）
					category = "BossMod",
					spellID = 1228454,
					ficon = "0",
					enable_tag = "role",
					name = L["移动BOSS"]..T.GetIconLink(1228454),
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 1)
						frame.text_frame.text:SetText(string.format("|cffff0000%s|r", L["移动BOSS"]))
						
						function frame:IsTanking()
							local isTanking = UnitDetailedThreatSituation("player", "boss1")
							return isTanking
						end
						
						function frame:check_boss()	
							for unit in T.IterateBoss() do
								if AuraUtil.FindAuraBySpellID(1228454, unit, "HELPFUL") then -- 能量印记
									return true
								end
							end
						end
						
						function frame:check()
							if self:IsTanking() and self:check_boss() then
								if not self.text_frame:IsShown() then								
									self.text_frame:Show()
									T.PlaySound("moveboss")
								end
							else
								self.text_frame:Hide()
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "UNIT_AURA_ADD" or event == "UNIT_AURA_REMOVED" then
							local unit, spellID = ...
							if spellID == 1228454 then
								frame:check()
							end
						elseif event == "UNIT_THREAT_SITUATION_UPDATE" then
							local unit = ...
							if unit == "player" then
								frame:check()
							end
						elseif event == "ENCOUNTER_START" then
							T.RegisterWatchAuraSpellID(1228454)
						end
					end,
					reset = function(frame, event)
						T.UnregisterWatchAuraSpellID(1228454)
					end,
				},
			},
		},
		{ -- 星界印记
			spells = {
				{1228219},--【星界印记】
			},
			options = {
				{ -- 嘲讽提示 奥术抹消（待测试）
					category = "BossMod",
					spellID = 1228219,
					ficon = "0",
					enable_tag = "role",					
					name = L["嘲讽提示"]..T.GetIconLink(1228219),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1228219] = 1, -- 星界印记
						}
						frame.cast_spellIDs = {
							[1228216] = true, -- 奥术抹消
						}
						
						function frame:override_check_boss()
							local pass
							local phase = T.GetCurrentPhase()
							
							for unit in T.IterateBoss() do
								spellID = select(9, UnitCastingInfo(unit))
								if spellID and self.cast_spellIDs[spellID] then
									pass = true
									return
								end
							end

							if not pass and phase == 1 then
								return true
							end
						end
						
						T.InitTauntAlert(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateTauntAlert(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetTauntAlert(frame)
					end,
				},
				{ -- 换坦计时条 星界印记（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1228219,
					ficon = "0",
					tank = true,
				},
				{ -- 图标 星界印记（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1228219,
					text = L["不分担"],
				},
			},
		},
		{ -- 沉默风暴
			spells = {
				{1228188, "7"},--【沉默风暴】
			},
			options = {
				{ -- 文字 沉默风暴 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["跑圈"]..L["倒计时"],
					data = {
						spellID = 1228161,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {63.0, 44.0, 23.0},
								[1.1] = {68},
								[1.2] = {68},
								[2] = {12.2, 21.0},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1228161, L["跑圈"], self, event, ...)
					end,
				},
				{ -- 计时条 沉默风暴（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228161,
					text = L["跑圈"],
				},
				{ -- 图标 沉默风暴（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1228188,
					spellIDs = {1238874},
					hl = "org",
				},
				{ -- 文字 沉默风暴（✓）
					category = "TextAlert",
					type = "spell",
					color = {0, 1, 1},
					preview = L["保持移动"],
					data = {
						spellID = 1228188,
						spellIDs = {1228188, 1238874},
						events =  {
							["UNIT_AURA_ADD"] = true,
							["UNIT_AURA_REMOVED"] = true,
						},
					},
					update = function(self, event, ...)
						if event == "UNIT_AURA_ADD" then
							local unit, spellID = ...
							if unit == "player" and (spellID == 1228188 or spellID == 1238874) then
								T.Start_Text_Timer(self, 6, L["保持移动"], true)
								T.PlaySound("keepmoving")
							end
						elseif event == "UNIT_AURA_REMOVED" then
							local unit, spellID = ...
							if unit == "player" and (spellID == 1228188 or spellID == 1238874) then
								self:Hide()
							end
						elseif event == "ENCOUNTER_START" then
							
						end
					end,
				},
				{ -- 团队框架高亮 沉默风暴（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1228188,
					spellIDs = {1238874},
				},				
				{ -- 首领模块 沉默风暴 多人光环（✓）
					category = "BossMod",
					spellID = 1228161,
					enable_tag = "rl",
					name = string.format(L["NAME多人光环提示"], T.GetIconLink(1228188)),	
					points = {a1 = "TOPLEFT", a2 = "CENTER", x = -700, y = 250},
					events = {
						["UNIT_AURA"] = true,	
					},
					init = function(frame)
						frame.role = true
						
						frame.spellIDs = {
							[1228188] = {},-- 沉默风暴
							[1238874] = {},-- 回音风暴
						}
						T.InitUnitAuraBars(frame)			
					end,
					update = function(frame, event, ...)
						T.UpdateUnitAuraBars(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetUnitAuraBars(frame)
					end,
				},
				{ -- 图标 沉默风暴（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1228168,
					spellIDs = {1238878},
					text = L["平静"],
				},
			},
		},
		{ -- 非凡力量
			spells = {
				{1228502, "0"},--【非凡力量】
			},
			options = {
				{ -- 文字 非凡力量 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = T.GetIconLink(1228502)..L["倒计时"],
					data = {
						spellID = 1228502,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {4.0, 22.0, 22.0, 22.0, 22.0, 22.0},
								[1.1] = {19.2, 22.0, 22.0, 22.0, 22.0, 22.0},
								[1.2] = {19.2, 22.0, 22.0, 22.0, 22.0, 22.0},
								[2] = {4.2, 22.0},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1228502, T.GetIconLink(1228502), self, event, ...)
					end,
				},
				{ -- 计时条 非凡力量（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228502,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1228502cast", "cast"),
				},
				{ -- 嘲讽提示 非凡力量（待测试）
					category = "BossMod",
					spellID = 1228506,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1228506),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1228506] = 2, -- 非凡力量
						}
						frame.cast_spellIDs = {
							[1228502] = true, -- 非凡力量
						}
						
						function frame:override_check_boss()
							if T.GetCurrentPhase() == 2 then
								return true
							end
						end
						
						T.InitTauntAlert(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateTauntAlert(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetTauntAlert(frame)
					end,
				},
				{ -- 换坦计时条 非凡力量（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1228506,
					ficon = "0",
					tank = true,
				},
			},
		},
		{ -- 奥术驱除
			spells = {
				{1227631},--【奥术驱除】
			},
			options = {
				{ -- 文字 奥术驱除 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["击退"]..L["倒计时"],
					data = {
						spellID = 1227631,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {155},
								[1.1] = {79},
								[1.2] = {79},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1227631, L["击退"], self, event, ...)
					end,
				},
				{ -- 计时条 奥术驱除（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227631,
					text = L["击退"],
					sound = "[knockback]cast",
				},
			},
		},
		{ -- 黑暗终界
			spells = {
				{1248009},--【黑暗终界】
			},
			options = {
				{ -- 血量（✓）
					category = "TextAlert", 
					type = "hp",
					data = {
						npc_id = "233817",
						ranges = {
							{ ul = 20, ll = 15.1, tip = L["阶段转换"]..string.format(L["血量2"], 15)},
						},
					},
				},
				{ -- 计时条 黑暗终界（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1248009,
				},
			},
		},
		{ -- 星界灼烧
			spells = {
				{1240705},--【星界灼烧】
			},
			options = {
				{ -- 图标 星界灼烧（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1240705,
					tip = L["DOT"],
				},
			},
		},
		{ -- 不稳定激涌
			spells = {
				{1232409},--【不稳定激涌】
			},
			options = {
				
			},
		},
		{ -- 奥术收集装置
			npcs = {
				{33707},--【奥术收集装置】
			},
			spells = {
				{1234328},--【光子轰击】
				{1226260},--【奥术汇流】
				{1243272},--【抑制裂口】
			},
			options = {
				{ -- 计时条 光子轰击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1234328,
					text = L["射线"],
					sound = "[ray]cast",
				},
				{ -- 图标 光子轰击（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1234324,
					tip = L["DOT"],
				},
				{ -- 团队框架高亮 光子轰击（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1234324,
				},
			},
		},
		{ -- 庇护的侍从
			npcs = {
				{32596, "0"},--【庇护的侍从】
			},
			spells = {
				{1232738, "1"},--【硬化之壳】
				{1238266},--【能量渐增】
			},
			options = {
				{ -- 姓名板光环 硬化之壳（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1232738,
				},
			},
		},
		{ -- 法力裂片
			spells = {
				{1233415, "1"},--【法力裂片】
			},
			options = {
				{ -- 计时条 法力牺牲（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1230529,
				},
				{ -- 计时条 法力牺牲（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HELPFUL",
					unit = "boss",
					spellID = 1230529,
				},
				{ -- 计时条 法力裂片（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HELPFUL",
					unit = "boss",
					spellID = 1233415,
					text = L["易伤"].."100%",
				},
			},
		},
		{ -- 聚焦之虹
			spells = {
				{1232412},--【聚焦之虹】
			},
			options = {
				{ -- 图标 聚焦之虹（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1232412,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},	
		{ -- 黑暗奇点
			spells = {
				{1233076, "5"},--【黑暗奇点】
			},
			options = {
				{ -- 图标 黑暗奇点（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233076,
					tip = L["DOT"],
				},
			},
		},
		{ -- 沉重黑暗
			spells = {		
				{1233074, "4"},--【沉重黑暗】
			},
			options = {
				{ -- 图标 沉重黑暗（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233074,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 虚空收割
			spells = {						
				{1243901, "12"},--【虚空收割】
			},
			options = {
				{ -- 文字 虚空收割 倒计时（待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1243901)..L["倒计时"],
					data = {
						spellID = 1243901,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							[15] = {
								[2] = {13.5, 8, 36, 8, 36, 8, 36},
							},
							[16] = {
								[2] = {25, 8, 8, 25, 8, 8, 25, 8, 8},
							},
						},
						cd_args = {
							round = true,
						},
					},					
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1243901, T.GetIconLink(1243901), self, event, ...)
					end,
				},
				{ -- 计时条 虚空收割（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 1243901,
					text = L["小怪"],
					dur = 7,
					tags = {3},
					sound = soundfile("1243901cast"),
				},
			},
		},
		{ -- 虚空具象
			spells = {
				{1243641},--【虚空涌动】
			},
			options = {
				{ -- 图标 虚空涌动（待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1243641,
					tip = L["DOT"],
				},
			},
		},
		{ -- 死亡挣扎
			spells = {
				{1232221, "12"},--【死亡挣扎】
			},
			options = {
				{ -- 计时条 死亡挣扎（待测试）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232221,
					text = L["击退"],
					sound = "[knockback]cast",
				},
			},
		},
		{ -- 阶段转换
			title = L["阶段转换"],
			options = {
				{
					category = "PhaseChangeData",
					phase = 1.1,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1230529, -- 法力牺牲
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 1.2,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1230529, -- 法力牺牲
					count = 2,
				},
				{
					category = "PhaseChangeData",
					phase = 2,		
					type = "CLEU",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1233076, -- 黑暗奇点
					count = 1,
				},
			},
		},
	},
}