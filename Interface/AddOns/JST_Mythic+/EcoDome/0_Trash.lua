local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[542] = {2675, 2676, 2677, "c542"}

local function soundfile(filename, arg)
	return string.format("[c542\\%s]%s", filename, arg or "")
end
--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c542"] = {
	map_id = 2830,
	alerts = {
		{ -- 吃撑的幼虫:啃噬 
			spells = {
				{1229474},
			},
			options = {
				{ -- 计时条 啃噬（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1229474,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 啃噬（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 1229474,
					mobID = "242209",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 吃撑的幼虫:吃撑爆发
			spells = {
				{1231497},
				{1231494},
			},
			options = {
				{ -- 图标 吃撑爆发（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1231494,
					tip = L["DOT"],
				},
			},
		},
		{ -- 肆虐的食腐者:饥饿狂怒
			spells = {
				{1221133},
			},
			options = {
				{ -- 姓名板光环 饥饿狂怒（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1221133,
					ficon = "11",
				},
				{ -- 驱散提示音 饥饿狂怒（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1221133,
					file = "[dispel]",
					ficon = "11",
				},
			},
		},
		{ -- 贪婪的毁灭者:不稳定的喷发
			spells = {
				{1226111},
			},
			options = {
				{ -- 计时条 不稳定的喷发（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1226111,
					show_tar = true,
				},
				{ -- 对我施法图标 不稳定的喷发（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1226111,
					hl = "yel_flash",
					msg = {str_applied = "%name %spell", str_rep = "%spell %dur"},
					sound = "[ray]cast,cd3",
				},
				{ -- 团队框架图标 不稳定的喷发（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1226111,
				},				
				{ -- 首领模块 不稳定的喷发 对我施法计时圆圈（✓）
					category = "BossMod",
					spellID = 1226111,
					enable_tag = "none",
					name = T.GetIconLink(1226111)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_TARGET"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1226111] = {		
								color = {1, 1, 0},
							},
						}
						T.InitCircleCastTimers(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateCircleCastTimers(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetCircleCastTimers(frame)
					end,
				},
			},
		},
		{ -- 贪婪的毁灭者:暴食瘴气
			spells = {
				{1221190},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 暴食瘴气（✓）
					category = "BossMod",
					spellID = 1221191,
					name = T.GetIconLink(1221190)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["236995"] = {
								engage_cd = 6.2,
								cast_cd = 18.2,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 1221190
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["强力DOT"]
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
				{ -- 计时条 暴食瘴气（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1221190,
					show_tar = true,
					sound = "[spread]cast",
				},
				{ -- 团队框架高亮 暴食瘴气（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1221190,
				},
				{ -- 首领模块 暴食瘴气 计时圆圈（✓）
					category = "BossMod",
					spellID = 1221190,
					enable_tag = "none",
					name = T.GetIconLink(1221190)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1221190] = { -- 暴食瘴气
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
				{ -- 团队框架高亮 暴食瘴气（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1221190,
					color = "red",
				},
			},
		},
		{ -- 贪食的饕餮者:暴食猛击
			spells = {
				{1221152},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 暴食猛击（✓）
					category = "BossMod",
					spellID = 1221152,
					name = T.GetIconLink(1221152)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["234883"] = {
								engage_cd = 6.2,
								cast_cd = 18.2,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 1221152
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)						
						frame.count_voice = "en"
						
						T.InitMobCooldownText(frame)						
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
				{ -- 计时条 暴食猛击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1221152,
					text = L["全团AE"].."+"..L["躲圈"],
					sound = "[mindstep]cast",
					glow = true,
				},
			},
		},
		{ -- 过载的哨兵:不稳定的核心
			spells = {
				{1231244},
			},
			options = {
				{ -- 姓名板光环 不稳定的核心（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1231244,
				},
			},
		},
		{ -- 过载的哨兵:奥术猛袭
			spells = {
				{1235368},
			},
			options = {
				{ -- 计时条 奥术猛袭（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1235368,
					sound = "[avoidfront]cast,notank",
				},				
				{ -- 图标 奥术猛袭（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1231224,
					tip = L["DOT"],
				},
			},
		},
		{ -- 过载的哨兵:奥术燃烧
			spells = {
				{1222202},
			},
			options = {
				{ -- 图标 奥术燃烧（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222202,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 驯服的废墟追猎者:迁跃
			spells = {
				{1222356},
			},
			options = {
				{ -- 计时条 迁跃（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1222356,
					sound = "[ray]cast",
				},
			},
		},
		{ -- 废土遗民远遁者:弧光震击
			spells = {
				{1229510},
			},
			options = {
				{ -- 计时条 弧光震击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1229510,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 弧光震击（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 1229510,
					mobID = "234962",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 废土遗民相位剑士:敏锐
			spells = {
				{1231608},
			},
			options = {
				{ -- 姓名板光环 敏锐（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1231608,
					ficon = "7",
				},
				{ -- 驱散提示音 敏锐（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1231608,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 废土遗民祭师:奥术箭(废土遗民诉契者)
			spells = {
				{1222815},
			},
			options = {
				{ -- 姓名板打断图标 奥术箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 1222815,
					mobID = "234957,234955",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 奥术箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1222815,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 奥术箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1222815,
				},
			},
		},
		{ -- 废土遗民祭师:电弧能量
			spells = {
				{1221483},
			},
			options = {
				{ -- 对我施法图标 电弧能量（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1221483,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 电弧能量（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1221483,
				},
				{ -- 图标 电弧能量（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1221483,
					tip = L["强力DOT"],
					hl = "blu",
					ficon = "7",
				},
				{ -- 驱散提示音 电弧能量（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1221483,
					file = "[dispel]",
					ficon = "7",
				},
				{ -- 团队框架高亮 电弧能量（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1221483,
					color = "blu",
				},
			},
		},
		{ -- 废土遗民诉契者:异变仪式
			spells = {
				{1221532},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 异变仪式（✓）
					category = "BossMod",
					spellID = 1221532,
					name = T.GetIconLink(1221532)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["234955"] = {
								engage_cd = 7.7,
								cast_cd = 21.4,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 1221532
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
				{ -- 计时条 异变仪式（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1221532,		
					text = L["全团AE"],
					glow = true,
					sound = "[aoe]cast",
				},
			},
		},
		{ -- 废土遗民诉契者:吞噬灵魂
			spells = {
				{1248701},
			},
			options = {
				{ -- 计时条 吞噬灵魂（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1248699,		
					text = L["转火"],
					sound = "[target]cast",
				},
				{ -- 姓名板光环 灵魂防护（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1248702,
				},
				{ -- 姓名板NPC高亮 挑衅之灵（✓）
					category = "PlateAlert",
					type = "PlateNpcID",
					mobID = "240952",
					hl_np = true,
				},
				{ -- 姓名板光环 干扰仪式（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HARMFUL",
					spellID = 1226492,
					hl_np = true,
				},
			},
		},
		{ -- 卡雷什元素:卡雷什之拥
			spells = {
				{1223000},
			},
			options = {
				{ -- 姓名板光环 卡雷什之拥（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1223000,
					ficon = "7",
				},
				{ -- 驱散提示音 卡雷什之拥（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1223000,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 废土蠕行者:幽暗之咬
			spells = {
				{1222341},
			},
			options = {
				{ -- 对我施法图标 幽暗之咬（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1222341,
					hl = "yel_flash",
				},
				{ -- 图标 幽暗之咬（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222341,
					tip = L["DOT"],
				},
			},
		},
		{ -- 废土蠕行者:掘进喷发
			spells = {
				{1223007},
			},
			options = {
				{ -- 计时条 掘进喷发（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1223007,
					sound = "[dodge_circle]cast",
				},
			},
		},
		{ -- 掘地蠕行者:碾地猛击
			spells = {
				{1215850},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 碾地猛击（✓）
					category = "BossMod",
					spellID = 1215850,
					name = T.GetIconLink(1215850)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["245092"] = {
								engage_cd = 20,
								cast_cd = 31.5,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 1215850
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["全团AE"].."+"..L["躲圈"]
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						frame.count_voice = "en"
						
						T.InitMobCooldownText(frame)						
					end,
					update = function(frame, event, ...)
						T.UpdateMobCooldownText(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetMobCooldownText(frame)
					end,
				},
				{ -- 计时条 碾地猛击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1215850,		
					text = L["全团AE"].."+"..L["躲圈"],
					glow = true,
					sound = "[mindstep]cast",
				},
			},
		},
		{ -- 掘地蠕行者:钻地冲击
			spells = {
				{1237195},
			},
			options = {
				{ -- 计时条 钻地冲击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1237195,
					show_tar = true,
					sound = "[getout]cast",
				},
				{ -- 团队框架图标 钻地冲击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1237195,
				},
				{ -- 首领模块 钻地冲击 对我施法计时圆圈（✓）
					category = "BossMod",
					spellID = 1237195,
					enable_tag = "none",
					name = T.GetIconLink(1237195)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_TARGET"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1237195] = {		
								color = {1, 1, 0},
							},
						}
						T.InitCircleCastTimers(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateCircleCastTimers(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetCircleCastTimers(frame)
					end,
				},
			},
		},
		{ -- 掘地蠕行者:猛烈沙暴
			spells = {
				{1237220},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 猛烈沙暴（✓）
					category = "BossMod",
					spellID = 1237220,
					name = T.GetIconLink(1237220)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["245092"] = {
								engage_cd = 13.8,
								cast_cd = 26.8,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 1237220
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
				{ -- 计时条 猛烈沙暴（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1237220,		
					text = L["全团AE"],
					glow = true,
					sound = "[aoe]cast",
				},
			},
		},
		{ -- 卡雷什涌动
			spells = {
				{1239229},
			},
			options = {
				{ -- 图标 卡雷什涌动（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1239229,
					tip = L["加速"].."+"..L["加急速"],
				},
			},
		},
	},
}