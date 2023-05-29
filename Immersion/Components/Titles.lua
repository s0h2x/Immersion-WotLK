local API, Titles, _, L = ImmersionAPI, {}, ...
L.TitlesMixin = Titles

-- Upvalue for update scripts
local GetScaledCursorPosition, UIParent = GetScaledCursorPosition, UIParent

local NORMAL_QUEST_DISPLAY = NORMAL_QUEST_DISPLAY:gsub(0, 'f')
local TRIVIAL_QUEST_DISPLAY = TRIVIAL_QUEST_DISPLAY:gsub(0, 'f')

-- Priority
local P_COMPLETE_QUEST   = 1
local P_AVAILABLE_QUEST  = 2
local P_AVAILABLE_GOSSIP = 3
local P_INCOMPLETE_QUEST = 4

-- Animation divisor
local ANI_DIVISOR = 10

----------------------------------
-- Display
----------------------------------
function Titles:AdjustHeight(newHeight)
	self.offset = 0
	if ( ANI_DIVISOR == 0 ) then 
		self:SetHeight(1)
		self:OnUpdateOffset()
		return
	elseif ( ANI_DIVISOR == 1 ) then
		self:SetHeight(newHeight)
		self:OnUpdateOffset()
		return
	end
	self:SetScript('OnUpdate', function(self)
		local height = self:GetHeight()
		local diff = newHeight - height
		if abs(newHeight - height) < 0.5 then
			self:SetHeight(newHeight)
			self:SetScript('OnUpdate', nil)
		else
			self:SetHeight(height + ( diff / ANI_DIVISOR ) )
		end
		self:OnUpdateOffset()
	end)
end

function Titles:OnUpdateOffset()
	local anchor, relativeRegion, relativeKey, x, y, offset
	if not self.ignoreAtCursor and L('gossipatcursor') then
		local posX, posY = API:GetScaledCursorPosition()
		local uiX, uiY = UIParent:GetCenter()
		x, y = (posX - uiX), (posY - uiY)
		anchor, relativeRegion, relativeKey, offset = 
			'CENTER', UIParent, 'CENTER', 0
	else
		anchor, relativeRegion, relativeKey, x, y = self:GetPoint()
		offset = (self.offset or 0) + L('titleoffsetY')
	end
	local diff = ( y - offset )
	if ( offset == 0 ) or abs( y - offset ) < 0.3 then
		self:SetPoint(anchor, relativeRegion, relativeKey, x, offset)
		if self:GetScript('OnUpdate') == self.OnUpdateOffset then
			self:SetScript('OnUpdate', nil)
		end
	else
		self:SetPoint(anchor, relativeRegion, relativeKey, x, offset + (ANI_DIVISOR > 1 and (diff / ANI_DIVISOR) or 0))
	end
end

function Titles:StopMoving()
	self:StopMovingOrSizing()
	local centerX, centerY = self:GetCenter()
	local scaleOffset = self:GetScale() * self:GetParent():GetScale()
	local uiX, uiY = GetScreenWidth() / 2 / scaleOffset, GetScreenHeight() / 2 / scaleOffset
	local newHorzVal, newVertVal = (centerX - uiX), (centerY - uiY)
	-- Horizontal clip fix
	if self:GetLeft() < 0 then
		newHorzVal = (self:GetWidth() / 2) - (GetScreenWidth() / 2) + 16
	elseif ( GetScreenWidth() - self:GetRight() ) < 0 then
		newHorzVal = (GetScreenWidth() / 2) - (self:GetWidth() / 2) - 16
	end
	-- Vertical clip fix
	if self:GetBottom() < 0 then
		newVertVal = (self:GetHeight() / 2) - (GetScreenHeight() / 2) + 16
	elseif ( GetScreenHeight() - self:GetTop() ) < 0 then
		newVertVal = (GetScreenHeight() / 2) - (self:GetHeight() / 2) - 16
	end
	self:ClearAllPoints()
	self:SetPoint('CENTER', UIParent, newHorzVal, newVertVal)
	L.Set('titleoffset', newHorzVal)
	L.Set('titleoffsetY', newVertVal)
end

function Titles:OnScroll(delta)
	self.offset = self.offset and self.offset + (-delta * 40) or (-delta * 40)
	self.ignoreAtCursor = true
	self:SetScript('OnUpdate', self.OnUpdateOffset)
end

function Titles:ResetPosition()
	self.offset = 0
	self.ignoreAtCursor = false
end

function Titles:OnEvent(event, ...)
	if self[event] then
		self[event](self, ...)
	else
		self:Hide()
	end
end

function Titles:OnHide()
	for i, button in pairs(self.Buttons) do
		button:UnlockHighlight()
		button:Hide()
	end
	wipe(self.Active)
	self.numActive = 0
	self.idx = 1
end

function Titles:GetNumActive()
	return self.numActive or 0
end

function Titles:GetButton(index)
	local button = self.Buttons[index]
	if not button then
		button = L.Create({
			type     = 'Button',
			name     = 'TitleButton',
			index    = index,
			parent   = self,
			inherit  = 'ImmersionTitleButtonTemplate',
			mixins   = {L.ButtonMixin, L.ScalerMixin},
			backdrop = L.Backdrops.GOSSIP_TITLE_BG,
		})
		button:Init(index)
		self.Buttons[index] = button
	end
	button:Show()
	return button
end

function Titles:UpdateActive()
	local newHeight, numActive = 0, 0
	wipe(self.Active)
	for i, button in pairs(self.Buttons) do
		if button:IsShown() then
			newHeight = newHeight + button:GetHeight()
			numActive = numActive + 1
			self.Active[i] = button
		end
	end
	ANI_DIVISOR = L('anidivisor')
	self.ignoreAtCursor = false
	self.numActive = numActive
	self:ResetPosition()
	self:AdjustHeight(newHeight)
	if self.SetFocus then
		local _, bestOptionIndex = self:GetBestOption()
		self:SetFocus(bestOptionIndex)
	end
end

function Titles:GetBestOption()
	local numActive = self:GetNumActive()
	if numActive > 0 then
		local option = self.Buttons[1]
		for i=2, numActive do
			option = option:ComparePriority(self.Buttons[i])
		end
		return option, option.idx
	end
end

----------------------------------
-- Gossip
----------------------------------
function Titles:GOSSIP_SHOW()
	self.idx = 1
	self.type = 'Gossip'
	self:Show()
	self:UpdateAvailableQuests(API:GetGossipAvailableQuests())
	self:UpdateActiveQuests(API:GetGossipActiveQuests())
	self:UpdateGossipOptions(API:GetGossipOptions())
	for i = self.idx, #self.Buttons do
		self.Buttons[i]:Hide()
	end
	self:UpdateActive()
end

function Titles:UpdateAvailableQuests(data)
	for i, quest in ipairs(data) do
		local button = self:GetButton(self.idx)
		----------------------------------
		local typeOfQ = (quest.isTrivial and TRIVIAL_QUEST_DISPLAY)
		button:SetFormattedText(typeOfQ or NORMAL_QUEST_DISPLAY, quest.title)
		----------------------------------
		local icon, useAtlas = API:GetQuestIconOffer(quest)
		button:SetIcon(icon, typeOfQ and 0.5, useAtlas)
		----------------------------------
		button:SetPriority(P_AVAILABLE_QUEST)
		----------------------------------
		button:SetID(i)
		button.type = 'Available'
		----------------------------------
		self.idx = self.idx + 1
	end
end

function Titles:UpdateActiveQuests(data)
	self.hasActiveQuests = (#data > 0)
	for i, quest in ipairs(data) do
		local button = self:GetButton(self.idx)
		----------------------------------
		local typeOfQ = (quest.isTrivial and TRIVIAL_QUEST_DISPLAY)
		button:SetFormattedText(typeOfQ or NORMAL_QUEST_DISPLAY, quest.title)
		----------------------------------
		local icon, useAtlas = API:GetQuestIconActive(quest)
		button:SetIcon(icon, typeOfQ and 0.5, useAtlas)
		----------------------------------
		button:SetPriority(quest.isComplete and P_COMPLETE_QUEST or P_INCOMPLETE_QUEST)
		----------------------------------
		button:SetID(i)
		button:SetType('Active')
		----------------------------------
		self.idx = self.idx + 1
	end
end

function Titles:UpdateGossipOptions(data)
	for i, option in ipairs(data) do
		local button = self:GetButton(self.idx)
		----------------------------------
		button:SetText(option.name)
		button:SetGossipIcon(option.type)
		button:SetPriority(P_AVAILABLE_GOSSIP)
		----------------------------------
		button:SetID(i)
		button:SetType('Gossip')
		----------------------------------
		self.idx = self.idx + 1
	end
end

function Titles:UNIT_QUEST_LOG_CHANGED(target, ...)
	if target ~= 'player' then
		return
	end
	if self:IsVisible() then
		if ( self.type == 'Gossip' and self.hasActiveQuests ) then
			self:Hide()
			self:GOSSIP_SHOW()
		elseif ( self.type == 'Quests' ) then
			self:Hide()
			self:QUEST_GREETING()
		end
	end
end

----------------------------------
-- Quest
----------------------------------
function Titles:QUEST_GREETING()
	self.idx = 1
	self.type = 'Quests'
	self:Show()
	self:UpdateActiveGreetingQuests(GetNumActiveQuests())
	self:UpdateAvailableGreetingQuests(GetNumAvailableQuests())
	for i = self.idx, #self.Buttons do
		self.Buttons[i]:Hide()
	end
	self:UpdateActive()
end


function Titles:UpdateActiveGreetingQuests(numActiveQuests)
	for i=1, numActiveQuests do
		local button = self:GetButton(self.idx)
		local title, isComplete = GetActiveTitle(i)
		----------------------------------
		local qType = ( IsActiveQuestTrivial(i) and TRIVIAL_QUEST_DISPLAY )
		button:SetFormattedText(qType or NORMAL_QUEST_DISPLAY, title)
		----------------------------------
		local icon = ( isComplete and 'ActiveQuestIcon') or
					( 'InCompleteQuestIcon' )
		button:SetGossipQuestIcon(icon, qType and 0.75)
		button:SetPriority(isComplete and P_COMPLETE_QUEST or P_INCOMPLETE_QUEST)
		----------------------------------
		button:SetID(i)
		button.type = 'ActiveQuest'
		----------------------------------
		self.idx = self.idx + 1
	end
end

function Titles:UpdateAvailableGreetingQuests(numAvailableQuests)
	for i=1, numAvailableQuests do
		local button = self:GetButton(self.idx)
		local title = GetAvailableTitle(i)
		local isTrivial, isDaily, isRepeatable = API:GetAvailableQuestInfo(i)
		----------------------------------
		local qType = ( isTrivial and TRIVIAL_QUEST_DISPLAY )
		button:SetFormattedText(qType or NORMAL_QUEST_DISPLAY, title)
		----------------------------------
		local icon = ( isDaily and 'DailyQuestIcon' ) or
					( isRepeatable and 'DailyActiveQuestIcon' ) or
					( 'AvailableQuestIcon' )
		button:SetGossipQuestIcon(icon, qType and 0.5)
		button:SetPriority(P_AVAILABLE_QUEST)
		----------------------------------
		button:SetID(i)
		button.type = 'AvailableQuest'
		----------------------------------
		self.idx = self.idx + 1
	end
end