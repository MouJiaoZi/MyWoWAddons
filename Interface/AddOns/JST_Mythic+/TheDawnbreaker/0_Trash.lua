local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[505] = {2580, 2581, 2593, "c505"}

local function soundfile(filename)
	return string.format("[c505\\%s]", filename)
end

--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c505"] = {
	map_id = 2662,
	alerts = {
		{ -- 夜幕影法师:暗夜箭
			spells = {
				{431303},
			},
			options = {
				{ -- 姓名板打断图标 暗夜箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 431303,
					mobID = "213892",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 暗夜箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 431303,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 暗夜箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 431303,
				},
			},
		},
		{ -- 夜幕影法师:诱捕暗影
			spells = {
				{431309},
			},
			options = {
				{ -- 图标 诱捕暗影（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 431309,
					hl = "pur",
					tip = L["减速"].."+"..L["DOT"],
					ficon = "8",
				},
				{ -- 团队框架高亮 诱捕暗影（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 431309,
					color = "pur",
				},
				{ -- 驱散提示音 诱捕暗影（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 431309,
					file = "[dispel]",
					ficon = "8",
				},
			},
		},
		{ -- 夜幕祭师:折磨光束
			spells = {
				{431364, "2"},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 折磨光束（✓）
					category = "BossMod",
					spellID = 431364,
					name = T.GetIconLink(431364)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["214761"] = {
								engage_cd = 1,
								cast_cd = 11.5,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 431364
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["注意治疗"]
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
				{ -- 计时条 折磨光束（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 431364,
					ficon = "2",
					sound = "[heal]cast",
					glow = true,
				},
				{ -- 图标 折磨光束（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 431365,
					hl = "red",
					tip = L["强力DOT"],
					sound = "[defense]",
				},
				{ -- 团队框架高亮 折磨光束（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 431365,
					color = "red",
				},
			},
		},
		{ -- 夜幕祭师:冥河之种
			spells = {
				{432448},
			},
			options = {
				{ -- 计时条 冥河之种（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 432448,
					show_tar = true,
					ficon = "7",
				},
				{ -- 驱散提示音 冥河之种（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_START",
					spellID = 432448,
					file = "[prepare_dispel]",
					ficon = "7",
				},
				{ -- 团队框架图标 冥河之种（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 432448,
				},
				{ -- 图标 冥河之种（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 432448,
					hl = "org_flash",
					tip = L["离开人群"],
					ficon = "7",					
					msg = {str_applied = "%name %spell"},
				},				
				{ -- 团队框架高亮 冥河之种（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 432448,
					color = "blu",
				},
			},
		},
		{ -- 夜幕司令官:污邪斩击
			spells = {
				{431491},
			},
			options = {
				{ -- 对我施法图标 污邪斩击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 431491,
					hl = "yel_flash",
				},
				{ -- 图标 污邪斩击（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 431491,
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 污邪斩击（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 431491,
					file = "[dispel]",
					ficon = "13",
				},
			},
		},
		{ -- 夜幕司令官:深渊嗥叫
			spells = {
				{450756},
			},
			options = {
				{ -- 计时条 深渊嗥叫（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 450756,
					ficon = "7",
				},
				{ -- 姓名板光环 深渊嗥叫（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 450756,
					ficon = "7",
				},
				{ -- 驱散提示音 深渊嗥叫（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 450756,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 苏雷吉网法师:迸发虫茧
			spells = {
				{451107},
			},
			options = {				
				{ -- 对我施法图标 迸发虫茧（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 451107,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 迸发虫茧（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 451107,
				},
				{ -- 图标 迸发虫茧（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 451107,
					hl = "red",
					tip = L["强力DOT"],
					sound = "[defense]cd3",
					msg = {str_applied = "%name %spell", str_rep = "%spell %dur"},
				},
				{ -- 首领模块 迸发虫茧 计时圆圈（✓）
					category = "BossMod",
					spellID = 451107,
					enable_tag = "none",
					name = T.GetIconLink(451107)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[451107] = { -- 迸发虫茧
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
				{ -- 团队框架高亮 迸发虫茧（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 451107,
					color = "red",
				},
			},
		},
		{ -- 苏雷吉网法师:蛛网箭
			spells = {
				{451113},
			},
			options = {
				{ -- 姓名板打断图标 蛛网箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 451113,
					mobID = "210966",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 蛛网箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 451113,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 蛛网箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 451113,
				},
			},
		},		
		{ -- 夜幕暗法师:折磨射线
			spells = {
				{431333},
			},
			options = {				
				{ -- 姓名板打断图标 折磨射线（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 431333,
					mobID = "213893,228539",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 图标 折磨射线（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 431333,
					hl = "red",
					tip = L["强力DOT"],
				},
				{ -- 团队框架高亮 折磨射线（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 431333,
					color = "red",
				},
			},
		},
		{ -- 夜幕暗法师:暗影屏障
			spells = {
				{432520},
			},
			options = {
				{ -- 姓名板打断图标 暗影屏障（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 432520,
					mobID = "213893,228539",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 暗影具象:黑暗之霰
			spells = {
				{432565},
			},
			options = {				
				{ -- 计时条 黑暗之霰（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 432565,
					sound = "[getout]cast",
					show_tar = true,
				},
				{ -- 对我施法图标 黑暗之霰（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 432565,
					hl = "yel_flash",
					msg = {str_applied = "%name %spell", str_rep = "%spell %dur"},
				},
				{ -- 首领模块 黑暗之霰 对我施法计时圆圈（✓）
					category = "BossMod",
					spellID = 432565,
					enable_tag = "none",
					name = T.GetIconLink(432565)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_TARGET"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[432565] = {		
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
		{ -- 暗影具象:深渊朽烂
			spells = {
				{453345, "2"},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 深渊朽烂（✓）
					category = "BossMod",
					spellID = 453345,
					name = T.GetIconLink(453345)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["211341"] = {
								engage_cd = 2,
								cast_cd = 18.2,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 453345
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..C_Spell.GetSpellName(frame.cast_spellID)
						frame.text_color = T.GetSpellColor(frame.cast_spellID)
						frame.sub_event = "SPELL_CAST_SUCCESS"
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
				{ -- 图标 深渊朽烂（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 453345,
					tip = L["强力DOT"],
					hl = "red",
				},
				{ -- 团队框架高亮 深渊朽烂（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 453345,
					color = "red",
				},
			},
		},
		{ -- 夜幕战略家:黑刃之锋
			spells = {
				{431494},
			},
			options = {
				{ -- 计时条 黑刃之锋（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 431494,
					sound = "[dodge]cast",
					text = L["冲击波"],
				},
				{ -- 图标 黑刃之锋（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 431494,
					tip = L["诱捕"],
					ficon = "7",
					hl = "blu",
				},
				{ -- 团队框架高亮 黑刃之锋（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 431494,
					color = "blu",
				},
				{ -- 驱散提示音 黑刃之锋（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 431494,
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 夜幕战略家:战略家之怒
			spells = {
				{451112},
			},
			options = {
				{ -- 姓名板光环 战略家之怒（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 451112,
					ficon = "11",
				},
				{ -- 驱散提示音 战略家之怒（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 451112,
					file = "[dispel]",
					ficon = "11",
				},
			},
		},
		{ -- 夜幕影行者:暗影之刃
			spells = {
				{1242681},
			},
			options = {
				{ -- 图标 暗影之刃（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242681,
					hl = "",
					tip = L["致死"].."%s1%",
				},
			},
		},		
		{ -- 扬升者维斯可里亚:深渊轰击（死亡尖啸者艾肯塔克 坚不可摧的伊克斯雷腾）
			spells = {
				{451119},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 深渊轰击（✓）
					category = "BossMod",
					spellID = 451119,
					name = T.GetIconLink(451119)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["211261"] = { -- 扬升者维斯可里亚
								engage_cd = 22.8,
								cast_cd = 12,
								cast_gap = 5,
							},
							["211263"] = { -- 死亡尖啸者艾肯塔克
								engage_cd = 6.5,
								cast_cd = 12,
								cast_gap = 5,
							},
							["211262"] = { -- 坚不可摧的伊克斯雷腾
								engage_cd = 4,
								cast_cd = 12,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 451119
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..C_Spell.GetSpellName(frame.cast_spellID)
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
				{ -- 计时条 深渊轰击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 451119,
					show_tar = true,
				},
				{ -- 对我施法图标 深渊轰击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 451119,
					hl = "yel_flash",
					sound = "[defense]",
				},
				{ -- 团队框架图标 深渊轰击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 451119,
				},
				{ -- 图标 深渊轰击（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 451119,
					tip = L["强力DOT"],	
					hl = "red",
				},
				{ -- 团队框架高亮 深渊轰击（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 451119,
					color = "red",
				},
			},
		},
		{ -- 扬升者维斯可里亚:晦影腐朽
			spells = {
				{451102},
			},
			options = {				
				{ -- 首领模块 小怪技能倒计时 晦影腐朽（✓）
					category = "BossMod",
					spellID = 451102,
					name = T.GetIconLink(451102)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["211261"] = { -- 扬升者维斯可里亚
								engage_cd = 13,
								cast_cd = 28,
								cast_gap = 5,
							},							
						}
						
						frame.cast_spellID = 451102
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
				{ -- 计时条 晦影腐朽（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 451102,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
				},
			},
		},
		{ -- 死亡尖啸者艾肯塔克:暗黑法球
			spells = {
				{450854},
			},
			options = {
				{ -- 计时条 暗黑法球（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 450854,
					sound = "[ball]cast,cd3",
					glow = true,
				},
				{ -- 图标 黑暗伤痕（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 460135,
					tip = L["强力DOT"],
					sound = "[defense]",
				},
				{ -- 团队框架高亮 黑暗伤痕（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 460135,
					color = "red",
				},
			},
		},
		{ -- 坚不可摧的伊克斯雷腾:恐惧猛击
			spells = {
				{451117},
			},
			options = {
				{ -- 计时条 恐惧猛击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 451117,
					text = L["大圈"],
					sound = "[outcircle]cast,notank",
				},
				{ -- 首领模块 恐惧猛击 对我施法计时圆圈（✓）
					category = "BossMod",
					spellID = 451117,
					enable_tag = "none",
					name = T.GetIconLink(451117)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_TARGET"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[451117] = {		
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
		{ -- 夜幕筑暗师:折磨喷发
			spells = {
				{431350},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 折磨喷发（✓）
					category = "BossMod",
					spellID = 431349,
					name = T.GetIconLink(431349)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["213885"] = {
								engage_cd = 7,
								cast_cd = 14.5,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 431349
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["分散"].."+"..L["注意治疗"]
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
				{ -- 计时条 折磨喷发（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 431349,
					text = L["分散"].."+"..L["注意治疗"],
					sound = "[spread]cast",
					glow = true,
				},
				{ -- 图标 折磨喷发（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 431350,
					hl = "red",
					tip = L["分散"].."+"..L["强力DOT"],
					sound = "[defense]",
				},
				{ -- 首领模块 折磨喷发 计时圆圈（✓）
					category = "BossMod",
					spellID = 431350,
					enable_tag = "none",
					name = T.GetIconLink(431350)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[431350] = { -- 折磨喷发
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
				{ -- 团队框架高亮 折磨喷发（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 431350,
					color = "red",
				},
			},
		},
		{ -- 夜幕筑暗师:招引增援
			spells = {
				{446615},
			},
			options = {				
				{ -- 首领模块 小怪技能倒计时 招引增援（✓）
					category = "BossMod",
					spellID = 446615,
					name = T.GetIconLink(446615)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["213885"] = {
								engage_cd = 15,
								cast_cd = 14.5,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 446615
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["召唤小怪"]
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
				{ -- 计时条 招引增援（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 446615,
					text = L["召唤小怪"],
					sound = "[add]cast",
				},
			},
		},		
		{ -- 渗透暗影
			spells = {
				{449332},
			},
			options = {
				{ -- 图标 渗透暗影（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 449332,
					hl = "yel",
				},
			},
		},
	},
}