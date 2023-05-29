local API, TEMPLATE, Elements, _, L = ImmersionAPI, {}, {}, ...
L.ElementsMixin = Elements

local TEXT_COLOR, TITLE_COLOR = GetMaterialTextColors('Stone') -- default text colors
local REWARDS_OFFSET = 10 -- vertical distance between sections
local ITEMS_PER_ROW = 2 -- modulus value for item rows
local ACTIVE_TEMPLATE

local LOOT_ITEM_TYPES = {
	[0] = 'item'; -- LOOT_LIST_ITEM
	[1] = 'currency'; -- LOOT_LIST_CURRENCY
}

----------------------------------
-- Helper functions
----------------------------------
local function AddSpellToBucket(spellBuckets, type, rewardSpellIndex)
	if not spellBuckets[type] then
		spellBuckets[type] = {}
	end
	local spellBucket = spellBuckets[type]
	spellBucket[#spellBucket + 1] = rewardSpellIndex
end

local function IsValidSpellReward(texture, knownSpell, isBoostSpell, garrFollowerID)
	-- check if already known, check if is boost spell, check if follower is collected
	return  texture and not knownSpell and
			(not isBoostSpell or API:IsCharacterNewlyBoosted()) and
			(not garrFollowerID or not API:IsFollowerCollected(garrFollowerID))
end

local function GetItemButton(parentFrame, index, buttonType)
	local rewardButtons = parentFrame.Buttons
	if ( not rewardButtons[index] ) then
		local button = CreateFrame('BUTTON', _..(buttonType or 'QuestInfoItem')..index, parentFrame, parentFrame.buttonTemplate)
		rewardButtons[index] = button
		button.container = parentFrame:GetParent():GetParent()
		button.highlight = parentFrame.ItemHighlight
	end
	return rewardButtons[index]
end

local function UpdateItemInfo(self, showMissing)
	assert(self.type)
	assert(self:GetID())

	if self.objectType == 'item' then
		local name, texture, amount, quality, isUsable = GetQuestItemInfo(self.type, self:GetID())
		local displayText;
		if showMissing then
			local missingAmount = amount > 1 and amount - GetItemCount(name)
			local hasMissingAmount = missingAmount and missingAmount > 0
			displayText = hasMissingAmount and ('%s\n|cff757575%s|r'):format(name, ITEM_MISSING:format(missingAmount))
		end
		displayText = displayText or name
		-- For the tooltip
		self.Name:SetText(displayText)
		self.itemTexture = texture
		SetItemButtonCount(self, amount)
	--	SetItemButtonQuality(self, quality, GetQuestItemLink(self.type, self:GetID()))
		SetItemButtonTexture(self, texture)
		if ( isUsable ) then
			SetItemButtonTextureVertexColor(self, 1.0, 1.0, 1.0)
			SetItemButtonNameFrameVertexColor(self, 1.0, 1.0, 1.0)
		else
			SetItemButtonTextureVertexColor(self, 0.9, 0, 0)
			SetItemButtonNameFrameVertexColor(self, 0.9, 0, 0)
		end
		SetPortraitToTexture(self.Icon, texture)
		self:Show()
		return true
	end
end

local function ToggleRewardElement(frame, value, anchor)
	if ( value and tonumber(value) ~= 0 ) then
		frame:SetPoint('TOPLEFT', anchor, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
		frame.ValueText:SetText(value)
		frame:Show()
		return true
	else
		frame:Hide()
	end
end

function Elements:UpdateBoundaries()
	self:AdjustToChildren()
	return self:AdjustToChildren(8, 8)
end

function Elements:Reset()
	for _, frame in pairs(self.Active) do
		frame:Hide()
	end
	wipe(self.Active)
	self:Hide()
	self.Content:Hide()
	self.Progress:Hide()
end

----------------------------------
-- Quest elements display
----------------------------------
function Elements:Display(template, material)
	local template = TEMPLATE[template]
	if not template then
		return 0
	end

	ACTIVE_TEMPLATE = template

	self.chooseItems = template.chooseItems

	self:SetMaterial(material)
	self.Progress:Hide()

	local content = self.Content
	local elementsTable = template.elements
	local height, lastFrame = 0
	for i = 1, #elementsTable, 3 do
		local shownFrame, bottomShownFrame = elementsTable[i](self)
		if ( shownFrame ) then
			shownFrame:SetParent(content)
			height = height + shownFrame:GetHeight() + abs(elementsTable[i+2])
			if ( lastFrame ) then
				shownFrame:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', elementsTable[i+1], elementsTable[i+2])
			else
				shownFrame:SetPoint('TOPLEFT', content, 'TOPLEFT', elementsTable[i+1] , elementsTable[i+2] + 10)
			end
			shownFrame:Show()
			self.Active[#self.Active + 1] = shownFrame
			lastFrame = bottomShownFrame or shownFrame
		end
	end
	return height
end


function Elements:SetMaterial(material)
	local progress = self.Progress
	local content = self.Content
	local rewards = content.RewardsFrame
	-- nil check this
	if ( self.material ~= material ) then
		self.material = material
		local textColor, titleTextColor = GetMaterialTextColors(material)
		local r, g, b 
		if not textColor or not titleTextColor then
			textColor, titleTextColor = TEXT_COLOR, TITLE_COLOR
		end
		-- Headers
		r, g, b = unpack(titleTextColor)
		content.ObjectivesHeader:SetTextColor(r, g, b)
		progress.ReqText:SetTextColor(r, g, b)
		rewards.Header:SetTextColor(r, g, b)
		-- Other text
		r, g, b = unpack(textColor)
		content.ObjectivesText:SetTextColor(r, g, b)
		content.GroupSize:SetTextColor(r, g, b)
		content.RewardText:SetTextColor(r, g, b)
		-- Progress text
		progress.MoneyText:SetTextColor(r, g, b)
		-- Reward frame text
		rewards.ItemChooseText:SetTextColor(r, g, b)
		rewards.ItemReceiveText:SetTextColor(r, g, b)
		rewards.PlayerTitleText:SetTextColor(r, g, b)
		rewards.XPFrame.ReceiveText:SetTextColor(r, g, b)

		local spellHeaderPool = rewards.spellHeaderPool
		spellHeaderPool.textR, spellHeaderPool.textG, spellHeaderPool.textB = r, g, b
	end
end

function Elements:ShowSpecialObjectives()
	-- Show objective spell
	local questID
	local numQuestRewards
	local numQuestChoices
	
	do  -- Get data
		questID = API:GetQuestID()
		numQuestRewards = API:GetNumQuestRewards()
		numQuestChoices = API:GetNumQuestChoices()
	end
	
	local questItem, numItems
	local rewardsCount = 0
	
	local spellID, spellName, spellTexture
	
	-- Setup choosable rewards
	if ( numQuestChoices > 0 ) then
		local index
		local baseIndex = rewardsCount
		for i = 1, numQuestChoices do	
			index = i + baseIndex
			questItem = GetItemButton(self, index)
			questItem.type = 'choice'
			questItem.objectType = 'item'
			questItem.questID = questID
			numItems = 1
			questItem:SetID(i)
			questItem:Show()

			spellName, spellTexture = GetQuestItemInfo(questItem.type, i) or GetQuestLogChoiceInfo(i)
			spellID = select(7, GetSpellInfo(spellName))
		end
	end
	
	local specialFrame = self.Content.SpecialObjectivesFrame
	local spellObjectiveLabel = specialFrame.SpellObjectiveLearnLabel
	local spellObjective = specialFrame.SpellObjectiveFrame

	local lastFrame = nil
	local totalHeight = 0

	if (spellID) then
		spellObjective.Icon:SetTexture(spellTexture)
		spellObjective.Name:SetText(spellName)
		spellObjective.spellID = spellID

		spellObjective:ClearAllPoints()
		if (lastFrame) then
			spellObjectiveLabel:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -4)
			totalHeight = totalHeight + 4
		else
			spellObjectiveLabel:SetPoint('TOPLEFT', 0, 0)
		end

		spellObjective:SetPoint('TOPLEFT', spellObjectiveLabel, 'BOTTOMLEFT', 0, -4)

		spellObjectiveLabel:SetText(LEARN_SPELL_OBJECTIVE)
		spellObjectiveLabel:SetTextColor(0, 0, 0)
		
		SetPortraitToTexture(spellObjective.Icon, spellTexture)

		spellObjectiveLabel:Show()
		spellObjective:Show()
		totalHeight = totalHeight + spellObjective:GetHeight() + spellObjectiveLabel:GetHeight()
		lastFrame = spellObjective
	else
		spellObjective:Hide()
		spellObjectiveLabel:Hide()
	end

	if (lastFrame) then
		specialFrame:SetHeight(totalHeight)
		specialFrame:Show()
		return specialFrame
	else
		return specialFrame:Hide()
	end
end

function Elements:ShowObjectivesHeader() return self.Content.ObjectivesHeader end

function Elements:ShowObjectivesText()
	local questObjectives = GetObjectiveText()
	local objectivesText = self.Content.ObjectivesText
	objectivesText:SetText(questObjectives)
	objectivesText:SetWidth(ACTIVE_TEMPLATE.contentWidth)
	return objectivesText
end

function Elements:ShowGroupSize()
	local groupNum = API:GetSuggestedGroupNum()
	local groupSize = self.Content.GroupSize
	if ( groupNum > 0 ) then
		groupSize:SetText(QUEST_SUGGESTED_GROUP_NUM:format(groupNum))
		groupSize:Show()
		return groupSize
	else
		return groupSize:Hide()
	end
end

----------------------------------
-- Quest reward handling
----------------------------------
function Elements:ShowRewards()
	local elements = self
	local self = self.Content.RewardsFrame -- more convenient this way
	local rewardButtons = self.Buttons
	local 	numQuestRewards, numQuestChoices, numQuestCurrencies,
			questID, money, xp, honor,
			playerTitle,
			numSpellRewards
			
	local numQuestSpellRewards = 0
	local totalHeight = 0
	local GetSpell = GetRewardSpell

	do  -- Get data
		questID = API:GetQuestID()
		numQuestRewards = API:GetNumQuestRewards()
		numQuestChoices = API:GetNumQuestChoices()
		money = API:GetRewardMoney()
		xp = API:GetRewardXP()
		honor = API:GetRewardHonor()
		playerTitle = API:GetRewardTitle()
		numSpellRewards = API:GetNumRewardSpells()
	end

	do -- Spell rewards
		for rewardSpellIndex = 1, numSpellRewards do
			local texture, name, isTradeskillSpell, isSpellLearned = GetSpell(rewardSpellIndex)
			local spellID = select(7, GetSpellInfo(name))
			if spellID then
				local knownSpell = tonumber(spellID) and IsSpellKnown(spellID)
			end

			-- only allow the spell reward if user can learn it
			if IsValidSpellReward(texture, knownSpell) then
				numQuestSpellRewards = numQuestSpellRewards + 1
			end
		end
	end

	local totalRewards = numQuestRewards + numQuestChoices + numQuestSpellRewards

	do -- Check if any rewards are present, break out if none
		if ( totalRewards == 0 and 
			money == 0 and 
			xp == 0 and 
			not playerTitle and 
			numQuestSpellRewards == 0 ) then

			return self:Hide()
		end
	end

	do -- Hide unused rewards
		for i = totalRewards + 1, #rewardButtons do
			local rewardButton = rewardButtons[i]
			rewardButton:ClearAllPoints()
			rewardButton:Hide()
		end
	end

	-- Setup locals 
	local questItem, name, texture, quality, isUsable, numItems
	local rewardsCount = 0
	local lastFrame = self.Header

	local totalHeight = self.Header:GetHeight()
	local buttonHeight = self.Buttons[1]:GetHeight()

	do -- Setup choosable rewards
		self.ItemChooseText:ClearAllPoints()
		self.MoneyIcon:Hide()
		if ( numQuestChoices > 0 ) then
			self.ItemChooseText:Show()
			self.ItemChooseText:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -5)

			local highestValue, moneyItem
			local index
			local baseIndex = rewardsCount
			for i = 1, numQuestChoices do
				index = i + baseIndex
				questItem = GetItemButton(self, index)
				questItem.type = 'choice'
				questItem.objectType = 'item'
				questItem.questID = questID
				numItems = 1
				questItem:SetID(i)
				questItem:Show()

				UpdateItemInfo(questItem)

				local vendorValue
				if (questItem.objectType == 'item') then
					local link = GetQuestItemLink(questItem.type, i)
					vendorValue = link and select(11, GetItemInfo(link))
				end
				
				if vendorValue and ( not highestValue or vendorValue > highestValue ) then
					highestValue = vendorValue
					if vendorValue > 0 and numQuestChoices > 1 then
						moneyItem = questItem
					end
				end

				if ( i > 1 ) then
					if ( mod(i, ITEMS_PER_ROW) == 1 ) then
						questItem:SetPoint('TOPLEFT', rewardButtons[index - 2], 'BOTTOMLEFT', 0, -2)
						lastFrame = questItem
						totalHeight = totalHeight + buttonHeight + 2
					else
						questItem:SetPoint('TOPLEFT', rewardButtons[index - 1], 'TOPRIGHT', 1, 0)
					end
				else
					questItem:SetPoint('TOPLEFT', self.ItemChooseText, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
					lastFrame = questItem
					totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
				end
				rewardsCount = rewardsCount + 1
			end

			if moneyItem then
				self.MoneyIcon:SetPoint('BOTTOMRIGHT', moneyItem, -13, 6)
				self.MoneyIcon:Show()
			end

			if ( numQuestChoices == 1 ) then
				elements.chooseItems = nil
				self.ItemChooseText:SetText(REWARD_ITEMS_ONLY)
			elseif ( elements.chooseItems ) then
				self.ItemChooseText:SetText(REWARD_CHOOSE)
			else
				self.ItemChooseText:SetText(REWARD_CHOICES)
			end
			totalHeight = totalHeight + self.ItemChooseText:GetHeight() + REWARDS_OFFSET
		else
			elements.chooseItems = nil
			self.ItemChooseText:Hide()
		end
	end

	do -- Wipe reward pools
		self.spellRewardPool:ReleaseAll()
		self.spellHeaderPool:ReleaseAll()
	end

	do -- Setup spell rewards
		if ( numQuestSpellRewards > 0 ) then
			local spellBuckets = {}

			-- Generate spell buckets
			for rewardSpellIndex = 1, numSpellRewards do
				local texture, name, isTradeskillSpell, isSpellLearned = GetSpell(rewardSpellIndex)
				local spellID = select(7, GetSpellInfo(name))
				if spellID then
					local knownSpell = IsSpellKnown(spellID)
				end
				if IsValidSpellReward(texture, knownSpell, isBoostSpell, garrFollowerID) then
					local bucket = 	isTradeskillSpell 	and QUEST_SPELL_REWARD_TYPE_TRADESKILL_SPELL or
									isBoostSpell 		and QUEST_SPELL_REWARD_TYPE_ABILITY or
									garrFollowerID 		and QUEST_SPELL_REWARD_TYPE_FOLLOWER or
									isSpellLearned 		and QUEST_SPELL_REWARD_TYPE_SPELL or
									genericUnlock 		and QUEST_SPELL_REWARD_TYPE_UNLOCK or QUEST_SPELL_REWARD_TYPE_AURA
					
					AddSpellToBucket(spellBuckets, bucket, rewardSpellIndex)
				end
			end

			-- Sort buckets in the correct order
			for orderIndex, spellBucketType in ipairs(QUEST_INFO_SPELL_REWARD_ORDERING) do
				local spellBucket = spellBuckets[spellBucketType]
				if spellBucket then
					for i, rewardSpellIndex in ipairs(spellBucket) do
						local texture, name, isTradeskillSpell, isSpellLearned, _, isBoostSpell, garrFollowerID = GetSpell(rewardSpellIndex)
						if i == 1 then
							local header = self.spellHeaderPool:Acquire()
							header:SetText(QUEST_INFO_SPELL_REWARD_TO_HEADER[spellBucketType])
							header:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
							if self.spellHeaderPool.textR and self.spellHeaderPool.textG and self.spellHeaderPool.textB then
								header:SetVertexColor(self.spellHeaderPool.textR, self.spellHeaderPool.textG, self.spellHeaderPool.textB)
							end
							header:Show()

							totalHeight = totalHeight + header:GetHeight() + REWARDS_OFFSET
							lastFrame = header
						end

						local anchorFrame
						local spellRewardFrame = self.spellRewardPool:Acquire()
						spellRewardFrame.Icon:SetTexture(texture)
						spellRewardFrame.Name:SetText(name)
						spellRewardFrame.rewardSpellIndex = rewardSpellIndex
						spellRewardFrame:Show()

						SetPortraitToTexture(spellRewardFrame.Icon, texture)
						
						anchorFrame = spellRewardFrame
						if i % 2 ==  1 then
							anchorFrame:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
							totalHeight = totalHeight + anchorFrame:GetHeight() + REWARDS_OFFSET

							lastFrame = anchorFrame
						else
							anchorFrame:SetPoint('LEFT', lastFrame, 'RIGHT', 1, 0)
						end
					end
				end
			end
		end
	end

	do -- Title reward
		if ( playerTitle ) then
			self.PlayerTitleText:Show()
			self.PlayerTitleText:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			totalHeight = totalHeight +  self.PlayerTitleText:GetHeight() + REWARDS_OFFSET
			self.TitleFrame:SetPoint('TOPLEFT', self.PlayerTitleText, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			self.TitleFrame.Name:SetText(playerTitle)
			self.TitleFrame:Show()
			lastFrame = self.TitleFrame
			totalHeight = totalHeight +  self.TitleFrame:GetHeight() + REWARDS_OFFSET
		else
			self.PlayerTitleText:Hide()
			self.TitleFrame:Hide()
		end
	end

	do -- Setup mandatory rewards
		if ( numQuestRewards > 0 or money > 0 or xp > 0 ) then
			-- receive text, will either say 'You will receive' or 'You will also receive'
			local questItemReceiveText = self.ItemReceiveText
			if ( numQuestChoices > 0 or numQuestSpellRewards > 0 or playerTitle ) then
				questItemReceiveText:SetText(REWARD_ITEMS)
			else
				questItemReceiveText:SetText(REWARD_ITEMS_ONLY)
			end
			questItemReceiveText:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
			questItemReceiveText:Show()
			totalHeight = totalHeight + questItemReceiveText:GetHeight() + REWARDS_OFFSET
			lastFrame = questItemReceiveText

			do -- Money rewards
				if ( money > 0 ) then
					MoneyFrame_Update(self.MoneyFrame, money)
					self.MoneyFrame:Show()
				else
					self.MoneyFrame:Hide()
				end
			end

			do -- XP rewards
				if ( ToggleRewardElement(self.XPFrame, xp, lastFrame) ) then
					lastFrame = self.XPFrame
					totalHeight = totalHeight + self.XPFrame:GetHeight() + REWARDS_OFFSET
				else
					self.Header:SetWidth(200)
				end
			end

			local index
			local baseIndex = rewardsCount
			local buttonIndex = 0

			do -- Item rewards
				for i = 1, numQuestRewards, 1 do
					buttonIndex = buttonIndex + 1
					index = i + baseIndex
					questItem = GetItemButton(self, index)
					questItem.type = 'reward'
					questItem.objectType = 'item'
					questItem.questID = questID
					questItem:SetID(i)
					questItem:Show()

					UpdateItemInfo(questItem)

					if ( buttonIndex > 1 ) then
						if ( mod(buttonIndex, ITEMS_PER_ROW) == 1 ) then
							questItem:SetPoint('TOPLEFT', rewardButtons[index - 2], 'BOTTOMLEFT', 0, -2)
							lastFrame = questItem
							totalHeight = totalHeight + buttonHeight + 2
						else
							questItem:SetPoint('TOPLEFT', rewardButtons[index - 1], 'TOPRIGHT', 1, 0)
						end
					else
						questItem:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
						lastFrame = questItem
						totalHeight = totalHeight + buttonHeight + REWARDS_OFFSET
					end
					rewardsCount = rewardsCount + 1
				end
			end

			do -- Honor reward 
				self.HonorFrame:ClearAllPoints()
				if ( honor > 0 ) then
					local faction = UnitFactionGroup('player')
					local icon = faction and ('Interface\\Icons\\PVPCurrency-Honor-%s'):format(faction)

					self.HonorFrame:SetPoint('TOPLEFT', lastFrame, 'BOTTOMLEFT', 0, -REWARDS_OFFSET)
					self.HonorFrame.Count:SetText(L.BreakUpLargeNumbers(honor))
					self.HonorFrame.Name:SetText(HONOR)
					self.HonorFrame.Icon:SetTexture(icon)
					self.HonorFrame:Show()
					
					SetPortraitToTexture(self.HonorFrame.Icon, icon);

					lastFrame = self.HonorFrame
					totalHeight = totalHeight + self.HonorFrame:GetHeight() + REWARDS_OFFSET
				else
					self.HonorFrame:Hide()
				end
			end

		else -- Hide all sub-frames
			self.ItemReceiveText:Hide()
			self.MoneyFrame:Hide()
			self.XPFrame:Hide()
			self.HonorFrame:Hide()
		end
	end

	-- deselect item
	elements.itemChoice = 0
	if ( self.ItemHighlight ) then
		self.ItemHighlight:Hide()
	end

	self:Show()
	self:SetHeight(totalHeight)
	return self, lastFrame
end

function Elements:CompleteQuest()
	local numQuestChoices = GetNumQuestChoices()
	self.itemChoice = (numQuestChoices == 1 and 1) or self.itemChoice

	if ( self.itemChoice == 0 and numQuestChoices > 0 ) then
		QuestChooseRewardError()
	else
		GetQuestReward(self.itemChoice)
	end
end


function Elements:AcceptQuest()
	if ( API:QuestFlagsPVP() ) then
		StaticPopup_Show('CONFIRM_ACCEPT_PVP_QUEST')
	else
		if ( API:QuestGetAutoAccept() ) then
			ImmersionFrame:ForceClose()
		else
			AcceptQuest()
		end
	end
	PlaySound(EnumConst.SOUNDKIT.IG_QUEST_LIST_OPEN)
end

function Elements:ShowProgress(material)
	self:Show()
	self.Content:Hide()
	self:SetMaterial(material)
	local self = self.Progress
	local numRequiredItems = API:GetNumQuestItems()
	local numRequiredMoney = API:GetQuestMoneyToGet()
	local buttonIndex, buttons = 1, self.Buttons
	
	if ( numRequiredItems > 0 or numRequiredMoney > 0 ) then
		self:Show()
		self.ReqText:Show()

		-- If there's money required then anchor and display it
		if ( numRequiredMoney > 0 ) then
			MoneyFrame_Update(self.MoneyFrame, numRequiredMoney)
			
			local moneyColor, moneyVertex
			if ( numRequiredMoney > GetMoney() ) then
				moneyColor, moneyVertex = 'red', 0.2
			else
				moneyColor, moneyVertex = 'white', 0.75
			end

			self.MoneyText:SetTextColor(moneyVertex, moneyVertex, moneyVertex)
			SetMoneyFrameColor(self.MoneyFrame, moneyColor)

			self.MoneyText:Show()
			self.MoneyFrame:Show()

			-- Reanchor required item
			buttons[1]:SetPoint('TOPLEFT', self.MoneyText, 'BOTTOMLEFT', 0, -10)
		else
			self.MoneyText:Hide()
			self.MoneyFrame:Hide()
			-- Reanchor required item
			buttons[1]:SetPoint('TOPLEFT', self.ReqText, 'BOTTOMLEFT', -3, -5)
		end

		for i=1, numRequiredItems do	
			local hidden = 0
			if ( hidden == 0 ) then
				local requiredItem = GetItemButton(self, buttonIndex, 'ProgressItem')
				requiredItem.type = 'required'
				requiredItem.objectType = 'item'
				requiredItem.questID = questID
				requiredItem:SetID(i)
				requiredItem:Show()
				
				UpdateItemInfo(requiredItem, true)

				if ( buttonIndex > 1 ) then
					if ( mod(buttonIndex, ITEMS_PER_ROW) == 1 ) then
						requiredItem:SetPoint('TOPLEFT', buttons[buttonIndex - 2], 'BOTTOMLEFT', 0, -2)
					else
						requiredItem:SetPoint('TOPLEFT', buttons[buttonIndex - 1], 'TOPRIGHT', 1, 0)
					end
				end

				buttonIndex = buttonIndex + 1
			end
		end
	else
		self:Hide()
		self.MoneyText:Hide()
		self.MoneyFrame:Hide()
		self.ReqText:Hide()
	end

	for i=buttonIndex, #buttons do
		buttons[i]:Hide()
	end
	return self:IsShown()
end
----------------------------------
-- Quest templates
----------------------------------
TEMPLATE.QUEST_DETAIL = { chooseItems = nil, contentWidth = 507,
	canHaveSealMaterial = true, sealXOffset = 400, sealYOffset = -6,
	elements = {
		Elements.ShowObjectivesHeader, 0, -15,
		Elements.ShowObjectivesText, 0, -5,
		Elements.ShowSpecialObjectives, 0, -10,
		Elements.ShowGroupSize, 0, -10,
		Elements.ShowRewards, 0, -15,
	}
}

TEMPLATE.QUEST_REWARD = { chooseItems = true, contentWidth = 507,
	canHaveSealMaterial = nil, sealXOffset = 300, sealYOffset = -6,
	elements = {
		Elements.ShowRewards, 0, -10,
	}
}