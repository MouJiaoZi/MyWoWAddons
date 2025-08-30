local totemSecure = {}
for totemID = 1, 6 do
	totemSecure[totemID] = CreateFrame("Button", "TotemFrameTotem"..totemID, nil, "SecureUnitButtonTemplate")
	totemSecure[totemID]:SetAttribute("*type2", "destroytotem")
	totemSecure[totemID]:SetAttribute("*totem-slot*", totemID)
	totemSecure[totemID]:Show()
end