local T, C, L, G = unpack(JST)

G.ChallengeMap_Order[378] = {2406, 2387, 2411, 2413, "c378"}

local function soundfile(filename, arg)
	return string.format("[c378\\%s]%s", filename, arg or "")
end
--------------------------------Locals--------------------------------

---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters["c378"] = {
	map_id = 2287,
	alerts = {
		{ -- 堕落的黑暗剑士:心能蚀甲
			spells = {
				{1235060},
			},
			options = {
				{ -- 图标 心能蚀甲（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1235060,
					hl = "",
					tip = L["DOT"],
				},
				{ -- 团队框架高亮 心能蚀甲（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1235060,
					color = "blu",
					amount = 7,
				},
				{ -- 驱散提示音 心能蚀甲（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1235060,
					file = "[dispel]",
					ficon = "7",
					amount = 7,
				},
			},
		},
		{ -- 堕落的驯犬者:射击
			spells = {
				{325535},
			},
			options = {
				{ -- 对我施法图标 射击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 325535,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 射击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 325535,
				},
			},
		},
		{ -- 堕落的驯犬者:忠心的野兽
			spells = {
				{326450},
			},
			options = {
				{ -- 计时条 忠心的野兽（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 326450,
					ficon = "6",
					glow = true,
				},
				{ -- 姓名板打断图标 忠心的野兽（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 326450,
					mobID = "164562",
					interrupt = 2,
					ficon = "6",
				},
			},
		},
		{ -- 邪恶的加尔贡:龟裂创伤
			spells = {
				{1237602},
			},
			options = {
				{ -- 图标 龟裂创伤（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1237602,
					hl = "red",
					tip = L["DOT"],
					ficon = "13",
				},
				{ -- 驱散提示音 龟裂创伤（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 1237602,
					file = "[dispel]",
					ficon = "13",
					amount = 3,
				},
				{ -- 团队框架高亮 龟裂创伤（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1237602,
					color = "red",
					amount = 3,
				},
			},
		},
		{ -- 劳苦的管理员:快逃！
			spells = {
				{1235121},
			},
			options = {
				{ -- 姓名板光环 快逃！（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1235121,
				},
			},
		},
		{ -- 哈尔吉亚斯的碎片:痛击
			spells = {
				{326409},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 痛击（✓）
					category = "BossMod",
					spellID = 326409,
					name = T.GetIconLink(326409)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["164557"] = {
								engage_cd = 8.2,
								cast_cd = 23,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 326409
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
				{ -- 计时条 痛击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 326409,
					sound = "[aoe]cast",
					glow = true,
				},
			},
		},
		{ -- 哈尔吉亚斯的碎片:罪孽震击
			spells = {
				{326441},
			},
			options = {
				{ -- 计时条 罪孽震击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 326441,
					sound = "[dodge_circle]cast",
				},
			},
		},		
		{ -- 堕落的搜集者:生命虹吸
			spells = {
				{325701},
			},
			options = {
				{ -- 图标 生命虹吸（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 325701,
					hl = "red",
					tip = L["强力DOT"],
					sound = "[defense]",
				},
				{ -- 团队框架高亮 生命虹吸（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 325701,
					color = "red",
				},
			},
		},
		{ -- 堕落的歼灭者:邪恶箭矢
			spells = {
				{338003},
			},
			options = {
				{ -- 姓名板打断图标 邪恶箭矢（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 338003,
					mobID = "165414",
					interrupt = 2,
					ficon = "6",
				},
				{ -- 对我施法图标 邪恶箭矢（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 338003,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 邪恶箭矢（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 338003,
				},
			},
		},
		{ -- 堕落的歼灭者:湮灭诅咒
			spells = {
				{325876},
			},
			options = {
				{ -- 图标 湮灭诅咒（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 325876,
					hl = "blu",
					tip = L["DOT"],
					ficon = "7",
				},
				{ -- 驱散提示音 湮灭诅咒（✓）
					category = "Sound",
					sub_event = "SPELL_AURA_APPLIED",
					spellID = 325876,
					file = "[dispel]",
					ficon = "7",
				},
				{ -- 团队框架高亮 湮灭诅咒（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 325876,
					color = "blu",
				},
			},
		},
		{ -- 石裔切割者:岩石监视者
			spells = {
				{1235808},
			},
			options = {
				{ -- 姓名板光环 岩石监视者（✓）
					category = "PlateAlert",
					type = "PlateAuras",
					aura_type = "HELPFUL",
					spellID = 1235808,
				},
			},
		},
		{ -- 石裔切割者:猛力横扫
			spells = {
				{326997},
			},
			options = {
				{ -- 计时条 猛力横扫（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 326997,
					sound = "[dodge]cast",
				},
			},
		},
		{ -- 石裔切割者:瓦解尖叫
			spells = {
				{1235326},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 瓦解尖叫（✓）
					category = "BossMod",
					spellID = 1235326,
					name = T.GetIconLink(1235326)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["167607"] = {
								engage_cd = 15.8,
								cast_cd = 32.8,
								cast_gap = 5,
							},
						}

						frame.cast_spellID = 1235326
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
				{ -- 首领模块 计时条 瓦解尖叫（✓）
					category = "BossMod",
					spellID = 1235808,
					name = string.format(L["计时条%s"], T.GetIconLink(1235326)),
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_SPELLCAST_CHANNEL_START"] = true,
						["UNIT_SPELLCAST_CHANNEL_UPDATE"] = true,
						["UNIT_SPELLCAST_CHANNEL_STOP"] = true,
					},
					init = function(frame)
						local name = C_Spell.GetSpellName(1235326)
						local icon = C_Spell.GetSpellTexture(1235326)
						local color = T.GetSpellColor(1235326)
						
						frame.bar = T.CreateAlertBarShared(1, "bossmod"..frame.config_id, icon, name, color)
						frame.bar.glow:SetBackdropBorderColor(unpack(color))
						frame.bar.glow:Show()
						
						function frame:UpdateCastState(start)
							if self.cast_exp then
								if UnitCastingInfo("player") then
									local endTimeMS = select(5, UnitCastingInfo("player"))
									if endTimeMS < self.cast_exp then
										self.bar.mid:SetText(string.format("|cff00ff00%s|r", L["安全施法"]))
										T.PlaySound("safecasting")
									else
										self.bar.mid:SetText(string.format("|cffff0000%s|r", L["停止施法"]))
										T.PlaySound("stopcasting")
									end
								elseif UnitChannelInfo("player") then
									local endTimeMS = select(5, UnitChannelInfo("player"))
									if endTimeMS < self.cast_exp then
										self.bar.mid:SetText(string.format("|cff00ff00%s|r", L["安全施法"]))
										T.PlaySound("safecasting")
									else
										self.bar.mid:SetText(string.format("|cffff0000%s|r", L["停止施法"]))
										T.PlaySound("stopcasting")
									end
								else
									self.bar.mid:SetText("")
									if start then
										T.PlaySound("interruptcasting")
									end
								end
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_START" then
							local unit, cast_GUID, cast_spellID = ...
							if unit and cast_GUID and cast_spellID then
								if cast_spellID == 1235326 and not frame.cast_exp then
									local startTimeMS, endTimeMS = select(4, UnitCastingInfo(unit))
									local cast_dur = (endTimeMS - startTimeMS)/1000
									T.StartTimerBar(frame.bar, cast_dur, true, true)
									frame.bar.anim:Play()
									frame.cast_exp = endTimeMS
									frame:UpdateCastState(true)
								elseif unit == "player" then
									frame:UpdateCastState()
								end
							end
						elseif event == "UNIT_SPELLCAST_STOP" then
							local unit, cast_GUID, cast_spellID = ...
							if unit and cast_GUID and cast_spellID then
								if cast_spellID == 1235326 and frame.cast_exp then
									T.StopTimerBar(frame.bar, true, true)
									frame.bar.anim:Stop()
									frame.cast_exp = nil
								elseif unit == "player" then
									frame:UpdateCastState()
								end
							end
						elseif event == "UNIT_SPELLCAST_CHANNEL_START" or event == "UNIT_SPELLCAST_CHANNEL_UPDATE" then
							local unit = ...
							if unit == "player" then
								frame:UpdateCastState()
							end
						elseif event == "UNIT_SPELLCAST_CHANNEL_STOP" then
							local unit = ...
							if unit == "player" then
								frame:UpdateCastState()
							end
						end
					end,
					reset = function(frame, event)
						T.StopTimerBar(frame.bar, true, true)
						frame.bar.anim:Stop()
						frame.cast_exp = nil
					end,
				},
			},
		},
		{ -- 石裔切割者:石拳
			spells = {
				{1237071},
			},
			options = {
				{ -- 对我施法图标 石拳（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1237071,
					hl = "yel_flash",
					sound = "[knockback]",
				},
			},
		},
		{ -- 石精噬踝者:脚踝撕咬
			spells = {
				{1235245},
			},
			options = {
				{ -- 图标 脚踝撕咬（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1235245,
					hl = "",
					tip = L["DOT"].."+"..L["减速"].."%s20%",
				},
				{ -- 团队框架高亮 龟裂创伤（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1235245,
					color = "red",
					amount = 5,
				},
			},
		},		
		{ -- 石裔剔骨者:投掷战刃
			spells = {
				{326638},
			},
			options = {
				{ -- 对我施法图标 投掷战刃（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_SUCCESS",
					spellID = 326638,
					dur = 1,
					show_tar = true,
					sound = "[getout]",
				},
				{ -- 首领模块 投掷战刃 计时圆圈（✓）
					category = "BossMod",
					spellID = 326638,
					enable_tag = "none",
					name = T.GetIconLink(326638)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[326638] = { -- 投掷战刃
								event = "SPELL_CAST_SUCCESS",
								target_me = true,
								dur = 1,
								color = {1, 1, 0},
								reverse = true,
							},
						}
						T.InitCircleTimers(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateCircleTimers(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetCircleTimers(frame)
					end,
				},
			},
		},
		{ -- 石裔掠夺者:变为石头
			spells = {
				{1235762},
			},
			options = {
				{ -- 计时条 变为石头（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1235762,
					sound = "[outcircle]cast",
				},
			},
		},
		{ -- 石裔掠夺者:致死打击
			spells = {
				{1235766},
			},
			options = {
				{ -- 对我施法图标 致死打击（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 1235766,
					hl = "yel_flash",
					sound = "[defense]",
				},
				{ -- 团队框架图标 致死打击（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 1235766,
				},
				{ -- 图标 致死打击（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1235766,
					hl = "red",
					tip = L["致死"].."50%",
				},
				{ -- 团队框架高亮 致死打击（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1235766,
					color = "red",
				},
			},
		},
		{ -- 审判官西加尔:耀武扬威
			spells = {
				{1236614},
			},
			options = {
				{ -- 计时条 耀武扬威（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1236614,
					text = L["增加伤害/治疗"],
				},
				{ -- 图标 耀武扬威（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1236614,
					hl = "gre",
					tip = L["增加伤害/治疗"].."30%",
					sound = "[spread]",
				},
				{ -- 首领模块 耀武扬威 计时圆圈（✓）
					category = "BossMod",
					spellID = 1236614,
					enable_tag = "none",
					name = T.GetIconLink(1236614)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {	
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1236614] = { -- 耀武扬威
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
		{ -- 审判官西加尔:邪恶箭矢
			spells = {
				{326829},
			},
			options = {
				{ -- 姓名板打断图标 邪恶箭矢（✓）
					category = "PlateAlert",
					type = "PlateInterrupt",
					spellID = 326829,
					mobID = "167876",
					interrupt = 3,
					ficon = "6",
				},
				{ -- 对我施法图标 邪恶箭矢（✓）
					category = "AlertIcon",
					type = "com",
					spellID = 326829,
					hl = "yel_flash",
				},
				{ -- 团队框架图标 邪恶箭矢（✓）
					category = "RFIcon",
					type = "Cast",
					spellID = 326829,
				},
			},
		},
		{ -- 审判官西加尔:驱散罪孽
			spells = {
				{326847},
			},
			options = {
				{ -- 计时条 驱散罪孽（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 326847,
					sound = "[dodge_circle]cast",
				},
				{ -- 图标 痛楚（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 326891,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 审判官西加尔:黑暗圣餐
			spells = {
				{326794},
			},
			options = {
				{ -- 首领模块 小怪技能倒计时 黑暗圣餐（✓）
					category = "BossMod",
					spellID = 326794,
					name = T.GetIconLink(326794)..L["倒计时"],
					enable_tag = "none",
					points = {hide = true},
					events = {
						["UNIT_ENTERING_COMBAT"] = true,
						["GROUP_LEAVING_COMBAT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					init = function(frame)
						frame.cast_npcID = {
							["167876"] = {
								engage_cd = 3.8,
								cast_cd = 31.3,
								cast_gap = 5,
							},
						}
						
						frame.cast_spellID = 326794
						frame.cast_str = T.GetSpellIcon(frame.cast_spellID)..L["召唤小怪"]
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
				{ -- 计时条 黑暗圣餐（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 326794,
					sound = "[add]cast",
					text = L["召唤小怪"],
				},
			},
		},
		{ -- 嫉妒具象:嫉妒之印
			spells = {
				{340446},
			},
			options = {				
				{ -- 图标 嫉妒之印（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 340446,
					tip = L["锁定"],
					hl = "red",
					sound = "[focusyou]",
				},
				{ -- 团队框架高亮 嫉妒之印（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 340446,
					color = "red",
				},
			},
		},
	},
}