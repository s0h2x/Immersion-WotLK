--	Filename:	Extensions.lua
--	Project:	pretty_wow
--	Author:		s0high
--	E-mail:		s0h2x.hub@gmail.com
--	Web:		https://github.com/s0h2x

---@type table<frame, Extension|TableMixin>
local Extension = {}
local TableMixin = {}

---@extension frames
Extension["Frame"] = CreateFrame("Frame")
Extension["Button"] = CreateFrame("Button")
Extension["Minimap"] = CreateFrame("Minimap")
---@extension subframes
Extension["Texture"] = Extension.Frame:CreateTexture()
Extension["FontString"] = Extension.Frame:CreateFontString()
---@extension uiobjects
if WorldFrame then
    Extension["PlayerModel"] = CreateFrame("PlayerModel")
    Extension["GameTooltip"] = CreateFrame("GameTooltip")
end

---@extension metatable
for frameType, frame in pairs(Extension) do
    frame:Hide(); TableMixin[frameType] = getmetatable(frame)
end

----------------------------------
-- Frame Mixin (General)
----------------------------------
local FrameMixin = {}
FrameMixin.ignoreParent = CreateFrame("Frame", nil, WorldFrame)
function FrameMixin:SetShown(shown)
    if shown then
        self:Show()
    else
        self:Hide()
    end
end
---@param ignore parent alpha|boolean
function FrameMixin:SetIgnoreParentAlpha(ignore)
    if ignore then
        if (ImmersionFrame.fadeState == "in") then
            self:SetParent(self.ignoreParent)
            self.isIgnoring = true
        end
    else
        self.isIgnoring = false
    end
end
---@return isIgnoring|boolean
function FrameMixin:IsIgnoringParentAlpha()
    if self.isIgnoring then
        return true
    end
    return false
end
---@class parentArray
---@type<string>
---@return parent[, arrayName]
function FrameMixin:SetParentArray(arrayName, element, isOwn)
    local parent = not isOwn and self:GetParent() or self
    if not parent[arrayName] then
        parent[arrayName] = {}
    end

    table.insert(parent[arrayName], element or self)
    return parent[arrayName]
end
---@extension method
for _, metatable in pairs(TableMixin) do
    for name, func in pairs(FrameMixin) do
        metatable.__index[name] = func
    end
end
----------------------------------
-- FontString Mixin
----------------------------------
local FontStringMixin = {}
---@type<string>
---@return isTruncated|boolean
function FontStringMixin:IsTruncated()
    local width = self:GetWidth()
    self:SetWidth(width + 10000)
    local isTruncated = self:GetStringWidth() > self.lengthText
    self:SetWidth(width)
    return isTruncated
end
for name, func in pairs(FontStringMixin) do
    TableMixin.FontString.__index[name] = func
end

----------------------------------
-- Model Mixin
----------------------------------
if Extension["PlayerModel"] then
    local ModelMixin = {}
    ---@return model|string
    function ModelMixin:GetModelFile()
        return self:ModelFileClipped(self:GetModel())
    end
    ---@class model animation
    ---@param animation<id, number>
    function ModelMixin:SetAnimation(animation)
        self:SetScript("OnUpdate", function(self, elapsed)
            if not self.animtime then return end
            if (self.animtime > self.duration or self.sequence == 0 or not self.hasAnimation) then
                if self.sequenceHooked then
                    self:SetScript("OnUpdate", nil)
                    self.sequenceHooked = nil
                end
            else
                self:SetSequenceTime(self.sequence, self.animtime)
                self.animtime = (self.animtime + (elapsed * 1000))
                self.sequenceHooked = true
            end
        end)
        self.animtime = 0
        self.duration = self:GetAnimationDuration() or 0
        self.sequence = self:GetModelAnimation(animation) or 0
        self.hasAnimation = self:HasAnimation(animation)
    end
    ---@class model camera
    ---@param camera scale<number>
    local cameraSquare = 1567.09284983 -->@sqrt(1366^2 + 768^2)
    function ModelMixin:SetCamDistanceScale(scale)
        local uiCameraID = self:GetModelFile()
        local posX, posY, posZ, yaw, zoomFactor = self:GetCameraInfo(uiCameraID)
        if posX and posY and posZ and yaw then
            local effscale = self:GetEffectiveScale() / scale
            local width, height = GetScreenWidth() * effscale, GetScreenHeight() * effscale
            local diff = (cameraSquare / math.sqrt(width * width + height * height)) / UIParent:GetEffectiveScale()
            if zoomFactor then
                self:SetModelScale(1.92)
                self:SetPosition(posX, posY, posZ)
            else
                self:SetModelScale(1.51 / self:GetEffectiveScale())
                self:SetPosition(posX * diff, posY * diff, posZ * diff)
            end
            self:SetFacing(yaw)
        else
            self:SetCamera(0)
        end
    end
    ---@extension method
    for name, func in pairs(ModelMixin) do
        TableMixin.PlayerModel.__index[name] = func
    end
end
