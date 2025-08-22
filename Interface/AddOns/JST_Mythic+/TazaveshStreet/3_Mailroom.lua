local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1194\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用


G.Encounters[2436] = {
	engage_id = 2424,
	npc_id = {"175646"},
	alerts = {
		{ -- 不稳定的货物
			spells = {
				{346947, "5"},
			},
			options = {				
				{ -- 文字 不稳定的货物 倒计时
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(346947)..L["倒计时"],
					data = {
						spellID = 346947,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {35.0, 43.7, 43.8},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 346947, T.GetIconLink(346947), self, event, ...)
					end,
				},
				{ -- 计时条 不稳定的货物
					category = "AlertTimerbar",
					type = "cast",
					spellID = 346947,
					sound = "[bomb]cast",
				},
				{ -- 图标 不稳定的货物
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 369133,
					hl = "yel",
					tip = L["减速"].."20%",
				},
				{ -- 图标 动荡爆炸
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 346297,
					hl = "red",
					tip = L["强力DOT"],
				},
			},
		},
		{ -- 有害液体
			spells = {
				{438599},
			},
			options = {
				{ -- 文字 有害液体 倒计时
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(346286)..L["倒计时"],
					data = {
						spellID = 346286,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {6.3, 42.0, 43.8, 43.7},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 346286, T.GetIconLink(346286), self, event, ...)
					end,
				},
				{ -- 计时条 有害液体
					category = "AlertTimerbar",
					type = "cast",
					spellID = 346286,
					sound = "[mindstep]cast",
				},
				{ -- 图标 炼金残渣
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 346844,
					hl = "blu",
					tip = L["DOT"],
					ficon = "7",
				},
				{ -- 团队框架高亮 炼金残渣
					category = "RFIcon",
					type = "Aura",
					spellID = 346844,
					color = "blu",
				},
				{ -- 驱散提示音 炼金残渣
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 346844,
					file = "[dispel]",
					ficon = "7",
				},
				{ -- 图标 四溅液体
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 346329,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 邮件旋风
			spells = {
				{346742},
			},
			options = {
				{ -- 文字 邮件旋风 倒计时
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(346742)..L["倒计时"],
					data = {
						spellID = 346742,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {16.0, 42.0, 43.8, 43.7},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 346742, T.GetIconLink(346742), self, event, ...)
					end,
				},
				{ -- 计时条 邮件旋风
					category = "AlertTimerbar",
					type = "cast",
					spellID = 346742,
					text = L["全团AE"],
					sound = "[aoe]cast",
					glow = true,
				},
			},
		},
		{ -- 现金汇款
			spells = {
				{346962},
			},
			options = {
				{ -- 文字 现金汇款 倒计时
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(346962)..L["倒计时"],
					data = {
						spellID = 346962,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {23.3, 42.0, 43.8, 43.7},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 346962, T.GetIconLink(346962), self, event, ...)
					end,
				},
				{ -- 计时条 现金汇款
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 346962,
					text = L["分担伤害"],
					sound = "[sharedmg]cast",
					glow = true,
				},
				{ -- 图标 现金汇款
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 346962,
					tip = L["分担伤害"],
					hl = "org",
				},
			},
		},
	},
}