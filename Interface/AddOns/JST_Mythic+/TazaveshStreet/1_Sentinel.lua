local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1194\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用


G.Encounters[2437] = {
	engage_id = 2425,
	npc_id = {"175616"},
	alerts = {
		{ -- 审讯
			spells = {
				{345598, "4,5"},
				{345990},
				{353424, "2"},
			},
			options = {
				{ -- 文字 审讯 倒计时
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(348350)..L["倒计时"],
					data = {
						spellID = 348350,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {40.7, 40.1, 36.3, 36.5},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 348350, T.GetIconLink(348350), self, event, ...)
					end,
				},
				{ -- 计时条 审讯
					category = "AlertTimerbar",
					type = "cast",
					spellID = 348350,
				},
				{ -- 计时条 审讯
					category = "AlertTimerbar",
					type = "cast",
					spellID = 347949,
					show_tar = true,
					sound = "[rescue]channel",
					glow = true,
				},
				{ -- 图标 审讯
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 347949,
					hl = "org",
				},
				{ -- 团队框架高亮 强化约束雕文
					category = "RFIcon",
					type = "Aura",
					spellID = 347949,
					color = "org",
				},
				{ -- 图标 监禁室
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 345990,
					hl = "red",
				},
			},
		},
		{ -- 武装安保
			spells = {
				{346204},
			},
			options = {
				{ -- 计时条 武装安保
					category = "AlertTimerbar",
					type = "cast",
					spellID = 346204,
					glow = "[dodge_circle]cast",
				},
				{ -- 图标 武装安保
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 348366,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 全副武装
			spells = {
				{348128},
			},
			options = {
				{ -- 文字 全副武装 倒计时
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = L["增加伤害"]..L["倒计时"],
					data = {
						spellID = 348128,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {29.7, 40.2, 53.8, 37.2},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 348128, L["增加伤害"], self, event, ...)
					end,
				},
				{ -- 计时条 全副武装
					category = "AlertTimerbar",
					type = "cast",
					spellID = 348128,
					glow = "[buff_dmg]cast",
					ficon = "0",
				},
				{ -- 图标 全副武装
					category = "AlertIcon",
					type = "aura",
					aura_type = "HELPFUL",
					unit = "boss1",
					spellID = 348128,
					hl = "yel",
					tip = L["增加伤害"].."25%",
					ficon = "0",
				},
			},
		},
		{ -- 扣押违禁品
			spells = {
				{345770},
				{353421},
			},
			options = {
				{ -- 文字 扣押违禁品 倒计时
					category = "TextAlert",
					type = "spell",
					preview = L["缴械"]..L["倒计时"],
					data = {
						spellID = 346006,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {20.0, 40.1, 27.9, 46.2, 37.6},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 346006, L["缴械"], self, event, ...)
					end,
				},
				{ -- 计时条 扣押违禁品
					category = "AlertTimerbar",
					type = "cast",
					spellID = 346006,
					glow = "[disarm]cast",
					glow = true,
				},
				{ -- 图标 扣押违禁品
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 345770,
					hl = "red",
					tip = L["沉默"],
				},
				{ -- 图标 精力
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 353421,
					hl = "gre",
					tip = L["加急速"],
				},
			},
		},
		{ -- 充能劈斩
			spells = {
				{1236348},
			},
			options = {
				{ -- 文字 充能劈斩 倒计时
					category = "TextAlert",
					type = "spell",
					preview = L["冲击波"]..L["倒计时"],
					data = {
						spellID = 1236348,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {12.8, 20.6, 19.4, 20.7, 19.4, 17.0, 17.0, 17.0, 20.6, 17.0},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1236348, L["冲击波"], self, event, ...)
					end,
				},
				{ -- 计时条 充能劈斩
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1236348,
					text = L["冲击波"],
					sound = "[dodge]cast",
				},
			},
		},
	},
}