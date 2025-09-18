local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[391] = {2437, 2454, 2436, 2452, 2451, "c391"}

local function soundfile(filename, arg)
	return string.format("[c391\\%s]%s", filename, arg or "")
end
--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c391"] = {
	map_id = 2441,
	alerts = {
		{ -- 海关保安:干扰手雷
			spells = {
				{355900},
			},
			options = {
				{ -- 声音 干扰手雷（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 355900,
					file = "[dodge_circle]",
				},
			},
		},
		{ -- 大门看护者佐·马兹:代理打击(装甲监工)
			spells = {
				{351047},
			},
			options = {
				{ -- 打坦计时条 代理打击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 352796,
					group = 1,
					ficon = "0",
					sound = "[minddefense]cast",
				},
			},
		},
		{ -- 大门看护者佐·马兹:辐射脉冲(传送门操控师佐·霍恩)
			spells = {
				{438599},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 辐射脉冲（✓）
					category = "BossMod",
					spellID = 356548,
					name = T.GetIconLink(356548)..L["倒计时"],
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["178392"] = {
								engage_cd = 13.3,
								cast_cd = 25.5,
								cast_gap = 5,
							},
							["179334"] = {
								engage_cd = 27.1,
								cast_cd = 27.1,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 356548
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
				{ -- 计时条 辐射脉冲（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356548,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
					group = 1,
				},
				{ -- 图标 辐射脉冲（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 356548,
					tip = L["DOT"],
					hl = "",
				},
			},
		},
		{ -- 传送门操控师佐·霍恩:裂隙冲击
			spells = {
				{352390},
			},
			options = {
				{ -- 计时条 辐射脉冲（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 352390,
					text = L["射线"],
					sound = "[ray]cast",
				},
			},
		},
		{ -- 传送门操控师佐·霍恩:强化约束雕文
			spells = {
				{356537},
			},
			options = {
				T.Temp_ImportantInterruptBar(356537), -- 强化约束雕文（✓）
				{ -- 姓名板打断图标 强化约束雕文（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 356537,
					mobID = "179334",
					interrupt = 1,
					ficon = "6",
				},
				{ -- 图标 强化约束雕文（缺数据）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 356324,
					hl = "blu",
					tip = L["减速"].."+"..L["强力DOT"],
					ficon = "7",
				},
				{ -- 团队框架高亮 强化约束雕文（缺数据）
					category = "RFIcon",
					type = "Aura",
					spellID = 356324,
					color = "blu",
				},
				{ -- 驱散提示音 强化约束雕文（缺数据）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 356324,
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 审讯专员:约束雕文
			spells = {
				{355915},
			},
			options = {			
				{ -- 图标 约束雕文（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355915,
					hl = "blu",
					tip = L["减速"].."+"..L["强力DOT"],
					ficon = "7",
				},
				{ -- 团队框架高亮 约束雕文（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 355915,
					color = "blu",
				},
				{ -- 驱散提示音 约束雕文（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 355915,
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 支援警官:凌光箭(专心的祭师，宏图)
			spells = {
				{354297},
			},
			options = {
				T.Temp_SubInterruptBar(354297, { -- 凌光箭（✓）
					show_tar = true,
				}),
				{ -- 姓名板打断图标 凌光箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 354297,
					mobID = "177817,180431",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 凌光箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 354297,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 凌光箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 354297,
				},
			},
		},
		{ -- 支援警官:强光屏障
			spells = {
				{355934},
			},
			options = {		
				T.Temp_ImportantInterruptBar(355934), -- 强光屏障（✓）
				{ -- 姓名板打断图标 强光屏障（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 355934,
					mobID = "177817",
					interrupt = 1,
					ficon = "6",
				},	
				{ -- 姓名板光环 折射护盾（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 355980,
					ficon = "7",
				},
				{ -- 驱散提示音 折射护盾（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 355980,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 装甲监工:光线切分者(追踪者佐·刻斯)
			spells = {
				{356001},
			},
			options = {
				{ -- 计时条 光线切分者（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356001,
					text = L["陷阱"],
					sound = "[mindstep]cast",
				},
				{ -- 图标 光线切分者（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 356011,
					tip = L["强力DOT"],
					hl = "red",
				},
				{ -- 团队框架高亮 光线切分者（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 356011,
					color = "red",
				},
				{ -- 自保技能提示 光线切分者（✓）
					category = "HPWatch",
					type = "Aura",
					spellID = 356011,
					threshold = 75,
				},
			},
		},		
		{ -- 追踪者佐·刻斯:封锁
			spells = {
				{356942},
			},
			options = {
				{ -- 团队框架图标 封锁（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 356942,
				},
				{ -- 驱散提示音 封锁（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_START",
					spellID = 356942,
					file = "[prepare_dispel]",
					ficon = "7",
				},
				{ -- 图标 封锁（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 356943,
					hl = "blu",
					tip = L["定身"].."+"..L["强力DOT"],
					ficon = "7",
				},
				{ -- 团队框架高亮 封锁（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 356943,
					color = "blu",
				},				
			},
		},
		{ -- 上古熔火恶犬:熔岩吐息
			spells = {
				{356404},
			},
			options = {
				{ -- 计时条 熔岩吐息（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356404,
					sound = "[dodge]cast",
				},
			},
		},
		{ -- 上古熔火恶犬:上古恐慌
			spells = {
				{356407},
			},
			options = {
				T.Temp_NormalInterruptBar(356407), -- 上古恐慌（✓）
				{ -- 姓名板打断图标 上古恐慌（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 356407,
					mobID = "180091",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 狂乱的夜爪豹:狂乱割裂
			spells = {
				{357827},
			},
			options = {
				{ -- 图标 狂乱割裂（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 357827,
					hl = "red",
					tip = L["强力DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 狂乱割裂（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 357827,
					file = "[dispel]",
					ficon = "13",
				},
				{ -- 团队框架高亮 狂乱割裂（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 357827,
					color = "red",
				},
			},
		},
		{ -- 暴怒的恐角龙:狂暴冲锋
			spells = {
				{357512},
			},
			options = {	
				{ -- 计时条 狂暴冲锋（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357512,
					group = 1,
					show_tar = true,
					sound = "[mindcharge]cast",
					glow = true,
				},
				{ -- 对我施法图标 狂暴冲锋（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 357512,
					hl = "yel_flash",
					sound = "cd3",
					msg = {str_applied = "%spell", str_rep = "%dur"},
				},
				{ -- 首领模块 狂暴冲锋 对我施法计时圆圈（✓）
					category = "BossMod",
					spellID = 357512,
					name = T.GetIconLink(357512)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_TARGET"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[357512] = {		
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
		{ -- 暴怒的恐角龙:狂野鞭笞 
			spells = {
				{357508},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 狂野鞭笞（✓）
					category = "BossMod",
					spellID = 357508,
					name = T.GetIconLink(357508)..L["倒计时"],
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["180495"] = {
								engage_cd = 17,
								cast_cd = 26.5,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 357508
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["近战AOE"]
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
				{ -- 计时条 狂野鞭笞（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357508,
					group = 1,
					sound = "[meleeaoe]cast",
					glow = true,
				},
			},
		},
		{ -- 集市维和者:重装方阵
			spells = {
				{355640},
			},
			options = {
				{ -- 姓名板光环 重装方阵（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 355640,
				},
			},
		},
		{ -- 贸易执行者:强力脚踢(指挥官佐·法)
			spells = {
				{355477},
			},
			options = {	
				{ -- 打坦计时条 强力脚踢（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355477,
					group = 1,
					ficon = "0",
					sound = "[knockback]cast",
				},
			},
		},
		{ -- 贸易执行者:力量增幅器
			spells = {
				{1244443},
			},
			options = {	
				T.Temp_ImportantInterruptBar(1244443, { -- 力量增幅器（✓）
					ficon = "14",
				}),
			},
		},
		{ -- 老练的火花法师:凌光齐射
			spells = {
				{355642},
			},
			options = {	
				T.Temp_ImportantInterruptBar(355642), -- 凌光齐射（✓）
				{ -- 姓名板打断图标 凌光齐射（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 355642,
					mobID = "179841",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 老练的火花法师:闪烁
			spells = {
				{355641},
			},
			options = {	
				{ -- 图标 闪烁（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355641,
					hl = "blu",
					tip = L["易伤"],
					ficon = "7",
				},
				{ -- 团队框架高亮 闪烁（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 355641,
					color = "blu",
				},
				{ -- 驱散提示音 闪烁（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 355641,
					file = "[dispel]",
					ficon = "7",
				},
			},
		},		
		{ -- 指挥官佐·法:致命武力
			spells = {
				{355479},
			},
			options = {
				{ -- 计时条 致命武力（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355479,
					group = 1,
					text = L["连线"],
					glow = true,
					sound = "[chain]cast",
				},
				{ -- 首领模块 致命武力 计时圆圈（✓）
					category = "BossMod",
					spellID = 355480,
					name = T.GetIconLink(355480)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[355480] = { -- 致命武力
								unit = "player",
								aura_type = "HARMFUL",
								color = {1, 1, 0},
								sound = "chainonyou",
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
				{ -- 图标 致命武力（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355487,
					tip = L["强力DOT"],
					hl = "red",
				},
				{ -- 团队框架高亮 致命武力（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 355487,
					color = "red",
				},
			},
		},
		{ -- 指挥官佐·法:震荡地雷
			spells = {
				{355473},
			},
			options = {
				{ -- 计时条 震荡地雷（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355473,
					sound = "[mindstep]cast",
				},
				
			},
		},
		{ -- 财团打手:凌光反打
			spells = {
				{356967},
			},
			options = {				
				{ -- 打坦计时条 凌光反打（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356967,
					group = 1,
					ficon = "0",
					sound = "[knockback]cast",
				},
			},
		},
		{ -- 财团打手:时空光线强化器
			spells = {
				{357229},
			},
			options = {
				{ -- 计时条 时空光线强化器（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357229,
					ficon = "7",
					text = L["增加伤害"],
				},
				{ -- 姓名板光环 时空光线强化器（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 357229,
					ficon = "7",
				},
			},
		},
		{ -- 财团智囊:光尘闪回
			spells = {
				{357197},
			},
			options = {
				{ -- 驱散提示音 光尘闪回（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 357197,
					file = "[outcircle]",
				},				
			},
		},
		{ -- 财团智囊:凌光箭
			spells = {
				{357196},
			},
			options = {
				T.Temp_SubInterruptBar(357196, { -- 凌光箭（✓）
					show_tar = true,
				}),
				{ -- 姓名板打断图标 凌光箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 357196,
					mobID = "180336",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 凌光箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 357196,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 凌光箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 357196,
				},
			},
		},
		{ -- 财团潜伏者:迅斩
			spells = {
				{355830},
			},
			options = {
				{ -- 对我施法图标 迅斩（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 355830,
					hl = "yel_flash",
					msg = {str_applied = "%name %spell"},
				},
				{ -- 团队框架图标 迅斩（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 355830,
				},
				{ -- 图标 迅斩（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355832,
					hl = "red",
					tip = L["强力DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 迅斩（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 355832,
					file = "[dispel]",
					ficon = "13",
				},
				{ -- 团队框架高亮 迅斩（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 355832,
					color = "red",
				}, 
				{ -- 自保技能提示 迅斩（✓）
					category = "HPWatch",
					type = "Aura",
					spellID = 355832,
					threshold = 65,
				},
			},
		},
		{ -- 财团走私者:凌光炸弹
			spells = {
				{357029},
			},
			options = {
				{ -- 图标 凌光炸弹（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 357029,
					hl = "blu",
					tip = L["炸弹"],
					ficon = "7",
				},
				{ -- 驱散提示音 凌光炸弹（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 357029,
					file = "[dispel]",
					ficon = "7",
				},
				{ -- 团队框架高亮 凌光炸弹（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 357029,
					color = "blu",
				},
			},
		},
		{ -- P.O.S.T.工人:开信刀
			spells = {
				{347716},
			},
			options = {
				{ -- 打坦计时条 开信刀（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 347716,
					dur = 1.5,
					group = 1,
					ficon = "0",
					sound = "[minddefense]cast",
				},
				{ -- 图标 开信刀（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 347716,
					hl = "red",
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 开信刀（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 347716,
					file = "[dispel]",
					ficon = "13",
					amount = 2,
				},
				{ -- 团队框架高亮 开信刀（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 347716,
					color = "red",
					amount = 2,
				},
			},
		},
		{ -- 损坏的分拣机:打开牢笼
			spells = {
				{347721},
			},
			options = {
				{ -- 计时条 打开牢笼（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 347721,
				},
			},
		},
		{ -- 过载的邮件元素:垃圾信息过滤
			spells = {
				{347775},
			},
			options = {				
				T.Temp_NormalInterruptBar(347775), -- 垃圾信息过滤（✓）
				{ -- 姓名板打断图标 垃圾信息过滤（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 347775,
					mobID = "176395",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 姓名板光环 垃圾信息过滤（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 347775,
					ficon = "7",
				},
				{ -- 驱散提示音 垃圾信息过滤（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 347775,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 过载的邮件元素:垃圾邮件
			spells = {
				{347903},
			},
			options = {
				T.Temp_NormalInterruptBar(347903, { -- 垃圾邮件（✓）
					show_tar = true,
					ficon = "14",
				}),
				{ -- 对我施法图标 垃圾邮件（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 347903,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 垃圾邮件（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 347903,
				},
			},
		},
		{ -- 卖场铁腕战士:静电之锤
			spells = {
				{358919},
			},
			options = {
				{ -- 图标 静电附着（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 351960,
					hl = "blu",
					tip = L["减速"].."%s10%",
					ficon = "7",
				},
				{ -- 团队框架高亮 静电附着（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 351960,
					color = "blu",
					amount = 3,
				},
				{ -- 驱散提示音 静电附着（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 351960,
					file = "[dispel]",
					ficon = "7",
					amount = 3,
				},
			},
		},
		{ -- 集市监督者:充能猛击 
			spells = {
				{1240821},
			},
			options = {
				{ -- 计时条 充能猛击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1240821,
					sound = "[spread]cast",
				},
				{ -- 首领模块 充能猛击 计时圆圈（✓）
					category = "BossMod",
					spellID = 1240820,
					name = T.GetIconLink(1240820)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1240820] = { -- 充能猛击
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
			},
		},
		{ -- 集市监督者:穿刺
			spells = {
				{1240912},
			},
			options = {
				{ -- 打坦计时条 穿刺（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1240912,
					group = 1,
					ficon = "0",
					sound = "[minddefense]cast",
				},
				{ -- 图标 穿刺（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1240912,
					hl = "",
					tip = L["易伤"].."20%",
				},
			},
		},
	},
}