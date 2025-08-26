local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1302\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------
if G.Client == "zhCN" or G.Client == "zhTW" then
	L["虚空"] = "虚空"
	L["复仇"] = "复仇"
	L["浩劫"] = "浩劫"
	L["撞球位置分配"] = "撞球位置分配"
elseif G.Client == "ruRU" then
	--L["虚空"] = "Void"
	--L["复仇"] = "Vengeance"
	--L["浩劫"] = "Havoc"
	--L["撞球位置分配"] = "Soak location assignment"
else
	L["虚空"] = "Void"
	L["复仇"] = "Vengeance"
	L["浩劫"] = "Havoc"
	L["撞球位置分配"] = "Soak location assignment"
end
---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters[2688] = {
	engage_id = 3122,
	npc_id = {"237661", "237660", "237662"},
	alerts = {
		{ -- NPC
			npcs = {
				{32500},--【阿达拉斯·暮焰】
				{31792},--【维拉瑞安·血愤】
				{31791},--【伊利萨·悲夜】
			},
			options = {
				{ -- 首领模块 姓名板标记 阿达拉斯·暮焰
					category = "BossMod",
					spellID = 1232569,
					enable_tag = "none",
					name = string.format(L["NAME姓名板标记"], T.GetNameFromNpcID("237661"))..T.hex_str(L["虚空"], {.23, .35, .96}),
					points = {hide = true},
					events = {
						["NAME_PLATE_UNIT_ADDED"] = true,
					},
					custom = {
						{
							key = "test_btn", 
							text = L["测试姓名板标记"],
							onclick = function(alert)
								T.ShowAllNameplateExtraTex("npc237661")
								C_Timer.After(3, function()
									T.HideAllNameplateExtraTex()
								end)
							end
						},
					},
					init = function(frame)
						G.NameplateTextures["npc237661"] = {
							w = 70,
							h = 30,
							text = L["虚空"],
							fs = 16,
							fc = {.23, .35, .96},
						}
						
						frame.mobID = "237661"
					end,
					update = function(frame, event, ...)
						if event == "NAME_PLATE_UNIT_ADDED" then
							local unit = ...
							local GUID = UnitGUID(unit)
							local npcID = select(6, strsplit("-", GUID))
							if npcID == frame.mobID then
								T.ShowNameplateExtraTex(unit, "npc237661")
							end
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
				{ -- 首领模块 姓名板标记 维拉瑞安·血愤
					category = "BossMod",
					spellID = 1231501,
					enable_tag = "none",
					name = string.format(L["NAME姓名板标记"], T.GetNameFromNpcID("237660"))..T.hex_str(L["浩劫"], {.72, .94, .19}),
					points = {hide = true},
					events = {
						["NAME_PLATE_UNIT_ADDED"] = true,
					},
					custom = {
						{
							key = "test_btn", 
							text = L["测试姓名板标记"],
							onclick = function(alert)
								T.ShowAllNameplateExtraTex("npc237660")
								C_Timer.After(3, function()
									T.HideAllNameplateExtraTex()
								end)
							end
						},
					},
					init = function(frame)
						G.NameplateTextures["npc237660"] = {
							w = 70,
							h = 30,
							text = L["浩劫"],
							fs = 16,
							fc = {.72, .94, .19},
						}
						
						frame.mobID = "237660"
					end,
					update = function(frame, event, ...)
						if event == "NAME_PLATE_UNIT_ADDED" then
							local unit = ...
							local GUID = UnitGUID(unit)
							local npcID = select(6, strsplit("-", GUID))
							if npcID == frame.mobID then
								T.ShowNameplateExtraTex(unit, "npc237660")
							end
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
				{ -- 首领模块 姓名板标记 伊利萨·悲夜
					category = "BossMod",
					spellID = 1232568,
					enable_tag = "none",
					name = string.format(L["NAME姓名板标记"], T.GetNameFromNpcID("237662"))..T.hex_str(L["复仇"], {.92, .62, .86}),
					points = {hide = true},
					events = {
						["NAME_PLATE_UNIT_ADDED"] = true,
					},
					custom = {
						{
							key = "test_btn", 
							text = L["测试姓名板标记"],
							onclick = function(alert)
								T.ShowAllNameplateExtraTex("npc237662")
								C_Timer.After(3, function()
									T.HideAllNameplateExtraTex()
								end)
							end
						},
					},
					init = function(frame)
						G.NameplateTextures["npc237662"] = {
							w = 70,
							h = 30,
							text = L["复仇"],
							fs = 16,
							fc = {.92, .62, .86},
						}
						
						frame.mobID = "237662"
					end,
					update = function(frame, event, ...)
						if event == "NAME_PLATE_UNIT_ADDED" then
							local unit = ...
							local GUID = UnitGUID(unit)
							local npcID = select(6, strsplit("-", GUID))
							if npcID == frame.mobID then
								T.ShowNameplateExtraTex(unit, "npc237662")
							end
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
			},
		},
		{ -- 吞噬者之怒
			npcs = {
				{32500},--【阿达拉斯·暮焰】
			},
			spells = {
				{1222232, "5,7"},--【吞噬者之怒】
				{1234565},--【吞噬】
				{1222310},--【无餍之饥】
			},
			options = {
				{ -- 图标 吞噬者之怒（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222232,
					hl = "blu",
					ficon = "7",
				},
				{ -- 图标 吞噬（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222307,
					effect = 1,
					hl = "",
					tip = L["吸收治疗"],
				},
				{ -- 首领模块 团队框架吸收治疗数值（待测试）
					category = "BossMod",
					spellID = 1222307,
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
				{ -- 图标 无餍之饥（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222310,
					text = L["易伤"],
					hl = "",
				},		
				{ -- 首领模块 吞噬者之怒 点名统计 逐个填坑（待测试）
					category = "BossMod",
					spellID = 1222232,
					enable_tag = "everyone",
					name = string.format(L["NAME点名排序"], T.GetIconLink(1222232)),
					points = {a1 = "TOPLEFT", a2 = "CENTER", x = -700, y = 350},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						["ADDON_MSG"] = true,
					},
					custom = {
						{
							key = "dispel_index1_bool",
							text = L["接受驱散的序号"].."1",
							default = true,
						},
						{
							key = "dispel_index2_bool",
							text = L["接受驱散的序号"].."2",
							default = true,
						},
						{
							key = "dispel_index3_bool",
							text = L["接受驱散的序号"].."3",
							default = true,
						},
						{
							key = "1_blank",
						},
					},
					init = function(frame)
						frame.aura_id = 1222232
						frame.element_type = "bar"
						frame.color = T.GetSpellColor(1222232)
						frame.role = true
						frame.raid_index = true
						frame.disable_copy_mrt = true
						frame.bar_num = 3
						frame.reset_index = 3
						
						frame.info = {
							{text = "1"},
							{text = "2"},
							{text = "3"},
						}
						
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 2)
						frame.text_frame_macro = T.CreateAlertTextShared("bossmod"..frame.config_id, 1)
						
						function frame:post_display(element, index, unit, GUID)							
							if not element.extra_text then
								local h = element:GetHeight()
								element.extra_text = T.createtext(element, "OVERLAY", floor(h*.6), "OUTLINE", "LEFT")
								element.extra_text:SetPoint("LEFT", element, "RIGHT", 5, 0)
								element:HookScript("OnSizeChanged", function(self, width, height)
									self.extra_text:SetFont(G.Font, floor(height*.6), "OUTLINE")
								end)
							end
							
							element.extra_text:SetText(L["未按宏"])
							
							if GUID == G.PlayerGUID then
								T.Start_Text_Timer(self.text_frame, 5, T.GetSpellIcon(1222232)..L["点你"])
							end
						end
						
						function frame:post_remove(element, index, unit, GUID)
							if GUID == G.PlayerGUID then
								self.text_frame:Hide()
							end
						end
						
						T.InitAuraMods_ByTime(frame)
					end,
					update = function(frame, event, ...)			
						T.UpdateAuraMods_ByTime(frame, event, ...)
						
						if event == "ADDON_MSG" then
							local channel, sender, GUID, message = ...
							if message == "DispelMe" then							
								T.Start_Text_Timer(frame.text_frame_macro, 2, L["已按宏"])
								
								local bar = frame.actives[GUID]
								if bar then
									bar.extra_text:SetText(L["已按宏"])
									local tag = string.format("dispel_index%d_bool", bar.index)
									local info = T.GetGroupInfobyGUID(GUID)
									if info then
										if C.DB["BossMod"][frame.config_id][tag] then
											T.GlowRaidFramebyUnit_Show("proc", "bm"..frame.config_id, info.unit, {.1, 1, 1})
											T.msg(string.format(L["驱散讯息有光环"], info.format_name, T.GetIconLink(frame.aura_id)))
										else
											T.msg(string.format(L["驱散讯息序号过滤"], info.format_name, T.GetIconLink(frame.aura_id)))
										end
									end
								else
									local info = T.GetGroupInfobyGUID(GUID)
									if info then
										T.msg(string.format(L["驱散讯息无光环"], info.format_name, T.GetIconLink(frame.aura_id)))
									end
								end
							end
						elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_AURA_REMOVED" and spellID == frame.aura_id then
								local unit_id = T.GetGroupInfobyGUID(destGUID)["unit"]
								T.GlowRaidFramebyUnit_Hide("proc", "bm"..frame.config_id, unit_id)
							end
						elseif event == "ENCOUNTER_START" then
							local diffcultyID = select(3, ...)
							if diffcultyID == 16 then
								frame.reset_index = 3
							else
								frame.reset_index = 2
							end
						end
					end,
					reset = function(frame, event)
						T.ResetAuraMods_ByTime(frame)
						T.GlowRaidFrame_HideAll("proc","bm"..frame.config_id)
						frame.text_frame:Hide()
						frame.text_frame_macro:Hide()
					end,
				},
			},
		},
		{ -- 虚空瞬步
			npcs = {
				{32500},--【阿达拉斯·暮焰】
			},
			spells = {
				{1227355},--【虚空瞬步】
				{1227685},--【饥渴斩击】
				{1235045},--【湮灭逼近】
			},
			options = {
				{ -- 文字 虚空瞬步 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1227355)..L["倒计时"],
					data = {
						spellID = 1227355,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {33.0, 31.1, 28.1},
								[2] = {21.2, 31.1, 28.1},
								[3] = {21.2, 31.1, 28.1},
								[4] = {21.2, 31.1},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1227355, T.GetIconLink(1227355), self, event, ...)
					end,
				},
				{ -- 计时条 虚空瞬步（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227355,
					sound = "[mindstep]cast",
				},
				{ -- 图标 湮灭逼近（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1235045,
					tip = L["DOT"],
					hl = "pur",
				},
			},
		},
		{ -- 根除
			npcs = {
				{32500},--【阿达拉斯·暮焰】
			},
			spells = {
				{1245743, "12,4"},--【根除】
			},
			options = {
				{ -- 计时条 根除（史诗待测试）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1245743,
					spellIDs = {1245726},
					text = L["躲地板"],
				},
			},
		},
		{ -- 坍缩之星
			npcs = {
				{32566},--【阿达拉斯·暮焰】
			},
			spells = {
				{1233093, "5"},--【坍缩之星】
				{1233105},--【黑暗残渣】
				{1233968, "4"},--【黑洞视界】
			},
			options = {
				{ -- 计时条 坍缩之星（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1233093,
					text = L["拉人"],
					sound = "[pull]cast",
				},
				{ -- 图标 黑暗残渣（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233105,
					tip = L["DOT"],
					hl = "red",
				},
				{ -- 图标 黑洞视界（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233968,
					tip = L["DOT"],
				},
			},
		},
		{ -- 恶魔追击
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1227809, "5"},--【恶魔追击】
				{1247415, "12"},--【弱化猎物】
			},
			options = {
				{ -- 文字 恶魔追击 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["冲锋"]..L["倒计时"],
					data = {
						spellID = 1227809,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {42.6, 34.9},
								[2] = {31.0, 34.9},
								[3] = {31.0, 34.9},
								[4] = {31.0},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1227809, L["冲锋"], self, event, ...)
					end,
				},				
				{ -- 首领模块 计时条 恶魔追击（✓）
					category = "BossMod",
					spellID = 1227809,
					name = string.format(L["计时条%s"], T.GetIconLink(1227847)),
					enable_tag = "none",
					points = {hide = true},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,	
					},
					init = function(frame)
						frame.bars = {}
						frame.max_count = 2
						
						function frame:start(index, GUID)
							if not self.bars[GUID] then
								self.bars[GUID] = T.CreateAlertBarShared(2, "bossmod"..self.config_id..GUID, C_Spell.GetSpellTexture(1227847), L["冲锋"], T.GetSpellColor(1227847))
							end
							
							local bar = self.bars[GUID]
							
							local info = T.GetGroupInfobyGUID(GUID)
							bar.mid:SetText(info and info.format_name or "")
							
							T.StartTimerBar(bar, 6, true, true)
								
							if self.diffcultyID == 16 then
								bar.ind_text:SetText(string.format("|cffFFFF00[%d]|r", index))
								T.PlaySound("1302\\charge"..index)
								
								local unit_frame = T.GetUnitFrame(info.unit)
								if unit_frame then					
									T.CreateRFIndex(unit_frame, string.format("|cffFF0000%d|r", index))
									C_Timer.After(6, function()
										T.HideRFIndexbyParent(unit_frame)
									end)
								end
							else
								bar.ind_text:SetText("")
								T.PlaySound("charge")
							end
								
							C_Timer.After(1, function()
								local name = T.GetNameByGUID(GUID)
								if name then
									T.SpeakText(name)
								end
							end)
						end
					end,
					update = function(frame, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local unit, cast_GUID, cast_spellID = ...
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_AURA_APPLIED" and spellID == 1227847 then -- 恶魔追击
								frame.count = frame.count + 1
            
								if frame.count == (frame.max_count + 1) then
									frame.count = 1
								end
								
								frame:start(frame.count, destGUID)
							end
						elseif event == "ENCOUNTER_START" then
							frame.count = 0
							
							frame.diffcultyID = select(3, ...)
							
							if frame.diffcultyID == 16 then
								frame.max_count = 3
							else
								frame.max_count = 2
							end
						end
					end,
					reset = function(frame, event)
						for _, bar in pairs(frame.bars) do
							T.StopTimerBar(bar, true, true)
						end
						frame.bars = table.wipe(frame.bars)
						T.HideAllRFIndex()
					end,
				},
				{ -- 首领模块 恶魔追击 计时圆圈（✓）
					category = "BossMod",
					spellID = 1227847,
					enable_tag = "none",
					name = T.GetIconLink(1227847)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1227847] = { -- 恶魔追击
								event = "SPELL_AURA_APPLIED",
								target_me = true,
								dur = 6,
								color = {1, 0, 0},
							},
						}
						T.InitCircleTimers(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateCircleTimers(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetCircleTimers(frame)
					end,
				},
				{ -- 图标 弱化猎物（史诗待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1247415,
					tip = L["易伤"],
				},
			},
		},
		{ -- 刃舞
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1241306},--【刃舞】
			},
			options = {
				{ -- 计时条 刃舞（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1241254,
					dur = 3,
					sound = "[mindstep]cast",
				},
			},
		},
		{ -- 眼棱
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1218103, "0,12"},--【眼棱】
				{1221490, "12"},--【邪能灼痕】
				{1225127},--【邪能之刃】
			},
			options = {		
				{ -- 文字 眼棱 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = T.GetIconLink(1218103)..L["倒计时"],
					data = {
						spellID = 1218103,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {19.7, 34.9, 34.9},
								[2] = {8.1, 34.9, 34.9},
								[3] = {8.2, 34.9, 34.9},
								[4] = {8.2, 34.9},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1218103, T.GetIconLink(1218103), self, event, ...)
					end,
				},
				{ -- 计时条 眼棱（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1218103,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1218103cast", "cast"),
				},
				{ -- 嘲讽提示 邪能灼痕（待测试）
					category = "BossMod",
					spellID = 1221490,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1221490),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.boss_npcID = "237660"
						frame.aura_spellIDs = {
							[1221490] = 1, -- 邪能灼痕
						}
						frame.cast_spellIDs = {
							[1218103] = true, -- 眼棱
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
				{ -- 换坦计时条 邪能灼痕（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1221490,
					ficon = "0",
					tank = true,
				},
				{ -- 图标 邪能之刃（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1225130,
					tip = L["DOT"],
				},
			},
		},
		{ -- 邪能地狱
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1223725, "2"},--【邪能地狱】
			},
			options = {
				{ -- 计时条 邪能地狱（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228238,
					text = L["全团AE"],
				},
				{ -- 图标 邪能地狱（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1245384,
					tip = L["DOT"],
				},
				{ -- 图标 邪能地狱（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1223725,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 邪能冲撞
			npcs = {
				{32552},--【维拉瑞安·血愤】
			},
			spells = {
				{1233863, "5"},--【邪能冲撞】
			},
			options = {
				{ -- 图标 邪能冲撞（待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1223042,
					tip = L["射线"],
					sound = "[ray]",
					hl = "org_flash",
				},
			},
		},
		{ -- 破裂
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1241833, "0,5"},--【破裂】
				{1226493},--【破碎之魂】
				{1241917},--【脆弱】
			},
			options = {
				{ -- 文字 破裂 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = T.GetIconLink(1241833)..L["倒计时"],
					data = {
						spellID = 1241833,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {15.3, 34.9, 34.9},
								[2] = {3.6, 34.9, 34.9},
								[3] = {3.6, 34.9, 34.9},
								[4] = {3.6, 34.9},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1241833, T.GetIconLink(1241833), self, event, ...)
					end,
				},
				{ -- 计时条 破裂（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1241833,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1241833cast", "cast"),
				},
				{ -- 嘲讽提示 破碎灵魂（待测试）
					category = "BossMod",
					spellID = 1226493,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1226493)..T.GetIconLink(1241917),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.boss_npcID = "237662"
						frame.aura_spellIDs = {
							[1226493] = 1, -- 破碎灵魂
							[1241917] = 1, -- 脆弱
						}
						frame.cast_spellIDs = {
							[1241833] = true, -- 破裂
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
				{ -- 换坦计时条 破碎灵魂（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1226493,
					ficon = "0",
					tank = true,
				},
				{ -- 换坦计时条 脆弱（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1241917,
					ficon = "0",
					tank = true,
				},
				{ -- 图标 脆弱（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1241946,
					tip = L["DOT"],
				},
			},
		},
		{ -- 幽魂炸弹
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1242259},--【幽魂炸弹】
				{1242284},--【灵魂重碾】
				{1242304, "4"},--【驱逐灵魂】
			},
			options = {
				{ -- 文字 幽魂炸弹 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["吸收盾"]..L["倒计时"],
					data = {
						spellID = 1242259,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {32.5, 34.9, 34.9},
								[2] = {21, 34.9, 34.9},
								[3] = {21, 34.9, 34.9},
								[4] = {21, 34.9},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1242259, L["吸收盾"], self, event, ...)
					end,
				},
				{ -- 计时条 幽魂炸弹（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1242259,
					glow = true,
				},
				{ -- 图标 灵魂重碾（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242284,
					effect = 1,
					hl = "",
					tip = L["吸收治疗"],
				},
				{ -- 图标 驱逐灵魂（待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242304,
					tip = L["DOT"],
				},
			},
		},
		{ -- 锁链咒符
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1240891, "12"},--【锁链咒符】
			},
			options = {				
				{ -- 计时条 锁链咒符（史诗待测试）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 1240891,
					dur = 2.5,
				},
				{ -- 图标 锁链咒符（史诗待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1223624,
					tip = L["减速"].."40%",
				},
			},
		},
		{ -- 献祭光环
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1225154, "2"},--【献祭光环】
			},
			options = {
				
			},
		},		
		{ -- 地狱火撞击
			npcs = {
				{32545},--【伊利萨·悲夜】
			},
			spells = {
				{1227113, "5"},--【地狱火撞击】
			},
			options = {
				{ -- 文字 地狱火撞击 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["大圈"].."+"..L["冲击波"]..L["倒计时"],
					data = {
						spellID = 1233672,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[3.5] = {6.3, 9.0, 9.0},
								[4.5] = {6.8, 9.0, 9.0, 9.0, 9.0},
							},
						},
						cd_args = {
							round = true,
							count_down_start = 5,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1233672, L["大圈"].."+"..L["冲击波"], self, event, ...)
					end,
				},
				{ -- 计时条 地狱火撞击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1233672,
					dur = 2.3,
					sound = "[safe]cast",
					glow = true,
				},			
			},
		},
		{ -- 邪能毁灭
			npcs = {
				{32545},--【伊利萨·悲夜】
			},
			spells = {
				{1227117, "5"},--【邪能毁灭】
				{1233381},--【凋零烈焰】
			},
			options = {
				{ -- 计时条 邪能毁灭（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227117,
					text = L["冲击波"],
					glow = true,
				},
				{ -- 图标 凋零烈焰（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233381,
					tip = L["减速"],
				},
			},
		},		
		{ -- 灵魂束缚
			spells = {
				{1245978, "12"},--【灵魂束缚】
			},
			options = {
				{ -- 图标 灵魂束缚（史诗待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242883,
				},
			},
		},
		{ -- 动荡的灵魂
			spells = {
				{1249198, "4"},--【动荡的灵魂】
			},
			options = {
				{ -- 图标 痛苦光环（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HELPFUL",
					unit = "boss",
					spellID = 1227154,
					tip = L["DOT"],
				},
			},
		},
		{ -- 恶魔变形
			spells = {
				{1232569},--【恶魔变形】
			},
			options = {
				{ -- 计时条 恶魔变形（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232569,
					text = L["阶段转换"],
					sound = "[phase]cast",
				},
			},
		},	
		{ -- 阶段转换
			title = L["阶段转换"],
			options = {
				{
					category = "PhaseChangeData",
					phase = 1.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 2,					
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1242133, -- 灵魂饱噬
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 2.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 2,
				},
				{
					category = "PhaseChangeData",
					phase = 3,					
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1242133, -- 灵魂饱噬
					count = 3,
				},
				{
					category = "PhaseChangeData",
					phase = 3.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 3,
				},
				{
					category = "PhaseChangeData",
					phase = 4,					
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1242133, -- 灵魂饱噬
					count = 5,
				},
				{
					category = "PhaseChangeData",
					phase = 4.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 4,
				},
			},
		},
	},
}