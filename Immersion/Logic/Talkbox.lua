local TalkBox, GetOffset, _, L = {}, UIParent.GetBottom, ...

----------------------------------
-- Offsets
----------------------------------
function TalkBox:SetOffset(x, y)
--[[if self:UpdateNameplateAnchor() then
		return
	end]]

	local point = L('boxpoint')
	local anidivisor = L('anidivisor')
	x = x or L('boxoffsetX')
	y = y or L('boxoffsetY')

	self.offsetX = x
	self.offsetY = y

	local isBottom = ( point:match('Bottom') )
	local isVert = ( isBottom or point == 'Top' )

	y = y + ( isBottom and self.extraY or 0 )

	local comp = isVert and y or x

	if ( not isBottom ) or ( anidivisor <= 1 ) or ( not self:IsVisible() ) then
		self:SetPoint(point, UIParent, x, y)
		return
	end
	self:SetScript('OnUpdate', function(self)
		self.isOffsetting = true
		local offset = (GetOffset(self) or 0) - (GetOffset(UIParent) or 0)
		local diff = ( comp - offset )
		if (offset == 0) or abs( comp - offset ) < 0.3 then
			self:SetPoint(point, UIParent, x, y)
			self.isOffsetting = false
			self:SetScript('OnUpdate', nil)
		elseif isVert then
			self:SetPoint(point, UIParent, x, offset + ( diff / anidivisor ))
		else
			-- self:SetPoint(point, UIParent, x, offset + ( diff / anidivisor ))
			self:SetPoint(point, parent, offset + (diff / anidivisor), y)
		end
	end)
end

-- Temporarily increase the frame offset, in case we want to show extra stuff,
-- like quest descriptions, quest rewards, items needed for quest progress, etc.
function TalkBox:SetExtraOffset(newOffset)
	local currX = ( self.offsetX or L('boxoffsetX') )
	local currY = ( self.offsetY or L('boxoffsetY') )
	local allowExtra = L('anidivisor') > 0
	self.extraY = allowExtra and newOffset or 0
	self:SetOffset(currX, currY)
end

function TalkBox:OnEnter()
	-- Highlight the button when it can be clicked
	if not L('disableboxhighlight') then
		local lastEvent = self.lastEvent
		if 	L('immersivemode') or ( ( ( lastEvent == 'QUEST_COMPLETE' ) and
			not (self.Elements.itemChoice == 0 and GetNumQuestChoices() > 1) ) or
			( lastEvent == 'QUEST_ACCEPTED' ) or
			( lastEvent == 'QUEST_DETAIL' ) or
			( lastEvent == 'ITEM_TEXT_READY' ) or
			( lastEvent ~= 'GOSSIP_SHOW' and IsQuestCompletable() ) ) then
			L.UIFrameFadeIn(self.Hilite, 0.15, self.Hilite:GetAlpha(), 1)
		end
	end
end

function TalkBox:OnLeave()
	L.UIFrameFadeOut(self.Hilite, 0.15, self.Hilite:GetAlpha(), 0)
end

function TalkBox:OnDragStart()
	if ( L('boxlock') or self.isOffsetting ) then return end
	self:StartMoving()
end

function TalkBox:OnDragStop()
	if ( L('boxlock') or self.isOffsetting ) then return end
	self:StopMovingOrSizing()
	local point, _, _, x, y = self:GetPoint()

	point = point:sub(1,1) .. point:sub(2):lower()

	-- convert center point to bottom
	if ( point == 'Center' ) then
		point = 'Bottom'
		-- calculate the horz offset from the center of the screen
		x = ( self:GetCenter() * ImmersionFrame:GetScale() ) - ( GetScreenWidth() / 2 )
		y = self:GetBottom()
	end
	
	local isBottom = point == 'Bottom'
	if isBottom then
		y = y - (self.extraY or 0)
	end

	self:ClearAllPoints()
	self.offsetX, self.offsetY = x, y

	L.Set('boxpoint', point)
	L.Set('boxoffsetX', x)
	L.Set('boxoffsetY', y)
	self:SetPoint(point, UIParent, point, x, isBottom and y + (self.extraY or 0) or y)
end

function TalkBox:OnLeftClick()
	-- Complete quest
	if self.lastEvent == 'QUEST_COMPLETE' then
		self.Elements:CompleteQuest()
	-- Accept quest
	elseif self.lastEvent == 'QUEST_DETAIL' or self.lastEvent == 'QUEST_ACCEPTED' then
		self.Elements:AcceptQuest()
	elseif self.lastEvent == 'ITEM_TEXT_READY' then
		local text = self.TextFrame.Text
		if text:GetNumRemaining() > 1 and text:IsSequence() then
			text:ForceNext()
		else
			ImmersionAPI:CloseItemText()
		end
	-- Progress quest to completion
	elseif self.lastEvent == 'QUEST_PROGRESS' then
		if IsQuestCompletable() then
			CompleteQuest()
		else
			ImmersionFrame:ForceClose()
		end
	else
		ImmersionFrame:ForceClose()
	end
end

function TalkBox:OnClick(button)
	if L('flipshortcuts') then
		button = button == 'LeftButton' and 'RightButton' or 'LeftButton'
	end
	if button == 'LeftButton' then
		if L('immersivemode') then
			L.Inputs.accept(ImmersionFrame)
		else
			self:OnLeftClick()
		end
	elseif button == 'RightButton' then
		local text = self.TextFrame.Text
		if text:GetNumRemaining() > 1 and text:IsSequence() then
			text:ForceNext()
		elseif text:IsSequence() then
			if ( ImmersionFrame.playbackEvent == 'IMMERSION_TOAST' ) then
				ImmersionFrame:RemoveToastByText(text.storedText)
			else
				text:RepeatTexts()
			end
		end
	end
end

function TalkBox:Dim()
	L.UIFrameFadeOut(self, 0.15, self:GetAlpha(), 0.05)
end

function TalkBox:Undim()
	L.UIFrameFadeIn(self, 0.15, self:GetAlpha(), 1)
end

----------------------------------
-- Mixin with scripts
----------------------------------
L.Mixin(L.frame.TalkBox, TalkBox)