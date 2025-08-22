local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[499] = {2571, 2570, 2573, "c499"}

local function soundfile(filename, arg)
	return string.format("[c499\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c499"] = {
	map_id = 2649,
	alerts = {
		{ -- 阿拉希步兵:防御
			spells = {
				{427342},
			},
			options = {
				{ -- 姓名板光环 防御（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 427342,
				},
			},
		},
		{ -- 热诚的神射手:射击
			spells = {
				{427629},
			},
			options = {
				{ -- 对我施法图标 射击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 427629,
					hl = "yel_flash",
				},
			},
		},
		{ -- 热诚的神射手:随意射击
			spells = {
				{462859},
			},
			options = {
				{ -- 对我施法图标 随意射击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 462859,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 随意射击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 462859,
				},
			},
		},
		{ -- 热诚的神射手:铁蒺藜
			spells = {
				{453458},
			},
			options = {
				{ -- 声音 铁蒺藜（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 453458,
					file = "[mindstep]",
				},
				{ -- 图标 铁蒺藜（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 453461,
					hl = "red",
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 铁蒺藜（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 453461,
					file = "[dispel]",
					ficon = "13",
				},
				{ -- 团队框架高亮 铁蒺藜（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 453461,
					color = "red",
				},			
			},
		},
		{ -- 阿拉希骑士:穿刺
			spells = {
				{444296},
			},
			options = {
				{ -- 图标 穿刺（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 427621,
					hl = "red",
					tip = L["强力DOT"],
					ficon = "13",
					sound = "[defense]",
				},
				{ -- 驱散提示音 穿刺（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 427621,
					file = "[dispel]",
					ficon = "13",
				},
				{ -- 团队框架高亮 穿刺（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 427621,
					color = "red",
				},
			},
		},		
		{ -- 阿拉希骑士:瓦解怒吼
			spells = {
				{427609},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 瓦解怒吼（✓）
					category = "BossMod",
					spellID = 453810,
					name = T.GetIconLink(427609)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["206696"] = {
								engage_cd = 20.1,
								cast_cd = 21.8,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 427609
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						
						T.InitMobCooldownText(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
				{ -- 首领模块 计时条 瓦解怒吼（✓）
					category = "BossMod",
					spellID = 427609,
					name = string.format(L["计时条%s"], T.GetIconLink(427609)),
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_SPELLCAST_CHANNEL_START"] = true,
						["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
						["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
					},
					init = function(frame)
						local name = C_Spell.GetSpellName(427609)
						local icon = C_Spell.GetSpellTexture(427609)
						local color = T.GetSpellColor(427609)
						
						frame.bar = T.CreateAlertBarShared(1, "bossmod"..frame.config_id, icon, name, color)
						frame.bar.glow:SetBackdropBorderColor(unpack(color))
						frame.bar.glow:Show()
						
						function frame:UpdateCastState(start)
							if self.cast_exp then
								if UnitCastingInfo("player") then
									local endTimeMS = select(5, UnitCastingInfo("player"))
									if endTimeMS < self.cast_exp then
										self.bar.mid:SetText(string.format("|cff00ff00%s|r", L["安全施法"]))
										T.PlaySound("safecasting")
									else
										self.bar.mid:SetText(string.format("|cffff0000%s|r", L["停止施法"]))
										T.PlaySound("stopcasting")
									end
								elseif UnitChannelInfo("player") then
									local endTimeMS = select(5, UnitChannelInfo("player"))
									if endTimeMS < self.cast_exp then
										self.bar.mid:SetText(string.format("|cff00ff00%s|r", L["安全施法"]))
										T.PlaySound("safecasting")
									else
										self.bar.mid:SetText(string.format("|cffff0000%s|r", L["停止施法"]))
										T.PlaySound("stopcasting")
									end
								else
									self.bar.mid:SetText("")
									if start then
										T.PlaySound("interruptcasting")
									end
								end
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_START" then
							local unit, cast_GUID, cast_spellID = ...
							if unit and cast_GUID and cast_spellID then
								if cast_spellID == 427609 and not frame.cast_exp then
									local startTimeMS, endTimeMS = select(4, UnitCastingInfo(unit))
									local cast_dur = (endTimeMS - startTimeMS)/1000
									T.StartTimerBar(frame.bar, cast_dur, true, true)
									frame.bar.anim:Play()
									frame.cast_exp = endTimeMS
									frame:UpdateCastState(true)
								elseif unit == "player" then
									frame:UpdateCastState()
								end
							end
						elseif event == "UNIT_SPELLCAST_STOP" then
							local unit, cast_GUID, cast_spellID = ...
							if unit and cast_GUID and cast_spellID then
								if cast_spellID == 427609 and frame.cast_exp then
									T.StopTimerBar(frame.bar, true, true)
									frame.bar.anim:Stop()
									frame.cast_exp = nil
								elseif unit == "player" then
									frame:UpdateCastState()
								end
							end
						elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
							local unit = ...
							if unit == "player" then
								frame:UpdateCastState()
							end
						elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
							local unit = ...
							if unit == "player" then
								frame:UpdateCastState()
							end
						end
					end,
					reset = function(frame, event)
						T.StopTimerBar(frame.bar, true, true)
						frame.bar.anim:Stop()
						frame.cast_exp = nil
					end,
				},
			},
		},
		{ -- 狂热的咒术师 亡灵法师 火球术
			spells = {
				{427469},
			},
			options = {
				{ -- 团队框架图标 火球术（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 427469,
				},
				{ -- 姓名板打断图标 火球术（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 427469,
					mobID = "206698,221760",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 狂热的咒术师:烈焰风暴
			spells = {
				{427484},
			},
			options = {
				{ -- 计时条 烈焰风暴（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 427484,
					sound = "[dodge_circle]cast",
				},
			},
		},
		{ -- 虔诚的牧师:强效治疗术
			spells = {
				{427356},
			},
			options = {
				{ -- 计时条 强效治疗术（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 427356,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 强效治疗术（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 427356,
					mobID = "206697",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 虔诚的牧师:神圣惩击
			spells = {
				{427357},
			},
			options = {
				{ -- 对我施法图标 神圣惩击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 427357,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 神圣惩击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 427357,
				},
				{ -- 姓名板打断图标 神圣惩击（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 427357,
					mobID = "206697,212827",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 作战山猫:飞扑 痛苦撕裂
			spells = {
				{446776},
				{427635},
			},
			options = {
				{ -- 图标 痛苦撕裂（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 427635,
					hl = "red",
					tip = L["强力DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 痛苦撕裂（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 427635,
					file = "[dispel]",
					ficon = "13",
				},
				{ -- 团队框架高亮 痛苦撕裂（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 427635,
					color = "red",
				},
			},
		},	
		{ -- 高阶牧师艾姆雅:反射护盾
			spells = {
				{464240},
			},
			options = {
				{ -- 计时条 反射护盾（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 464240,
					spellIDs = {428150},
					sound = "[reflect_shield]cast",
					glow = true,
				},
				{ -- 姓名板光环 反射护盾（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 464240,
					spellIDs = {428150},
				},
			},
		},
		{ -- 守卫队长苏雷曼:盾牌猛击
			spells = {
				{448485},
			},
			options = {
				{ -- 对我施法图标 盾牌猛击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 448485,
					hl = "yel_flash",
					tip = L["击退"],
					sound = "[knockoff]",
				},
			},
		},
		{ -- 守卫队长苏雷曼:雷霆一击
			spells = {
				{448492},
			},
			options = {				
				{ -- 首领模块 小怪技能倒计时 雷霆一击（✓）
					category = "BossMod",
					spellID = 448492,
					name = T.GetIconLink(448492)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["212826"] = {
								engage_cd = 15.3,
								cast_cd = 15.8,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 448492
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						frame.sound_default = false
						
						T.InitMobCooldownText(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},				
				{ -- 计时条 雷霆一击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 448492,
					sound = "[aoe]cast",
				},
				{ -- 图标 雷霆一击（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 448492,
					tip = L["减速"].."50%",
				},
			},
		},
		{ -- 铸炉大师达米安:烈焰圣印
			spells = {
				{427950},
			},
			options = {
				{ -- 计时条 烈焰圣印（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 427950,
					text = L["躲地板"],
					sound = "[mindstep]cast",
				},
				{ -- 图标 熔岩池（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 427900,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 铸炉大师达米安:热浪
			spells = {
				{427897},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 热浪（✓）
					category = "BossMod",
					spellID = 427897,
					name = T.GetIconLink(427897)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["212831"] = {
								engage_cd = 9.9,
								cast_cd = 18.2,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 427897
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						
						T.InitMobCooldownText(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
				{ -- 计时条 热浪（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 427897,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
				},
				{ -- 图标 热浪（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 427897,
					tip = L["减速"].."70%",
				},
			},
		},
		{ -- 艾蕾娜·安博兰兹
			npcs = {
				{27828},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 圣光烁辉（✓）
					category = "BossMod",
					spellID = 424431,
					name = T.GetIconLink(424431)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						["ENCOUNTER_START"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["211290"] = {
								engage_cd = 25.2,
								cast_cd = 36.4,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 424431
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						frame.only_trash = true
						
						T.InitMobCooldownText(frame)						
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
			},
		},
		{ -- 歇尼麦尔中士
			npcs = {
				{27825},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 跃进打击（✓）
					category = "BossMod",
					spellID = 424423,
					name = T.GetIconLink(424423)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						["ENCOUNTER_START"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["239836"] = {
								engage_cd = 4.9,
								cast_cd = 12.1,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 424423
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						frame.only_trash = true
						
						T.InitMobCooldownText(frame)						
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
			},
		},
		{ -- 泰纳·杜尔玛
			npcs = {
				{27825},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 余烬风暴（✓）
					category = "BossMod",
					spellID =  424462,
					name = T.GetIconLink(424462)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
						["ENCOUNTER_START"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["239834"] = {
								engage_cd = 31.2,
								cast_cd = 33.7,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 424462
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						frame.only_trash = true
						
						T.InitMobCooldownText(frame)						
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
			},
		},
		{ -- 热切的圣骑士:奉献
			spells = {
				{424429},
			},
			options = {
				{ -- 计时条 奉献（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 424429,
					sound = "[outcircle]cast",
				},
				{ -- 图标 奉献（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 424430,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 热切的圣骑士:神圣鸣罪
			spells = {
				{448791},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 神圣鸣罪（✓）
					category = "BossMod",
					spellID = 448791,
					name = T.GetIconLink(448791)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["206704"] = {
								engage_cd = 15.4,
								cast_cd = 22.5,
								cast_gap = 3,
							},
						}
						
						frame.cast_spellID = 448791
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						
						T.InitMobCooldownText(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},				
				{ -- 计时条 神圣鸣罪（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 448791,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
				},
			},
		},
		{ -- 热心的圣殿骑士:圣殿骑士之怒
			spells = {
				{444728},
			},
			options = {
				{ -- 姓名板光环 圣殿骑士之怒（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 444728,
					ficon = "7",
				},
				{ -- 驱散提示音 圣殿骑士之怒（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 444728,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},		
		{ -- 光耀之子:纯净
			spells = {
				{448787},
			},
			options = {
				{ -- 对我施法图标 纯净（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 448787,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 纯净（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 448787,
				},
				{ -- 图标 纯净（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 448787,
					hl = "red",
					tip = L["强力DOT"],
					sound = "[defense]",
				},
				{ -- 团队框架高亮 纯净（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 448787,
					color = "red",
				},
			},
		},
		{ -- 光耀之子:强光迸发
			spells = {
				{427601},
			},
			options = {
				{ -- 计时条 强光迸发（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 427601,
					sound = "[outcircle]cast",
				},
			},
		},
		{ -- 亡灵法师:连珠火球
			spells = {
				{444743},
			},
			options = {
				{ -- 计时条 连珠火球（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 444743,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 连珠火球（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 444743,
					mobID = "221760",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 布朗派克爵士:辉耀烈焰
			spells = {
				{451763},
			},
			options = {
				{ -- 声音 辉耀烈焰（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 451763,
					file = "[defense]",
				},
				{ -- 图标 辉耀烈焰（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 451764,
					tip = L["DOT"],
				},
			},
		},
		{ -- 布朗派克爵士:炽热打击
			spells = {
				{435165},
			},
			options = {
				{ -- 对我施法图标 炽热打击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 435165,
					hl = "yel_flash",
				},
				{ -- 图标 炽热打击（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 435165,
					hl = "",
					tip = L["DOT"],
				},
			},
		},
	},
}