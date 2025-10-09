local T, C, L, G = unpack(select(2, ...))
local addon_name = G.addon_name
local FrameHolder = G.FrameHolder

T.CreateSpellLineFrame = function(name, text, size, anchor1, anchor2, x, y)
	local frame = CreateFrame("Frame", addon_name..name, FrameHolder)
	frame:Hide()
	
	local width = size*5 + 5*4
	local height = size
	frame:SetSize(width, height)
	
	frame.movingname = text
	frame.point = { a1 = anchor1, a2 = anchor2, x = x, y = y}
	T.CreateDragFrame(frame)
	
	frame.active_byindex = {}
	
	return frame
end

T.CreateSpellIconBase = function(parent, tag)
	local icon = CreateFrame("Frame", nil, parent)
	icon:SetSize(40, 40)
	icon:Hide()
	
	T.createborder(icon)
	
	icon.texture = icon:CreateTexture(nil, "BORDER", nil, 1)
	icon.texture:SetTexCoord( .1, .9, .1, .9)
	icon.texture:SetAllPoints()
	
	icon.cooldown = CreateFrame("Cooldown", nil, icon, "CooldownFrameTemplate")
	icon.cooldown:SetAllPoints()
	icon.cooldown:SetDrawEdge(false)
	icon.cooldown:SetFrameLevel(icon:GetFrameLevel())
	icon.cooldown:SetReverse(true)
	
	icon.charge_text = T.createtext(icon, "OVERLAY", 20, "OUTLINE", "RIGHT") -- 层数
	icon.charge_text:SetPoint("BOTTOMRIGHT", icon, "BOTTOMRIGHT", 0, 2)
	icon.charge_text:SetHeight(12)
	icon.charge_text:SetTextColor(0, 1, 1)

	icon.source_text = T.createtext(icon, "OVERLAY", 12, "OUTLINE", "CENTER") -- 玩家名字
	icon.source_text:SetPoint("TOPLEFT", icon, "TOPLEFT", -2, -2)
	icon.source_text:SetPoint("TOPRIGHT", icon, "TOPRIGHT", 2, -2)
	icon.source_text:SetHeight(12)
	
	icon:HookScript("OnShow", function(self)
		parent:lineup()
	end)
	
	icon:HookScript("OnHide", function(self)
		parent:lineup()
	end)
	
	table.insert(parent.active_byindex, icon)
	
	icon.tag = tag
	
	return icon
end