local T, C, L, G = unpack(JST)

local function soundfile(filename, arg)
	return string.format("[1302\\%s]%s", filename, arg or "")
end

--------------------------------Locals--------------------------------
if G.Client == "zhCN" or G.Client == "zhTW" then
	L["出墙"] = "出墙"
	L["消墙"] = "消墙"
	L["坦克出墙"] = "坦克出墙"
	L["出墙消墙位置分配"] = "出墙、消墙位置分配"
	L["安全区文字持续时间"] = "安全区文字持续时间"
elseif G.Client == "ruRU" then
	--L["出墙"] = "Spwan wall"
	--L["消墙"] = "Break wall"
	--L["坦克出墙"] = "Tank spwan wall"
	--L["出墙消墙位置分配"] = "Spwan/break wall assignment"
	--L["安全区文字持续时间"] = "Safe spot display duration"
else
	L["出墙"] = "Spwan wall"
	L["消墙"] = "Break wall"
	L["坦克出墙"] = "Tank spwan wall"
	L["出墙消墙位置分配"] = "Spwan/break wall assignment"
	L["安全区文字持续时间"] = "Safe spot display duration"
end
---------------------------------Notes--------------------------------

---------------------------------Data--------------------------------
-- engage_id = 1810, -- 测试用
-- npc_id = {"91784"}, -- 测试用

G.Encounters[2747] = {
	engage_id = 3133,
	npc_id = {"237861"},
	alerts = {
		{ -- 虚空棱镜
			spells = {
				{1233657},--【虚空棱镜】
			},
			options = {
				{ -- 图标 折射熵变（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1241137,
					tip = L["快走开"],
					sound = "[sound_dd]",
				},
			},
		},
		{ -- 水晶枢纽
			spells = {
				{1226089},--【水晶枢纽】
				{1232130},--【节点破片】
			},
			options = {
				
			},
		},
		{ -- 破碎节点
			spells = {
				{1236784, "12"},--【破碎节点】
				{1232760, "12"},--【水晶裂伤】
				{1232130},--【节点破片】
			},
			options = {
				{ -- 图标 水晶裂伤（史诗待测试）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1232760,
					tip = L["DOT"],
				},
			},
		},
		{ -- 虚空注能节点
			spells = {
				{1236785},--【虚空注能节点】
				{1232130},--【节点破片】
				{1247424},--【虚无吞噬】
				{1247495},--【虚无爆炸】
			},
			options = {
				{ -- 文字 虚无吞噬 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["大圈"]..L["倒计时"],
					data = {
						spellID = 1247424,
						events =  {
							["UNIT_AURA_ADD"] = true,
						},	
					},
					update = function(self, event, ...)
						if event == "ENCOUNTER_START" then
							self.round = true							
							self.last_cast = 0
							T.Start_Text_DelayTimer(self, 51, L["大圈"], true)
						elseif event == "UNIT_AURA_ADD" then
							local unit, spellID = ...
							if spellID == 1247424 and GetTime() - self.last_cast > 1 then
								self.last_cast = GetTime()
								T.Start_Text_DelayTimer(self, 51, L["大圈"], true)
							end
						end
					end,
				},
				{ -- 首领模块 虚无吞噬 计时圆圈（✓）
					category = "BossMod",
					spellID = 1247424,
					enable_tag = "none",
					name = T.GetIconLink(1247424)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1247424] = { -- 虚无吞噬
								unit = "player",
								aura_type = "HARMFUL",
								color = T.GetSpellColor(1247424),
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
				{ -- 团队框架高亮 虚无吞噬（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1247424,
				},
			},
		},
		{ -- 结晶过载
			spells = {
				{1233917},--【结晶过载】
			},
			options = {
				{ -- 计时条 结晶过载（待测试）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1225673,
					text = L["BOSS狂暴"],
				},
			},
		},
		{ -- 结晶震荡波
			spells = {
				{1224414},--【结晶震荡波】
			},
			options = {
				{ -- 文字 结晶震荡波 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["出墙"]..L["倒计时"],
					data = {
						spellID = 1233411,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {
							["all"] = {
								[1] = {7, 20.7, 30.3, 20.7, 30.3, 20.7, 30.3, 20.7, 30.3, 20.7, 30.3, 20.7, 30.3, 20.7, 30.3, 20.7, 30.3, 20.7},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 1233411, L["出墙"], self, event, ...)
					end,
				},
				{ -- 首领模块 结晶震荡波 计时圆圈（✓）
					category = "BossMod",
					spellID = 1233411,
					enable_tag = "none",
					name = T.GetIconLink(1233411)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1233411] = { -- 结晶震荡波
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
				{ -- 首领模块 出墙、消墙位置分配（待测试）
					category = "BossMod",
					spellID = 1233416,
					enable_tag = "everyone",
					name = L["出墙消墙位置分配"].." "..string.format(L["使用标记%s"], T.FormatRaidMark("1,2,3,4,5,6")),
					points = {a1 = "TOPLEFT", a2 = "CENTER", x = 300, y = 340, width = 200, height = 200},
					events = {
						["UNIT_SPELLCAST_SUCCEEDED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["COMBAT_LOG_EVENT_UNFILTERED"] = true,
					},
					custom = {
						{
							key = "mrt_custom_btn",
							text = L["粘贴MRT模板"],
						},
						{
							key = "mrt_analysis_btn",
							text = L["MRT战术板解析"],
							onclick = function(alert)
								alert:ReadNoteAssignments(true)
							end
						},
						{
							key = "safe_dur_sl",
							text = L["安全区文字持续时间"],
							default = 30,
							min = 5,
							max = 50,
						},
						{
							key = "rl_bool",
							text = L["团队分配"],
							default = false,
							apply = function(value, frame)
								if value then
									if T.IsInPreview() then
										frame:PreviewRLFrame()
									end
									frame.rl_frame.enable = true
									T.RestoreDragFrame(frame.rl_frame, frame)
								else
									frame.rl_frame.enable = false
									frame.rl_frame:Hide()
									T.ReleaseDragFrame(frame.rl_frame)
								end
							end,
						},
					},
					init = function(frame)						
						T.GetScaleCustomData(frame)
						
						frame.text_frame = T.CreateAlertTextShared("bossmod"..frame.config_id, 2)
						
						frame.graphs = {}
						frame.graph_bg = CreateFrame("Frame", nil, frame)
						frame.graph_bg:SetAllPoints(frame)
						frame.graph_bg:Hide()
						
						local slices = 6
						local degrees = 100
						local widthMultiplier = 0.82 -- Decrease to create more space between slices
						
						local size = 160
						local circumference = 2 * math.pi * size / (360 / degrees)
						local slice_width = circumference / slices * widthMultiplier
						local slice_height = size
						
						frame.graph_tex_info = {
							str = {layer = "ARTWORK", text = "-", fs = 25, color = {1, 1, 1}, points = {"TOP", 0, -20}},
						}
						
						for i = 1, 6 do
							local rotation = (i - 0.5 - (slices / 2)) * (2 * math.pi * ((degrees / 360) / slices))
							
							frame.graph_tex_info["slice"..i] = {
								layer = "BACKGROUND",
								sub_layer = 1,
								tex = G.media.triangle,
								color = {1, .3, .3},
								w = slice_width,
								h = slice_height,
								rotation = {rotation, 0.5, 0.92},
								points = {"BOTTOM", 0, 0},
							}
						end
						
						T.UpdateGraphTextures(frame, frame.graph_bg)
						
						frame.graph_bg:SetAllPoints(frame)
						frame.graph_bg:Hide()
						
						local bar_width = 60
						local bar_height = 100
						T.CreateMovableFrame(frame, "rl_frame", bar_width*6+25, bar_height+15, {a1 = "TOPLEFT", a2 = "TOPLEFT", x = 225, y = -150}, "_rl_frame", L["团队分配"])
						frame.rl_frame.bars = {}
						
						for i = 1, 6 do
							local bar = CreateFrame("StatusBar", nil, frame.rl_frame)
							bar:SetSize(bar_width, bar_height)
							bar:SetPoint("BOTTOMLEFT", frame.rl_frame, "BOTTOMLEFT", (bar_width+5)*(i-1), 0)
							
							bar:SetOrientation("VERTICAL")
							bar:SetStatusBarTexture(G.media.blank)
							bar:SetStatusBarColor(0, 1, 1)
							T.createborder(bar, .25, .25, .25, 1)
														
							bar:SetMinMaxValues(0, 6)
												
							bar.name = T.createtext(bar, "OVERLAY", 14, "OUTLINE", "CENTER")
							bar.name:SetPoint("BOTTOM", bar, "BOTTOM", 0, 0)
							
							bar.text = T.createtext(bar, "OVERLAY", 14, "OUTLINE", "CENTER")
							bar.text:SetPoint("BOTTOM", bar.name, "TOP", 0, 0)
							
							bar.rt = T.createtext(bar, "OVERLAY", 14, "OUTLINE", "CENTER")
							bar.rt:SetPoint("BOTTOM", bar, "TOP", 0, 0)
							bar.rt:SetText(T.FormatRaidMark(i))
							
							bar.players = {}
							bar.value = 0
							bar.change = 0
							
							table.insert(frame.rl_frame.bars, bar)
						end
						
						function frame:BarDisplay(index)
							local bar = frame.rl_frame.bars[index]
							local str = ""
							for i, GUID in pairs(bar.players) do
								local format_name = T.GetGroupInfobyGUID(GUID)["format_name"]
								if i == 1 then
									str = str..format_name
								else
									str = str.."\n"..format_name
								end
							end
							
							bar.name:SetText(str)
							bar:SetValue(bar.value)
							
							if bar.change == 0 then
								bar.text:SetText(string.format("%d", bar.value))
							elseif bar.change > 0 then
								bar.text:SetText(string.format("%d|cffff0000+%d|r", bar.value, bar.change))
							else
								bar.text:SetText(string.format("%d|cff00ff00%d|r", bar.value, bar.change))
							end							
						end
						
						function frame:BarUpdate(index, GUID, change)
							table.insert(frame.rl_frame.bars[index]["players"], GUID)
							frame.rl_frame.bars[index]["change"] = frame.rl_frame.bars[index]["change"] + change
							frame:BarDisplay(index)
						end
						
						function frame:BarApplyChanges(index)
							frame.rl_frame.bars[index]["players"] = table.wipe(frame.rl_frame.bars[index]["players"])
							frame.rl_frame.bars[index]["value"] = frame.rl_frame.bars[index]["value"]+frame.rl_frame.bars[index]["change"]
							frame.rl_frame.bars[index]["change"] = 0
							frame:BarDisplay(index)
						end
						
						function frame:Display(i, text)
							self.graph_bg:Show()
							
							self.graphs.str.text:SetText(T.FormatRaidMark(i)..text)
							
							for index = 1, 6 do
								local slice = self.graphs["slice"..index]
								if index == i then
									local r, g, b = T.GetRaidMarkColor(index)
									slice.tex:SetVertexColor(r, g, b)
								else
									slice.tex:SetVertexColor(.3, .3, .3)
								end
							end
						end
						
						function frame:DisplaySafe(position, preview)
							if position then
								self:Display(position, string.format("|cff00ff00%s|r", L["安全"]))
								if not preview then
									local dur = C.DB["BossMod"][self.config_id]["safe_dur_sl"]
									T.Start_Text_Timer(self.text_frame, dur, T.FormatRaidMark(position)..string.format("|cff00ff00%s|r", L["安全"]))
								end
							end
						end
						
						function frame:DisplayAssignment(assignmentType, GUID, position, tank, preview)
							if assignmentType == "SPAWN" then
								if GUID == G.PlayerGUID then
									self:Display(position, string.format("|cff4EE8FF%s|r", L["出墙"]))
									local exp_time = select(6, AuraUtil.FindAuraBySpellID(1233411, "player", "HARMFUL")) -- 结晶震荡波
									if exp_time then
										local dur = exp_time - GetTime()
										T.Start_Text_Timer(self.text_frame, dur, T.FormatRaidMark(position)..string.format("|cff4EE8FF%s|r", L["出墙"]))
										if not tank then
											T.SendChatMsg(L["出墙"]..string.format("{rt%d}", position), 5, "SAY")
										else
											T.SendChatMsg(L["坦克"]..L["出墙"]..string.format("{rt%d}", position), 5, "SAY")
										end
									end
									if not preview then
										T.PlaySound("mark\\mark"..position)
									end
								end
								if not preview then
									local info = T.GetGroupInfobyGUID(GUID)
									if info then
										if not tank then
											local ind = mod(self.spwans_count, 2) == 1 and 1 or 3
											T.msg(string.format("[%d-%d]%s%s%s", self.rotation_count, ind, info.format_name, L["出墙"], T.FormatRaidMark(position)))
											self:BarUpdate(position, GUID, 1)
										else
											T.msg(string.format("[%d-%d]%s%s%s", self.rotation_count, 2, info.format_name, L["坦克"]..L["出墙"], T.FormatRaidMark(position)))
											self:BarUpdate(position, GUID, self.difficultyID == 16 and 3 or 1)
										end
									end
								end
							else
								if GUID == G.PlayerGUID then
									self:Display(position, string.format("|cffFF1D2D%s|r", L["消墙"]))
									local exp_time = select(6, AuraUtil.FindAuraBySpellID(1227373, "player", "HARMFUL")) -- 碎壳
									if exp_time then
										local dur = exp_time - GetTime()
										T.Start_Text_Timer(self.text_frame, dur, T.FormatRaidMark(position)..string.format("|cffFF1D2D%s|r", L["消墙"]))
										T.SendChatMsg(L["消墙"]..string.format("{rt%d}", position), 5, "YELL")
									end
									if not preview then
										T.PlaySound("mark\\mark"..position)
									end
								end
								if not preview then
									local info = T.GetGroupInfobyGUID(GUID)
									if info then
										T.msg(string.format("[%d-%d]%s%s%s", self.rotation_count, 4, info.format_name, L["消墙"], T.FormatRaidMark(position)))
										self:BarUpdate(position, GUID, -1)
									end
								end
							end
						end
						
						frame.spawnGUIDs = {}
						frame.breakGUIDs = {}
						frame.spawns = {}
						frame.tankSpawns = {}
						frame.breaks = {}
						frame.safespots = {}
						frame.spwans_count = 0
						frame.rotation_count = 0
						
						local heroicDefault = [[
							+ 1 1 0 1 1 0 (3)
							T 6 (3)
							+ 1 1 0 1 1 0 (3)
							- 2 2 0 2 0 0
							
							+ 1 1 0 1 1 0 (3)
							T 6 (3)
							+ 1 1 0 1 1 0 (3)
							- 0 2 0 2 2 0
							
							+ 1 1 0 1 1 0 (3)
							T 6 (3)
							+ 1 1 0 1 1 0 (3)
							- 2 1 0 0 2 1
							
							+ 1 1 0 1 1 0 (3)
							T 6 (3)
							+ 1 1 0 1 1 0 (3)
							- 2 1 0 1 2 0
							
							+ 1 1 0 1 1 0 (3)
							T 6 (3)
							+ 1 1 0 1 1 0 (3)
							- 2 2 0 0 1 1
							
							+ 1 1 1 0 1 0 (4)
							T 6 (4)
							+ 1 1 1 0 1 0 (4)
							- 1 1 0 0 3 1
							
							+ 1 1 1 0 1 0 (4)
							T 6 (4)
							+ 1 1 1 0 1 0 (4)
							- 2 2 1 0 1 0
							
							+ 1 1 1 0 1 0 (4)
							T 6 (4)
							+ 1 1 1 0 1 0 (4)
							- 0 0 0 0 3 3
							
							+ 0 0 0 0 2 2 (4)
							T 6 (4)
							+ 1 1 1 0 1 0 (4)
							- 0 0 0 0 0 0
						]]
												
						heroicDefault = gsub(heroicDefault, "\t", "")
						heroicDefault = string.format("#%dstart%s\n%send", frame.config_id, L["出墙消墙位置分配"], heroicDefault)
						
						function frame:copy_mrt()
							return heroicDefault
						end
						
						function frame:ReadNoteAssignments(display)
							self.spawns = table.wipe(self.spawns)
							self.tankSpawns = table.wipe(self.tankSpawns)
							self.breaks = table.wipe(self.breaks)
							self.safespots = table.wipe(self.safespots)
						
							local tag = string.format("#%sstart", self.config_id)
							local note = VMRT and VMRT.Note and VMRT.Note.Text1
							local useDefaultAssignments = not (note and note:match(tag))
							local defaultAssignment
							
							if useDefaultAssignments then
								if frame.difficultyID == 15 or display then -- Heroic
									defaultAssignment = heroicDefault
								end
							end
	
							for _, line in T.IterateNoteAssignment(self.config_id, defaultAssignment) do
								local assignmentType = line:match("^[T%+%-]")
								
								if assignmentType == "+" then -- Spawns
									local spawns, safespot = line:match("^[T%+%-]%s*(.+)%((%d)%)")
									
									safespot = tonumber(safespot)
									
									if spawns and safespot then
										local position = 0
										local assignments = {}
										
										for count in spawns:gmatch("%d") do
											position = position + 1
											
											for _ = 1, tonumber(count) do
												table.insert(assignments, position)
											end
										end
										
										table.insert(self.spawns, assignments)
										table.insert(self.safespots, safespot)
										
										if display then
											local ind = mod(#self.spawns, 2) == 0 and 3 or 1
											local tag = string.format("%d-%d", ceil(#self.spawns/2), ind)
											local assignment_str = table.concat(assignments, ",")
											T.msg(tag, L["出墙"], assignment_str, L["安全"], safespot)
										end
									end
								elseif assignmentType == "T" then -- Tank spawns
									local tankSpawn, safespot = line:match("^[T%+%-]%s*(%d)%s*%((%d)%)")
									
									tankSpawn = tonumber(tankSpawn)
									safespot = tonumber(safespot)
									
									if tankSpawn and safespot then
										table.insert(self.tankSpawns, tankSpawn)
										table.insert(self.safespots, safespot)
										
										if display then
											local tag = string.format("%d-%d", #self.tankSpawns, 2)
											T.msg(tag, L["坦克"]..L["出墙"], tankSpawn, L["安全"], safespot)
										end
									end
								elseif assignmentType == "-" then -- Breaks
									local breaks = line:match("^[T%+%-]%s*(.+)")
									
									if breaks then
										local position = 0
										local assignments = {}
										
										for count in breaks:gmatch("%d") do
											position = position + 1
											
											for _ = 1, tonumber(count) do
												table.insert(assignments, position)
											end
										end
										
										table.insert(self.breaks, assignments)
										
										if display then
											local assignment_str = table.concat(assignments, ",")
											local tag = string.format("%d-%d", #self.breaks, 4)
											T.msg(tag, L["消墙"], assignment_str)
											T.msg("--------------")
										end
									end
								end
							end
						end
						
						function frame:Assign(assignmentType)
							local affected, positions
							
							if assignmentType == "SPAWN" then
								affected = self.spawnGUIDs
								positions = table.remove(self.spawns, 1)
							else
								affected = self.breakGUIDs
								positions = table.remove(self.breaks, 1)
							end
							
							if not positions then return end
							
							T.SortTable(affected, true)
							
							for i, GUID in ipairs(affected) do
								local position = positions[i]
								
								if position then
									self:DisplayAssignment(assignmentType, GUID, position)
								end
							end
							
							if assignmentType == "SPAWN" then
								self.spawnGUIDs = table.wipe(self.spawnGUIDs)
							else
								self.breakGUIDs = table.wipe(self.breakGUIDs)
							end
							
							T.msg("--------------")
						end
						
						function frame:PreviewRLFrame()
							if C.DB["BossMod"][self.config_id]["rl_bool"] then
								local change_type = math.random(2) == 1 and "add" or "remove"
								for i = 1, 6 do
									local bar = self.rl_frame.bars[i]
									bar.value = math.random(4)
									bar.change = 0
									bar.players = table.wipe(bar.players)
									local change = math.random(2) == 1
									if change then
										if change_type == "add" then
											self:BarUpdate(i, G.PlayerGUID, 1)
										elseif change_type == "remove" then
											self:BarUpdate(i, G.PlayerGUID, -1)
										end
									else
										self:BarDisplay(i)
									end
								end
								self.rl_frame:Show()
							end
						end
						
						function frame:PreviewShow()
							self.graph_bg:Show()
							
							local rad_type = math.random(3)
							local rad_spot = math.random(6)
							
							if rad_type == 1 then
								self:DisplaySafe(rad_spot, true)
							elseif rad_type == 2 then
								self:DisplayAssignment("SPAWN", G.PlayerGUID, rad_spot, false, true)
							else
								self:DisplayAssignment("BREAK", G.PlayerGUID, rad_spot, false, true)
							end
							
							self:PreviewRLFrame()
						end
						
						function frame:PreviewHide()
							self.graph_bg:Hide()
							if C.DB["BossMod"][self.config_id]["rl_bool"] then
								self.rl_frame:Hide()
							end
						end						
					end,
					update = function(frame, event, ...)
						if event == "ENCOUNTER_START" then
							frame.difficultyID = select(3, ...)
							
							frame.spawnGUIDs = table.wipe(frame.spawnGUIDs)
							frame.breakGUIDs = table.wipe(frame.breakGUIDs)
							
							frame.spwans_count = 0
							frame.rotation_count = 0
							
							for i = 1, 6 do
								local bar = frame.rl_frame.bars[i]
								bar.value = 0
								bar.change = 0
								bar.players = table.wipe(bar.players)
								frame:BarDisplay(i)
							end
							
							frame:ReadNoteAssignments()
							
							-- Broadcast the initial safespot
							local safespot = table.remove(frame.safespots, 1)
							frame:DisplaySafe(safespot)
							
							if C.DB["BossMod"][frame.config_id]["rl_bool"] then
								frame.rl_frame:Show()
							end
						elseif event == "UNIT_SPELLCAST_SUCCEEDED" then
							local unit, castGUID, spellID = ...
							
							if unit == "boss1" then
								if spellID == 1233416 or spellID == 1231871 then -- 结晶震荡波/震波猛击
									local safespot = table.remove(frame.safespots, 1)
									frame:DisplaySafe(safespot)
								elseif spellID == 1220394 then -- 粉碎抽打
									local safespot = frame.safespots[1]
									frame:DisplaySafe(safespot)
								end
							end
						elseif event == "UNIT_SPELLCAST_START" then
							local unit, castGUID, spellID = ...
							
							if unit == "boss1" and spellID == 1231871 then -- 震波猛击
								for unit in T.IterateGroupMembers() do
									local isTanking = UnitDetailedThreatSituation(unit, "boss1")
									
									if isTanking then
										local GUID = UnitGUID(unit)
										local position = table.remove(frame.tankSpawns, 1)
										
										if position then
											frame:DisplayAssignment("SPAWN", GUID, position, true)
											
											C_Timer.After(4, function()
												frame:BarApplyChanges(position)
											end)
										end
										
										return
									end
								end
							end
						elseif event == "COMBAT_LOG_EVENT_UNFILTERED" then
							local _, sub_event, _, sourceGUID, _, _, _, destGUID, _, _, _, spellID = CombatLogGetCurrentEventInfo()
							
							if sub_event == "SPELL_AURA_APPLIED" then
								if spellID == 1233411 then -- 结晶震荡波
									table.insert(frame.spawnGUIDs, destGUID)
					
									if #frame.spawnGUIDs == 1 then
										frame.spwans_count = frame.spwans_count + 1
										frame.rotation_count = ceil(frame.spwans_count/2)
										
										C_Timer.After(0.2, function() 
											frame:Assign("SPAWN")
										end)
										C_Timer.After(10, function()
											for position = 1, 6 do
												frame:BarApplyChanges(position)
											end
										end)
									end
								elseif spellID == 1227373 then -- 碎壳
									table.insert(frame.breakGUIDs, destGUID)
									
									if #frame.breakGUIDs == 1 then
										C_Timer.After(0.2, function()
											frame:Assign("BREAK")
										end)
										C_Timer.After(8, function()
											for position = 1, 6 do
												frame:BarApplyChanges(position)
											end
										end)
									end
								end
							end
						end
					end,
					reset = function(frame, event)
						T.Stop_Text_Timer(frame.text_frame)
						frame.graph_bg:Hide()
						if C.DB["BossMod"][frame.config_id]["rl_bool"] then
							frame.rl_frame:Hide()
						end
					end,
				},
				{ -- 计时条 结晶震荡波（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1233416,
					glow = true,
				},
				{ -- 图标 结晶震荡波（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1224414,
					tip = L["DOT"],
				},
				{ -- 团队框架高亮 结晶震荡波（✓）
					category = "RFIcon",
					type = "Aura",
					spellID = 1224414,
				},
			},
		},
		{ -- 粉碎抽打
			spells = {
				{1220394, "5"},--【粉碎抽打】
			},
			options = {
				{ -- 计时条 粉碎抽打（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1220394,
					text = L["消墙"],
				},
				{ -- 文字 粉碎抽打 击退（✓）
					category = "TextAlert",
					type = "spell",
					preview = L["击退"]..L["倒计时"],
					data = {
						spellID = 1220394,
						events = {
							["UNIT_SPELLCAST_START"] = true,
						},
					},
					update = function(self, event, ...)
						if event == "UNIT_SPELLCAST_START" then
							local unit, _, spellID = ...
							if unit == "boss1" and spellID == 1220394 then
								local debuff = AuraUtil.FindAuraBySpellID(1227378, "player", "HARMFUL") -- 水晶覆体
								if debuff then
									T.Start_Text_Timer(self, 2, T.GetIconLink(1220394), true)
									T.PlaySound("knockback")
								end
							end
						end
					end,
				},
			},
		},
		{ -- 碎壳
			spells = {
				{1227373, "5"},--【碎壳】
				{1227378, "5"},--【水晶覆体】
			},
			options = {
				{ -- 文字 碎壳 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					preview = L["消墙"]..L["倒计时"],
					data = {
						spellID = 1227367,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_SUCCEEDED"] = true,
						},
						info = {
							["all"] = {
								[1] = {40.5, 51, 51, 51, 51, 51, 51, 51, 51},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_SUCCEEDED", "boss1", 1227367, L["消墙"], self, event, ...)
					end,
				},
				{ -- 首领模块 碎壳 计时圆圈（✓）
					category = "BossMod",
					spellID = 1227373,
					enable_tag = "none",
					name = T.GetIconLink(1227373)..L["计时圆圈"],
					points = {a1 = "CENTER", a2 = "CENTER", x = 0, y = -25},
					events = {
						["UNIT_AURA"] = true,
					},
					init = function(frame)
						frame.spellIDs = {
							[1227373] = { -- 碎壳
								unit = "player",
								aura_type = "HARMFUL",
								color = {0, 1, 0},
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
				{ -- 图标 水晶覆体（✓）
					category = "AlertIcon",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "player",
					spellID = 1227378,
					tip = L["定身"],
				},			
			},
		},
		{ -- 猛波震击
			spells = {
				{1231871, "0,12"},--【猛波震击】			
			},
			options = {
				{ -- 文字 猛波震击 倒计时（史诗待测试）
					category = "TextAlert",
					type = "spell",
					ficon = "0",
					preview = L["坦克出墙"]..L["倒计时"],
					data = {
						spellID = 1231871,
						events =  {
							["ENCOUNTER_PHASE"] = true,
							["UNIT_SPELLCAST_START"] = true,
						},
						info = {
							["all"] = {
								[1] = {18, 51, 51, 51, 51, 51, 51, 51, 51},
							},
						},
						cd_args = {
							round = true,
						},
					},
					update = function(self, event, ...)
						T.UpdateCooldownTimer("UNIT_SPELLCAST_START", "boss1", 1231871, L["坦克出墙"], self, event, ...)
					end,
				},
				{ -- 计时条 猛波震击（✓）
					category = "AlertTimerbar",
					type = "cast",
					spellID = 1231871,
					ficon = "0",
					show_tar = true,
					sound = soundfile("1231871cast", "cast"),
				},
				{ -- 嘲讽提示 猛波震击（待测试）
					category = "BossMod",
					spellID = 1231871,
					ficon = "0",
					enable_tag = "role",
					name = L["嘲讽提示"]..T.GetIconLink(1231871),
					points = {hide = true},
					events = {					
						["UNIT_AURA_ADD"] = true,
						["UNIT_AURA_REMOVED"] = true,
						["UNIT_SPELLCAST_START"] = true,
						["UNIT_SPELLCAST_STOP"] = true,
						["UNIT_THREAT_SITUATION_UPDATE"] = true,
					},
					init = function(frame)
						frame.aura_spellIDs = {
							[1231871] = 1, -- 猛波震击
						}
						frame.cast_spellIDs = {
							[1231871] = true, -- 猛波震击
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
				{ -- 换坦计时条 猛波震击（✓）
					category = "AlertTimerbar",
					type = "aura",
					aura_type = "HARMFUL",
					unit = "group",
					spellID = 1231871,
					ficon = "0",
					tank = true,
				},
			},
		},
	},
}