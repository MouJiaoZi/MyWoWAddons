local T, C, L, G = unpack(JST)

G.MobData[505] = {

	["213892"] = { -- 夜幕影法师
		cc = {
			["CC_Grip"] = true,
			["CC_Stun"] = true,
			["CC_Silence"] = true,
			["CC_Disorient"] = true,
			["CC_Fear"] = true,
			["CC_KnockOff"] = true,
			["CC_KnockBack"] = true,
		},
		spell = {
			["SPELL_CAST_START"] = {
				431303, -- 暗夜箭
			},
		},
	},	
	
	["210966"] = { -- 苏雷吉网法师
		cc = {
			["CC_Grip"] = true,
			["CC_Stun"] = true,
			["CC_Silence"] = true,
			["CC_Disorient"] = true,
			["CC_Fear"] = true,
			["CC_KnockOff"] = true,
			["CC_KnockBack"] = true,
		},
		spell = {
			["SPELL_CAST_START"] = {
				451113, -- 蛛网箭
			},
		},
	},

}