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

G.Encounters[2691] = {
	engage_id = 3135,
	npc_id = {"233824", "241517", "234478"},
	alerts = {
		{ -- 湮灭	
			spells = {
				{1229327, "4"},--【湮灭】
			},
			options = {
				
			},
		},
		{ -- 千钧猛击
			spells = {
				{1230087, "0"},--【千钧猛击】
			},
			options = {
				{ -- 文字 千钧猛击 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1230087)..L["倒计时"],
					data = {
						spellID = 1230087,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {23.5, 47.1, 47.1, 47.1},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1230087, T.GetIconLink(1230087), self, event, ...)
					end,
				},
				{ -- 计时条 千钧猛击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1230087,
					sound = "[knockoff]cast,cd3",
				},				
			},
		},
		{ -- 活体物质
			npcs = {
				{33480, "1"},--【活体物质】 
			},
			spells = {
				{1231005},--【裂变】
				{1248240, "1,12"},--【无限可能】
				{1228206},--【过量物质】
				{1228207},--【集体引力】
			},
			options = {
				{ -- 首领模块 裂变 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1231005,
					enable_tag = "none",
					name = T.GetIconLink(1231005)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,	
					},
					custom = {
						{
							key = "hp_perc_sl",
							text = L["血量阈值百分比"],
							default = 50,
							min = 10,
							max = 90,
						},
					},
					init = function(frame)
						frame.mobs = {}
						frame.check = false
					end,
					update = function(frame, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_AURA_APPLIED" and spellID == 1231005 then -- 裂变
								table.insert(frame.mobs, destGUID)
								if not frame.check then
									frame.check = true
									T.AddPersonalSpellCheckTag("bossmod"..frame.config_id, C.DB["BossMod"][frame.config_id]["hp_perc_sl"], {"TANK"})
								end
							elseif sub_event == "SPELL_AURA_REMOVED" and spellID == 1231005 then -- 裂变
								tDeleteItem(frame.mobs, destGUID)
								if #frame.mobs == 0 and frame.check then
									frame.check = false
									T.RemovePersonalSpellCheckTag("bossmod"..frame.config_id)
								end
							end
						elseif event == "ENCOUNTER_START" then
							frame.mobs = table.wipe(frame.mobs)
							frame.check = false
						end
					end,
					reset = function(frame, event)
						T.RemovePersonalSpellCheckTag("bossmod"..frame.config_id)
					end,
				},
				{ -- 图标 过量物质（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1228206,
					hl = "yel",
				},
				{ -- 首领模块 过量物质 多人光环（✓）
					category = "BossMod",
					spellID = 1228206,
					enable_tag = "rl",
					name = string.format(L["NAME多人光环提示"], T.GetIconLink(1228206)),	
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -500},
					events = {
						["UNIT_AURA"] = true,	
					},
					init = function(frame)
						frame.spellIDs = {
							[1228206] = {},-- 过量物质
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
		{ -- 凡躯的脆弱
			spells = {
				{1230168},--【凡躯的脆弱】受到的物理伤害提高100%。该效果可叠加。
			},
			options = {
				{ -- 换坦计时条 凡躯的脆弱（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1230168,
					ficon = "0",
					tank = true,
				},
			},
		},
		{ -- 吞噬
			spells = {
				{1229038, "4,5"},--【吞噬】
				{1229674},--【吞食饥饿】
			},
			options = {
				{ -- 文字 吞噬 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1229038)..L["倒计时"],
					data = {
						spellID = 1229038,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {11.8, 94.1},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1229038, T.GetIconLink(1229038), self, event, ...)
					end,
				},
				{ -- 计时条 吞噬（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1229038,
					sound = "channel,cd3"
				},
			},
		},
		{ -- 暗物质
			spells = {
				{1230999, "2"},--【暗物质】
				{1231002},--【黑暗能量】
			},
			options = {
				{ -- 文字 暗物质 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["分散"]..L["倒计时"],
					data = {
						spellID = 1230979,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {35.3, 43.6, 50.5},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1230979, L["分散"], self, event, ...)
					end,
				},
				{ -- 计时条 暗物质（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1230979,
					sound = "[spread]cast",
					text = L["分散"],
				},
				{ -- 首领模块 暗物质 计时圆圈（✓）
					category = "BossMod",
					spellID = 1230979,
					enable_tag = "none",
					name = T.GetIconLink(1230979)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1230979] = { -- 暗物质
								event = "SPELL_CAST_START",
								dur = 4,
								color = {1, .5, .1},
								reverse = true,
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
				{ -- 图标 黑暗能量（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1231002,
					tip = L["DOT"].."+"..L["减速"],
				},
			},
		},
		{ -- 破碎空间
			spells = {
				{1243690, "2"},--【破碎空间】
				{1243704, "4,5"},--【反物质】
				{1243699},--【空间碎片】
			},
			options = {
				{ -- 文字 破碎空间 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["大球"]..L["倒计时"],
					data = {
						spellID = 1243690,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {44, 47, 47},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1243690, L["大球"], self, event, ...)
					end,
				},
				{ -- 首领模块 计时条 破碎空间（✓）
					category = "BossMod",
					spellID = 1243690,
					name = string.format(L["计时条%s"], T.GetIconLink(1243690)),
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_SPELLCAST_START"] = true,	
					},
					init = function(frame)
						frame.bar = T.CreateAlertBarShared(1, "bossmod"..frame.config_id, C_Spell.GetSpellTexture(1243690), L["大球"], T.GetSpellColor(1243690))
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_START" then
							local unit, cast_GUID, cast_spellID = ...
							if unit == "boss1" and cast_spellID == 1243690 then -- 破碎空间
								T.StartTimerBar(frame.bar, 4, true, true)
								T.StartCountDown(nil, GetTime() + 4, 4, "prepare_incircle")
							end
						end
					end,
					reset = function(frame, event)
						T.StopTimerBar(frame.bar, true, true)
					end,
				},
			},
		},
		{ -- 引力倒逆
			spells = {
				{1243577, "5,12"},--【引力倒逆】
				{1243609},--【浮空】
				{1250614, "12"},--【畸变之力】
			},
			options = {
				{ -- 文字 引力倒逆 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1243577)..L["倒计时"],
					data = {
						spellID = 1243577,
						events =  {
							["UNIT_AURA_ADD"] = true,
						},	
						info = {52, 42, 51},
					},
					update = function(self, event, ...)
						if event == "ENCOUNTER_START" then
							self.round = true							
							self.last_cast = 0
							self.next_count = 1
							
							local dur = self.data.info[self.next_count]
							if dur then
								T.Start_Text_DelayTimer(self, dur, T.GetIconLink(1243577), true)
							end
						elseif event == "UNIT_AURA_ADD" then
							local unit, spellID = ...
							if spellID == 1243577 and GetTime() - self.last_cast > 1 then
								self.last_cast = GetTime()
								self.next_count = self.next_count + 1
								
								local dur = self.data.info[self.next_count]
								if dur then
									T.Start_Text_DelayTimer(self, dur, T.GetIconLink(1243577), true)
								end
							end
						end
					end,
				},
				{ -- 首领模块 引力倒逆 计时圆圈（✓）
					category = "BossMod",
					spellID = 1243577,
					enable_tag = "none",
					name = T.GetIconLink(1243577)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1243577] = { -- 引力倒逆
								unit = "player",
								aura_type = "HARMFUL",
								color = {1, 1, 0},
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
				{ -- 图标 浮空（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1243609,
					hl = "yel",
				},
				{ -- 首领模块 浮空 多人光环（✓）
					category = "BossMod",
					spellID = 1243609,
					enable_tag = "rl",
					name = string.format(L["NAME多人光环提示"], T.GetIconLink(1243609)),	
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -400},
					events = {
						["UNIT_AURA"] = true,	
					},
					init = function(frame)						
						frame.spellIDs = {
							[1243609] = {},-- 浮空
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
		{ -- 虚空领主之拳
			spells = {
				{1227665, "0"},--【虚空领主之拳】
			},
			options = {
				
			},
		},
		{ -- 宇宙辐射
			spells = {
				{1228367},--【宇宙辐射】
			},
			options = {
				
			},
		},
		{ -- 翔空雷什
			spells = {
				{1235114},--【翔空雷什】
				{1235467, "5"},--【晦暗之门】
				{1241188, "4"},--【无尽黑暗】
				{1237080, "4"},--【破碎世界】
				{1235490, "4"},--【天体物理射流】
				{1232987, "4"},--【黑洞】
			},
			options = {
				
			},
		},
		{ -- 星辰之核
			spells = {
				{1246930},--【星辰之核】
				{1246948},--【迸射流星】
			},
			options = {
				{ -- 图标 星辰之核（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1246930,
					hl = "yel",
				},
			},
		},
		{ -- 灭绝
			spells = {
				{1238765, "4"},--【灭绝】
			},
			options = {
				{ -- 文字 灭绝 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["躲地板"]..L["倒计时"],
					data = {
						spellID = 1238765,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[2] = {26, 35.2},
								[3] = {32, 35.2},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1238765, L["躲地板"], self, event, ...)
					end,
				},
				{ -- 计时条 灭绝（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 1238765,
					icon_tex = 132153,
					dur = 8.5,
					text = L["躲地板"],
					glow = true,
				},
				{ -- 图标 灭绝（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1238773,
					tip = L["昏迷"],
				},
			},
		},
		{ -- 伽马爆发
			spells = {
				{1237319, "2,5"},--【伽马爆发】
			},
			options = {
				{ -- 文字 伽马爆发 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["推人"]..L["倒计时"],
					data = {
						spellID = 1237319,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},					
						info = {
							["all"] = {
								[2] = {40},
								[3] = {45},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss", 1237319, L["推人"], self, event, ...)
					end,
				},
				{ -- 计时条 伽马爆发（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1237319,
					text = L["推人"],
					sound = "[push]cast,cd3",
					glow = true,
				},
			},
		},
		{ -- 引力扭曲
			spells = {
				{1234242, "12"},--【引力扭曲】
			},
			options = {
				
			},
		},
		{ -- 倾压引力
			spells = {
				{1234243},--【倾压引力】
				{1234251},--【碾碎】
			},
			options = {
				
			},
		},
		{ -- 引力倒转
			spells = {				
				{1234244},--【引力倒转】
			},
			options = {
				
			},
		},
		{ -- 蚀盛
			spells = {
				{1237690, "4"},--【蚀盛】
			},
			options = {
				{ -- 计时条 蚀盛（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1237690,
				},
			},
		},		
		{ -- 阿托席恩:物质喷发
			npcs = {
				{32741},--【阿托席恩】 
			},
			spells = {
				{1237694, "3"},--【物质喷发】
				{1237696},--【碎片地带】
			},
			options = {
				{ -- 文字 物质喷发 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["头前"]..L["倒计时"],
					data = {
						spellID = 1237694,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[2] = {20, 17.5, 17.7},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1237694, L["头前"], self, event, ...)
					end,
				},
				{ -- 计时条 物质喷发（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1237694,
					text = L["头前"],
				},
				{ -- 图标 碎片地带（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1237696,
					tip = L["DOT"].."+"..L["减速"],
				},
			},
		},
		{ -- 阿托席恩:物质破坏
			npcs = {
				{32741, "12"},--【阿托席恩】 
			},
			spells = {
				{1249423},--【物质破坏】 
				{1237696},--【碎片地带】
			},
			options = {
			
			},
		},
		{ -- 帕哥斯:星尘新星
			npcs = {
				{32745},--【帕哥斯】
			},
			spells = {
				{1237695, "3"}, --【星尘新星】
				{1237696}, --【碎片地带】
				
			},
			options = {
				{ -- 文字 星尘新星 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["大圈"]..L["倒计时"],
					data = {
						spellID = 1237695,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[3] = {27.2, 35.3},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1237695, L["大圈"], self, event, ...)
					end,
				},
				{ -- 计时条 星尘新星（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1237695,
				},
			},
		},
		{ -- 帕哥斯:星辰碎片冲击
			npcs = {
				{32745, "12"},--【帕哥斯】
			},
			spells = {
				{1249454},--【星辰碎片冲击】
				{1249456},--【星辰碎片】
				{1254384},--【星辰迸发】
				{1237696},--【碎片地带】
			},
			options = {
				
			},
		},	
		{ -- 阿托席恩 帕哥斯:征服者的十字
			npcs = {
				{32741},--【阿托席恩】
				{32745},--【帕哥斯】
			},
			spells = {
				{1239262, "1,12"},--【征服者的十字】虚空领主召唤虚空守卫方阵来争夺领地，并限制玩家移动。
			},
			options = {
				{ -- 文字 征服者的十字 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["召唤小怪"]..L["倒计时"],
					data = {
						spellID = 1239262,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[2] = {13, 35.3},
								[3] = {20, 35.3},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1239262, L["召唤小怪"], self, event, ...)
					end,
				},
				{ -- 计时条 征服者的十字（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1239262,
					text = L["召唤小怪"],
					sound = "[add]cast",
				},
			},
		},
		{ -- 虚空守卫
			npcs = {
				{33583},--【虚空守卫】 
			},
			spells = {
				{1239270},--【虚空守护】
				{1246537},--【熵能统合】
			},
			options = {
				{ -- 图标 虚空守护（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1239270,
					hl = "red",
					tip = L["强力DOT"],
				},
				{ -- 团队框架高亮 虚空守护（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1239270,
					color = "org",
				},
			},
		},
		{ -- 虚无束缚者
			npcs = {
				{33586},--【虚无束缚者】 
			},
			spells = {
				{1246541},--【虚无缠缚】
				{1249248, "12"},--【无边无界】
			},
			options = {
				{ -- 计时条 虚无缠缚（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1246541,
				},
				{ -- 图标 虚无缠缚（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1246542,
					tip = L["DOT"].."+"..L["减速"],
					hl = "org",
					sound = "[defense]",
				},
				{ -- 首领模块 虚无缠缚 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1246542,
					enable_tag = "none",
					name = T.GetIconLink(1246542)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1246542] = 0,
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
			},
		},
		{ -- 阿托席恩 帕哥斯:湮灭之触
			npcs = {
				{32741},--【阿托席恩】
				{32745},--【帕哥斯】
			},
			spells = {
				{1246143, "0,4"},--【湮灭之触】
			},
			options = {
				{ -- 换坦计时条 湮灭之触（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1246143,
					ficon = "0",
					tank = true,
				},
			},
		},
		{ -- 动荡能量
			spells = {
				{1245292, "1"},--【动荡能量】
			},
			options = {
				{ -- 计时条 动荡能量（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "boss",
					spellID = 1245292,
					text = L["BOSS易伤"],
				},
			},
		},
		{ -- 吸积盘
			spells = {
				{1233292},--【吸积盘】
			},
			options = {
				
			},
		},		
		{ -- 熄灭众星
			spells = {
				{1231716, "2"},--【熄灭众星】
				{1232394},--【重力井】
				{1248479, "4,12"},--【星辰过载】
			},
			options = {
				{ -- 计时条 熄灭众星（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1231716,
				},
				{ -- 图标 重力井（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1232394,
					hl = "gre",
				},
			},
		},
		{ -- 吞噬
			spells = {
				{1233539, "4,5,12"},--【吞噬】
				{1233557, "5"},--【密度】
				{1232973},--【超级新星】
			},
			options = {				
				{ -- 文字 吞噬 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1233539)..L["倒计时"],
					data = {
						spellID = 1233539,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[4] = {30.9, 100},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1233539, T.GetIconLink(1233539), self, event, ...)
					end,
				},
				{ -- 计时条 吞噬（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1233539,
					sound = "channel,cd3"
				},
				{ -- 文字 超级新星 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1232973)..L["倒计时"],
					data = {
						spellID = 1232973,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[4] = {39.8, 14.5, 33.3, 33.3, 18.9, 14.4},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1232973, T.GetIconLink(1232973), self, event, ...)
					end,
				},
				{ -- 计时条 超级新星（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232973,
					sound = soundfile("1232973cast", "cast"),
				},
				{ -- 计时条 超级新星（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_SUCCESS",
					spellID = 1232973,
					dur = 5,
					text = L["全团AE"],
				},
			},
		},	
		{ -- 昏天黑地
			spells = {
				{1234052, "4"},--【昏天黑地】
				{1234054},--【暗影震荡】
			},
			options = {
				{ -- 文字 昏天暗地 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["圆环"]..L["倒计时"],
					data = {
						spellID = 1234044,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[4] = {64.3, 33.3, 66.7},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1234044, L["圆环"], self, event, ...)
					end,
				},
				{ -- 计时条 昏天暗地（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1234044,
					text = L["圆环"],
					sound = "[ring]cast",
				},
				{ -- 图标 暗影震荡（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1234054,
					tip = L["易伤"].."400%",
					hl = "red",
					sound = "[sound_water]cd3",
				},
				{ -- 首领模块 暗影震荡 计时圆圈（✓）
					category = "BossMod",
					spellID = 1234054,
					enable_tag = "none",
					name = T.GetIconLink(1234054)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1234054] = { -- 暗影震荡
								unit = "player",
								aura_type = "HARMFUL",
								color = {1, 0, 0},
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
			},
		},
		{ -- 寰宇崩塌
			spells = {
				{1234263, "0"},--【寰宇崩塌】
				{1234266, "0"},--【寰宇脆弱】
			},
			options = {
				{ -- 文字 寰宇崩塌 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["拉人"]..L["倒计时"],
					data = {
						spellID = 1234263,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[4] = {48.7, 33.3, 33.3, 33.3, 33.3},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1234263, L["拉人"], self, event, ...)
					end,
				},
				{ -- 计时条 寰宇崩塌（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1234263,
					show_tar = true,
					sound = "[pull]cast,cd3"
				},
				{ -- 换坦计时条 寰宇脆弱（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1234266,
					ficon = "0",
					tank = true,
				},
				{ -- 首领模块 寰宇崩塌 计时圆圈（✓）
					category = "BossMod",
					spellID = 1234263,
					enable_tag = "none",
					name = T.GetIconLink(1234263)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1234263] = { -- 寰宇崩塌
								event = "SPELL_CAST_START",
								dur = 4,
								color = {0, 1, 1},
								reverse = true,
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
			},
		},
		{ -- 虚空之握
			spells = {
				{1250055, "2"},--【虚空之握】
			},
			options = {
				{ -- 图标 虚空之握（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1250055,
					tip = L["强力DOT"].."+"..L["减速"],
					hl = "red",
					sound = "[defense]",
				},
				{ -- 首领模块 虚空之握 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1250055,
					enable_tag = "none",
					name = T.GetIconLink(1250055)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1250055] = 0,
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
				{ -- 团队框架高亮 虚空之握（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1250054,
					color = "red",
				},
				{ -- 首领模块 虚空之握 点名统计 整体排序（✓）
					category = "BossMod",
					spellID = 1250054,
					enable_tag = "none",
					name = string.format(L["NAME点名排序"], T.GetIconLink(1250055)),
					points = {a1 = "TOPLEFT", a2 = "CENTER", x = -700, y = 400},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.aura_id = 1250055
						frame.element_type = "bar"
						frame.color = T.GetSpellColor(1250055)
						frame.raid_index = true
						frame.disable_copy_mrt = true
						frame.support_spells = 10
						frame.bar_num = 5
					
						frame.info = {
							{text = "1"},
							{text = "2"},
							{text = "3"},
							{text = "4"},
							{text = "5"},
						}
						
						frame.total_aura_num = 4
						frame.last_cast = 0
						frame.count = 0
						
						T.InitAuraMods_ByMrt(frame)
					end,
					update = function(frame, event, ...)
						if frame.difficultyID == 16 then
							if event == "COMBAT_LOG_EVENT_UNFILTERED" then
								local _, sub_event, _, sourceGUID, sourceName, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
								if sub_event == "SPELL_AURA_APPLIED" and spellID == 1250055 then
									if GetTime() - frame.last_cast > 3 then
										frame.last_cast = GetTime()
										frame.count = frame.count + 1
										if frame.count == 1 then
											frame.total_aura_num = 4
										else
											frame.total_aura_num = 5
										end
									end
								end
							elseif event == "ENCOUNTER_START" then
								frame.total_aura_num = 4
								frame.last_cast = 0
								frame.count = 0
							end
						end
						
						T.UpdateAuraMods_ByMrt(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetAuraMods_ByMrt(frame)
					end,
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
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 1234898, -- 黑洞视界
				},
				{
					category = "PhaseChangeData",
					phase = 2,
					type = "CLEU",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1246143, -- 湮灭之触
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 2.5,
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1246143, -- 湮灭之触
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 3,
					type = "CLEU",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1246143, -- 湮灭之触
					count = 2,
				},
				{
					category = "PhaseChangeData",
					phase = 3.5,
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1246143, -- 湮灭之触
					count = 2,
				},
				{
					category = "PhaseChangeData",
					phase = 4,
					type = "CLEU",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1231716, -- 熄灭众星
				},
			},
		},
	},
}