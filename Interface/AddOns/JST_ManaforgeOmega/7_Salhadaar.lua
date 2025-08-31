 local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1302\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------
if G.Client == "zhCN" or G.Client == "zhTW" then
	L["显示所有点位"] = "显示所有点位"
	L["过地刺序号"] = "过地刺序号"
	L["准备过地刺"] = "准备过地刺"
	L["地刺"] = "地刺"
	L["过"] = "过！"
	L["没点"] = "没点"
	L["引歼星斩分配"] = "引%s分配"
	L["引左"] = "引左"
	L["引右"] = "引右"
	L["歼星斩左右分配"] = "%s点名左右分配"
	L["不要写坦克"] = "除坦克外都写在这里，顺序从左到右。"
elseif G.Client == "ruRU" then
	--L["显示所有点位"] = "Show all positions"
	--L["过地刺序号"] = "Pass Index"
	--L["准备过地刺"] = "Prepare spike rings" 
	--L["地刺"] = "Spike"
	--L["过"] = "Pass！"
	--L["没点"] = "Not\non You"
	--L["引歼星斩分配"] = "bait %s assignment"
	--L["歼星斩左右分配"] = "%s debuff left/right assignment"
	--L["引左"] = "Bait LEFT"
	--L["引右"] = "Bait RIGHT"
	--L["不要写坦克"] = "All except tanks are written here, in order from left to right."
else
	L["显示所有点位"] = "Show all positions"
	L["过地刺序号"] = "Pass Index"
	L["准备过地刺"] = "Prepare spike rings" 
	L["地刺"] = "Spike"
	L["过"] = "Pass！"
	L["没点"] = "Not\non You"
	L["引歼星斩分配"] = "bait %s assignment"
	L["歼星斩左右分配"] = "%s debuff left/right assignment"
	L["引左"] = "Bait LEFT"
	L["引右"] = "Bait RIGHT"
	L["不要写坦克"] = "All except tanks are written here, in order from left to right."
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
				--{1224767},--【侍王之奴】
				--{1224764},--【破誓者】
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
				{ -- 文字 唤动誓言 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1224906)..L["全团AE"]..L["倒计时"],
					data = {
						spellID = 1224906,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {115},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1224906, L["全团AE"], self, event, ...)
					end,
				},
				{ -- 计时条 唤动誓言（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1224906,
					text = L["全团AE"],
					glow = true,
				},
				{ -- 首领模块 唤动誓言 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1224906,
					enable_tag = "none",
					name = T.GetIconLink(1224906)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["JST_CUSTOM"] = true,
					},
					init = function(frame)
						T.CreatePersonalSpellAlertBase(frame)
					end,
					update = function(frame, event, ...)
						if event == "JST_CUSTOM" then
							local id = ...
							
							if id == frame.config_id then
								frame:ActiveCheck()
								C_Timer.After(5, function() frame:RemoveCheck() end)
							end
							
						elseif event == "ENCOUNTER_START" then
							frame.check = false		
							C_Timer.After(112, function() T.FireEvent("JST_CUSTOM", frame.config_id) end)
						end
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertBase(frame)
					end,
				},
			},
		},
		{ -- 复仇誓言
			spells = {
				{1238975, "12"},--【复仇誓言】
			},
			options = {
				{ -- 文字 复仇誓言 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					ficon = "12",
					preview = T.GetIconLink(1238975)..L["倒计时"],
					data = {
						spellID = 1238975,
						events =  {
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {32, 32, 16.5},
						sound = "1302\\prepare_spirit",
					},
					update = function(self, event, ...)
						if event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, _, spellID = ...
							if string.find(unit, "boss") and spellID == 1224776 then  -- 镇压统治
								self.set = self.set + 1
								local wait = self.data.info[self.set]
								T.Start_Text_DelayTimer(self, wait, L["影子"], true)
							end
							
						elseif event == "ENCOUNTER_START" then
							self.set = 0
							self.round = true
							
							if C.DB["TextAlert"]["spell"][self.data.spellID]["sound_bool"] then
								self.count_down_start = 4
								self.prepare_sound = "1302\\prepare_spirit"
							end
						end
					end,
				},
				{ -- 首领模块 计时条 复仇誓言（✓）
					category = "BossMod",
					spellID = 1238975,
					ficon = "12",
					name = string.format(L["计时条%s"], T.GetIconLink(1238975)),
					enable_tag = "none",
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 300},
					events = {
						["UNIT_SPELLCAST_SUCCEEDED"] = true,
						["JST_CUSTOM"] = true,
					},
					init = function(frame)
						frame.bars = {}
						frame.textures = {}
						frame.set = 0
						frame.durations = {32, 32, 16.5}
						frame.colors = {
							{1, 0, 0},
							{1, 1, 0},
							{0, 1, 0},
						}
						
						local icon = C_Spell.GetSpellTexture(1238975)
						local color = T.GetSpellColor(1238975)
						
						for i = 1, 3 do
						
							local bar = T.CreateAlertBarShared(2, "bossmod"..frame.config_id..i, icon, L["影子"].." "..i, color)
							table.insert(frame.bars, bar)
							
							local tex = frame:CreateTexture(nil, "OVERLAY")
							tex:SetTexture(G.media.blank)
							tex:SetVertexColor(unpack(frame.colors[i]))
							tex:SetSize(5, 2000)
							tex:SetPoint("BOTTOM", UIParent, "CENTER")
							tex:Hide()
							table.insert(frame.textures, tex)
							
						end
						
						function frame:show_tex(set, index, wait, dur)
							if set >= index then
								local tex = self.textures[index]
								C_Timer.After(wait, function()
									tex:Show()
								end)
								C_Timer.After(wait+dur, function()
									tex:Hide()
								end)
							end
						end
						
						function frame:start(set)
							for i = 1, set do
								local wait_dur = 1.2*(i-1)
								C_Timer.After(wait_dur, function()
									T.StartTimerBar(self.bars[i], 3, true, true)
									T.PlaySound("1302\\spirit"..i)
								end)
								C_Timer.After(wait_dur+3, function()
									T.PlaySound("sound_dong")
								end)
								
								if i == 1 then
									self:show_tex(set, i, 0, 3)
								elseif i == 2 then
									self:show_tex(set, i, 3, 1.2)
								else
									self:show_tex(set, i, 4.2, 1.2)
								end
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "JST_CUSTOM" then
							local id, set = ...
							if id == frame.config_id then
								frame:start(set)
							end
						elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, _, spellID = ...
							if string.find(unit, "boss") and spellID == 1224776 then  -- 镇压统治
								frame.set = frame.set + 1
								local wait = frame.durations[frame.set]
								C_Timer.After(wait, function() 
									T.FireEvent("JST_CUSTOM", frame.config_id, frame.set)
								end)
							end
							
						elseif event == "ENCOUNTER_START" then
							frame.set = 0
						end
					end,
					reset = function(frame, event)
						for _, bar in pairs(frame.bars) do
							T.StopTimerBar(bar, true, true)
						end
					end,
				},
			},
		},
		{ -- 镇压统治
			spells = {
				{1224787, "5"},--【征服】
				{1224812},--【主宰】	
			},
			options = {
				{ -- 文字 镇压统治 倒计时（✓）
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
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss", 1224776, L["连招"], self, event, ...)
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
				{ -- 首领模块 分段计时条 镇压统治（✓）
					category = "BossMod",
					spellID = 1224795,
					name = string.format(L["计时条%s"], T.GetIconLink(1238975)..T.GetIconLink(1224812)),
					enable_tag = "none",
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 400, width = 615, height = 30},
					events = {
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_SUCCEEDED"] = true,
					},
					init = function(frame)
						frame.bars = {}
						frame.order = {}
						frame.count = 0
						
						for i = 1, 4 do
							local bar = T.CreateTimerBar(frame, nil, false, false, true, 150, 30)
							T.SetHighLightBorderColor(bar, bar, {0, 1, 0}, 3)
							
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
								bar:SetStatusBarColor(.9, .3, 0)								
							elseif spell == "VANQUISH" then
								bar.left:SetText(L["冲击波"])
								bar:SetStatusBarColor(.6, 0, 1)
							else
								bar.left:SetText("?")
								bar:SetStatusBarColor(.3, .3, .3)
							end
							
							if assigned then
								bar.glow:Show()
							else
								bar.glow:Hide()
							end
							
							bar:Show()
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
							local unit, castGUID, spellID = ...
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
				{ -- 首领模块 征服 MRT轮次分配（✓）
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
				{ -- 文字 放逐 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1227529)..L["倒计时"],
					data = {
						spellID = 1227529,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {30.5, 16, 23.5, 16.5},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1227529, T.GetIconLink(1227529), self, event, ...)
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
				{ -- 首领模块 放逐 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1227549,
					enable_tag = "none",
					name = T.GetIconLink(1227549)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1227549] = 0,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 65
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
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
				{ -- 文字 处斩 倒计时（✓）
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
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1225010, L["射线"], self, event, ...)
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
				{ -- 文字 围攻 倒计时（✓）
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
							[15] = {
								[1] = {49, 40},
							},
							[16] = {
								[1] = {9, 40, 40},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1225016, L["吐息"], self, event, ...)
					end,
				},
				{ -- 计时条 围攻（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1225016,
					text = L["吐息"],
				},
				{ -- 首领模块 分段计时条 围攻（✓）
					category = "BossMod",
					spellID = 1225016,
					enable_tag = "none",
					name = string.format(L["计时条%s"], T.GetIconLink(1225016)),
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 325},
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
				{ -- 文字 虚空击碎者 倒计时（✓）
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
							[15] = {
								[2] = {5.5},
								[2.1] = {75},
							},
							[16] = {
								[2] = {2.5},
								[2.1] = {70},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1228115, L["大圈"], self, event, ...)
					end,
				},
				{ -- 计时条 虚空击碎者（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228115,
					text = L["大圈"],
				},
			},
		},
		{ -- 次元吐息
			spells = {
				{1228163, "5,12"},--【次元吐息】
				{1234539, "0"},--【维度眩光】
			},
			options = {
				{ -- 文字 次元吐息 倒计时（✓）
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
							[15] = {
								[2] = {28.5},
								[2.1] = {90},
							},
							[16] = {
								[2] = {20.5},
								[2.1] = {75},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1228163, L["头前"], self, event, ...)
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
				{ -- 文字 宇宙之喉 倒计时（✓）
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
							[15] = {
								[2] = {22.4},
								[2.1] = {84},
							},
							[16] = {
								[2] = {15.5},
								[2.1] = {77},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1234529, T.GetIconLink(1234529), self, event, ...)
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
				{ -- 文字 集结影卫 倒计时（✓）
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
								[2] = {38.5},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1228065, L["阶段转换"], self, event, ...)
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
				{ -- 文字 恐惧炮击 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1232399)..L["引圈"]..L["倒计时"],
					data = {
						spellID = 1232399,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
							["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						},
					},
					update = function(self, event, ...)
						if event == "ENCOUNTER_PHASE" then
							local phase = ...
							if phase == 2.1 then
								if self.diffcultyID == 16 then
									T.Start_Text_DelayTimer(self, 23.1, L["引圈"], true)
								else
									T.Start_Text_DelayTimer(self, 15.9, L["引圈"], true)
								end
							end
							
						elseif event == "UNIT_SPELLCAST_START" then
							local unit, _, spellID = ...
							if string.find(unit, "boss") and spellID == 1232399 then -- 恐惧炮击
								if not T.IsUnitOutOfRange(unit) then
									self.GUID = UnitGUID(unit)
									T.Start_Text_DelayTimer(self, 24.3, L["引圈"], true)
								end
							end
							
						elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, destGUID = CombatLogGetCurrentEventInfo()
							if sub_event == "UNIT_DIED" and destGUID == self.GUID then
								T.Stop_Text_Timer(self)
							end
							
						elseif event == "ENCOUNTER_START" then
							self.diffcultyID = select(3, ...)
							self.GUID = nil
							
							self.round = true
							self.count_down_start = 5
							self.prepare_sound = "baitcircles"
						end
					end,
				},
				{ -- 计时条 恐惧炮击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232399,
					sound = "[dodge_circle]cast",
					range_ck = true,
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
				{ -- 姓名板光环 暮光屏障（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1237105,
				},
				{ -- 计时条 节点光束（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228075,
					sound = "[ray]cast",
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
				{ -- 姓名板打断图标 虚无震击（✓）
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
				{ -- 声音 暮光屠戮（✓）
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
				{ -- 首领模块 收割 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1228056,
					enable_tag = "none",
					name = T.GetIconLink(1228056)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1228056] = 0,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 65
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
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
				{ -- 文字 星河重碾 倒计时（✓）
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
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss", 1226648, T.GetIconLink(1226648), self, event, ...)
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
				{ -- 声音 星河重碾（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1225316,
					private_aura = true,
					file = soundfile("1225316aura"),
				},
				{ -- 首领模块 星河重碾 示意图（✓）
					category = "BossMod",
					spellID = 1225316,
					ficon = "12",
					enable_tag = "everyone",
					name = string.format(L["NAME示意图"], T.GetIconLink(1225316)),	
					points = {a1 = "TOPLEFT", a2 = "CENTER", x = 300, y = 300, width = 240, height = 240},
					events = {
						["ENCOUNTER_PHASE"] = true,
						["JST_CUSTOM"] = true,
					},
					custom = {
						{
							key = "all_points_bool",
							text = L["显示所有点位"],
							default = false,
							apply = function(value, alert)
								if alert.display_set then
									local assignmentType = alert:GetassignmentType()
									alert:Display(alert.display_set, assignmentType)
								end
							end,
							
						},
						{
							key = "scale_sl",
							text = L["尺寸"],
							default = 100,
							min = 60,
							max = 140,
							apply = function(value, alert)
								alert:SetScale(value/100)
							end,
						},
						{
							key = "dur_sl",
							text = L["持续时间"],
							default = 15,
							min = 5,
							max = 30,
						},
						{
							key = "preview_index_dd",
							text = L["预览轮次"],
							default = 1,
							key_table = {
								{1, "1"},
								{2, "2"},
								{3, "3"},
							},
							apply = function(value, alert)
								alert:UpdatePreviewInfo()
							end,
						},
					},
					init = function(frame)
						frame.spawnTimes = {17, 55, 55}	
						
						frame.locals = {
							RANGED = L["远程"],
							MELEE = L["近战"],
							TANK = L["坦克"],
						}
						
						frame.assignments = {
							[1] = {
								RANGED = 1,
								MELEE = 7,
								TANK = 7,
							},
							[2] = {
								RANGED = 1,
								MELEE = 2,
								TANK = 2,
							},
							[3] = {
								RANGED = 8,
								MELEE = 4,
								TANK = 4,
							}
						}
						
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 2)
						
						local MAP_SIZE = 240
						local CIRCLE_SIZE = 0.12
						local MARKER_SIZE = 0.07
						
						local CENTER_RING_DISTANCE = 0.08
						local INNER_RING_DISTANCE = 0.185
						local MIDDLE_RING_DISTANCE = 0.298
						local OUTER_RING_DISTANCE = 0.42
						
						local MAP_CENTER_OFFSET_X = 0 * MAP_SIZE
						local MAP_CENTER_OFFSET_Y = 0.01 * MAP_SIZE
						
						frame.graph_bg = CreateFrame("Frame", nil, frame)
						frame.graph_bg:SetAllPoints(frame)
						frame.graph_bg:Hide()
						
						frame.bg = frame.graph_bg:CreateTexture(nil, "BACKGROUND")
						frame.bg:SetAllPoints()
						frame.bg:SetTexture("Interface\\AddOns\\JST_ManaforgeOmega\\textures\\nexus_king_map.tga")
						
						local mark_data = {
							{270, OUTER_RING_DISTANCE},
							{0, MIDDLE_RING_DISTANCE},
							{270, MIDDLE_RING_DISTANCE},
							{130, MIDDLE_RING_DISTANCE},
							{27, MIDDLE_RING_DISTANCE},
							{154.5, MIDDLE_RING_DISTANCE},
							{-27, INNER_RING_DISTANCE},
							{0, OUTER_RING_DISTANCE},
						}
						
						for i = 1, 8 do
							local mark = frame.graph_bg:CreateTexture(nil, "OVERLAY")
							mark:SetSize(MAP_SIZE*MARKER_SIZE, MAP_SIZE*MARKER_SIZE)
							mark:SetTexture([[Interface\TargetingFrame\UI-RaidTargetingIcons]])
							SetRaidTargetIconTexture(mark, i)
							
							local degree = mark_data[i][1]
							local distance = mark_data[i][2]
							
							local x = math.cos(math.rad(degree)) * distance * MAP_SIZE + MAP_CENTER_OFFSET_X
							local y = math.sin(math.rad(degree)) * distance * MAP_SIZE + MAP_CENTER_OFFSET_Y
							
							mark:SetPoint("CENTER", frame.graph_bg, "CENTER", x, y)
						end
						
						frame.circles = {}
						
						for i = 1, 6 do
							local circle = frame.graph_bg:CreateTexture(nil, "ARTWORK")
							circle:SetSize(MAP_SIZE*CIRCLE_SIZE, MAP_SIZE*CIRCLE_SIZE)
							circle:SetTexture(G.media.circle)
							
							table.insert(frame.circles, circle)
						end
						
						local circle_data = {
							{
								{251, OUTER_RING_DISTANCE},  -- Ranged 1
								{270, OUTER_RING_DISTANCE}, -- Ranged 2
								{289, OUTER_RING_DISTANCE}, -- Ranged 3
								{15, INNER_RING_DISTANCE}, -- Melee 1
								{333, INNER_RING_DISTANCE}, -- Tank
								{291, INNER_RING_DISTANCE}, -- Melee 2
							},
							{
								{251, OUTER_RING_DISTANCE},  -- Ranged 1
								{270, OUTER_RING_DISTANCE}, -- Ranged 2
								{289, OUTER_RING_DISTANCE}, -- Ranged 3
								{334, MIDDLE_RING_DISTANCE}, -- Melee 1
								{0, MIDDLE_RING_DISTANCE}, -- Tank
								{26, MIDDLE_RING_DISTANCE}, -- Melee 2
							},
							{
								{341, OUTER_RING_DISTANCE},  -- Ranged 1
								{0, OUTER_RING_DISTANCE}, -- Ranged 2
								{19, OUTER_RING_DISTANCE}, -- Ranged 3
								{103, MIDDLE_RING_DISTANCE}, -- Melee 1
								{129, MIDDLE_RING_DISTANCE}, -- Tank
								{155, MIDDLE_RING_DISTANCE}, -- Melee 2
							},
						}
						
						local circle_positions = {{}, {}, {}}
						local indexToType = {"RANGED", "RANGED", "RANGED", "MELEE", "TANK", "MELEE"}						
						for i = 1, 3 do
							for j = 1, 6 do
								local degree = circle_data[i][j][1]
								local distance = circle_data[i][j][2]
								
								circle_positions[i][j] = {
									math.cos(math.rad(degree)) * distance * MAP_SIZE + MAP_CENTER_OFFSET_X,
									math.sin(math.rad(degree)) * distance * MAP_SIZE + MAP_CENTER_OFFSET_Y,
								}
							end
						end
						
						function frame:UpdateCircle(index, position, assigned)
							local tex = self.circles[index]
							local x, y = unpack(position)
							
							if assigned then
								tex:SetVertexColor(0, 1, 0, .8)
							else
								tex:SetVertexColor(1, 0, 0, .5)
							end
							
							tex:SetPoint("CENTER", self.graph_bg, "CENTER", x, y)
							tex:Show()
						end
						
						function frame:HideCircle(index)
							local tex = self.circles[index]
							tex:Hide()
						end
						
						function frame:GetassignmentType()
							local info = T.GetGroupInfobyGUID(G.PlayerGUID)
							local isTank = info.role == "TANK"
							local isRanged = info.pos == "RANGED"
							local assignmentType = isTank and "TANK" or isRanged and "RANGED" or "MELEE"
							
							return assignmentType
						end
						
						function frame:Display(set, assignmentType)
							local assignmentTypesToShow = {
								[assignmentType] = true -- Always show our own assignmentType
							}
							
							if C.DB["BossMod"][self.config_id]["all_points_bool"] then
								assignmentTypesToShow.MELEE = true
								assignmentTypesToShow.RANGED = true
								assignmentTypesToShow.TANK = true
							elseif assignmentType ~= "RANGED" then
								assignmentTypesToShow.MELEE = true
								assignmentTypesToShow.TANK = true
							end
							
							for index, position in ipairs(circle_positions[set]) do
								local positionType = indexToType[index]
								local shouldShow = assignmentTypesToShow[positionType]
								local assigned = positionType == assignmentType
								
								if shouldShow then
									self:UpdateCircle(index, position, assigned)
								else
									self:HideCircle(index)
								end
							end
							
							self.display_set = set
						end
						
						function frame:UpdateNextSpwan(set)
							local spawnTime = self.spawnTimes[set]
							
							if spawnTime then
								local showTime = C.DB["BossMod"][self.config_id]["dur_sl"]
								local wait = math.max(spawnTime - showTime, 0)
								local duration = math.min(showTime, spawnTime)
								local assignmentType = self:GetassignmentType()
								
								C_Timer.After(wait, function()
									T.FireEvent("JST_CUSTOM", self.config_id, "SHOW", set, assignmentType, duration)
								end)
								C_Timer.After(spawnTime, function()
									T.FireEvent("JST_CUSTOM", self.config_id, "NEXT")
								end)
							end
						end
						
						function frame:UpdatePreviewInfo()
							local set = C.DB["BossMod"][self.config_id]["preview_index_dd"]
							local assignmentType = self:GetassignmentType()
							self:Display(set, assignmentType)							
						end
						
						function frame:PreviewShow()
							self:UpdatePreviewInfo()
							self.graph_bg:Show()
						end
						
						function frame:PreviewHide()
							self.graph_bg:Hide()
						end
					end,
					update = function(frame, event, ...)
						if event == "JST_CUSTOM" then
							local id, key, set, assignmentType, duration = ...
							
							if id ~= frame.config_id or T.GetCurrentPhase() ~= 3 then return end
							
							if key == "SHOW" then
								local mark = frame.assignments[set][assignmentType]
								local str = string.format("%s %s", T.FormatRaidMark(mark), frame.locals[assignmentType])
								T.Start_Text_Timer(frame.text_frame, duration, str, true)
								
								frame:Display(set, assignmentType)
								
								frame.graph_bg:Show()
								C_Timer.After(duration, function()
									frame.graph_bg:Hide()
								end)
								
							elseif key == "NEXT" then
								frame.set = frame.set + 1
								frame:UpdateNextSpwan(frame.set)
							end
							
						elseif event == "ENCOUNTER_PHASE" then
							local phase = ...
							if phase == 3 then
								frame.set = frame.set + 1
								frame:UpdateNextSpwan(frame.set)
							end
							
						elseif event == "ENCOUNTER_START" then
							frame.set = 0
						end
					end,
					reset = function(frame, event)
						frame.graph_bg:Hide()
						frame:Hide()
					end,
				},
			},
		},
		{ -- 黑暗之星
			spells = {
				{1248137, "5"},--【黑暗之星】
				--{1225444, "4"},--【灰飞烟灭】
				--{1225645},--【暮光尖峰】
				--{1226384},--【黑暗周转】
				--{1226879},--【星辰碰撞】
				--{1234906},--【节点坍缩】
			},
			options = {
				{ --首领模块 暮光尖峰计时条（✓）
					category = "BossMod",
					spellID = 1225645,
					ficon = "12",
					enable_tag = "none",
					name = T.GetIconLink(1225645)..L["计时条"],
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 325},
					events = {					
						["UNIT_SPELLCAST_SUCCEEDED"] = true,
						["JST_CUSTOM"] = true,
					},
					
					init = function(frame)
						frame.default_bar_width = 500
						T.GetSingleBarCustomData(frame)
						
						frame.set = 0
						frame.index = 0
						frame.pass = {{3, 7}, {5, 8}, {5, 7}}
						frame.icon = C_Spell.GetSpellTexture(1225645)
						frame.cross_tex = {}
						
						local path = T.GetBossModData(frame)
						local data = T.ValueFromPath(G.Encounters, path)
						if not data.custom then
							data.custom = {}
						end
						
						for i = 1, 6 do
							local set = ceil(i/2)
							local index = ((i-1)%2)+1
							local k = string.format("pass%d%d_dd", set, index)
							local str = string.format("%s%d-%d", L["地刺"], set, index)
							
							table.insert(data.custom, 
								{
									key = k,
									text = str, 
									default = frame.pass[set][index],
									key_table = {
										{0, L["无"]},
										{1, "1"},
										{2, "2"},
										{3, "3"},
										{4, "4"},
										{5, "5"},
										{6, "6"},
										{7, "7"},
										{8, "8"},
									},
								}
							)
						end
						
						frame.progress_bar = T.CreateTimerBar(frame, frame.icon, false, true, true, nil, nil, {.59, .26, .81})
						frame.progress_bar:SetAllPoints(frame)					
						
						T.CreateTagsforBar(frame.progress_bar, 8)
						
						for i = 1, 8 do
							frame.progress_bar["tagindex"..i] = T.createtext(frame.progress_bar, "OVERLAY", 12, "OUTLINE", "LEFT")
							frame.progress_bar["tagindex"..i]:SetPoint("BOTTOM", frame.progress_bar.tag_indcators[i], "TOP", 0, 2)
							frame.progress_bar["tagindex"..i]:SetText(i)
						end
						
						for i = 1, 8 do
							frame.progress_bar:pointtag(i, (i-1)/8)
						end
						
						for i = 1, 2 do
							local tex = frame.progress_bar:CreateTexture(nil, "BORDER")
							tex:SetSize(37.5, 25)
							tex:SetTexture(G.media.blank)
							tex:SetVertexColor(0, 1, 0)
							
							table.insert(frame.cross_tex, tex)
						end
						
						frame.progress_bar:HookScript("OnSizeChanged", function(self, width, height)
							for _, tex in pairs(frame.cross_tex) do
								tex:SetSize(width/8, height)
							end
						end)
						
						function frame:PointTex(tex, index)
							tex:ClearAllPoints()
							tex:Hide()
							if index > 0 then
								local width = C.DB["BossMod"][self.config_id]["width_sl"]/8
								local x_offset = (index - 1)*width
								tex:SetPoint("LEFT", self.progress_bar, "LEFT", x_offset, 0)
								tex:Show()
							end
						end
						
						function frame:StartProgressBar(set)
							local pass1_key = string.format("pass%d%d_dd", set, 1)
							local pass2_key = string.format("pass%d%d_dd", set, 2)
							local index1 = C.DB["BossMod"][self.config_id][pass1_key]
							local index2 = C.DB["BossMod"][self.config_id][pass2_key]
							self:PointTex(self.cross_tex[1], index1)
							self:PointTex(self.cross_tex[2], index2)
							
							T.StartTimerBar(self.progress_bar, 16, true, true)
						end
						
						frame.bar = T.CreateAlertBarShared(2, "bossmod"..frame.config_id, frame.icon, L["地刺"], {1, 1, 1})

						function frame:Start(set, index)
							local pass1_key = string.format("pass%d%d_dd", set, 1)
							local pass2_key = string.format("pass%d%d_dd", set, 2)
							local pass1 = C.DB["BossMod"][self.config_id][pass1_key]
							local pass2 = C.DB["BossMod"][self.config_id][pass2_key]
							
							local IsPass = index == pass1 or index == pass2
							local IsPrepare = index == (pass1 -1) or index == (pass2 -1)
							
							if IsPass then
								self.bar:SetStatusBarColor(0, 1, 0)
								self.bar.left:SetText(string.format("%d %s", index, L["过"]))
								T.PlaySound("pass")
							elseif IsPrepare then
								self.bar:SetStatusBarColor(1, 1, 0)
								self.bar.left:SetText(string.format("%d %s", index, L["准备"]))
								T.PlaySound("prepare")
							else
								self.bar:SetStatusBarColor(.59, .26, .81)
								self.bar.left:SetText(string.format("%d %s", index, L["地刺"]))
							end
							
							T.StartTimerBar(self.bar, 2, true, true)
						end
						
						function frame:PreviewShow()
							self:StartProgressBar(random(3))
						end
						
						function frame:PreviewHide()
							T.StopTimerBar(self.progress_bar, true, true)
						end
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, castGUID, spellID = ...
							
							if string.find(unit, "boss") and spellID == 1225319 then  -- 星河重碾
								frame.bar:SetStatusBarColor(0, 1, 1)
								frame.bar.left:SetText(L["准备过地刺"])
								T.StartTimerBar(frame.bar, 5, true, true)
								
								frame.set = frame.set + 1
								frame.index = 1
								
								C_Timer.After(5, function()
									frame:StartProgressBar(frame.set)
									T.FireEvent("JST_CUSTOM", frame.config_id, frame.set, frame.index)
								end)
							end
							
						elseif event == "JST_CUSTOM" then
							local id, set, index = ...
							
							if id ~= frame.config_id then return end
							
							frame:Start(set, index)
							
							if index < 8 then
								frame.index = frame.index + 1
								C_Timer.After(2, function()
									T.FireEvent("JST_CUSTOM", frame.config_id, frame.set, frame.index)
								end)
							end 
						elseif event == "ENCOUNTER_START" then
							frame.set = 0
							frame.index = 0
						end
					end,
					reset = function(frame, event)
						T.StopTimerBar(frame.progress_bar, true, true)
						T.StopTimerBar(frame.bar, true, true)
					end,
				},
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
					hl = "red",
				},
				{ -- 首领模块 暮光创痕 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1226362,
					enable_tag = "none",
					name = T.GetIconLink(1226362)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1226362] = 0,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 65
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
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
				{ -- 文字 歼星斩 倒计时（✓）
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
								[3] = {35, 15, 40, 15, 40, 15},
							},
						},
						cd_args = {
							round = true,
							count_down_start = 5,
							mute_count_down = true,
							prepare_sound = "prepare_starkiller",
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss", 1226347, T.GetIconLink(1226347), self, event, ...)
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
				{ -- 图标 歼星新星（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1226042,
					tip = L["DOT"],
					hl = "red",
				},
				{ -- 首领模块 引歼星斩分配（✓）
					category = "BossMod",
					ficon = "12",
					spellID = 1226024,
					enable_tag = "everyone",
					name = string.format(L["引歼星斩分配"], T.GetIconLink(1226024)),
					points = {hide = true},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						["JST_CUSTOM"] = true,
					},
					custom = {
						{
							key = "mrt_custom_btn",
						},
						{
							key = "mrt_analysis_btn",
						},
					},
					init = function(frame)
						frame.prompt_dur = 4
						frame.assignments = {}
						frame.info = {
							{ text = L["引左"], sound = "1302\\baitleft"},
							{ text = L["引右"], sound = "1302\\baitright"},
						}
						
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 2)
						
						function frame:Assign()
							if not next(self.assignments) then return end
							
							local set = self.set
							local GUIDs = self.assignments[set]       
							if not GUIDs then return end
							
							local my_index = tIndexOf(GUIDs, G.PlayerGUID)
							
							if my_index and my_index <= 2 then
								local str = self.info[my_index].text
								local sound = self.info[my_index].sound
								
								T.Start_Text_Timer(self.text_frame, self.prompt_dur, str, true)								
								T.PlaySound(sound)
								T.SendChatMsg(str, self.prompt_dur, "SAY")
							end
							
							local str = string.format("%s[%d]", self.config_name, set)
							for _, GUID in pairs(GUIDs) do
								local name = T.ColorNickNameByGUID(GUID)
								str = str.." "..name
							end
							T.msg(str)
							
						end
						
						function frame:copy_mrt()
							local str = [[
								#%dstart%s
								player player
								player player
								player player
								player player 
								player player
								player player
								end
							]]
							
							str = gsub(str, "	", "")
							return string.format(str, self.config_id, C_Spell.GetSpellName(self.config_id))
						end
						
						function frame:ReadNote(display)
							self.assignments = table.wipe(self.assignments)
							
							if display then
								T.msg(self.config_name)
							end
							
							local set = 0
							
							for _, line in T.IterateNoteAssignment(self.config_id) do
								local GUIDs = T.LineToGUIDArray(line)
								
								if next(GUIDs) then
									set = set + 1
									
									table.insert(self.assignments, GUIDs)
									
									if display then
										local str = string.format("[%d]", set)
										for _, GUID in pairs(GUIDs) do
											local name = T.ColorNickNameByGUID(GUID)
											str = str.." "..name
										end
										T.msg(str)
									end
								end
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_AURA_REMOVED" and spellID == 1228265 then -- 君王的欲求 P3
								frame.phase3 = true
								
							elseif sub_event == "SPELL_CAST_START" and spellID == 1225319 then  -- 星河重碾
								local starkill_wait = 27.8 - frame.prompt_dur
								
								C_Timer.After(starkill_wait, function()
									T.FireEvent("JST_CUSTOM", frame.config_id)
								end)
							
							elseif sub_event == "SPELL_CAST_SUCCESS" and spellID == 1226442 then  -- 歼星斩
								frame.set = frame.set + 1
								
								if (frame.set%2) == 0 then
									local starkill_wait = 15 - frame.prompt_dur
									C_Timer.After(starkill_wait, function() 
										T.FireEvent("JST_CUSTOM", frame.config_id)
									end)
								end
								
							end
						elseif event == "JST_CUSTOM" then
							local id = ...
							
							if id ~= frame.config_id or not frame.phase3 then return end
							
							frame:Assign()
							
						elseif event == "ENCOUNTER_START" then
							frame.phase3 = false
							frame.set = 1
							
							frame:ReadNote()
						end
					end,
					reset = function(frame, event)
						T.Stop_Text_Timer(frame.text_frame)
					end,				
				},
				{ -- 歼星斩左右分配（✓）
					category = "BossMod",
					ficon = "12",
					spellID = 1226018,
					enable_tag = "everyone",
					name = string.format(L["歼星斩左右分配"], T.GetIconLink(1226018)),
					points = {a1 = "BOTTOM", a2 = "CENTER", x = 0, y = 400, width = 200, height = 60},
					events = {					
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					custom = {
						{
							key = "mrt_custom_btn",
						},
						{
							key = "mrt_analysis_btn",
						},
					},
					init = function(frame)
						frame.anchor_holder = CreateFrame("Frame", nil, frame)
						frame.anchor_holder:SetAllPoints(frame)
						frame.anchor_holder:Hide()
						frame.anchor_holder.t = 0

						frame.info = {
							left = {
								tex = G.media.triangle,
								rotation = 90,
								anchor = "LEFT",
							},
							mid = {
								tex = G.media.blank,
								text = L["没点"],
								anchor = "CENTER",
							},
							right = {
								tex = G.media.triangle,
								rotation = 270,	
								anchor = "RIGHT",
							},
						}
						
						for key, info in pairs(frame.info) do
							local anchor = CreateFrame("Frame", nil, frame.anchor_holder)
							anchor:SetPoint(info.anchor, frame.anchor_holder, info.anchor, 0, 0)
							anchor:SetSize(60, 60)
							
							anchor.tex = anchor:CreateTexture(nil, "BACKGROUND")
							anchor.tex:SetAllPoints(anchor)
							anchor.tex:SetTexture(info.tex)
							anchor.tex:SetVertexColor(1, 1, 1)
							if info.rotation then
								anchor.tex:SetRotation(info.rotation/180*math.pi)
							end
							
							anchor.text = T.createtext(anchor, "OVERLAY", 24, "OUTLINE", "CENTER")
							anchor.text:SetPoint("CENTER", anchor, "CENTER", 0, 0)
							anchor.text:SetTextColor(1, 0, 0)
							
							if info.text then
								anchor.text:SetText(info.text)
							else
								anchor.timer = true
							end
							
							anchor.anchorIDs = {}
							anchor.GUIDs = {}
							
							frame.anchor_holder[key] = anchor
						end
						
						function frame:copy_mrt()
							local str = [[
								#%dstart%s
								player player player player player player player player player player player player player player player player player player
								end
								%s
							]]
							
							str = gsub(str, "	", "")
							return string.format(str, self.config_id, C_Spell.GetSpellName(self.config_id), L["不要写坦克"])
						end
						
						function frame:ReadNote(display)
							self.anchor_holder.left.GUIDs = table.wipe(self.anchor_holder.left.GUIDs)
							self.anchor_holder.right.GUIDs = table.wipe(self.anchor_holder.right.GUIDs)
							
							local notank_GUIDs = {}
							
							for _, line in T.IterateNoteAssignment(self.config_id) do
								local GUIDs = T.LineToGUIDArray(line)
								
								for _, GUID in ipairs(GUIDs) do
									local info = T.GetGroupInfobyGUID(GUID)
									local unit = info.unit
									local role = info.role
									
									if role ~= "TANK" then
										tInsertUnique(notank_GUIDs, GUID)
									end
								end
							end
							
							local note = #notank_GUIDs > 0
							
							local GUIDsToAdd = {}							
							for unit in T.IterateGroupMembers() do
								local GUID = UnitGUID(unit)
								local role = UnitGroupRolesAssigned(unit)
								
								if role ~= "TANK" and not tContains(notank_GUIDs, GUID) then
									table.insert(GUIDsToAdd, GUID)
								end
							end
							
							table.sort(GUIDsToAdd)
							tAppendAll(notank_GUIDs, GUIDsToAdd)
							
							if not note then
								table.sort(notank_GUIDs)
							end
						
							local after_me = false
							local left_str, right_str = L["左"], L["右"]
							for index, GUID in ipairs_reverse(notank_GUIDs) do
								if GUID == G.PlayerGUID then
									after_me = true
								end
								
								if GUID ~= G.PlayerGUID then
									if not after_me then
										table.insert(self.anchor_holder.left.GUIDs, GUID)
										local name = T.ColorNickNameByGUID(GUID)
										left_str = left_str.." "..name
									else
										table.insert(self.anchor_holder.right.GUIDs, GUID)
										local name = T.ColorNickNameByGUID(GUID)
										right_str = right_str.." "..name
									end
								end
							end
							
							if display then
								T.msg(self.config_name)
								T.msg(left_str)
								T.msg(right_str)
							end
						end
						
						function frame:CreatePrivateAuraAnchor(key, GUID)
							local region = self.anchor_holder[key]
							local unit = GUID == G.PlayerGUID and "player" or T.GetGroupInfobyGUID(GUID)["unit"]
							
							local privateAnchorArgs = {
								unitToken = unit,
								auraIndex = 1,
								parent = region,
								showCountdownFrame = false,
								showCountdownNumbers = false,
								iconInfo = {
									iconAnchor = {
										point = "CENTER",
										relativeTo = region,
										relativePoint = "CENTER",
										offsetX = 0,
										offsetY = 0
									},
									iconWidth = region:GetWidth(),
									iconHeight = region:GetHeight()
								}
							}
							region.anchorIDs[GUID] = C_UnitAuras.AddPrivateAuraAnchor(privateAnchorArgs)
						end
						
						frame:CreatePrivateAuraAnchor("mid", G.PlayerGUID)
						
						function frame:CreatePrivateAuraAnchors(key)
							local region = self.anchor_holder[key]
							
							-- Remove existing anchor IDs
							for _, anchorID in pairs(region.anchorIDs) do
								C_UnitAuras.RemovePrivateAuraAnchor(anchorID)
							end
							
							region.anchorIDs = table.wipe(region.anchorIDs)
							
							local role = UnitGroupRolesAssigned("player")
							if role ~= "TANK" then -- 坦克不创建左右的锚点
								for _, GUID in pairs(region.GUIDs) do
									self:CreatePrivateAuraAnchor(region, GUID)
								end
							end
						end
						
						function frame:start_timer(preview)
							self.anchor_holder.exp_time = GetTime() + 6
							self.anchor_holder:SetScript("OnUpdate", function(s, e)
								s.t = s.t + e
								if s.t > .05 then		
									local remain = s.exp_time - GetTime()
									if remain > 0 then
										s.left.text:SetText(T.FormatTime(remain))
										s.right.text:SetText(T.FormatTime(remain))
									else
										self:stop_timer()
									end
									s.t = 0
								end
							end)
							
							self.anchor_holder:Show()
						end
						
						function frame:stop_timer()
							self.anchor_holder:SetScript("OnUpdate", nil)
							self.anchor_holder.left.text:SetText("")
							self.anchor_holder.right.text:SetText("")
							self.anchor_holder:Hide()
						end
						
						function frame:PreviewShow()
							self:start_timer()
						end
						
						function frame:PreviewHide()
							self:stop_timer()
						end
					end,
					update = function(frame, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_CAST_START" and spellID == 1226024 then -- 歼星斩
								frame:start_timer()
							end
						elseif event == "ENCOUNTER_START" then
							frame:ReadNote()
							frame:CreatePrivateAuraAnchors("left")
							frame:CreatePrivateAuraAnchors("right")
						end
					end,
					reset = function(frame, event)
						frame:stop_timer()
					end,
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