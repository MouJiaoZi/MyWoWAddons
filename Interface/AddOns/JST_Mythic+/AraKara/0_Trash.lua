local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[503] = {2583, 2584, 2585, "c503"}

local function soundfile(filename)
	return string.format("[c503\\%s]", filename)
end

--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c503"] = {
	map_id = 2660,
	alerts = {
		{ -- 啊呃！
			spells = {
				{436401},
			},
			options = {
				{ -- 图标 啊呃！（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",					
					spellID = 436401,
					hl = "red",
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 团队框架高亮 啊呃！（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 436401,
					color = "red",
					amount = 3,
				},
			},
		},
		{ -- 戳刺飞虫:放血戳刺
			spells = {
				{438599},
			},
			options = {
				{ -- 图标 放血戳刺（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",					
					spellID = 438599,
					hl = "red",
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 团队框架高亮 放血戳刺（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 438599,
					color = "red",
					amount = 2,
				},
			},
		},
		{ -- 颤声侍从:蛛网箭（纳克特 伊克辛 沾血的网法师）
			spells = {
				{434786},
			},
			options = {				
				{ -- 姓名板打断图标 蛛网箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 434786,
					mobID = "216293,218324,217531,223253",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 蛛网箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 434786,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 蛛网箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 434786,
				},
			},
		},
		{ -- 颤声侍从:共振弹幕
			spells = {
				{434793},
			},
			options = {
				{ -- 计时条 共振弹幕（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 434793,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 共振弹幕（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 434793,
					mobID = "216293",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 充血的爬行者:毒性喷吐
			spells = {
				{438618},
			},
			options = {				
				{ -- 图标 毒性喷吐（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 438618,
					hl = "gre",
					tip = L["DOT"],
					ficon = "9",
				},
				{ -- 团队框架高亮 毒性喷吐（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 438618,
					color = "gre",
					amount = 2,
				},
				{ -- 驱散提示音 毒性喷吐（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 438618,
					file = "[dispel]",
					ficon = "9",
					amount = 2,
				},
			},
		},
		{ -- 阿提克:蛛网喷射（纳克特 伊克辛）
			spells = {
				{434824},
			},
			options = {				
				{ -- 计时条 蛛网喷射（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 434824,
					sound = "[dodge]cast",
				},
			},
		},
		{ -- 阿提克:毒液箭
			spells = {
				{436322},
			},
			options = {				
				{ -- 姓名板打断图标 毒液箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 436322,
					mobID = "217533",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 图标 毒液箭（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 436322,
					hl = "gre",
					tip = L["强力DOT"],
					sound = "[defense]",
					ficon = "9",
				},
				{ -- 团队框架高亮 毒液箭（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 436322,
					color = "gre",
				},
			},
		},
		{ -- 阿提克:毒云
			spells = {
				{438826},
			},
			options = {				
				{ -- 计时条 毒云（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 438826,
					sound = "[mindstep]cast",			
				},
				{ -- 图标 毒云（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 438825,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 纳克特:巢穴的召唤
			spells = {
				{438877},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 巢穴的召唤（✓）
					category = "BossMod",
					spellID = 438877,
					name = T.GetIconLink(438877)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["218324"] = {
								engage_cd = 9,
								cast_cd = 23,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 438877
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
				{ -- 计时条 巢穴的召唤（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 438877,
					spellIDs = {438883},
					sound = "[aoe]cast",
					glow = true,
				},
			},
		},
		{ -- 伊克辛:惊惧尖鸣
			spells = {
				{434802},
			},
			options = {
				{ -- 姓名板打断图标 惊惧尖鸣（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 434802,
					mobID = "217531",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 沾血的助手:深掘打击
			spells = {
				{433002, "0"},
			},
			options = {			
				{ -- 对我施法图标 深掘打击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 433002,
					hl = "yel_flash",
				},
			},
		},
		{ -- 沾血的网法师:恶臭齐射
			spells = {
				{448248},
			},
			options = {				
				{ -- 计时条 恶臭齐射（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 448248,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 恶臭齐射（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 448248,
					mobID = "223253",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 图标 恶臭齐射（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",					
					spellID = 448248,
					effect = 2,
					hl = "gre",
					tip = L["强力DOT"],
					ficon = "9",
				},
				{ -- 驱散提示音 恶臭齐射（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 448248,
					file = "[dispel]",
					ficon = "9",
				},
			},
		},
		{ -- 魁梧的血卫:穿刺
			spells = {
				{453161},
			},
			options = {
				{ -- 计时条 穿刺（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 453161,
					sound = "[dodge]cast",
				},
			},
		},
		{ -- 魁梧的血卫:虫群风暴
			spells = {
				{1241693},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 虫群风暴（✓）
					category = "BossMod",
					spellID = 1241693,
					name = T.GetIconLink(1241693)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["216338"] = {
								engage_cd = 5,
								cast_cd = 30.2,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 1241693
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
				{ -- 计时条 虫群风暴（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1241693,
					sound = "[aoe]cast",
					glow = true,
				},
				{ -- 图标 虫群风暴（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",					
					spellID = 1241694,
					tip = L["DOT"],
				},
			},
		},		
		{ -- 哨兵鹿壳虫:预警尖鸣
			spells = {
				{432967},
			},
			options = {
				{ -- 计时条 预警尖鸣（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 432967,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 预警尖鸣（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 432967,
					mobID = "216340",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 鲜血监督者:爆发蛛网
			spells = {
				{433845},
			},
			options = {
				{ -- 计时条 爆发蛛网（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 433845,
					sound = "[mindstep]cast",
				},
			},
		},
		{ -- 鲜血监督者:毒液箭雨
			spells = {
				{433841},
			},
			options = {
				{ -- 姓名板打断图标 毒液箭雨（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 433841,
					mobID = "216364",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 图标 毒液箭雨（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",					
					spellID = 433841,
					hl = "gre",
					tip = L["强力DOT"],
					ficon = "9",
				},
				{ -- 驱散提示音 毒液箭雨（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 433841,
					file = "[dispel]",
					ficon = "9",
				},
			},
		},
		{ -- 强化雄虫:勒握斩击
			spells = {
				{1241785, "0"},
			},
			options = {
				{ -- 图标 污血（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",					
					spellID = 1241785,
					tip = L["DOT"],
					ficon = "7",
					hl = "blu",
				},
				{ -- 团队框架高亮 污血（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1241785,
					color = "blu",
					amount = 10,
				},
				{ -- 驱散提示音 污血（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1241785,
					file = "[dispel]",
					ficon = "7",
					amount = 10,
				},
			},
		},
		{ -- 血腥迷瘴
			spells = {
				{439832},
			},
			options = {
				{ -- 图标 血腥迷瘴（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 439832,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},	
	},
}