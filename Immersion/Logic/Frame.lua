local _, L = ...
local Frame, TalkBox, API, GetTime = {}, {}, ImmersionAPI, GetTime

----------------------------------
-- Event handler
----------------------------------
function Frame:OnEvent(event, ...)
	self:ResetElements(event)
	self:HandleGossipQuestOverlap(event)
	if self[event] then
		event = self[event](self, ...) or event
	end
	self.TalkBox.lastEvent = event
	self.lastEvent = event
	self.timeStamp = GetTime()
	self:UpdateItems()
--	self:UpdateBackground()
	return event
end

function Frame:OnHide()
	self.TalkBox.BackgroundFrame.OverlayKit:Hide()
	if L('hideui') and L('camerarotationenabled') then 
		MoveViewRightStop()
	end
end

----------------------------------
-- Content handler (gossip & quest)
----------------------------------
function Frame:AddQuestInfo(template)
	local elements = self.TalkBox.Elements
	local content = elements.Content
	local height = elements:Display(template, 'Stone')
	local numSpellRewards = API:GetNumRewardSpells()

	-- hacky fix to stop a content frame that only contains a spacer from showing.
	if height > 20 then
		elements:Show()
		content:Show()
		elements:UpdateBoundaries()
		if (not numSpellRewards or numSpellRewards < 1) then
			elements:UpdateBoundaries() -- double call to fix a content frame bug width ...
		end
	else
		elements:Hide()
		content:Hide()
	end

	-- Extra: 32 px padding 
	self.TalkBox:SetExtraOffset((height + 32) * L('elementscale'))
	self.TalkBox.NameFrame.Name.FadeIn:Play()
end

function Frame:IsGossipAvailable(ignoreAutoSelect)
	-- if there is only a non-gossip option, then go to it directly
	if 	(API:GetNumGossipAvailableQuests() == 0) and 
		(API:GetNumGossipActiveQuests() == 0) and 
		(API:GetNumGossipOptions() == 1) and
		not API:ForceGossip() then
		----------------------------
		if API:CanAutoSelectGossip(ignoreAutoSelect) then
			return false
		end
	end
	return true
end

function Frame:IsQuestAutoAccepted(questStartItemID)
	-- Auto-accepted quests need to be treated differently from other quests,
	-- and different from eachother depending on the source of the quest. 
	-- Handling here is prone to cause bugs/weird behaviour, update with caution.

	local questID = API:GetQuestID()
	local isFromAdventureMap = API:QuestIsFromAdventureMap()
	local isFromAreaTrigger = API:QuestGetAutoAccept() and API:QuestIsFromAreaTrigger()
	local isFromItem = (questStartItemID ~= nil and questStartItemID ~= 0)

	-- the quest came from an adventure map, so user has already seen and accepted it.
	if isFromAdventureMap then
		return true
	end

	-- an item pickup by loot caused this quest to show up, don't intrude on the user.
	if isFromItem then
		-- add a new quest tracker popup and close the quest dialog
		if AddQuestWatch(questID, 'OFFER') then
			PlayAutoAcceptQuestSound()
		end
		API:CloseQuest()
		return true
	end

	-- triggered from entering an area, but also from forced campaign quests.
	-- let's not intrude on the user; just add a tracker popup.
	if isFromAreaTrigger then
		-- add a new quest tracker popup and close the quest dialog
		if AddAutoQuestPopUp(questID, 'OFFER') then
			PlayAutoAcceptQuestSound()
		end
		API:CloseQuest()
		return true
	end
end

-- Iterate through gossip options and simulate a click on the best option.
function Frame:SelectBestOption()
	local button = self.TitleButtons:GetBestOption()
	if button then
		button.Hilite:SetAlpha(1)
		button:Click()
		button:OnLeave()
		PlaySound(EnumConst.SOUNDKIT.IG_QUEST_LIST_SELECT)
	end
end

function Frame:GetRemainingSpeechTime()
	return self.TalkBox.TextFrame.Text:GetTimeRemaining()
end

function Frame:IsSpeechFinished()
	return self.TalkBox.TextFrame.Text:IsFinished()
end

-- hack to figure out if event is related to quests
function Frame:IsObstructingQuestEvent(forceEvent)
	local event = forceEvent or self.lastEvent or ''
	return ( event:match('^QUEST') and event ~= 'QUEST_ACCEPTED' )
end

function Frame:IsNotQuestDisplayed()
	return ( self.IsAvailableQuestID ~= '' and
	  self.IsAvailableQuestObjective ~= '' and
	  not UnitExists('questnpc')
	)
end

function Frame:IsNPCObjectOrItem(notInGossip, notInQuest)
	if notInGossip or notInQuest then
		local model = self.TalkBox.MainFrame.Model
		local m2 = model.file[model:GetModel()]
		return ( model.unit ~= 'ether' or type(m2) ~= 'string' )
	end
end

function Frame:HandleGossipQuestOverlap(event)
	-- Since Blizzard handles this transition by mutually exclusive gossip/quest frames,
	-- and their visibility to determine whether to close gossip or quest interaction,
	-- events need to be checked so that an NPC interaction is correctly transitioned.
	if (type(event) == 'string') then
		if ( event == 'GOSSIP_SHOW' ) then
		--	API:CloseQuest()
		elseif self:IsObstructingQuestEvent(event) then
			API:CloseGossip()
		end
	end
end

function Frame:HandleGossipOpenEvent(kit)
--	if not self.gossipHandlers[kit] then
--		self:SetBackground(kit)
	self:UpdateTalkingHead(API:GetUnitName('npc'), API:GetGossipText(), 'GossipGossip')
	if not L('gossipmode') and self:IsGossipAvailable() then
		self:PlayIntro('GOSSIP_SHOW')
	else
		self:PlayIntro('GOSSIP_SHOW')
	end
--	end
end

function Frame:SetBackground(kit)
	local backgroundFrame = self.TalkBox.BackgroundFrame;
	local overlay = backgroundFrame.OverlayKit;
	
	if kit and not L('disablebgtextures') then
		local backgroundAtlas = API:GetFinalNameFromTextureKit('QuestBG-%s', kit)
		local atlasInfo = API:GetAtlasInfo(backgroundAtlas)
		if atlasInfo then
			overlay:Show()
			overlay:SetGradientAlpha('HORIZONTAL', 1, 1, 1, 0, 1, 1, 1, 0.5)

			overlay:SetSize(atlasInfo.width, atlasInfo.height)
			overlay:SetTexture(atlasInfo.file)
			overlay:SetTexCoord(
				atlasInfo.leftTexCoord, atlasInfo.rightTexCoord,-- + 0.035,
				atlasInfo.topTexCoord, atlasInfo.bottomTexCoord)-- + 0.035)
			return
		end
	end
end

function Frame:UpdateBackground()
	local theme = API:GetQuestDetailsTheme(API:GetQuestID())
	local kit = theme and theme.background and theme.background:gsub('QuestBG%-', '')
	if kit then
		self:SetBackground(kit)
	end
end

function Frame:ResetElements(event)
	if ( self.IgnoreResetEvent[event] ) then return end
	
	self.Inspector:Hide()
	self.TalkBox.Elements:Reset()
	-- self:SetBackground(nil)
end

function Frame:UpdateTalkingHead(title, text, npcType, explicitUnit, isToastPlayback)
	local unit = explicitUnit
	if not unit then
		if ( UnitExists('questnpc') and not UnitIsUnit('questnpc', 'player') and not UnitIsDead('questnpc') ) then
			unit = 'questnpc'
		elseif ( UnitExists('npc') and not UnitIsUnit('npc', 'player') and not UnitIsDead('npc') ) then
			unit = 'npc'
		else
			unit = npcType
		end
	end
	local talkBox = self.TalkBox
	talkBox:SetExtraOffset(0)
	talkBox.MainFrame.Indicator:SetTexture('Interface\\GossipFrame\\' .. npcType .. 'Icon')
	talkBox.MainFrame.Model:SetUnit(unit)
	talkBox.NameFrame.Name:SetText(title)
	local textFrame = talkBox.TextFrame
	textFrame.Text:SetText(text)
	-- Add contents to toast.
	if not isToastPlayback then
		if L('onthefly') then
			self:QueueToast(title, text, npcType, unit)
		end
	end
	if L('showprogressbar') and not L('disableprogression') then
		talkBox.ProgressionBar:Show()
	end
	self.isToastPlayback = isToastPlayback and L('onthefly')
end

function Frame:HandleGossipToastClosed()
	if L('hideui') and L('camerarotationenabled') then 
		if self.isToastPlayback then
			if ( API:GetNumGossipAvailableQuests() > 0 ) then
				if ( self.lastEvent ~= 'GOSSIP_SHOW' ) then
					MoveViewRightStop()
				end
			else
				MoveViewRightStop()
			end
		end
	end
end

----------------------------------
-- Content handler (items)
----------------------------------
function Frame:SetItemTooltip(tooltip, item)
	local objType = item.objectType
	if objType == 'item' then
		tooltip:SetQuestItem(item.type, item:GetID())
	elseif objType == 'currency' then
		tooltip:SetQuestCurrency(item.type, item:GetID())
	end
	tooltip.Icon.Texture:SetTexture(item.itemTexture or item.Icon:GetTexture())
end

function Frame:GetItemColumn(owner, id)
	local columns = owner and owner.Columns
	if columns and id then
		local column = columns[id]
		local anchor = columns[id - 1]
		if not column then
			column = CreateFrame('Frame', nil, owner)
			column:SetSize(1, 1) -- set size to make sure children are drawn
			column:SetScript('OnHide', function(self) self.lastItem = nil end)
			column:SetFrameStrata("FULLSCREEN_DIALOG")
			L.Mixin(column, L.AdjustToChildren)
			columns[id] = column
		end
		if anchor then
			column:SetPoint('TOPLEFT', anchor, 'TOPRIGHT', 30, 0)
		else
			column:SetPoint('TOPLEFT', owner, 0, -30)
		end
		column:Show()
		return column
	end
end

function Frame:ShowItems()
	local inspector = self.Inspector
	local items, hasChoice, hasExtra = inspector.Items
	local active, extras, choices = inspector.Active, inspector.Extras, inspector.Choices
	inspector:Show()
	for id, item in ipairs(items) do
		local tooltip = inspector.tooltipFramePool:Acquire()
		local owner = item.type == 'choice' and choices or extras
		local columnID = ( id % 3 == 0 ) and 3 or ( id % 3 )
		local column = self:GetItemColumn(owner, columnID)

		hasChoice = hasChoice or item.type == 'choice'
		hasExtra = hasExtra or item.type ~= 'choice'

		-- Set up tooltip
		tooltip:SetParent(column)
		tooltip:SetOwner(column, "ANCHOR_NONE")
		tooltip.owner = owner

		active[id] = tooltip.Button
		tooltip.Button:SetID(id)

		-- Mixin the tooltip button functions
		L.Mixin(tooltip.Button, L.TooltipMixin)
		tooltip.Button:SetReferences(item, inspector)

		self:SetItemTooltip(tooltip, item, inspector)

		-- Readjust tooltip size to fit the icon
		-- local width, height = tooltip:GetSize()
		-- tooltip:SetSize(width + 30, height + 4)

		-- Anchor the tooltip to the column
		tooltip:SetPoint('TOP', column.lastItem or column, column.lastItem and 'BOTTOM' or 'TOP', 0, 0)
		column.lastItem = tooltip
	end

	-- Text display:
	local elements = self.TalkBox.Elements
	local progress = elements.Progress
	local rewardsFrame = elements.Content.RewardsFrame
	-- Choice text:
	if rewardsFrame.ItemChooseText:IsVisible() then
		choices.Text:Show()
		choices.Text:SetText(rewardsFrame.ItemChooseText:GetText())
	else
		choices.Text:Hide()
	end
	-- Extra text:
	if progress.ReqText:IsVisible() then
		extras.Text:Show()
		extras.Text:SetText(progress.ReqText:GetText())
	elseif rewardsFrame.ItemReceiveText:IsVisible() and hasExtra then
		extras.Text:Show()
		extras.Text:SetText(rewardsFrame.ItemReceiveText:GetText())
	else
		extras.Text:Hide()
	end
	------------------------------
	inspector.Threshold = #active
	inspector:AdjustToChildren()
	if inspector.SetFocus then
		inspector:SetFocus(1)
	end
end

function Frame:UpdateItems()
	local items = self.Inspector.Items
	wipe(items)
	-- count item rewards
	for _, item in ipairs(self.TalkBox.Elements.Content.RewardsFrame.Buttons) do
		if item:IsVisible() then
			items[#items + 1] = item
		end
	end
	-- count necessary quest progress items
	for _, item in ipairs(self.TalkBox.Elements.Progress.Buttons) do
		if item:IsVisible() then
			items[#items + 1] = item
		end
	end
	self.hasItems = #items > 0
	
	return items, #items
end

----------------------------------
-- Animation players
----------------------------------
function Frame:PlayIntro(event, freeFloating)
	local isShown = self:IsVisible()
	local shouldAnimate = not isShown and not L('disableglowani')
	self.playbackEvent = event

	if freeFloating then
		self:ClearKeyboardInput()
	else
		self:SetPropagateKeyboardInput()
	end

	self:Show()

	if IsOptionFrameOpen() then
		self:ForceClose(true)
	else
		self:FadeIn(nil, shouldAnimate, freeFloating)

		local box = self.TalkBox
		local x, y = L('boxoffsetX'), L('boxoffsetY')
		box:ClearAllPoints()
		box:SetOffset(box.offsetX or x, box.offsetY or y)

		if not shouldAnimate and not L('disableglowani') then
			self.TalkBox.MainFrame.Sheen.FadeIn:Stop()
			self.TalkBox.MainFrame.Sheen.FadeIn:Play()
			self.TalkBox.MainFrame.TextSheen.FadeIn:Stop()
			self.TalkBox.MainFrame.TextSheen.FadeIn:Play()
		end
	end
end

-- This will also hide the frames after the animation is done.
function Frame:PlayOutro(optionFrameOpen)
	self:ClearKeyboardInput()
	self:FadeOut(0.5)
	self:PlayToasts(optionFrameOpen)
	self:HandleGossipToastClosed()
end

function Frame:ForceClose(optionFrameOpen)
	API:CloseGossip()
	API:CloseQuest()
	API:CloseItemText()
	self:PlayOutro(optionFrameOpen)
end

----------------------------------
-- Key input handler
----------------------------------
local inputs, modifierStates, numbers = L.Inputs, L.ModifierStates, L.Numbers;

function Frame:IsInspectModifier(button)
	return button and button:match(L('inspect')) and true
end

function Frame:IsModifierDown(modifier)
	return modifierStates[modifier or L('inspect')]()
end

function Frame:IsActionInputs(frame, button)
	local input
	local actionIndex
	for action, func in pairs(inputs) do
		-- run through input handlers and check if button matches a configured key.
		if L.cfg[action] == button then
			input = func
			break
		end
		actionIndex = action
	end
	if input then
		input(frame)
	end
end

function Frame:IsNumericInputs(titles, button)
	return inputs.number(titles, tonumber(button))
end

function Frame:SetPropagateKeyboardInput()
	if InCombatLockdown() then return end
	
	local IsAction = self.ActionInput
	local IsNumeric = self.SelectInput
	local IsInspect = self.InspectInput
	
	if IsInspect then
		SetOverrideBindingClick(IsInspect, true, 'ESCAPE', IsInspect:GetName(), 'ESCAPE')
	end
	
	if IsAction then
		for action in next, inputs do
			local bind = L.cfg[action] or L(action)
			if bind ~= nil then
				SetOverrideBindingClick(IsAction, true, bind, IsAction:GetName(), bind)
			end
		end
	end
	
	if IsNumeric and L.cfg.enablenumbers then
		for button, modifiers in next, numbers do
			for _, modifier in next, modifiers do
				button = tonumber(button)
				local numeric = modifier..button
				if type(button) == 'number' then
					SetOverrideBindingClick(IsNumeric, true, numeric, IsNumeric:GetName(), numeric)
				end
			end
		end
	end
end

function Frame:ClearKeyboardInput()
    if not InCombatLockdown() then
        for _, input in pairs({
            self.InspectInput,
            self.ActionInput,
            self.SelectInput
        }) do
            ClearOverrideBindings(input)
        end
    end
end

----------------------------------
-- Mixin with scripts
----------------------------------
L.Mixin(L.frame, Frame)