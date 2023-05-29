--	Filename:	Utils.lua
--	Project:	pretty_wow
--	Author:		s0high
--	E-mail:		s0h2x.hub@gmail.com
--	Web:		https://github.com/s0h2x

---@type table<function, UtilMixin>
UtilMixin = {}

---@type table<string, Config>
---@param data<table>
---@return modelset data|table
function UtilMixin:CurrentModelData(data)
    return data[self:GetCurrentModelSet()] or data['Original']
end

---@param model<string>
---@return truncated model name|string
function UtilMixin:ModelFileClipped(model)
    if model and type(model) == 'string' then
        model = string.lower(model)
        model = string.gsub(model, '\\', '/')
        model = string.gsub(model, '%.m2', '')
        model = string.gsub(model, '%.mdx', '')
        model = string.gsub(model, 'character/', '')
        model = string.gsub(model, 'creature/', '')
        model = string.gsub(model, 'interface/addons/immersion/textures/m2/', '')
        model = string.gsub(model, 'world/expansion02/doodads/', '')
        return model
    end
end

---@param model<string>
function UtilMixin:CheckErrorModel(model)
    if ( model == 'spells\\errorcube.m2' ) then
        self:ClearModel()
        self:SetModel('interface\\buttons\\talktomequestion_white.m2')
    end
end

---@class model camera
---@param cameraID<table, string>
---@return camera position|table
function UtilMixin:GetCameraInfo(cameraID)
    local camera = EnumConst.UiModelPositionCamera
    local fileData = self:CurrentModelData(camera)
    local uiCamera = fileData[cameraID] or camera['Original'][cameraID]
    if uiCamera then
        return uiCamera[1], uiCamera[2], uiCamera[3], uiCamera[4], uiCamera[5]
    end
    return nil
end

---@class animation
---@param model animationID
---@return animationID|number
function UtilMixin:GetModelAnimation(animationID)
    local model = self:GetModelFile()
    local mapData = self:CurrentModelData(EnumConst.AnimationMap)
    local animationMapCanvas = mapData[model] or EnumConst.AnimationMap['Original'][model]
    
    if animationMapCanvas and animationMapCanvas[animationID] then
        return animationMapCanvas[animationID]
    end
	
    local defectData = self:CurrentModelData(EnumConst.AnimationModelDefect)
    local animationRandomCanvas = defectData[model] or EnumConst.AnimationModelDefect['Original'][model]
    
    if animationRandomCanvas and animationRandomCanvas[animationID] then
        local animationIDToMixin = { 64, 65, 185 }
        return animationIDToMixin[math.random(#animationIDToMixin)]
    end
	
    return animationID
end

---@param animation<id, number>
---@return hasAnimation|boolean
function UtilMixin:HasAnimation(animationID)
    local model = self:GetModelFile()
    local hasCamera = self:GetCameraInfo(model)
    
    local animationData = self:CurrentModelData(EnumConst.AnimationMap)
    local hasAnimation = animationData[model] or EnumConst.AnimationMap['Original'][model]
    if hasAnimation and animationID or hasCamera then
        return true
    end
    return false
end

---@return defect model file name|string
function UtilMixin:HasDefectAnimation()
    local model = self:GetModelFile()
    local defectList = EnumConst.ModelToDefectList
    local defectData = self:CurrentModelData(defectList)
    return defectData[model] or defectList['Original'][model]
end

---@type table<number, UtilMixin>
---@param animation<id, number>
---@return animation duration|number
UtilMixin.DefaultAnimDuration = 5000
function UtilMixin:GetDefectModelAnimationDuration(animationID)
    local model = self:GetModelFile()
    local defectList = EnumConst.ModelToDefectList
    
    if self:IsDefectModel() then
        local defectData = self:CurrentModelData(defectList)
        local isDefect = defectData[model] or defectList['Original'][model]
        if isDefect and isDefect[animationID] then
            return isDefect[animationID]
        end
    end
    return UtilMixin.DefaultAnimDuration
end

---@type table<number, UtilMixin>
---@return animation duration|number
function UtilMixin:GetAnimationDuration()
    return self.duration or UtilMixin.DefaultAnimDuration
end