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
				{ -- 声音 干扰手雷
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
				{ -- 计时条 代理打击
					category = "AlertTimerbar",
					type = "cast",
					spellID = 351047,
					sound = "[add]cast",
				},
			},
		},
		{ -- 大门看护者佐·马兹:辐射脉冲(传送门操控师佐·霍恩)
			spells = {
				{438599},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 辐射脉冲
					category = "BossMod",
					spellID = 356548,
					name = T.GetIconLink(356548)..L["倒计时"],
					enable_tag = "none",
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
								engage_cd = 0.1,
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
				{ -- 计时条 辐射脉冲
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356548,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
				},
				{ -- 图标 辐射脉冲
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
				{ -- 计时条 辐射脉冲
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
				{ -- 姓名板打断图标 强化约束雕文
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 356537,
					mobID = "179334",
					interrupt = 1,
					ficon = "6",
				},
				{ -- 图标 强化约束雕文
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 356324,
					hl = "blu",
					tip = L["减速"].."+"..L["强力DOT"],
					ficon = "7",
				},
				{ -- 团队框架高亮 强化约束雕文
					category = "RFIcon",
					type = "Aura",
					spellID = 356324,
					color = "blu",
				},
				{ -- 驱散提示音 强化约束雕文
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
				{ -- 图标 强化约束雕文
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355915,
					hl = "blu",
					tip = L["减速"].."+"..L["强力DOT"],
					ficon = "7",
				},
				{ -- 团队框架高亮 强化约束雕文
					category = "RFIcon",
					type = "Aura",
					spellID = 355915,
					color = "blu",
				},
				{ -- 驱散提示音 强化约束雕文
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
				{ -- 姓名板打断图标 凌光箭
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 354297,
					mobID = "177817,180431",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 凌光箭
					category = "AlertIcon",
					type = "com",
					spellID = 354297,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 凌光箭
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
				{ -- 计时条 强光屏障
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355934,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 强光屏障
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 355934,
					mobID = "177817",
					interrupt = 1,
					ficon = "6",
				},	
				{ -- 姓名板光环 折射护盾
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 355980,
					ficon = "7",
				},
				{ -- 驱散提示音 折射护盾
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 355980,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 装甲监工:光线切分者
			spells = {
				{356001},
			},
			options = {
				{ -- 计时条 光线切分者
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356001,
					text = L["陷阱"],
					sound = "[mindstep]cast",
				},
				{ -- 图标 光线切分者
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 356011,
					tip = L["强力DOT"],
					hl = "red",
				},
			},
		},
		{ -- 财团打手:凌光反打
			spells = {
				{356967},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 凌光反打
					category = "BossMod",
					spellID = 356967,
					ficon = "0",
					name = T.GetIconLink(356967)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["180348"] = {
								engage_cd = 28.3,
								cast_cd = 31.6,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 356967
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["击退"]
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
				{ -- 对我施法图标 凌光反打
					category = "AlertIcon",
					type = "com",
					spellID = 356967,
					hl = "yel_flash",
					sound = "[konckback]",
				},
			},
		},
		{ -- 财团打手:时空光线强化器
			spells = {
				{357229},
			},
			options = {
				{ -- 计时条 时空光线强化器
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357229,
					ficon = "7",
					text = L["增加伤害"],
				},
				{ -- 姓名板光环 时空光线强化器
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 357229,
					ficon = "7",
				},
				{ -- 驱散提示音 时空光线强化器
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 357229,
					aura_type = "HELPFUL",
					file = "[dispel]",
					ficon = "7",
				},
			},
		},
		{ -- 财团智囊:光尘闪回
			spells = {
				{357197},
			},
			options = {
				{ -- 驱散提示音 光尘闪回
					category = "Sound",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 357197,
					file = "[change_pos]",
				},				
			},
		},
		{ -- 财团智囊:凌光箭
			spells = {
				{357196},
			},
			options = {
				{ -- 姓名板打断图标 凌光箭
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 357196,
					mobID = "180336",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 凌光箭
					category = "AlertIcon",
					type = "com",
					spellID = 357196,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 凌光箭
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
				{ -- 对我施法图标 迅斩（待测试）
					category = "AlertIcon",
					type = "com",
					spellID = 355830,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 迅斩（待测试）
					category = "RFIcon",
					type = "Cast",
					spellID = 355830,
				},
				{ -- 图标 迅斩
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355832,
					hl = "red",
					tip = L["强力DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 迅斩
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 355832,
					file = "[dispel]",
					ficon = "13",
				},
				{ -- 团队框架高亮 迅斩
					category = "RFIcon",
					type = "Aura",
					spellID = 355832,
					color = "red",
				},
			},
		},
		{ -- 财团走私者:凌光炸弹
			spells = {
				{357029},
			},
			options = {
				{ -- 图标 凌光炸弹
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 357029,
					hl = "blu",
					tip = L["炸弹"],
					ficon = "7",
				},
				{ -- 驱散提示音 凌光炸弹
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 357029,
					file = "[dispel]",
					ficon = "7",
				},
				{ -- 团队框架高亮 凌光炸弹
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
				{ -- 对我施法图标 开信刀
					category = "AlertIcon",
					type = "com",
					spellID = 347716,
					hl = "yel_flash",
				},
				{ -- 图标 开信刀
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 347716,
					hl = "red",
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 开信刀
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 347716,
					file = "[dispel]",
					ficon = "13",
					amount = 2,
				},
				{ -- 团队框架高亮 开信刀
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
				{ -- 计时条 打开牢笼
					category = "AlertTimerbar",
					type = "cast",
					spellID = 347721,
					glow = true,
				},
			},
		},
		{ -- 过载的邮件元素:垃圾信息过滤
			spells = {
				{347775},
			},
			options = {				
				{ -- 计时条 垃圾信息过滤
					category = "AlertTimerbar",
					type = "cast",
					spellID = 347775,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 垃圾信息过滤
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 347775,
					mobID = "176395",
					interrupt = 2,
					ficon = "6",
				},			
				{ -- 姓名板光环 垃圾信息过滤
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 347775,
					ficon = "7",
				},
				{ -- 驱散提示音 垃圾信息过滤
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
				{ -- 计时条 垃圾邮件
					category = "AlertTimerbar",
					type = "cast",
					spellID = 347903,
					glow = true,
				},
				{ -- 对我施法图标 垃圾邮件
					category = "AlertIcon",
					type = "com",
					spellID = 347903,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 垃圾邮件
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
				{ -- 图标 静电附着
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 351960,
					hl = "blu",
					tip = L["减速"].."%s10%",
					ficon = "7",
				},
				{ -- 团队框架高亮 静电附着
					category = "RFIcon",
					type = "Aura",
					spellID = 351960,
					color = "blu",
					amount = 3,
				},
				{ -- 驱散提示音 静电附着
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
				{ -- 计时条 充能猛击
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1240821,
					sound = "[outcircle]cast",
				},
			},
		},
		{ -- 集市监督者:穿刺
			spells = {
				{1240912},
			},
			options = {
				{ -- 对我施法图标 穿刺
					category = "AlertIcon",
					type = "com",
					spellID = 1240912,
					hl = "yel_flash",
				},
				{ -- 图标 穿刺
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
		{ -- 集市维和者:压制打击
			spells = {
				{355637},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 压制打击
					category = "BossMod",
					spellID = 355637,
					name = T.GetIconLink(355637)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["179840"] = {
								engage_cd = 1.5,
								cast_cd = 15.3,
								cast_gap = 3.2,
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
			},
		},
		{ -- 集市维和者:重装方阵
			spells = {
				{355640},
			},
			options = {
				{ -- 姓名板光环 重装方阵
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 355640,
				},
			},
		},
	},
}