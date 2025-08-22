---@diagnostic disable-next-line: deprecated, undefined-global
local thisAddon, F, E, I, V, P, G, L = unpack(MUISkin)

---@diagnostic disable-next-line: undefined-global
local CreateFrame = CreateFrame
---@diagnostic disable-next-line: undefined-global
local EnumerateFrames = EnumerateFrames
---@diagnostic disable-next-line: undefined-global
local CreateColor = CreateColor

function F.CreateStyle(frame, useStripes, useShadow, useGradient)
    if not frame or frame.__MERStyle or frame.MERStyle then
        return
    end

    if frame:GetObjectType() == "Texture" then
        frame = frame:GetParent()
    end

    local holder = frame.MERStyle or CreateFrame("Frame", nil, frame, "BackdropTemplate")
    holder:SetFrameLevel(frame:GetFrameLevel())
    holder:SetFrameStrata(frame:GetFrameStrata())
    holder:SetOutside(frame)
    holder:Show()

    if not useStripes then
        local stripes = holder.MERstripes
            or holder:CreateTexture(holder:GetName() and holder:GetName() .. "Overlay" or nil, "BORDER")
        stripes:ClearAllPoints()
        stripes:Point("TOPLEFT", 1, -1)
        stripes:Point("BOTTOMRIGHT", -1, 1)
        stripes:SetTexture([[Interface\AddOns\MUISkin\stripes]], true, true)
        stripes:SetHorizTile(true)
        stripes:SetVertTile(true)
        stripes:SetBlendMode("ADD")

        holder.MERstripes = stripes
    end

    if not useShadow then
        local mshadow = holder.mShadow
            or holder:CreateTexture(holder:GetName() and holder:GetName() .. "Overlay" or nil, "BORDER")
        mshadow:SetInside(holder)
        mshadow:Width(33)
        mshadow:Height(33)
        mshadow:SetTexture([[Interface\AddOns\MUISkin\Overlay]])
        mshadow:SetVertexColor(1, 1, 1, 0.6)

        holder.mShadow = mshadow
    end

    if not useGradient then
        local tex = holder.MERgradient
            or holder:CreateTexture(holder:GetName() and holder:GetName() .. "Overlay" or nil, "BORDER")
        tex:SetInside(holder)
        tex:SetTexture([[Interface\AddOns\MUISkin\gradient.tga]])
        tex:SetVertexColor(0.3, 0.3, 0.3, 0.15)

        holder.MERgradient = tex
    end

    frame.MERStyle = holder
    frame.__MERStyle = 1
end

local module = thisAddon:GetModule("MER_Style")

function module:CreateGradientFrame(frame, w, h, o, r1, g1, b1, a1, r2, g2, b2, a2)
    assert(frame, "doesn't exist!")

    frame:Size(w, h)
    frame:SetFrameStrata("BACKGROUND")

    local gf = frame:CreateTexture(nil, "BACKGROUND")
    gf:SetAllPoints()
    gf:SetTexture(E.media.blankTex)
    if E.Classic then
		gf:SetGradientAlpha(o, r1, g1, b1, a1, r2, g2, b2, a2)
	else
		gf:SetGradient(o, CreateColor(r1, g1, b1, a1), CreateColor(r2, g2, b2, a2))
	end
end

function module:UpdateTemplateStrata(frame)
    if frame.MERStyle then
        frame.MERStyle:SetFrameLevel(frame:GetFrameLevel())
        frame.MERStyle:SetFrameStrata(frame:GetFrameStrata())
    end
end

function module:SetTemplate(frame, template, glossTex, ignoreUpdates, _, isUnitFrameElement, isNamePlateElement)
    template = template or frame.template or "Default"
    glossTex = glossTex or frame.glossTex or nil
    ignoreUpdates = ignoreUpdates or frame.ignoreUpdates or false

    if ignoreUpdates then
        return
    end

    local isStatusBar = false
    local parent = frame:GetParent()

    if parent then
        if parent.IsObjectType and (parent:IsObjectType("Texture") or parent:IsObjectType("Statusbar")) then
            isStatusBar = true
        elseif E.statusBars[parent] ~= nil then
            isStatusBar = true
        end
    end

    local skinForUnitFrame = isUnitFrameElement and not isNamePlateElement
    local skinForTransparent = (template == "Transparent") and not isNamePlateElement and not isStatusBar
    local skinForTexture = (template == "Default" and not glossTex)
        and not isUnitFrameElement
        and not isNamePlateElement
        and not isStatusBar

    if (skinForTransparent or skinForUnitFrame or isStatusBar or skinForTexture) then
        if frame.Center ~= nil then
            frame.Center:SetDrawLayer("BACKGROUND", -7)
        end

        if not frame.CreateStyle then
            return F.Developer.LogDebug("API functions not found!", "MERCreateStyle", not frame.CreateStyle)
        end

        frame:CreateStyle()
    else
        if frame.MERStyle then
            frame.MERStyle:Hide()
        end
    end
end

function module:API(obj, n)
    local mt = getmetatable(obj).__index

    if not mt or type(mt) == "function" then
        return
    end


    if mt.SetTemplate and not mt.MERSkin then
        if not obj.CreateStyle then
            mt.CreateStyle = F.CreateStyle
        end

        -- Hook elvui template
        if not self:IsHooked(mt, "SetTemplate") then
            self:SecureHook(mt, "SetTemplate", "SetTemplate")
        end

        -- Hook FrameLevel
        if mt.SetFrameLevel and (not self:IsHooked(mt, "SetFrameLevel")) then
            self:SecureHook(mt, "SetFrameLevel", "UpdateTemplateStrata")
        end

        -- Hook FrameStrata
        if mt.SetFrameStrata and (not self:IsHooked(mt, "SetFrameStrata")) then
            self:SecureHook(mt, "SetFrameStrata", "UpdateTemplateStrata")
        end

        mt.MERSkin = true
    end
end

local object = CreateFrame("Frame")
local handled = {
    Frame = true,
    Button = true,
    ModelScene = true,
    Slider = true,
    ScrollFrame = true,
}

function module:MetatableScan()
    self.MERStyle = {}

    self:API(object, 1)
    self:API(object:CreateTexture(), 2)
    self:API(object:CreateFontString(), 3)
    self:API(object:CreateMaskTexture(), 4)


    object = EnumerateFrames()
    while object do
        local objType = object:GetObjectType()
        if not object:IsForbidden() and not handled[objType] then
            self:API(object)
            handled[objType] = true
        end

        object = EnumerateFrames(object)
    end
end

function module:ForceRefresh()
    E:UpdateFrameTemplates()
    E:UpdateMediaItems(true)
end

function module:Register()
    F.Event.ContinueOutOfCombat(function()
        if not self.___registered then
            self.___registered = true
            self:MetatableScan()
            self:ForceRefresh()
        end
    end)
end

F.Event.RegisterOnceCallback("MER.InitializedSafe", F.Event.GenerateClosure(module.Register, module))
