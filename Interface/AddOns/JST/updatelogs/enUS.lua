local T, C, L, G = unpack(select(2, ...))

--if G.Client ~= "zhTW" then return end

L["更新日志内容"]			= [[
5.94
Salhadaar Starkiller assign bug fix
The Dawnbreaker Manifested Shadow correct Black Hail target determination errors.
Eco-Dome Al'dani Azhiccar Toxic Regurgitation add drop pool sound.
Organize the control/interruption timing bar data of Mythic+ and separate it from other timing bars in the same group.
Organize the tank timing bar of the Mythic+.
Organize self-protection prompt of the Mythic+.
The self-protection prompt can now display a preview effect and select the direction of icon arrangement.
The self-protection prompt will now monitor activated group cooldown buffs.
The self-protection prompt now correctly prompts for the heal potion cooldown.
The sound effects of the self-protection prompt should be spaced at least 10 seconds apart.
Delete some Mythic+ trash spell countdown. (Abyssal Rot/Abysal Blast/Gluttonous Miasma)
Cancel Evoker's reminder to dispel Enrage.
Other error corrections.

5.92
Fractillus spawn/break wall assignment display the direction and distance of the assigned location.
Fractillus spawn/break wall assignment group status display allocation position.
Salhadaar When soak the Conquer, indicate danger when debuffed with Banishment.
Salhadaar Twilight Massacre adds a timing circle for casting on me.
Salhadaar Netherbreaker adds mythic difficulty countdown and timing bar.
Salhadaar Besiege delete timing bar.
Salhadaar Dimension Breath adds mythic difficulty timing bar.
Salhadaar Behead adds timing bar in Intermission Two: King's Hunger.
Dimensius Remake Dark Matter timing circle.
Dimensius Soaring Reshii adds a aura icon.
Dimensius Gamma Burst adds a timing circle.
Dimensius Crushing Gravity/Inverse Gravity adds timing circles.
Streets of Wonder Zo'phex the Sentinel Interrogation timing bar adds immune spell monitoring.
Streets of Wonder Mailroom Mayhem Money Order timing bar adds immune spell monitoring.
Streets of Wonder Force Multiplier delete nameplate interrupt icon, changed to timing bar.
Operation: Floodgate Big M.O.M.M.A. adds a nameplate glow and spell icon for Maximum Distortion.
Operation: Floodgate Big M.O.M.M.A. delete Maximum Distortion nameplate interrupt number, changed to timing bar, prompt the bar when your interrupt spell is ready to use.
Ara-Kara, City of Echoes adds a nameplate glow and spell icon for Alarm Shrill.
Ara-Kara, City of Echoes Add self-protection spell prompt for several spells.
Eco-Dome Al'dani Soul-Scribe delete Whispers of Fate countdown.
Eco-Dome Al'dani Soul-Scribe add a sound prompt for Fatebound spirit soak.
Eco-Dome Al'dani add a sound prompt for Unstable Core.
Eco-Dome Al'dani Add dark filters to Al'dani Sands.
Eco-Dome Al'dani Add self-protection spell prompt for several spells.
Other error corrections.

5.90
Forgeweaver Araz Arcane Collector mark error correction.
The Soul Hunters the Hunt damage soak assignment.
The Soul Hunters delete the Hunt timing bar sound prompt.
The Soul Hunters intermission position assignment options moved to Soul Tether column.
Priory of the Sacred Flame Taener Duelmal add Fireball nameplate interrupt prompt in boss fight. 
Priory of the Sacred Flame Forge Master Damian Heat Wave countdown text prompt bug fix.
Eco-Dome Al'dani Ravenous Destroyer Volatile Ejection target correction.
Eco-Dome Al'dani Ravenous Destroyer add Gluttonous Miasma casting on me icon prompt.
Other error corrections.

5.86
Salhadaar Manaforged Titan Killing countdown.
Salhadaar Subdivision Rule timing bar and soak prompt.
Salhadaar Reap Countdown.
Dimensius Excess Mass pick up assignment and raid status monitoring.
Dimensius adds Antimatter timing bar.
Dimensius adds Mass Destruction assignment.
Dimensius adds Mass Destruction timing circle.
Fix the error of glow/index nember not disappearing on the raid frames.
Bug fix of the incorrect sequence of CC spells.
The CC chain MRT template no longer includes non group control spells.
Remove useless functions and correct other errors.

5.85
Salhadaar add Shadowguard Reaper control chain.
Dimensius Correct Mythic countdown data.
Dimensius Modify the reference events for the phase transition and timeline data.
Other error corrections.

5.83
Tazavesh: Streets of Wonder update.
Other error corrections.

5.82
Tazavesh: So'leah's Gambit update.
The dispelling prompt sound will now detect whether the dispelling spell is not in cooldown.

5.80
The Soul Hunters intermission position assignment bug fix.
Other error corrections.

5.78
Forgeweaver Araz Arcane Collector mark error correction.
The Soul Hunters Devourer's Ire handover timimg correction.
The Soul Hunters Correction of intermission position assignment in special circumstances.
Other error corrections.

5.74
Delete the test module that was mistakenly added. If the update does not delete the relevant files, please delete JST_Test from the plugin folder.I'm very sorry.
|cffff0000World of Warcraft\_retail_\Interface\AddOns\JST_Test DELETE THIS!!!|r

5.73
Plexus Sentinel add a sound prompt to Manifest Matrices timing circle.
The Soul Hunters Devourer's Ire handover timimg correction.
The Soul Hunters Collapsing Star soak assignment marks replace skull to cross.
Fractillus Correct the error in determining the placement of tanks on walls.
Fractillus Null Consumption change the color of the timing circle to light blue,
Trash Only detect the Dragon ride in Seat of the Devourer.
Other error corrections.

5.71
fix raid frames glow bug.

5.70
Loom'ithar Add MRT note analysis function for the assignment of Infusion Pylons soak.
Forgeweaver Araz Fixed some control chain display bugs in certain rounds
The Soul Hunters Add Devourer's Ire handover prompt (it is recommended to add a handover mark to MRT note)
The Soul Hunters monitoring raid Unending Hunger stacks with Devourer's Ire.
The Soul Hunters fix bug of Frailty stacks prompt (tank spirit soak)
Fractillus spawn/break wall assignment and error notification
Update the value of new raid buff inf team information
Other error corrections.

5.66
When the custom voice pack entry is missing, try using the entry from the default voice pack.
Supplement the default list of CC, prompt to use spell ID when unable to read spell name.
The Soul Hunters Collapsing Star show remaining quantity.
The Soul Hunters Dark Residue show timing text.
The Soul Hunters The Hunt timing bar show immune spell icons.
Other error corrections.

5.65
Fractillus Null Consumption prompt self-protection when 2+ stacks.
Fractillus Null Consumption raid frames glow when 2+ stacks.
The Soul Hunters Frailty spirit soak prompt.
The Soul Hunters Frailty(DOT) prompt self-protection when 2+ stacks.
The Soul Hunters Frailty(DOT) raid frames glow when 2+ stacks.
The Soul Hunters Fel Devastation bait front text timer.
Update Araz/Fractillus mythic timeline mrt note.
Fix raid frames glow bug.

5.64
Attempt to fix the bug where self-protection spells frame do not disappear.
The Soul Hunters error correction of Devourer's Ire dispel assignment.
The Soul Hunters Charge timer bar with sound effects and team framework serial number switch.
Salhadaar add mythic difficulty spell countdown text and timeline mrt note.
Salhadaar prompt defensive spells for Invoke the Oath/Banishment/Reap/Twilight Scar.
Salhadaar Invoke the Oath/Vengeful Oath timing bar.
Salhadaar Galactic Smash assignment map.
Salhadaar Twilight Spikes timing bar.
Salhadaar Starkiller Swing baiting assignment.
Salhadaar Starkiller Swing left/right assignment.
Other error corrections.

5.62
New tool: Group CC Monitoring, currently used in some boss battles, will be applied to the Mythic+ in the future.
Loom'ithar deleted Infusion Tether sorting.
Forgeweaver Araz add CC Monitoring for Arcane Manifestation.
The Soul Hunters Redo Devourer's Ire dispel assignment.
The Soul Hunters prompt defensive spells for Encroaching Oblivion/Dark Residue/Soulcrush.
The Soul Hunters Dark Residue soak assignment.
The Soul Hunters The Hunt timing bar and immune spells check.
The Soul Hunters add mythic difficulty spell countdown text and timeline mrt note.
Fractillus prompt defensive spells for Null Consumption/Shattershell.
Fractillus spawn/break wall assignment can provide advance notice of the tank's placement of the wall. (Default off, click on the small gear to open detailed settings and manually enable)
Fractillus spawn/break wall assignment add the default MRT note for normal/mythic difficulties.These will be load without writing custom MRT note.
Fractillus spawn/break wall assignment adding custom priority note functionality. it requires copying mythic difficulty MRT note templates.
Fractillus add mythic difficulty spell countdown text and timeline mrt note.
Dimensius add raid timing bar for Reverse Gravity.
Remove useless functions and correct other errors.

5.49
Plexus Sentinel mythic timeline data.
Soulbinder Naazindhri mythic timeline data.
Loom'ithar Infusion Pylons soak assignment and player status monitoring.
Loom'ithar prompt defensive spells for Infusion Tether/Arcane Outrage
Loom'ithar Infusion Tether raid list and raid frame index.
Loom'ithar Fix Primal Spellstorm count down.
Loom'ithar mythic timeline data.
Forgeweaver Araz collector heath/power monitoring and HP difference check.
Forgeweaver Araz Astral Harvest/Void Harvest timing circles.
Forgeweaver Araz Astral Harvest/Void Harvest raid list and raid frame index.
Forgeweaver Araz Arcane Echo HP monitoring and killing countdown.
Forgeweaver Araz prompt defensive spells for Arcane Expulsion.
Forgeweaver Araz Mana Sacrifice add countdown text.
Forgeweaver Araz Photon Blast add countdown text and timing bar for targeted collector.
Forgeweaver Araz mythic timeline data.
Remove useless functions and correct other errors.

5.20
Plexus Sentinel prompt defensive spells for soak Eradicating Salvo.
Soulbinder Naazindhri prompt dispel sound when Void Burst 2+ stacks. 
Soulbinder Naazindhri prompt defensive spells for Void Burst 3+ stacks.
Soulbinder Naazindhri prompt defensive spells for casting Arcane Expulsion.
Forgeweaver Araz automatic mark for Collector(Order of appearance)
Forgeweaver Araz add power bar for Collector, show nameplate mark for highest power Collector.
Forgeweaver Araz add timing bar and countdown for Astral Harvest.
Forgeweaver Araz prompt defensive spells for soak Arcane Obliteration.
Remove useless functions and correct other errors.

5.10
Plexus Sentinel changes phase transition reference events.
Plexus Sentinel adds Eradicating Salvo damage soak timing bar.
Loom'ithar adds Primal Spellstorm countdown.
Soulbinder Naazindhri adds Void Burst raid frame glow when above the 2 stacks.
Soulbinder Naazindhri Voidblade Ambush countdown text has been changed to a timing circle.
Soulbinder Naazindhri add Soulray Annihilation assignment of left/right.
Dimensius adds personal denfensive spell prompt for Fission/Null Binding/Voidgrasp.
Dimensius adds index number on raid frames for Voidgrasp。
Other error corrections.

5.03
Dimensius add several spell countdown.
Dimensius Cosmic Collapse adds a timing circle.
Dimensius Shadowquake adds a timing circles.
Dimensius modifies the Shattered Space sound effect and adds a countdown.
Personal Defensive spell prompt add sound.
Other error corrections.
]]