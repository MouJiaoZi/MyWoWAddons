local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[525] = {2648, 2649, 2650, 2651, "c525"}

local function soundfile(filename, arg)
	return string.format("[c525\\%s]%s", filename, arg or "")
end
--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c525"] = {
	map_id = 2773,
	alerts = {
		{ -- 幽暗爬行者:昏睡毒液 
			spells = {
				{465813},
			},
			options = {
				{ -- 图标 昏睡毒液（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 465813,
					hl = "gre",
					tip = L["减速"].."40%",
					ficon = "9",
				},
				{ -- 团队框架高亮 昏睡毒液（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 465813,
					color = "gre",
				},
				{ -- 驱散提示音 昏睡毒液（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 465813,
					file = "[dispel]",
					ficon = "9",
				},
			},
		},
		{ -- 暗索士兵:黑血创伤
			spells = {
				{462737},
			},
			options = {
				{ -- 图标 黑血创伤（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 462737,
					hl = "blu",
					tip = L["DOT"],
					ficon = "7",
				},
				{ -- 驱散提示音 黑血创伤（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 462737,
					file = "[dispel]",
					ficon = "7",
					amount = 5,
				},
				{ -- 团队框架高亮 黑血创伤（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 462737,
					color = "blu",
					amount = 5,
				},
			},
		},
		{ -- 无人机狙击手:狙击
			spells = {
				{464655},
			},
			options = {
				{ -- 对我施法图标 狙击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 464655,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 狙击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 464655,
				},
			},
		},
		{ -- 无人机狙击手:特技射击
			spells = {
				{1214468},
			},
			options = {
				{ -- 团队框架图标 特技射击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1214468,
				},
				{ -- 姓名板打断图标 特技射击（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 1214468,
					mobID = "229069",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 撕碎王3000型:碎切
			spells = {
				{474337},
			},
			options = {
				{ -- 计时条 碎切（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 474337,
					sound = "[change_pos]cast,cd2",
					glow = true,
				},
				{ -- 图标 碎切（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 474351,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 撕碎王3000型:火焰喷射器
			spells = {
				{465754},
			},
			options = {
				{ -- 计时条 火焰喷射器（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 465754,
					sound = "[avoidfront]cast",
				},
				{ -- 图标 火焰喷射器（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 474388,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 载货机器人:上紧发条
			spells = {
				{465120},
			},
			options = {
				{ -- 图标 上紧发条（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 465120,
					hl = "red_flash",
					tip = L["锁定"],
					sound = "[focusyou]",
				},
				{ -- 姓名板法术来源图标 上紧发条（✓）
					category = "PlateAlert",
					type = "PlayerAuraSource",
					aura_type = "HARMFUL",
					spellID = 465120,
					hl_np = true,
				},
			},
		},
		{ -- 风险投资公司勘探员:“易投”炸弹 III
			spells = {
				{463169},
			},
			options = {
				{ -- 对我施法图标 “易投”炸弹 III（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 463169,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 “易投”炸弹 III（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 463169,
				},
			},
		},
		{ -- 风险投资公司勘探员:勘测光束
			spells = {
				{462771},
			},
			options = {
				{ -- 计时条 勘测光束（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 462771,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 勘测光束（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 462771,
					mobID = "229686",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 图标 勘测光束（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 462771,
					tip = L["强力DOT"],
					hl = "red",
					sound = "[defense]",
				},
				{ -- 团队框架图标 勘测光束（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 462771,
				},
				{ -- 团队框架高亮 勘测光束（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 462771,
					color = "red",
				},
				{ -- 图标 勘探之地（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 472338,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 风险投资公司建筑师:射钉枪
			spells = {
				{1213805},
			},
			options = {
				{ -- 对我施法图标 射钉枪（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1213805,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 射钉枪（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1213805,
				},
				{ -- 图标 钉伤（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1213803,
					tip = L["定身"].."+"..L["DOT"],
					hl = "",
				},
				{ -- 团队框架高亮 钉伤（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1213803,
					color = "red",
				},
			},
		},
		{ -- 风险管理公司潜水员:鱼叉
			spells = {
				{468631},
			},
			options = {
				{ -- 计时条 鱼叉（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 468631,
					glow = true,
				},
				{ -- 图标 鱼叉（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 468631,
					tip = L["DOT"],
					hl = "",
				},
				{ -- 团队框架高亮 鱼叉（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 468631,
					color = "red",
				},
			},
		},
		{ -- 风险管理公司潜水员:安放爆盐炸弹
			spells = {
				{468726},
			},
			options = {
				{ -- 计时条 安放爆盐炸弹（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 468726,
					sound = "[bomb]cast",
				},
			},
		},
		{ -- 暗索爆破手:R.P.G.G.
			spells = {
				{1216039},
			},
			options = {
				{ -- 计时条 R.P.G.G.（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1216039,
					sound = "[dodge_circle]cast",
				},
			},
		},
		{ -- 暗索爆破手:重新装填
			spells = {
				{461796},
			},
			options = {
				{ -- 计时条 重新装填（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 461796,
					glow = true,
				},
			},
		},
		{ -- 暗索扭血者:鲜血冲击
			spells = {
				{465871},
			},
			options = {
				{ -- 团队框架图标 鲜血冲击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 465871,
				},
				{ -- 姓名板打断图标 鲜血冲击（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 465871,
					mobID = "230748",
					interrupt = 3,
					ficon = "6",
				},
			},
		},
		{ -- 暗索扭血者:扭曲精华
			spells = {
				{465827},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 扭曲精华（✓）
					category = "BossMod",
					spellID = 465827,
					name = T.GetIconLink(465827)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["230748"] = {
								engage_cd = 5.9,
								cast_cd = 19.4,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 465827
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
				{ -- 计时条 扭曲精华（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 465827,
					sound = "[aoe]cast",
					glow = true,
				},
				{ -- 图标 扭曲精华（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 465830,
					tip = L["DOT"],
					hl = "",
				},
			},
		},
		{ -- 爆壳螃蟹:钳夹
			spells = {
				{468672},
			},
			options = {
				{ -- 图标 钳夹（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 468672,
					tip = L["减速"].."%s10%",
					hl = "",
				},
			},
		},
		{ -- 爆壳螃蟹:炸蟹
			spells = {
				{468680},
			},
			options = {
				{ -- 图标 炸蟹（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 468680,
					tip = L["DOT"],
					hl = "red_flash",
				},
			},
		},
		{ -- 被惊扰的海藻:回春水藻
			spells = {
				{471733},
			},
			options = {
				{ -- 姓名板打断图标 回春水藻（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 471733,
					mobID = "231223",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 被惊扰的海藻:投弃海藻
			spells = {
				{471736},
			},
			options = {
				{ -- 计时条 投弃海藻（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 471736,
					glow = true,
				},
			},
		},
		{ -- 暗索调查员:突击调查
			spells = {
				{465682},
			},
			options = {
				{ -- 计时条 突击调查（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 465682,
					sound = "[dodge]cast",
				},
			},
		},
		{ -- 风险投资公司电工:闪电箭
			spells = {
				{465595},
			},
			options = {
				{ -- 对我施法图标 闪电箭（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 465595,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 闪电箭（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 465595,
				},
				{ -- 姓名板打断图标 闪电箭（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 465595,
					mobID = "231312",
					interrupt = 3,
					ficon = "6",
				},
			},
		},
		{ -- 风险投资公司电工:过载
			spells = {
				{469799},
			},
			options = {				
				{ -- 图标 过载（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 469799,
					tip = L["DOT"],
					hl = "blu",
					ficon = "7",
				},
				{ -- 驱散提示音 过载（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 469799,
					file = "[dispel]",
					ficon = "7",
				},
				{ -- 团队框架高亮 过载（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 469799,
					color = "blu",
				},
			},
		},
		{ -- 暗索接线者:火花猛击
			spells = {
				{465666},
			},
			options = {
				{ -- 对我施法图标 火花猛击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 465666,
					hl = "yel_flash",
				},
			},
		},
		{ -- 暗索接线者:电池释能
			spells = {
				{465603},
			},
			options = {
				{ -- 首领模块 计时条 电池释能（✓）
					category = "BossMod",
					spellID = 465603,
					name = string.format(L["计时条%s"], T.GetIconLink(465603)),
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_SPELLCAST_SUCCEEDED"] = true,	
					},
					init = function(frame)
						frame.bars = {}
						
						function frame:hide_all()
							for i, bar in pairs(frame.bars) do
								T.StopTimerBar(bar, true, true)
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, cast_GUID, cast_spellID = ...
							if unit and cast_GUID and cast_spellID and cast_spellID == 465603 then -- 电池释能
								local GUID = UnitGUID(unit)
								if not frame.bars[GUID] then
									
									frame.bars[GUID] = T.CreateAlertBarShared(2, "bossmod"..frame.config_id.."-"..GUID, C_Spell.GetSpellTexture(465603), L["躲圈"], T.GetSpellColor(465603))
									frame.bars[GUID].prepare_sound = "dodge_circle"
									frame.bars[GUID].count_down_start = 3
								end
								if not frame.bars[GUID]["exp_time"] or frame.bars[GUID]["exp_time"] - GetTime() < 2 then
									T.StartTimerBar(frame.bars[GUID], 3, true, true)
								end
							end
						end
					end,
					reset = function(frame, event)
						frame:hide_all()
					end,
				},
			},
		},
	},
}