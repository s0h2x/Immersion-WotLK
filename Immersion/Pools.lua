local ObjectPoolMixin, _, L = {}, ...
local Mixin, CreateFromMixins = L.MixinNormal, L.CreateFromMixins

----------------------------------
-- Compat
----------------------------------
-- function Mixin(object, ...)
	-- local mixins = {...};
	-- for _,mixin in pairs(mixins) do
		-- for k,v in next,mixin do
			-- object[k] = v;
		-- end
	-- end
	-- return object;
-- end
 
-- function CreateFromMixins(...)
	-- return Mixin({}, ...)
-- end

function ObjectPoolMixin:OnLoad(creationFunc, resetterFunc)
	self.creationFunc = creationFunc
	self.resetterFunc = resetterFunc

	self.activeObjects = {}
	self.inactiveObjects = {}

	self.numActiveObjects = 0
end

function ObjectPoolMixin:Acquire()
	local numInactiveObjects = #self.inactiveObjects
	if numInactiveObjects > 0 then
		local obj = self.inactiveObjects[numInactiveObjects]
		self.activeObjects[obj] = true
		self.numActiveObjects = self.numActiveObjects + 1
		self.inactiveObjects[numInactiveObjects] = nil
		return obj, false
	end

	local newObj = self.creationFunc(self);
	if self.resetterFunc and not self.disallowResetIfNew then
		self.resetterFunc(self, newObj);
	end
	self.activeObjects[newObj] = true
	self.numActiveObjects = self.numActiveObjects + 1
	return newObj, true
end

function ObjectPoolMixin:Release(obj)
	if self:IsActive(obj) then
		self.inactiveObjects[#self.inactiveObjects + 1] = obj
		self.activeObjects[obj] = nil
		self.numActiveObjects = self.numActiveObjects - 1
		if self.resetterFunc then
			self.resetterFunc(self, obj)
		end

		return true
	end

	return false
end

function ObjectPoolMixin:ReleaseAll()
	for obj in pairs(self.activeObjects) do
		self:Release(obj)
	end
end

function ObjectPoolMixin:SetResetDisallowedIfNew(disallowed)
	self.disallowResetIfNew = disallowed;
end

function ObjectPoolMixin:EnumerateActive()
	return pairs(self.activeObjects)
end

function ObjectPoolMixin:GetNextActive(current)
	return (next(self.activeObjects, current))
end

function ObjectPoolMixin:IsActive(object)
	return (self.activeObjects[object] ~= nil)
end

function ObjectPoolMixin:GetNumActive()
	return self.numActiveObjects
end

function ObjectPoolMixin:EnumerateInactive()
	return ipairs(self.inactiveObjects)
end

function L.CreateObjectPool(creationFunc, resetterFunc)
	local objectPool = CreateFromMixins(ObjectPoolMixin)
	objectPool:OnLoad(creationFunc, resetterFunc)
	return objectPool
end

local FramePoolMixin = CreateFromMixins(ObjectPoolMixin)

local function FramePoolFactory(framePool)
	local parentName, frameName = framePool.parent and framePool.parent:GetName()
	if parentName then
		framePool.createFrames = framePool.createFrames + 1
		frameName = string.format("%sPoolFrame%s%d", parentName, framePool.frameTemplate, framePool.createFrames)
	else
		frameName = string.format("FramePoolFrame_%s_%s", framePool:GetNumActive(), time())
	end
	return CreateFrame(framePool.frameType, frameName, framePool.parent, framePool.frameTemplate)
end

local function ForbiddenFramePoolFactory(framePool)
	return print(framePool.frameType, string.format("FramePoolFrame_%s_%s", framePool:GetNumActive(), time()), framePool.parent, framePool.frameTemplate)
end

function FramePoolMixin:OnLoad(frameType, parent, frameTemplate, resetterFunc, forbidden)
	if forbidden then
		ObjectPoolMixin.OnLoad(self, ForbiddenFramePoolFactory, resetterFunc)
	else
		ObjectPoolMixin.OnLoad(self, FramePoolFactory, resetterFunc)
	end
	self.createFrames = 0
	self.frameType = frameType
	self.parent = parent
	self.frameTemplate = frameTemplate
end

function FramePoolMixin:GetTemplate()
	return self.frameTemplate
end

local function FramePool_Hide(framePool, frame)
	frame:Hide()
end

function FramePool_HideAndClearAnchors(framePool, frame)
	frame:Hide()
	frame:ClearAllPoints()
end

function L.CreateFramePool(frameType, parent, frameTemplate, resetterFunc, forbidden)
	local framePool = CreateFromMixins(FramePoolMixin)
	framePool:OnLoad(frameType, parent, frameTemplate, resetterFunc or FramePool_HideAndClearAnchors, forbidden)
	return framePool
end

local TexturePoolMixin = CreateFromMixins(ObjectPoolMixin)

local function TexturePoolFactory(texturePool)
	return texturePool.parent:CreateTexture(nil, texturePool.layer, texturePool.textureTemplate, texturePool.subLayer)
end

function TexturePoolMixin:OnLoad(parent, layer, subLayer, textureTemplate, resetterFunc)
	ObjectPoolMixin.OnLoad(self, TexturePoolFactory, resetterFunc)
	self.parent = parent
	self.layer = layer
	self.subLayer = subLayer
	self.textureTemplate = textureTemplate
end

TexturePool_Hide = FramePool_Hide
local TexturePool_HideAndClearAnchors = FramePool_HideAndClearAnchors

function CreateTexturePool(parent, layer, subLayer, textureTemplate, resetterFunc)
	local texturePool = CreateFromMixins(TexturePoolMixin)
	texturePool:OnLoad(parent, layer, subLayer, textureTemplate, resetterFunc or TexturePool_HideAndClearAnchors)
	return texturePool
end

local FontStringPoolMixin = CreateFromMixins(ObjectPoolMixin)

local function FontStringPoolFactory(fontStringPool)
	return fontStringPool.parent:CreateFontString(nil, fontStringPool.layer, fontStringPool.fontStringTemplate, fontStringPool.subLayer)
end

function FontStringPoolMixin:OnLoad(parent, layer, subLayer, fontStringTemplate, resetterFunc)
	ObjectPoolMixin.OnLoad(self, FontStringPoolFactory, resetterFunc)
	self.parent = parent
	self.layer = layer
	self.subLayer = subLayer
	self.fontStringTemplate = fontStringTemplate
end

FontStringPool_Hide = FramePool_Hide
FontStringPool_HideAndClearAnchors = FramePool_HideAndClearAnchors

function L.CreateFontStringPool(parent, layer, subLayer, fontStringTemplate, resetterFunc)
	local fontStringPool = CreateFromMixins(FontStringPoolMixin)
	fontStringPool:OnLoad(parent, layer, subLayer, fontStringTemplate, resetterFunc or FontStringPool_HideAndClearAnchors)
	return fontStringPool
end

local ActorPoolMixin = CreateFromMixins(ObjectPoolMixin)

local function ActorPoolFactory(actorPool)
	return actorPool.parent:CreateActor(nil, actorPool.actorTemplate)
end

function ActorPoolMixin:OnLoad(parent, actorTemplate, resetterFunc)
	ObjectPoolMixin.OnLoad(self, ActorPoolFactory, resetterFunc)
	self.parent = parent
	self.actorTemplate = actorTemplate
end

ActorPool_Hide = FramePool_Hide
function ActorPool_HideAndClearModel(actorPool, actor)
	actor:ClearModel()
	actor:Hide()
end

function CreateActorPool(parent, actorTemplate, resetterFunc)
	local actorPool = CreateFromMixins(ActorPoolMixin)
	actorPool:OnLoad(parent, actorTemplate, resetterFunc or ActorPool_HideAndClearModel)
	return actorPool
end

local FramePoolCollectionMixin = {}

function CreateFramePoolCollection()
	local poolCollection = CreateFromMixins(FramePoolCollectionMixin)
	poolCollection:OnLoad()
	return poolCollection
end

function FramePoolCollectionMixin:OnLoad()
	self.pools = {}
end

function FramePoolCollectionMixin:GetNumActive()
	local numTotalActive = 0
	for _, pool in pairs(self.pools) do
		numTotalActive = numTotalActive + pool:GetNumActive()
	end
	return numTotalActive
end

function FramePoolCollectionMixin:GetOrCreatePool(frameType, parent, template, resetterFunc, forbidden)
	local pool = self:GetPool(template)
	if not pool then
		pool = self:CreatePool(frameType, parent, template, resetterFunc, forbidden)
	end
	return pool
end

function FramePoolCollectionMixin:CreatePool(frameType, parent, template, resetterFunc, forbidden)
	assert(self:GetPool(template) == nil)
	local pool = L.CreateFramePool(frameType, parent, template, resetterFunc, forbidden)
	self.pools[template] = pool
	return pool
end

function FramePoolCollectionMixin:GetPool(template)
	return self.pools[template]
end

function FramePoolCollectionMixin:Acquire(template)
	local pool = self:GetPool(template)
	assert(pool)
	return pool:Acquire()
end

function FramePoolCollectionMixin:Release(object)
	for _, pool in pairs(self.pools) do
		if pool:Release(object) then
			-- Found it! Just return
			return
		end
	end

	-- Huh, we didn't find that object
	assert(false)
end

function FramePoolCollectionMixin:ReleaseAllByTemplate(template)
	local pool = self:GetPool(template)
	if pool then
		pool:ReleaseAll()
	end
end

function FramePoolCollectionMixin:ReleaseAll()
	for key, pool in pairs(self.pools) do
		pool:ReleaseAll()
	end
end

function FramePoolCollectionMixin:EnumerateActiveByTemplate(template)
	local pool = self:GetPool(template)
	if pool then
		return pool:EnumerateActive()
	end

	return nop
end

function FramePoolCollectionMixin:EnumerateActive()
	local currentPoolKey, currentPool = next(self.pools, nil)
	local currentObject = nil
	return function()
		if currentPool then
			currentObject = currentPool:GetNextActive(currentObject)
			while not currentObject do
				currentPoolKey, currentPool = next(self.pools, currentPoolKey)
				if currentPool then
					currentObject = currentPool:GetNextActive()
				else
					break
				end
			end
		end

		return currentObject
	end, nil
end

local FixedSizeFramePoolCollectionMixin = CreateFromMixins(FramePoolCollectionMixin)

function CreateFixedSizeFramePoolCollection()
	local poolCollection = CreateFromMixins(FixedSizeFramePoolCollectionMixin)
	poolCollection:OnLoad()
	return poolCollection
end

function FixedSizeFramePoolCollectionMixin:OnLoad()
	FramePoolCollectionMixin.OnLoad(self)
	self.sizes = {}
end

function FixedSizeFramePoolCollectionMixin:CreatePool(frameType, parent, template, resetterFunc, forbidden, maxPoolSize, preallocate)
	local pool = FramePoolCollectionMixin.CreatePool(self, frameType, parent, template, resetterFunc, forbidden)

	if preallocate then
		for i = 1, maxPoolSize do
			pool:Acquire()
		end
		pool:ReleaseAll()
	end

	self.sizes[template] = maxPoolSize

	return pool
end

function FixedSizeFramePoolCollectionMixin:Acquire(template)	
	local pool = self:GetPool(template)
	assert(pool)

	if pool:GetNumActive() < self.sizes[template] then
		return pool:Acquire()
	end
	return nil
end

ImmersionAPI.CreateFramePool = L.CreateFramePool; -- for XML
ImmersionAPI.CreateFontStringPool = L.CreateFontStringPool; -- for XML
