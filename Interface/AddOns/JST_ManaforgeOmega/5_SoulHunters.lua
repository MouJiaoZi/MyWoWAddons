local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1302\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------
if G.Client == "zhCN" or G.Client == "zhTW" then
	L["虚空"] = "虚空"
	L["复仇"] = "复仇"
	L["浩劫"] = "浩劫"
	L["撞球位置分配"] = "撞球位置分配"
	L["免疫就绪"] = "免疫就绪"
	L["即将就绪"] = "即将就绪"
	L["免疫没好"] = "免疫没好"
	L["脆弱吃魂剩余数量"] = "%s吃魂剩余数量"
	L["注意吃魂"] = "注意吃魂"
elseif G.Client == "ruRU" then
	--L["虚空"] = "Void"
	--L["复仇"] = "Vengeance"
	--L["浩劫"] = "Havoc"
	--L["撞球位置分配"] = "Soak location assignment"
	--L["免疫就绪"] = "Immunity ready"
	--L["即将就绪"] = "Immunity soon"
	--L["免疫没好"] = "Immunity CD"	
	--L["脆弱吃魂剩余数量"] = "%s spirit soak remain number"
	--L["注意吃魂"] = "soak spirit"
else
	L["虚空"] = "Void"
	L["复仇"] = "Vengeance"
	L["浩劫"] = "Havoc"
	L["撞球位置分配"] = "Soak location assignment"
	L["免疫就绪"] = "Immunity ready"
	L["即将就绪"] = "Immunity soon"
	L["免疫没好"] = "Immunity CD"
	L["脆弱吃魂剩余数量"] = "%s spirit soak remain number"
	L["注意吃魂"] = "soak spirit"
end
---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters[2688] = {
	engage_id = 3122,
	npc_id = {"237661", "237660", "237662"},
	alerts = {
		{ -- NPC
			npcs = {
				{32500},--【阿达拉斯·暮焰】
				{31792},--【维拉瑞安·血愤】
				{31791},--【伊利萨·悲夜】
			},
			options = {
				{ -- 首领模块 姓名板标记 阿达拉斯·暮焰
					category = "BossMod",
					spellID = 1232569,
					enable_tag = "none",
					name = string.format(L["NAME姓名板标记"], T.GetNameFromNpcID("237661"))..T.hex_str(L["虚空"], {.23, .35, .96}),
					points = {hide = true},
					events = {
						["NAME_PLATE_UNIT_ADDED"] = true,
					},
					custom = {
						{
							key = "test_btn", 
							text = L["测试姓名板标记"],
							onclick = function(alert)
								T.ShowAllNameplateExtraTex("npc237661")
								C_Timer.After(3, function()
									T.HideAllNameplateExtraTex()
								end)
							end
						},
					},
					init = function(frame)
						G.NameplateTextures["npc237661"] = {
							w = 70,
							h = 30,
							text = L["虚空"],
							fs = 16,
							fc = {.23, .35, .96},
						}
						
						frame.mobID = "237661"
					end,
					update = function(frame, event, ...)
						if event == "NAME_PLATE_UNIT_ADDED" then
							local unit = ...
							local GUID = UnitGUID(unit)
							local npcID = select(6, strsplit("-", GUID))
							if npcID == frame.mobID then
								T.ShowNameplateExtraTex(unit, "npc237661")
							end
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
				{ -- 首领模块 姓名板标记 维拉瑞安·血愤
					category = "BossMod",
					spellID = 1231501,
					enable_tag = "none",
					name = string.format(L["NAME姓名板标记"], T.GetNameFromNpcID("237660"))..T.hex_str(L["浩劫"], {.72, .94, .19}),
					points = {hide = true},
					events = {
						["NAME_PLATE_UNIT_ADDED"] = true,
					},
					custom = {
						{
							key = "test_btn", 
							text = L["测试姓名板标记"],
							onclick = function(alert)
								T.ShowAllNameplateExtraTex("npc237660")
								C_Timer.After(3, function()
									T.HideAllNameplateExtraTex()
								end)
							end
						},
					},
					init = function(frame)
						G.NameplateTextures["npc237660"] = {
							w = 70,
							h = 30,
							text = L["浩劫"],
							fs = 16,
							fc = {.72, .94, .19},
						}
						
						frame.mobID = "237660"
					end,
					update = function(frame, event, ...)
						if event == "NAME_PLATE_UNIT_ADDED" then
							local unit = ...
							local GUID = UnitGUID(unit)
							local npcID = select(6, strsplit("-", GUID))
							if npcID == frame.mobID then
								T.ShowNameplateExtraTex(unit, "npc237660")
							end
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
				{ -- 首领模块 姓名板标记 伊利萨·悲夜
					category = "BossMod",
					spellID = 1232568,
					enable_tag = "none",
					name = string.format(L["NAME姓名板标记"], T.GetNameFromNpcID("237662"))..T.hex_str(L["复仇"], {.92, .62, .86}),
					points = {hide = true},
					events = {
						["NAME_PLATE_UNIT_ADDED"] = true,
					},
					custom = {
						{
							key = "test_btn", 
							text = L["测试姓名板标记"],
							onclick = function(alert)
								T.ShowAllNameplateExtraTex("npc237662")
								C_Timer.After(3, function()
									T.HideAllNameplateExtraTex()
								end)
							end
						},
					},
					init = function(frame)
						G.NameplateTextures["npc237662"] = {
							w = 70,
							h = 30,
							text = L["复仇"],
							fs = 16,
							fc = {.92, .62, .86},
						}
						
						frame.mobID = "237662"
					end,
					update = function(frame, event, ...)
						if event == "NAME_PLATE_UNIT_ADDED" then
							local unit = ...
							local GUID = UnitGUID(unit)
							local npcID = select(6, strsplit("-", GUID))
							if npcID == frame.mobID then
								T.ShowNameplateExtraTex(unit, "npc237662")
							end
						end
					end,
					reset = function(frame, event)
						T.HideAllNameplateExtraTex()
					end,
				},
			},
		},
		{ -- 吞噬者之怒
			npcs = {
				{32500},--【阿达拉斯·暮焰】
			},
			spells = {
				{1222232, "5,7"},--【吞噬者之怒】
				--{1234565},--【吞噬】
				--{1222310},--【无餍之饥】
			},
			options = {
				{ -- 图标 吞噬者之怒（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222232,
					hl = "blu",
					ficon = "7",
				},
				{ -- 图标 吞噬（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222307,
					effect = 1,
					hl = "",
					tip = L["吸收治疗"],
				},
				{ -- 首领模块 团队框架吸收治疗数值（待测试）
					category = "BossMod",
					spellID = 1222307,
					ficon = "2",
					enable_tag = "role",
					name = L["团队框架吸收治疗数值"],
					points = {hide = true},
					events = {
						["UNIT_HEAL_ABSORB_AMOUNT_CHANGED"] = true,
					},
					init = function(frame)
						T.InitRFHealAbsorbValues(frame)			
					end,
					update = function(frame, event, ...)
						T.UpdateRFHealAbsorbValues(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetRFHealAbsorbValues(frame)
					end,
				},
				{ -- 首领模块 吞噬者之怒 分配及驱散（待测试）
					category = "BossMod",
					spellID = 1222232,
					enable_tag = "everyone",
					name = T.GetIconLink(1222232)..L["分配"].."("..string.format(L["NAME驱散提示"], T.GetIconLink(1222232))..")",
					points = {a1 = "TOPLEFT", a2 = "CENTER", x = -700, y = 350},
					events = {
						["JST_MACRO_PRESSED"] = true,
						["JST_DISPEL_EVENT"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					custom = {
						{
							key = "mrt_custom_btn",
						},
						{
							key = "mrt_analysis_btn",
						},
					},
					init = function(frame)
						frame.GUIDToHealerGUID = {}
						frame.backupHealerGUIDs = {}
						frame.lastDispelAssignmentTime = {}
						frame.macroPressed = false	
						frame.aura_id = 1222232
						frame.text_frame_dispeler = T.CreateAlertTextShared("bossmod"..frame.config_id.."dispeler", 1)
						frame.text_frame_dispelee = T.CreateAlertTextShared("bossmod"..frame.config_id.."dispelee", 1)
						
						function frame:copy_mrt()
							local str = [[
								#%dstart%s
								damager damager healer
								damager damager healer
								damager damager healer
								end
							]]
							
							str = gsub(str, "	", "")
							return string.format(str, self.config_id, C_Spell.GetSpellName(self.config_id))
						end
						
						function frame:ReadNote(display)
							self.GUIDToHealerGUID = table.wipe(self.GUIDToHealerGUID)
							self.backupHealerGUIDs = table.wipe(self.backupHealerGUIDs)
							
							local assignedHealerGUIDs = {}
							local set = 0
							
							for _, line in T.IterateNoteAssignment(self.config_id) do
								local GUIDs = T.LineToGUIDArray(line)
								
								if next(GUIDs) then
									set = set + 1
									local healerGUID
									
									-- First find the healer GUID
									for _, GUID in ipairs(GUIDs) do
										local unit = T.GUIDToUnit(GUID)
										local isHealer = UnitGroupRolesAssigned(unit) == "HEALER"
										
										if isHealer then
											healerGUID = GUID											
											tInsertUnique(assignedHealerGUIDs, healerGUID)
											break
										end
									end
									
									-- Assign each GUID to be dispelled by the found healer
									if healerGUID then
										local str = string.format("[%d] ", set)
										for _, GUID in pairs(GUIDs) do
											self.GUIDToHealerGUID[GUID] = healerGUID
											local name = T.ColorNickNameByGUID(GUID)
											str = str.." "..name
										end
										
										local healer_name = T.ColorNickNameByGUID(healerGUID)
										str = str..string.format("(%s:%s)", L["驱散"], healer_name)
										
										if display then
											T.msg(str)
										end
									end
								end
							end
							
							-- Find unassigned healer GUIDs, they are first prio in the backup list
							for unit in T.IterateGroupMembers() do
								local GUID = UnitGUID(unit)
								local isVisible = UnitIsVisible(unit)
								local isHealer = UnitGroupRolesAssigned(unit) == "HEALER"
								local isAssigned = tContains(assignedHealerGUIDs, GUID)
								
								if isVisible and isHealer and not isAssigned then
									table.insert(self.backupHealerGUIDs, GUID)
								end
							end
							
							table.sort(self.backupHealerGUIDs)
							table.sort(assignedHealerGUIDs)
							
							tAppendAll(self.backupHealerGUIDs, assignedHealerGUIDs)
							
							local str = L["替补驱散优先级"]
							for _, GUID in pairs(self.backupHealerGUIDs) do
								local healer_name = T.ColorNickNameByGUID(GUID)
								str = str.." "..healer_name
							end
							
							if display then
								T.msg(str)
							end 
						end
						
						function frame:AssignHealer(GUID, healerGUID)
							self.lastDispelAssignmentTime[healerGUID] = GetTime()
							
							if healerGUID == G.PlayerGUID then
								self.currentTarget = GUID
								
								local info = T.GetGroupInfobyGUID(GUID)
								T.GlowRaidFramebyUnit_Hide("pixel", "bm"..frame.config_id, info.unit)
								T.GlowRaidFramebyUnit_Show("proc", "bm"..frame.config_id, info.unit, {0, 1, 0})
								T.Start_Text_Timer(self.text_frame_dispeler, 5, L["驱散"]..info.format_name)
								
								T.PlaySound("dispel_now")
								C_Timer.After(1, function()
									local name = T.GetNameByGUID(GUID)
									if name then
										T.SpeakText(name)
									end
								end)
							elseif GUID == G.PlayerGUID then
								local healer_name = T.ColorNickNameByGUID(healerGUID)
								T.Start_Text_Timer(self.text_frame_dispelee, 5, healer_name..L["驱散你"])
							end
						end
					end,
					update = function(frame, event, ...)			
						 if event == "JST_MACRO_PRESSED" then
							local arg = ...
							if arg == "DispelMe" and C_UnitAuras.GetPlayerAuraBySpellID(frame.aura_id) and not frame.macroPressed then -- Devourer's Ire
								frame.macroPressed = true
								
								T.SendChatMsg(L["已按宏"], nil, "RAID")
								T.addon_msg("dispel_event,"..frame.aura_id, "GROUP")
							end
						
						elseif event == "JST_DISPEL_EVENT" then
							local unit, GUID, spellID = ...
							
							if spellID ~= frame.aura_id then return end
							
							local assignedHealerGUID = frame.GUIDToHealerGUID[GUID]
							
							-- If the player that pressed their macro has a healer assigned to them, assign them if possible
							if assignedHealerGUID then
								local assignedHealerUnit = T.GUIDToUnit(assignedHealerGUID)
								local isAlive = not UnitIsDeadOrGhost(assignedHealerUnit)
								
								if isAlive then
									frame:AssignHealer(GUID, assignedHealerGUID)
									return
								end
							end
							
							for _, healerGUID in ipairs(frame.backupHealerGUIDs) do
								local healerUnit = T.GUIDToUnit(healerGUID)
								local isAlive = not UnitIsDeadOrGhost(healerUnit)
								local lastDispelAssignmentTime = frame.lastDispelAssignmentTime[healerGUID] or 0
								local isAffected = AuraUtil.FindAuraBySpellID(frame.aura_id, healerUnit, "HARMFUL")
								
								if isAlive and not isAffected and lastDispelAssignmentTime < GetTime() - 8 then
									frame:AssignHealer(GUID, healerGUID)
									return
								end
							end
							
							-- Assign the highest priority backup healer (first in the array) that is alive/not affected
							-- Basically the same as above, but don't check for last dispel assignment time
							-- This should practically ever happen
							for _, healerGUID in ipairs(frame.backupHealerGUIDs) do
								local healerUnit = T.GUIDToUnit(healerGUID)
								local isAlive = not UnitIsDeadOrGhost(healerUnit)
								local isAffected = AuraUtil.FindAuraBySpellID(frame.aura_id, healerUnit, "HARMFUL")
								
								if isAlive and not isAffected then
									frame:AssignHealer(GUID, healerGUID)
									return
								end
							end
						
						elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							
							if sub_event == "SPELL_AURA_APPLIED" and spellID == frame.aura_id then
								if destGUID == G.PlayerGUID then
									frame.macroPressed = false
								end
								
								-- If we are the assigned healer to dispel the target, glow their frame red
								local assignedHealerGUID = frame.GUIDToHealerGUID[destGUID]
								if assignedHealerGUID == G.PlayerGUID then
									local unit = T.GUIDToUnit(destGUID)
									T.GlowRaidFramebyUnit_Show("pixel", "bm"..frame.config_id, unit, {1, 0, 0})
								end
								
							elseif sub_event == "SPELL_AURA_REMOVED" and spellID == frame.aura_id then
								if destGUID == G.PlayerGUID then
									T.Stop_Text_Timer(frame.text_frame_dispelee)
								end
								
								local assignedHealerGUID = frame.GUIDToHealerGUID[destGUID]
								if assignedHealerGUID == G.PlayerGUID or frame.currentTarget == destGUID then
									local unit = T.GUIDToUnit(destGUID)
									T.GlowRaidFramebyUnit_Hide("pixel", "bm"..frame.config_id, unit)
									T.GlowRaidFramebyUnit_Hide("proc", "bm"..frame.config_id, unit)
									T.Stop_Text_Timer(frame.text_frame_dispeler)
								end
							end
							
						elseif event == "ENCOUNTER_START" then
							frame.macroPressed = false
							frame.lastDispelAssignmentTime = table.wipe(frame.lastDispelAssignmentTime)

							frame:ReadNote()
						end
					end,
					reset = function(frame, event)
						frame.currentTarget = nil
						T.GlowRaidFrame_HideAll("pixel","bm"..frame.config_id)
						T.GlowRaidFrame_HideAll("proc","bm"..frame.config_id)
						T.Stop_Text_Timer(frame.text_frame_dispeler)
						T.Stop_Text_Timer(frame.text_frame_dispelee)
					end,
				},
				{ -- 图标 无餍之饥（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1222310,
					text = L["易伤"],
					hl = "",
				},		
			},
		},
		{ -- 虚空瞬步
			npcs = {
				{32500},--【阿达拉斯·暮焰】
			},
			spells = {
				{1227355},--【虚空瞬步】
				--{1227685},--【饥渴斩击】
				--{1235045},--【湮灭逼近】
			},
			options = {
				{ -- 文字 虚空瞬步 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = T.GetIconLink(1227355)..L["倒计时"],
					data = {
						spellID = 1227355,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							[15] = {
								[1] = {33.0, 31.1, 28.1},
								[2] = {21.2, 31.1, 28.1},
								[3] = {21.2, 31.1, 28.1},
								[4] = {20.2, 31.1},
							},
							[16] = {
								[1] = {26.5, 33.7},
								[2] = {15.2, 33.7},
								[3] = {15.7, 33.7},
								[4] = {8.4},
							},	
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1227355, T.GetIconLink(1227355), self, event, ...)
					end,
				},
				{ -- 计时条 虚空瞬步（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227355,
					sound = "[mindstep]cast",
				},
				{ -- 图标 湮灭逼近（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1235045,
					tip = L["DOT"],
					hl = "pur",
				},
				{ -- 首领模块 湮灭逼近 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1235045,
					enable_tag = "none",
					name = T.GetIconLink(1235045)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1235045] = 0,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 65
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
				},
			},
		},
		{ -- 根除
			npcs = {
				{32500},--【阿达拉斯·暮焰】
			},
			spells = {
				{1245743, "12,4"},--【根除】
			},
			options = {
				{ -- 计时条 根除（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1245726,
					text = L["躲地板"],
				},
			},
		},
		{ -- 坍缩之星
			npcs = {
				{32566},--【阿达拉斯·暮焰】
			},
			spells = {
				{1233093, "5"},--【坍缩之星】
				--{1233105},--【黑暗残渣】
				--{1233968, "4"},--【黑洞视界】
			},
			options = {
				{ -- 计时条 坍缩之星（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1233093,
					text = L["拉人"],
					sound = "[pull]cast",
				},
				{ -- 图标 黑暗残渣（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233105,
					tip = L["DOT"],
					hl = "red",
				},
				{ -- 首领模块 黑暗残渣 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1233105,
					enable_tag = "none",
					name = T.GetIconLink(1233105)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1233105] = 0,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 65
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
				},
				{ -- 首领模块 分配 黑暗残渣（✓）
					category = "BossMod",
					spellID = 1233093,
					ficon = "12",
					name = T.GetIconLink(1233093)..L["撞球位置分配"].." "..string.format(L["使用标记%s"], T.FormatRaidMark("1,2,8,5,4,3,6")),
					enable_tag = "everyone",
					points = {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 30, y = -200},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,	
					},
					custom = {
						{
							key = "dur_sl",
							text = L["持续时间"],
							default = 30,
							min = 5,
							max = 30,
						},
					},
					init = function(frame)
						frame.intermissionCount = 0
						frame.affectedCount = 0
						frame.affected = {}
						frame.isWarlockOrShadowPriest = {}
						frame.isHealer = {}
						frame.indexToMark = {1, 2, 8, 5, 4, 3, 6}
						
						T.GetBarsCustomData(frame)
						
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 2)
						
						function frame:init_data()
							self.affectedCount = 0
							self.affected = table.wipe(self.affected)
							for i = 1, 7 do
								self.affected[i] = {}
							end
						end
						
						function frame:assign()
							self.intermissionCount = self.intermissionCount + 1
        
							-- Sort all subgroups
							for _, group in pairs(self.affected) do
								table.sort(group)
							end
							
							-- Sort groups
							-- Warlocks and Shadow Priests should be close to star
							table.sort(self.affected, function(groupA, groupB)
								if #groupA == 0 then return false end
								if #groupB == 0 then return true end
								
								-- Count warlocks/shadow priests in group A
								local countA = 0
								
								for _, GUID in pairs(groupA) do
									local isWarlockOrShadowPriest = self.isWarlockOrShadowPriest[GUID]
									
									if isWarlockOrShadowPriest then
										countA = countA + 1
									end
								end
								
								-- Count warlocks/shadow priests in group A
								local countB = 0
								
								for _, GUID in pairs(groupB) do
									local isWarlockOrShadowPriest = self.isWarlockOrShadowPriest[GUID]
									
									if isWarlockOrShadowPriest then
										countB = countB + 1
									end
								end
								
								if countA ~= countB then
									return countA > countB
								end
								
								-- Count healers in group A
								local healerCountA = 0
								
								for _, GUID in pairs(groupA) do
									local isHealer = self.isHealer[GUID]
									
									if isHealer then
										healerCountA = healerCountA + 1
									end
								end
								
								-- Count healers in group b
								local healerCountB = 0
								
								for _, GUID in pairs(groupB) do
									local isHealer = self.isHealer[GUID]
									
									if isHealer then
										healerCountB = healerCountB + 1
									end
								end
								
								if healerCountA ~= healerCountB then
									return healerCountA > healerCountB
								end
								
								return groupA[1] < groupB[1]
							end)
												
							for groupIndex, group in pairs(self.affected) do
								local markIndex = self.indexToMark[groupIndex]
								
								local str = ""
									
								for _, GUID in ipairs(group) do
									local info = T.GetGroupInfobyGUID(GUID)
									str = str.." "..info.format_name
								end
								
								T.msg(string.format("%s%s:%s", L["撞球"], T.FormatRaidMark(markIndex), str))
								
								if tContains(group, G.PlayerGUID) then
									local dur = C.DB["BossMod"][self.config_id]["dur_sl"]
									T.Start_Text_Timer(self.text_frame, dur, L["撞球"].." "..T.FormatRaidMark(markIndex))
									T.PlaySound("mark\\mark"..markIndex)
								end
							end
							
							self:init_data()
						end
					end,
					update = function(frame, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local unit, cast_GUID, cast_spellID = ...
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_AURA_APPLIED" and spellID == 1242883 then -- 灵魂束缚
								if frame.intermissionCount >= 2 then return end
            
								frame.affectedCount = frame.affectedCount + 1
								
								local groupIndex = math.floor((frame.affectedCount - 1) / 3) + 1
								
								table.insert(frame.affected[groupIndex], destGUID)
								
								if frame.affectedCount == 1 then
									C_Timer.After(0.5, function()
										frame:assign()
									end)
								end
							end
						elseif event == "ENCOUNTER_START" then
							frame.intermissionCount = 0
							frame.isWarlockOrShadowPriest = table.wipe(frame.isWarlockOrShadowPriest)
							frame.isHealer = table.wipe(frame.isHealer)
							frame:init_data()
							
							 for unit in T.IterateGroupMembers() do
								local GUID = UnitGUID(unit)
								local role = UnitGroupRolesAssigned(unit)
								local class = UnitClassBase(unit)
								
								if class == "WARLOCK" or (class == "PRIEST" and role == "DAMAGER") then
									frame.isWarlockOrShadowPriest[GUID] = true
								end
								
								if role == "HEALER" then
									frame.isHealer[GUID] = true
								end
							end
						end
					end,
					reset = function(frame, event)
						T.Stop_Text_Timer(frame.text_frame)
					end,
				},
				{ -- 图标 黑洞视界（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233968,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 恶魔追击
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1227809, "5"},--【恶魔追击】
				--{1247415, "12"},--【弱化猎物】
			},
			options = {
				{ -- 文字 恶魔追击 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["冲锋"]..L["倒计时"],
					data = {
						spellID = 1227809,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},					
						info = {
							["all"] = {
								[1] = {42.6, 34.9},
								[2] = {31.0, 34.9},
								[3] = {31.0, 34.9},
								[4] = {8.0},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1227809, L["冲锋"], self, event, ...)
					end,
				},				
				{ -- 首领模块 恶魔追击 计时圆圈（✓）
					category = "BossMod",
					spellID = 1227847,
					enable_tag = "none",
					name = T.GetIconLink(1227847)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1227847] = { -- 恶魔追击
								event = "SPELL_AURA_APPLIED",
								target_me = true,
								dur = 6,
								color = {1, 0, 0},
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
				{ -- 首领模块 计时条 恶魔追击（✓）
					category = "BossMod",
					spellID = 1227809,
					name = string.format(L["计时条%s"], T.GetIconLink(1227847)),
					enable_tag = "none",
					points = {hide = true},
					events = {
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,	
					},
					custom = {
						{
							key = "sound_bool",
							text = L["音效"],
							default = true,
							sound = "charge",
						},
						{
							key = "raid_index_bool",
							text = L["团队序号"],
							default = true,
						},
					},
					init = function(frame)
						frame.bars = {}
						frame.max_count = 2
						frame.trackedspellIDs = {}
						
						frame.immuse_class = {
							--DRUID = 22812, -- 树皮术 test
							MAGE = 45438, -- Ice Block
							DEMONHUNTER = 196555, -- Netherwalk
							HUNTER = 186265, -- Turtle
							PALADIN = 642, -- Divine Shield
							PRIEST = 47585, -- Dispersion
							ROGUE = 31224, -- Cloak of Shadows
						}
						
						for _, spellID in pairs(frame.immuse_class) do
							frame.trackedspellIDs[spellID] = true
						end
						
						function frame:UpdateImmuseBuff(GUID)
							local bar =  self.bars[GUID]
							if not bar then return end
							
							local info = T.GetGroupInfobyGUID(GUID)
							local unit = info.unit
							local spellID = self.immuse_class[info.class]
							if spellID then
								local buffed = AuraUtil.FindAuraBySpellID(spellID, unit, "HELPFUL")
								if buffed then
									bar:SetStatusBarTexture(0, 1, 0)
									bar.spell_text:SetText(T.GetSpellIcon(spellID))
								else
									bar:SetStatusBarTexture(1, .2, 0)
									local ready, _, _, remain = T.GetGroupCooldown(GUID, spellID)
									if ready then
										bar.spell_text:SetText(string.format("|cff00ff00%s|r", L["免疫就绪"]))
									elseif remain and remain <= 5 then
										bar.spell_text:SetText(string.format("|cff00ff00%s%s|r", L["即将就绪"]))
									else
										bar.spell_text:SetText(string.format("|cff8c8d8c%s|r", L["免疫没好"]))
									end
								end
							else
								bar:SetStatusBarTexture(1, .2, 0)
								bar.spell_text:SetText("")
							end							
						end
						
						function frame:CreateBar(GUID)
							local bar = T.CreateAlertBarShared(2, "bossmod"..self.config_id..GUID, C_Spell.GetSpellTexture(1227847), L["冲锋"])
							
							bar.spell_text = T.createtext(bar, "OVERLAY", C.DB["TimerbarOption"]["bar_height"]*.8, "OUTLINE", "LEFT")
							bar.spell_text:SetPoint("LEFT", bar, "RIGHT", 5, 0)
							
							bar:HookScript("OnSizeChanged", function(self, width, height)
								self.spell_text:SetFont(G.Font, height*.8, "OUTLINE")
							end)
							
							self.bars[GUID] = bar
							
							return bar
						end
						
						function frame:start(index, GUID)
							local bar = self.bars[GUID] or self:CreateBar(GUID)
							
							local info = T.GetGroupInfobyGUID(GUID)
							bar.mid:SetText(info and info.format_name or "")
							
							self:UpdateImmuseBuff(GUID)
							T.StartTimerBar(bar, 6, true, true)
							
							if self.diffcultyID == 16 then
								bar.ind_text:SetText(string.format("|cffFFFF00[%d]|r", index))
								
								if C.DB["BossMod"][self.config_id]["sound_bool"] then
									T.PlaySound("1302\\charge"..index)
								end
								
								if C.DB["BossMod"][self.config_id]["raid_index_bool"] then
									local unit_frame = T.GetUnitFrame(info.unit)
									if unit_frame then					
										T.CreateRFIndex(unit_frame, string.format("|cffFF0000%d|r", index))
										C_Timer.After(6, function()
											T.HideRFIndexbyParent(unit_frame)
										end)
									end
								end
							else
								bar.ind_text:SetText("")
								if C.DB["BossMod"][self.config_id]["sound_bool"] then
									T.PlaySound("charge")
								end
							end
							
							if C.DB["BossMod"][self.config_id]["sound_bool"] then
								C_Timer.After(1, function()
									local name = T.GetNameByGUID(GUID)
									if name then
										T.SpeakText(name)
									end
								end)
							end
						end
					end,
					update = function(frame, event, ...)
						if event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local unit, cast_GUID, cast_spellID = ...
							local _, sub_event, _, _, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							if sub_event == "SPELL_AURA_APPLIED" and spellID == 1227847 then -- 恶魔追击
								frame.count = frame.count + 1
            
								if frame.count == (frame.max_count + 1) then
									frame.count = 1
								end
								
								frame:start(frame.count, destGUID)
								
							elseif sub_event == "SPELL_AURA_APPLIED" and frame.trackedspellIDs[spellID] then		
								frame:UpdateImmuseBuff(destGUID)
								
							elseif sub_event == "SPELL_AURA_REMOVED" and frame.trackedspellIDs[spellID] then
								frame:UpdateImmuseBuff(destGUID)	
							end
						elseif event == "ENCOUNTER_START" then
							frame.count = 0
							
							frame.diffcultyID = select(3, ...)
							
							if frame.diffcultyID == 16 then
								frame.max_count = 3
							else
								frame.max_count = 2
							end
						end
					end,
					reset = function(frame, event)
						for _, bar in pairs(frame.bars) do
							T.StopTimerBar(bar, true, true)
						end
						frame.bars = table.wipe(frame.bars)
						T.HideAllRFIndex()
					end,
				},
				{ -- 图标 弱化猎物（史诗待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1247415,
					tip = L["易伤"],
				},
			},
		},
		{ -- 刃舞
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1241306},--【刃舞】
			},
			options = {
				{ -- 计时条 刃舞（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1241254,
					dur = 3,
					sound = "[mindstep]cast",
				},
			},
		},
		{ -- 眼棱
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1218103, "0,12"},--【眼棱】
				--{1221490, "12"},--【邪能灼痕】
				--{1225127},--【邪能之刃】
			},
			options = {		
				{ -- 文字 眼棱 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = T.GetIconLink(1218103)..L["倒计时"],
					data = {
						spellID = 1218103,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {19.7, 34.9, 34.9},
								[2] = {8.2, 34.9, 34.9},
								[3] = {8.2, 34.9, 34.9},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1218103, T.GetIconLink(1218103), self, event, ...)
					end,
				},
				{ -- 计时条 眼棱（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1218103,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1218103cast", "cast"),
				},
				{ -- 嘲讽提示 邪能灼痕（待测试）
					category = "BossMod",
					spellID = 1221490,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1221490),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.boss_npcID = "237660"
						frame.aura_spellIDs = {
							[1221490] = 1, -- 邪能灼痕
						}
						frame.cast_spellIDs = {
							[1218103] = true, -- 眼棱
						}
						
						T.InitTauntAlert(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateTauntAlert(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetTauntAlert(frame)
					end,
				},
				{ -- 换坦计时条 邪能灼痕（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1221490,
					ficon = "0",
					tank = true,
				},
				{ -- 图标 邪能之刃（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1225130,
					tip = L["DOT"],
				},
			},
		},
		{ -- 邪能地狱
			npcs = {
				{31792},--【维拉瑞安·血愤】
			},
			spells = {
				{1223725, "2"},--【邪能地狱】
			},
			options = {
				{ -- 计时条 邪能地狱（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1228238,
					text = L["全团AE"],
				},
				{ -- 图标 邪能地狱（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1245384,
					tip = L["DOT"],
				},
				{ -- 图标 邪能地狱（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1223725,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 邪能冲撞
			npcs = {
				{32552},--【维拉瑞安·血愤】
			},
			spells = {
				{1233863, "5"},--【邪能冲撞】
			},
			options = {
				{ -- 图标 邪能冲撞（待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1223042,
					tip = L["射线"],
					sound = "[ray]",
					hl = "org_flash",
				},
			},
		},
		{ -- 破裂
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1241833, "0,5"},--【破裂】
				--{1226493},--【破碎之魂】
				{1241917},--【脆弱】
			},
			options = {
				{ -- 文字 破裂 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = T.GetIconLink(1241833)..L["倒计时"],
					data = {
						spellID = 1241833,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {15.3, 34.9, 34.9},
								[2] = {3.6, 34.9, 34.9},
								[3] = {3.6, 34.9, 34.9},
								[4] = {3.6},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1241833, T.GetIconLink(1241833), self, event, ...)
					end,
				},
				{ -- 计时条 破裂（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1241833,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1241833cast", "cast"),
				},
				{ -- 嘲讽提示 破碎灵魂（待测试）
					category = "BossMod",
					spellID = 1226493,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1226493)..T.GetIconLink(1241917),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.boss_npcID = "237662"
						frame.aura_spellIDs = {
							[1226493] = 1, -- 破碎灵魂
							[1241917] = 1, -- 脆弱
						}
						frame.cast_spellIDs = {
							[1241833] = true, -- 破裂
						}
						
						T.InitTauntAlert(frame)
					end,
					update = function(frame, event, ...)
						T.UpdateTauntAlert(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetTauntAlert(frame)
					end,
				},
				{ -- 换坦计时条 破碎灵魂（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1226493,
					ficon = "0",
					tank = true,
				},
				{ -- 换坦计时条 脆弱（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1241917,
					ficon = "0",
					tank = true,
				},
				{ -- 文字 脆弱吃魂剩余数量（✓）
					category = "TextAlert",
					type = "spell",
					preview = string.format(L["脆弱吃魂剩余数量"], T.GetIconLink(1241917)),
					data = {
						spellID = 1241917,
						events =  {
							["UNIT_AURA_ADD"] = true,
							["UNIT_AURA_UPDATE"] = true,
							["UNIT_AURA_REMOVED"] = true,
						},
						spellIDs = {1241917, 1241946},
					},
					update = function(self, event, ...)
						if event == "UNIT_AURA_ADD" or event == "UNIT_AURA_UPDATE" then
							local unit, spellID, auraID = ...
							if spellID == 1241917 then
								if not AuraUtil.FindAuraBySpellID(1241946, "player", "HARMFUL") then -- 无脆弱
									local aura_data = C_UnitAuras.GetAuraDataByAuraInstanceID(unit, auraID)
									if aura_data and aura_data.applications > 0 then
										local remain = aura_data.expirationTime - GetTime()
										T.Start_Text_Timer(self, remain, string.format("%s|cffffff00%d|r %s", T.GetSpellIcon(1247424), aura_data.applications, L["注意吃魂"]), true)
									end
								end
							elseif unit == "player" and spellID == 1241946 then
								self:Hide()
							end
						elseif event == "UNIT_AURA_REMOVED" then
							local unit, spellID = ...
							if spellID == 1241917 then
								self:Hide()
							end
						end
					end,
				},
				{ -- 图标 脆弱（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1241946,
					tip = L["DOT"],
				},
				{ -- 首领模块 脆弱 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1241946,
					enable_tag = "none",
					name = T.GetIconLink(1241946).."(2+)"..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1241946] = 2,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 70
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
				},
				{ -- 团队框架高亮 脆弱（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1241946,
					amount = 2,
				},
			},
		},
		{ -- 幽魂炸弹
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1242259},--【幽魂炸弹】
				--{1242284},--【灵魂重碾】
				--{1242304, "4"},--【驱逐灵魂】
			},
			options = {
				{ -- 文字 幽魂炸弹 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["吸收盾"]..L["倒计时"],
					data = {
						spellID = 1242259,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {32.5, 34.9, 34.9},
								[2] = {21, 34.9, 34.9},
								[3] = {21, 34.9, 34.9},
								[4] = {14},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss", 1242259, L["吸收盾"], self, event, ...)
					end,
				},
				{ -- 计时条 幽魂炸弹（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1242259,
					glow = true,
				},
				{ -- 图标 灵魂重碾（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242284,
					effect = 1,
					hl = "",
					tip = L["吸收治疗"],
				},
				{ -- 首领模块 灵魂重碾 玩家自保技能提示（✓）
					category = "BossMod",
					spellID = 1242284,
					enable_tag = "none",
					name = T.GetIconLink(1242284)..L["玩家自保技能提示"],	
					points = {hide = true},
					events = {
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_AURA_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1242284] = 0,
						}
						frame.ignore_roles = {"TANK"}
						frame.threshold = 65
						
						T.InitPersonalSpellAlertbyAura(frame)
					end,
					update = function(frame, event, ...)
						T.UpdatePersonalSpellAlertbyAura(frame, event, ...)
					end,
					reset = function(frame, event)
						T.ResetPersonalSpellAlertbyAura(frame)
					end,
				},
				{ -- 图标 驱逐灵魂（待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242304,
					tip = L["DOT"],
					hl = "red",
				},				
			},
		},
		{ -- 锁链咒符
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1240891, "12"},--【锁链咒符】
			},
			options = {				
				{ -- 计时条 锁链咒符（✓）
					category = "AlertTimerbar",
					type = "cleu",
					event = "SPELL_CAST_START",
					spellID = 1240891,
					dur = 2.5,
				},
				{ -- 图标 锁链咒符（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1223624,
					tip = L["减速"].."40%",
				},
			},
		},
		{ -- 献祭光环
			npcs = {
				{31791},--【伊利萨·悲夜】
			},
			spells = {
				{1225154, "2"},--【献祭光环】
			},
			options = {
				
			},
		},		
		{ -- 地狱火撞击
			npcs = {
				{32545},--【伊利萨·悲夜】
			},
			spells = {
				{1227113, "5"},--【地狱火撞击】
			},
			options = {
				{ -- 文字 地狱火撞击 倒计时（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["大圈"].."+"..L["冲击波"]..L["倒计时"],
					data = {
						spellID = 1233672,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {
							["all"] = {
								[3.5] = {6.5, 9.0, 9.0},
							},
						},
						cd_args = {
							round = true,
							count_down_start = 5,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss", 1233672, L["大圈"].."+"..L["冲击波"], self, event, ...)
					end,
				},
				{ -- 计时条 地狱火撞击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1233672,
					dur = 2.3,
					sound = "[safe]cast",
					glow = true,
				},			
			},
		},
		{ -- 邪能毁灭
			npcs = {
				{32545},--【伊利萨·悲夜】
			},
			spells = {
				{1227117, "5"},--【邪能毁灭】
				--{1233381},--【凋零烈焰】
			},
			options = {
				{ -- 首领模块 邪能毁灭 倒计时（待测试）
					category = "BossMod",
					spellID = 1227117,
					enable_tag = "none",
					name = T.GetIconLink(1227117)..L["引头前"]..L["倒计时"],
					points = {hide = true},
					events = {
						["UNIT_SPELLCAST_SUCCEEDED"] = true,
					},
					init = function(frame)	
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 1)	
						frame.text_frame.round = true
						frame.text_frame.count_down_start = 5
						frame.text_frame.prepare_sound = "baitfront"
					end,
					update = function(frame, event, ...)
						if event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, castGUID, spellID = ...
							
							if not string.find(unit, "boss") or not castGUID then return end
							
							if spellID == 1232568 then -- 恶魔变形 (伊利萨·悲夜)
								frame.metaCount = frame.metaCount + 1
								
								if frame.metaCount > 2 then
									T.Start_Text_DelayTimer(frame.text_frame, 5.6, L["引头前"], true)
								end
							elseif spellID == 1227117 then -- 邪能毁灭
								frame.felDevCount = frame.felDevCount + 1
								
								if frame.felDevCount ~= 3 then -- 3rd one is the last Fel Devastation in 3rd intermission
									T.Start_Text_DelayTimer(frame.text_frame, 8, L["引头前"], true)
								end
							end
						elseif event == "ENCOUNTER_START" then
							frame.metaCount = 0
							frame.felDevCount = 0
						end
					end,
					reset = function(frame, event)
						T.Stop_Text_Timer(frame.text_frame)
					end,
				},
				{ -- 计时条 邪能毁灭（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1227117,
					text = L["冲击波"],
					glow = true,
				},
				{ -- 图标 凋零烈焰（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1233381,
					tip = L["减速"],
				},
			},
		},		
		{ -- 灵魂束缚
			spells = {
				{1245978, "12"},--【灵魂束缚】
			},
			options = {
				{ -- 图标 灵魂束缚（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1242883,
				},
			},
		},
		{ -- 动荡的灵魂
			spells = {
				{1249198, "4"},--【动荡的灵魂】
			},
			options = {
				{ -- 图标 痛苦光环（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HELPFUL",
					unit = "boss",
					spellID = 1227154,
					tip = L["DOT"],
				},
			},
		},
		{ -- 恶魔变形
			spells = {
				{1232569},--【恶魔变形】
			},
			options = {
				{ -- 计时条 恶魔变形（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1232569,
					text = L["阶段转换"],
					sound = "[phase]cast",
				},
			},
		},	
		{ -- 阶段转换
			title = L["阶段转换"],
			options = {
				{
					category = "PhaseChangeData",
					phase = 1.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 2,					
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1233093, -- 坍缩之星
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 2.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 2,
				},
				{
					category = "PhaseChangeData",
					phase = 3,					
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1233863, -- 邪能冲撞
					count = 1,
				},
				{
					category = "PhaseChangeData",
					phase = 3.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 3,
				},
				{
					category = "PhaseChangeData",
					phase = 4,					
					type = "CLEU",
					sub_event = "SPELL_AURA_REMOVED",
					spellID = 1227117, -- 邪能毁灭
					count = 3,
				},
				{
					category = "PhaseChangeData",
					phase = 4.5,					
					type = "CLEU",
					sub_event = "SPELL_CAST_START",
					spellID = 1232569, -- 恶魔变形
					count = 4,
				},
			},
		},
	},
}