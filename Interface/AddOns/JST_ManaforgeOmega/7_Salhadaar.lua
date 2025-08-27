 local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1302\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------
if G.Client == "zhCN" or G.Client == "zhTW" then

elseif G.Client == "ruRU" then

else

end
---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters[2690] = {
	engage_id = 3134,
	npc_id = {"237763"},
	alerts = {
		{ -- 敕令：誓言约束
			spells = {
				{1224731, "5"},--【敕令:誓言约束】
				{1224767},--【侍王之奴】
				{1224764},--【破誓者】
				{1224906},--【唤动誓言】
			},
			options = {
				{ -- 计时条 敕令:誓言约束（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1224731,
				},
				{ -- 图标 誓言约束（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1224737,
					hl = "yel",
				},
				{ -- 首领模块 誓言约束 多人光环（✓）
					category = "BossMod",
					spellID = 1224737,
					enable_tag = "rl",
					name = string.format(L["NAME多人光环提示"], T.GetIconLink(1224737)),	
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -500},
					events = {
						["UNIT_AURA"] = true,	
					},
					init = function(frame)
						frame.bar_num = 20
						
						frame.spellIDs = {
							[1224737] = { -- 誓言约束
								progress_stack = 3,
							},
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
			},
		},
		{ -- 复仇誓言
			spells = {
				{1238975, "12"},--【复仇誓言】
			},
			options = {
				
			},
		},
		{ -- 镇压统治
			spells = {
				{1224787, "5"},--【征服】
				{1224812},--【主宰】	
			},
			options = {
				{ -- 文字 镇压统治 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1224776)..L["连招"]..L["倒计时"],
					data = {
						spellID = 1224776,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {
							["all"] = {
								[1] = {13.5, 40, 40},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 1224776, L["连招"], self, event, ...)
					end,
				},
				{ -- 计时条 征服（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1224787,
					text = L["分担伤害"],
					show_tar = true,
					sound = soundfile("1224787cast", "cast"),
				},
				{ -- 换坦计时条 征服（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1224795,
					ficon = "0",
					tank = true,
				},
				{ -- 计时条 主宰（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1224812,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1224812cast", "cast"),
				},
				{ -- 换坦计时条 主宰（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1224816,
					ficon = "0",
					tank = true,
				},
				{ -- 首领模块 分段计时条 镇压统治（待测试）
					category = "BossMod",
					spellID = 1224795,
					name = string.format(L["计时条%s"], T.GetIconLink(1238975)..T.GetIconLink(1224812)),
					enable_tag = "none",
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 400, width = 415, height = 25},
					events = {
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_SUCCEEDED"] = true,
					},
					init = function(frame)
						frame.bars = {}
						frame.order = {}
						frame.count = 0
						
						for i = 1, 4 do
							local bar = T.CreateTimerBar(frame, nil, false, false, false, 100, 25)
							bar.index = i
							if i == 1 then
								bar:SetPoint("LEFT", frame, "LEFT", 0, 0)
							else
								bar:SetPoint("LEFT", frame.bars[i-1], "RIGHT", 5, 0)
							end
							table.insert(frame.bars, bar)
						end
						
						function frame:update_bar(index, spell, assigned)
							local bar = frame.bars[index]
							bar.castType = spell
							bar.assigned = assigned
							
							bar:SetMinMaxValues(0, 1)
							if spell == "UNKNOWN" then
								bar:SetValue(0)
							elseif self.count > index then
								bar:SetValue(1)
							else
								bar:SetValue(0)
							end
							
							if spell == "CONQUER" then
								bar.left:SetText(L["分担"])
								bar:SetStatusBarColor(1, 1, 0)								
							elseif spell == "VANQUISH" then
								bar.left:SetText(L["冲击波"])
								bar:SetStatusBarColor(.6, 0, 1)
							else
								bar.left:SetText("?")
								bar:SetStatusBarColor(.3, .3, .3)
							end
						end
						
						function frame:SetConquer(index)
							local isTank = UnitGroupRolesAssigned("player") == "TANK"
							local isTanking = UnitDetailedThreatSituation("player", "boss1")
							local assigned = false
							
							if isTank and isTanking then
								local othersAssigned
								if self.order[1] == "CONQUER" and index == 1 then
									othersAssigned = true
								elseif self.order[1] == "VANQUISH" and index == 3 then
									othersAssigned = true
								end
								
								assigned = not othersAssigned
							else -- Non-active tank
								if self.order[1] == "CONQUER" and index == 1 then
									assigned = true
								elseif self.order[1] == "VANQUISH" and index == 3 then
									assigned = true
								end
							end
							
							self:update_bar(index, "CONQUER", assigned)
						end
						
						function frame:SetVanquish(index)
							self:update_bar(index, "VANQUISH")
						end
						
						function frame:SetUnknown(index)
							self:update_bar(index, "UNKNOWN")
						end
						
						function frame:Start(index)
							local bar = frame.bars[index]
							local castType = bar.castType
							local duration = castType == "CONQUER" and 4 or 2.5
							
							bar:SetMinMaxValues(0, duration)
							
							bar.exp_time = GetTime() + duration
							bar:SetScript("OnUpdate", function(s, e)
								s.t = s.t + e
								if s.t > s.update_rate then		
									local remain = s.exp_time - GetTime()
									if remain > 0 then
										s.right:SetText(T.FormatTime(remain))
										s:SetValue(duration - remain)
									else
										s:SetScript("OnUpdate", nil)
										s.right:SetText("")
										s:SetValue(duration)
									end
									s.t = 0
								end
							end)
						end
						
						function frame:UpdateOrder()
							local order = self.order
							
							if order[1] == "CONQUER" then -- 征服
								order[3] = "VANQUISH"
								
								if order[2] == "CONQUER" then -- 征服 > 征服
									order[3] = "VANQUISH"
									order[4] = "VANQUISH"
								elseif order[2] == "VANQUISH" then -- 征服 > 主宰
									order[3] = "VANQUISH"
									order[4] = "CONQUER"
								end
							elseif order[1] == "VANQUISH" then -- 主宰
								order[3] = "CONQUER"
								
								if order[2] == "CONQUER" then -- 主宰 > 征服
									order[3] = "CONQUER"
									order[4] = "VANQUISH"
								elseif order[2] == "VANQUISH" then -- 主宰 > 主宰
									order[3] = "CONQUER"
									order[4] = "CONQUER"
								end
							end
						end
						
						function frame:UpdateStates()
							for index = 1, 4 do
								local castType = self.order[index]
								
								if castType == "CONQUER" then
									self:SetConquer(index)
								elseif castType == "VANQUISH" then
									self:SetVanquish(index)
								else
									self:SetUnknown(index)
								end
							end
						end
						
						function frame:PreviewShow()
							local orders = {
								{"VANQUISH", "VANQUISH", "CONQUER", "CONQUER"},
								{"CONQUER", "CONQUER", "VANQUISH", "VANQUISH"},
								{"VANQUISH", "CONQUER", "CONQUER", "VANQUISH"},
								{"CONQUER", "VANQUISH", "VANQUISH", "CONQUER"},
							}
							
							self.order = orders[math.random(4)]
							self.assignments = {false, true}
							self.count = 2 + math.random(2)
							self:UpdateStates()
							self:Start(self.count)
						end
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_START" then
							local unit, _, spellID = ...
							if string.find(unit, "boss") and (spellID == 1224787 or spellID == 1224812) then
								frame.count = frame.count + 1
								frame.order[frame.count] = spellID == 1224787 and "CONQUER" or "VANQUISH"
								
								frame:UpdateOrder()
								frame:UpdateStates()
								frame:Start(frame.count)
							end

						elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, _, spellID = ...
							if string.find(unit, "boss") and (spellID == 1224787 or spellID == 1224812) then
								-- Hide states after the 4th cast completes
								if frame.count == 4 then
									frame.order = table.wipe(frame.order)
									frame.count = 0
									for _, bar in pairs(frame.bars) do
										T.StopTimerBar(bar, true, true)
									end
								end
							end
							
						elseif event == "ENCOUNTER_START" then
							frame.order = table.wipe(frame.order)
							frame.count = 0
						end
					end,
					reset = function(frame, event)
						for _, bar in pairs(frame.bars) do
							T.StopTimerBar(bar, true, true)
						end
					end,
				},
				{ -- 首领模块 征服 MRT轮次分配（待测试）
					category = "BossMod", 
					spellID = 1224787,
					ficon = "3,12",
					enable_tag = "spell",
					name = string.format(L["NAME技能轮次安排"], T.GetIconLink(1224787)),
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -270},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.sub_event = "SPELL_CAST_START"
						frame.cast_id = 1224787
						
						frame.loop = true
						frame.assign_count = 2
						frame.alert_dur = 6
						frame.raid_glow = "pixel"
						
						function frame:override_action(count, display_count)
							T.PlaySound("sharedmg")
							T.Start_Text_Timer(self.text_frame, 6, string.format("|cff00ff00%s|r", L["分担"]), true)
						end
						
						function frame:override_action_inactive(count, display_count)
							if UnitGroupRolesAssigned(unit) ~= "TANK" then
								T.PlaySound("dontsharedmg")
								T.Start_Text_Timer(self.text_frame, 6, string.format("|cffff0000%s|r", L["不分担"]), true)
							end
						end
						
						T.InitSpellBars(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateSpellBars(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetSpellBars(frame)
					end,
				},	
			},
		},
		{ -- 放逐
			spells = {
				{1227529},--【放逐】
			},
			options = {
				{ -- 文字 放逐 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1227529)..L["连招"]..L["倒计时"],
					data = {
						spellID = 1227529,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {30.6, 15.9, 23.5, 16.5},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1227529, L["连招"], self, event, ...)
					end,
				},
				{ -- 计时条 放逐（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227529,
					text = L["DOT"],
				},
				{ -- 图标 放逐（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1227549,
					tip = L["强力DOT"],
					hl = "red",
				},
				{ -- 团队框架高亮 放逐（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1227549,
				},
			},
		},
		{ -- 暴君威压
			spells = {
				{1224822, "2"},--【暴君威压】
			},
			options = {
				
			},
		},
		{ -- 分形镜像
			spells = {
				{1225099},--【分形镜像】
				{1247215},--【分形之爪】
			},
			options = {
				
			},
		},
		{ -- 处斩
			spells = {
				{1224827},--【处斩】
				{1231097},--【寰宇裂伤】
			},
			options = {
				{ -- 文字 处斩 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["射线"]..L["倒计时"],
					data = {
						spellID = 1225010,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {32.5, 40.0},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1225010, L["射线"], self, event, ...)
					end,
				},
				{ -- 计时条 处斩（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1225010,
					text = L["准备"]..L["射线"],
					glow = true,
				},
				{ -- 计时条 处斩（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_SUCCESS",
					spellID = 1225010,
					dur = 7,
					tags = {3.5},
					text = L["射线"],
				},
				{ -- 声音 处斩（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1224864,
					private_aura = true,
					file = "[fixate]",
				},
				{ -- 图标 寰宇裂伤（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1231097,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 围攻
			spells = {
				{1227330},--【围攻】
			},
			options = {
				{ -- 文字 围攻 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["吐息"]..L["倒计时"],
					data = {
						spellID = 1225016,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {49.0, 40.1},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1225016, L["吐息"], self, event, ...)
					end,
				},
				{ -- 计时条 围攻（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1225016,
					text = L["吐息"],
				},
				{ -- 首领模块 分段计时条 围攻（待测试）
					category = "BossMod",
					spellID = 1225016,
					name = string.format(L["计时条%s"], T.GetIconLink(1225016)),
					enable_tag = "none",
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 300},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.spell_info = {
							["SPELL_CAST_SUCCESS"] = {
								[1225016] = {
									dur = 24.5,
									color = {0, 1, 0},
									sound = "breath",
									divide_info = {
										dur = {3, 5.3, 7.6, 9.9, 12.2, 14.5},
										sound = "count",
									},
								},
							},
						}
						
						function frame:post_update_show(sub_event, spellID)
							self.bar:SetStatusBarColor(0, 1, 0)
							self.state = 1
						end
						
						function frame:progress_update(sub_event, spellID, remain)
							if remain <= 21.5 then
								if self.state == 1 then
									self.state = 2
									self.bar:SetStatusBarColor(1, 0, 0)
								end
							end
						end
						
						T.InitSpellCastBar(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateSpellCastBar(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetSpellCastBar(frame)
					end,
				},
				{ -- 图标 围攻（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1227470,
					tip = L["强力DOT"],
					hl = "red",
				},
			},	
		},
		{ -- 融合虚空之翼
			spells = {
				{1227891, "4"},--【融合虚空之翼】
			},
			options = {
				{ -- 血量（✓）
					category = "TextAlert", 
					type = "hp",
					data = {
						npc_id = "237763",
						phase = 1,
						ranges = {
							{ ul = 54, ll = 50.1, tip = L["阶段转换"]..string.format(L["血量2"], 50)},
						},
					},
				},
				{ -- 计时条 融合虚空之翼（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227734,
					ficon = "4",
					text = L["击退"].."+"..L["阶段转换"],
				},
			},
		},
		{ -- 虚空击碎者
			spells = {
				{1228113},--【虚空击碎者】
			},
			options = {
				{ -- 文字 虚空击碎者 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1228115)..L["大圈"]..L["倒计时"],
					data = {
						spellID = 1228115,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[2] = {11.4},
								[2.1] = {75},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1228115, L["大圈"], self, event, ...)
					end,
				},
				{ -- 计时条 虚空击碎者（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228115,
					text = L["大圈"],
				},
				{ -- 声音 虚空击碎者（分配后更改音效）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1228114,
					private_aura = true,
					file = "[dropnow]",
				},
			},
		},
		{ -- 次元吐息
			spells = {
				{1228163, "5,12"},--【次元吐息】
				{1234539, "0"},--【维度眩光】
			},
			options = {
				{ -- 文字 次元吐息 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["头前"]..L["倒计时"],
					data = {
						spellID = 1228163,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[2] = {28.4},
								[2.1] = {90},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1228163, L["头前"], self, event, ...)
					end,
				},
				{ -- 计时条 次元吐息（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228163,
					text = L["头前"],
					sound = "[breath]cast",
				},
			},
		},
		{ -- 宇宙之喉
			spells = {
				{1234529, "0"},--【宇宙之喉】
			},
			options = {
				{ -- 文字 宇宙之喉 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = T.GetIconLink(1234529)..L["倒计时"],
					data = {
						spellID = 1234529,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[2] = {22.4},
								[2.1] = {84},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1234529, T.GetIconLink(1234529), self, event, ...)
					end,
				},
				{ -- 计时条 宇宙之喉（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1234529,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1234529cast", "cast"),
				},
				{ -- 嘲讽提示 宇宙之喉（待测试）
					category = "BossMod",
					spellID = 1234529,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1234529),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.boss_npcID = "233823"
						frame.aura_spellIDs = {
							[1234529] = 1, -- 宇宙之喉
						}
						frame.cast_spellIDs = {
							[1234529] = true, -- 宇宙之喉
						}
						
						T.InitTauntAlert(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateTauntAlert(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetTauntAlert(frame)
					end,
				},
				{ -- 换坦计时条 宇宙之喉（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1234529,
					ficon = "0",
					tank = true,
				},
			},
		},
		{ -- 集结影卫
			spells = {
				{1228065, "5"},--【集结影卫】
			},
			options = {
				{ -- 文字 集结影卫 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1228065)..L["阶段转换"]..L["倒计时"],
					data = {
						spellID = 1228065,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[2] = {38.4},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1228065, L["阶段转换"], self, event, ...)
					end,
				},
				{ -- 计时条 集结影卫（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228065,
					text = L["阶段转换"],
				},
			},
		},
		{ -- 法力铸造泰坦
			npcs = {
				{32639},--【法力铸造泰坦】 
			},
			spells = {
				--{1230302, "4"},--【自毁】
				--{1232399},--【恐惧炮击】
			},
			options = {
				{ -- 计时条 自毁（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1230302,
				},
				{ -- 计时条 恐惧炮击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232399,
				},
			},
		},
		{ -- 节点亲王
			npcs = {
				{33469},--【节点亲王Ky'vor】
				{32642},--【节点亲王Xevvos】 
			},
			spells = {
				--{1237105, "12"},--【暮光屏障】
				--{1228075},--【节点光束】
				--{1230261, "6"},--【虚无震击】
			},
			options = {
				{ -- 姓名板光环 暮光屏障（史诗待测试）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1237105,
				},
				{ -- 计时条 节点光束（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228075,
				},
				{ -- 图标 节点光束（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1228081,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
				{ -- 姓名板打断图标 虚无震击
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 1230263,
					mobID = "241803,241798",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 影卫收割者
			npcs = {
				{32645},--【影卫收割者】 
			},
			spells = {
				--{1237107, "12"},--【暮光屠戮】
				--{1250044},--【瞄准】
				--{1228053, "2"},--【收割】
			},
			options = {
				{ -- 计时条 暮光屠戮（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_SUCCESS",
					spellID = 1237106,
					dur = 5,
				},
				{ -- 声音 暮光屠戮（分配后更改音效）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1237108,
					private_aura = true,
					file = soundfile("1237108aura"),
				},
				{ -- 图标 收割（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1228056,
					tip = L["DOT"],
				},
				{ -- 团队框架高亮 收割（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1228056,
				},
			},
		},
		{ -- 封印熔炉
			spells = {
				{1232327},--【封印熔炉】
			},
			options = {
				{ -- 计时条 封印熔炉（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232327,
					text = L["推人"],
				},
			},
		},
		{ -- 皇家结界
			spells = {
				{1228284},--【皇家结界】
			},
			options = {
				{ -- 文字 皇家结界 免疫提醒（✓）
					category = "TextAlert",
					type = "spell",
					color = {1, 1, 0},
					preview = T.GetIconLink(1228284)..L["免疫"],
					data = {
						spellID = 1228284,
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
							if UnitExists("target") and AuraUtil.FindAuraBySpellID(1228284, "target", "HELPFUL") then
								self:Show()	
							else
								self:Hide()
							end
						elseif event == "UNIT_AURA_ADD" then
							local unit, spellID = ...
							if spellID == 1228284 and UnitIsUnit(unit, "target") then
								self:Show()
							end
						elseif event == "UNIT_AURA_REMOVED" then
							local unit, spellID = ...
							if spellID == 1228284 and UnitIsUnit(unit, "target") then
								self:Hide()
							end
						end
					end,
				},
			},
		},
		{ -- 君王的欲求
			spells = {
				{1228265, "5"},--【君王的欲求】
			},
			options = {
				{ -- 计时条 君王的欲求（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 1228265,
					dur = 6,
				},
				{ -- 计时条 君王的欲求（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HELPFUL",
					unit = "boss",
					spellID = 1228265,
					color = {0, 1, 0},
					text = L["易伤"],
					glow = true,
				},
				{ -- 血量（✓）
					category = "TextAlert", 
					type = "hp",
					data = {
						npc_id = "233823",
						phase = 2.2,
						ranges = {
							{ ul = 45, ll = 40.1, tip = L["阶段转换"]..string.format(L["血量2"], 40)},
						},
					},
				},
			},
		},
		{ -- 星河重碾
			spells = {
				{1226648, "5"},--【星河重碾】
			},
			options = {
				{ -- 文字 星河重碾 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1226648)..L["倒计时"],
					data = {
						spellID = 1226648,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {
							["all"] = {
								[3] = {5, 55, 55},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 1226648, T.GetIconLink(1226648), self, event, ...)
					end,
				},
				{ -- 计时条 星河重碾（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_SUCCESS",
					spellID = 1226648,
					dur = 12,
					tags = {4},
				},
				{ -- 声音 星河重碾（分配后更改音效）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1225316,
					private_aura = true,
					file = "[bombonyou]",
				},
			},
		},
		{ -- 黑暗之星
			spells = {
				{1248137, "5"},--【黑暗之星】
				{1225444, "4"},--【灰飞烟灭】
				{1225645},--【暮光尖峰】
				{1226384},--【黑暗周转】
				{1226879},--【星辰碰撞】
				{1234906},--【节点坍缩】
			},
			options = {
				
			},
		},
		{ -- 暮光创痕
			spells = {
				{1226362, "2"},--【暮光创痕】
			},
			options = {
				{ -- 图标 暮光创痕（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1226362,
					tip = L["DOT"],
				},
				{ -- 团队框架高亮 暮光创痕（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1226362,
				},
			},
		},
		{ -- 身星俱碎
			spells = {
				{1226417, "0"},--【身星俱碎】
			},
			options = {
				{ -- 嘲讽提示 身星俱碎（待测试）
					category = "BossMod",
					spellID = 1226413,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1226413),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.boss_npcID = "237763"
						frame.aura_spellIDs = {
							[1226413] = 1, -- 身星俱碎
						}
						frame.cast_spellIDs = {
							[1248210] = true, -- 星河重碾
						}
						
						T.InitTauntAlert(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateTauntAlert(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetTauntAlert(frame)
					end,
				},
				{ -- 换坦计时条 身星俱碎（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1226413,
					ficon = "0",
					tank = true,
				},
			},
		},
		{ -- 歼星斩
			spells = {
				{1226347},--【歼星斩】
				{1226042},--【歼星新星】
			},
			options = {
				{ -- 文字 歼星斩 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1226347)..L["倒计时"],
					data = {
						spellID = 1226347,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {
							["all"] = {
								[3] = {35, 15, 40, 15},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 1226347, T.GetIconLink(1226347), self, event, ...)
					end,
				},
				{ -- 计时条 歼星斩（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1226024,
					sound = "cast,cd5",
				},
				{ -- 声音 歼星斩（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1226018,
					private_aura = true,
					file = soundfile("1226018aura"),
				},
				{ -- 图标 歼星新星（待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1226042,
					tip = L["DOT"],
				},
			},
		},
		{ -- 暮光世界
			spells = {
				{1225634},--【暮光世界】
			},
			options = {
				
			},
		},
		{ -- 阶段转换
			title = L["阶段转换"],
			options = {
				{
					category = "PhaseChangeData",
					phase = 2,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1227734, -- 融合虚空之翼 50%
				},
				{
					category = "PhaseChangeData",
					phase = 2.1,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1228065, -- 集结影卫
				},
				{
					category = "PhaseChangeData",
					phase = 2.2,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1228265, -- 君王的欲求
				},
				{
					category = "PhaseChangeData",
					phase = 3,					
					type = "CLEU",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 1224822, -- 暴君威压
				},
			},
		},
	},
}