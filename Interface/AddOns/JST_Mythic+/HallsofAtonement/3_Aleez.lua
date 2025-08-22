local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1185\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用


G.Encounters[2411] = {
	engage_id = 2403,
	npc_id = {"165410"},
	alerts = {
		{ -- 心能箭矢
			spells = {
				{323538, "0,6"},
			},
			options = {
				{ -- 姓名板打断图标 心能箭矢（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 323538,
					mobID = "165410",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 心能箭矢（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 323538,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 心能箭矢（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 323538,
				},
			},
		},
		{ -- 不稳定的心能
			spells = {
				{1236512},
			},
			options = {
				{ -- 文字 不稳定的心能 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["DOT"].."+"..L["分散"]..L["倒计时"],
					data = {
						spellID = 1236512,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {10.0, 17.8, 15.8, 16.2, 15.8, 15.8, 15.8, 17.0, 17.0, 17.0},
							},
						},
						cd_args = {
							round = true,
							count_down_start = 4,
							prepare_sound = "spread",
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 1236512, L["DOT"].."+"..L["分散"], self, event, ...)
					end,
				},
				{ -- 图标 不稳定的心能（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1236513,
					ficon = "7",
					hl = "blu",
					tip = L["DOT"],
				},
				{ -- 团队框架高亮 不稳定的心能（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1236513,
					color = "blu",
				},
			},
		},
		{ -- 幽灵附身
			spells = {
				{323597},
			},
			options = {
				{ -- 文字 幽灵附身 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["召唤小怪"]..L["倒计时"],
					data = {
						spellID = 323743,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},					
						info = {							
							["all"] = {
								[1] = {14.6, 20.7, 20.6, 20.6, 20.6, 20.7, 20.6, 21.9, 24.3},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 323743, L["召唤小怪"], self, event, ...)
					end,
				},
				{ -- 声音 幽灵附身（✓）
					category = "Sound",
					sub_event = "SPELL_CAST_SUCCESS",
					spellID = 323743,
					file = "[add]",
				},
			},	
		},
		{ -- 阴森的教民:萦绕锁定
			npcs = {
				{21861},
			},
			spells = {
				{323650},
			},
			options = {
				{ -- 计时条 萦绕锁定（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 323650,
					show_tar = true,
					sound = "[focus]",
				},
				{ -- 图标 萦绕锁定（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 323650,
					hl = "red",
					tip = L["锁定"],
				},
			},
		},
		{ -- 心能喷泉
			spells = {
				{329340},
			},
			options = {
				{ -- 计时条 心能喷泉（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 329340,
					sound = "[dodge_circle]cast",
				},
			},
		},
	},
}