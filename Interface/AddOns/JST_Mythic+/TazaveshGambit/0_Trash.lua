local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[392] = {2448, 2449, 2455, "c392"}

local function soundfile(filename, arg)
	return string.format("[c392\\%s]%s", filename, arg or "")
end
--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c392"] = {
	map_id = 2441,
	alerts = {
		{ -- 浊盐碎壳者:破壳猛击
			spells = {
				{355048},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 破壳猛击
					category = "BossMod",
					spellID = 355048,
					name = T.GetIconLink(355048)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["178139"] = {
								engage_cd = 7.6,
								cast_cd = 15.8,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 355048
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
				{ -- 对我施法图标 破壳猛击
					category = "AlertIcon",
					type = "com",
					spellID = 355048,
					hl = "yel_flash",
					sound = "[knockback]",
					tip = L["击退"],
				},
			},
		},
		{ -- 浊盐碎壳者:鱼人战吼
			spells = {
				{355057},
			},
			options = {
				{ -- 计时条 鱼人战吼
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355057,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 鱼人战吼
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 355057,
					mobID = "178139",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 浊盐缚鳞者:活力鱼串
			spells = {
				{355132},
			},
			options = {
				{ -- 计时条 活力鱼串
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355132,
					glow = true,
				},
			},
		},
		{ -- 浊盐鱼术师:不稳定的河豚
			spells = {
				{355234},
			},
			options = {
				{ -- 计时条 不稳定的河豚
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355234,
					text = L["炸弹"],
					sound = "[bomb]cast",
				},
			},
		},
		{ -- 浊盐鱼术师:水箭
			spells = {
				{355225},
			},
			options = {
				{ -- 姓名板打断图标 水箭
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 355225,
					mobID = "178142",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 水箭
					category = "AlertIcon",
					type = "com",
					spellID = 355225,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 水箭
					category = "RFIcon",
					type = "Cast",
					spellID = 355225,
				},
			},
		},
		{ -- 踏滨巨人:投掷巨石
			spells = {
				{355464},
			},
			options = {
				{ -- 计时条 投掷巨石
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355464,
					sound = "[mindstep]cast",
				},
			},
		},
		{ -- 踏滨巨人:海潮践踏
			spells = {
				{355429},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 海潮践踏
					category = "BossMod",
					spellID = 355429,
					name = T.GetIconLink(355429)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["178165"] = {
								engage_cd = 12,
								cast_cd = 22.7,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 355429
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
				{ -- 计时条 海潮践踏
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355429,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
				},
			},
		},
		{ -- 雷铸守护者:充能脉冲
			spells = {
				{355584},
			},
			options = {
				{ -- 计时条 充能脉冲
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355584,
					sound = "[outcircle]cast",
				},
			},
		},
		{ -- 雷铸守护者:连环爆裂
			spells = {
				{355577},
			},
			options = {
				{ -- 计时条 连环爆裂
					category = "AlertTimerbar",
					type = "cast",
					spellID = 355577,
					sound = "[mindstep]cast",
				},
				{ -- 图标 连环爆裂
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 355581,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 时沙号海潮贤者:盐渍飞弹
			spells = {
				{356843},
			},
			options = {
				{ -- 姓名板打断图标 盐渍飞弹
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 356843,
					mobID = "179388",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 盐渍飞弹
					category = "AlertIcon",
					type = "com",
					spellID = 356843,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 盐渍飞弹
					category = "RFIcon",
					type = "Cast",
					spellID = 356843,
				},
			},
		},
		{ -- 肌肉虬结的水手:超级塞松啤酒
			spells = {
				{356133},
			},
			options = {
				{ -- 计时条 超级塞松啤酒
					category = "AlertTimerbar",
					type = "cast",
					spellID = 356133,
					glow = true,
				},
				{ -- 姓名板光环 超级塞松啤酒
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 356133,
				},
			},
		},
		{ -- 海盗船军官:利剑投掷
			spells = {
				{368661},
			},
			options = {
				{ -- 计时条 利剑投掷
					category = "AlertTimerbar",
					type = "cast",
					spellID = 368661,
					sound = "[outcircle]cast",
				},
			},
		},
		{ -- 专心的祭师:不稳定的裂隙
			spells = {
				{357260},
			},
			options = {
				{ -- 计时条 不稳定的裂隙
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357260,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 不稳定的裂隙
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 357260,
					mobID = "180431",
					interrupt = 1,
					ficon = "6",
				},
			},
		},
		{ -- 热心的同谋:能量挥砍
			spells = {
				{357281},
			},
			options = {
				{ -- 对我施法图标 能量挥砍
					category = "AlertIcon",
					type = "com",
					spellID = 357281,
					hl = "yel_flash",
				},
				{ -- 图标 能量挥砍
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 357281,
					tip = L["易伤"].."%s10%",
				},
			},
		},
		{ -- 热心的同谋:重唤活力
			spells = {
				{357284},
			},
			options = {
				{ -- 计时条 重唤活力
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357284,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 重唤活力
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 357284,
					mobID = "180432",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 盛装的星辰先知:游移之星
			spells = {
				{357226},
			},
			options = {
				{ -- 计时条 游移之星
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357226,
					sound = "[dodge]cast",
				},
			},
		},
		{ -- 盛装的星辰先知:流浪的脉冲星
			spells = {
				{357238},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 流浪的脉冲星
					category = "BossMod",
					spellID = 357238,
					name = T.GetIconLink(357238)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["180429"] = {
								engage_cd = 13.1,
								cast_cd = 26.6,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 357238
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
				{ -- 计时条 流浪的脉冲星
					category = "AlertTimerbar",
					type = "cast",
					spellID = 357238,
					sound = "[add]cast",
				},
				{ -- 姓名板NPC高亮 流浪的脉冲星
					category = "PlateAlert",
					type = "PlateNpcID",
					mobID = "180433",
					hl_np = true,
				},
			},
		},
	},
}