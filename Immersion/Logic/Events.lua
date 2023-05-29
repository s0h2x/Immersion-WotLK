local _, L = ...
local Events, API = L.frame, ImmersionAPI
----------------------------------
-- Events
----------------------------------
function Events:GOSSIP_SHOW(customGossipHandler)
	self:HandleGossipOpenEvent(customGossipHandler)
end

function Events:GOSSIP_CLOSED(...)
	API:CloseGossip(...)
	self:PlayOutro()
	L.ClickedTitleCache = nil
end

function Events:QUEST_GREETING(...)
	self:PlayIntro('QUEST_GREETING')
	self:UpdateTalkingHead(API:GetUnitName('questnpc') or API:GetUnitName('npc'), API:GetGreetingText(), 'AvailableQuest')
end

function Events:QUEST_PROGRESS(...) -- special case, doesn't use QuestInfo
	self.IsAvailableQuestID = GetTitleText()
	self:PlayIntro('QUEST_PROGRESS')
	self:UpdateTalkingHead(API:GetTitleText(), API:GetProgressText(), API:IsQuestCompletable() and 'ActiveQuest' or 'IncompleteQuest')
	local elements = self.TalkBox.Elements
	local hasItems = elements:ShowProgress('Stone')
	elements:UpdateBoundaries()
	if hasItems then
		local width, height = elements.Progress:GetSize()
		-- Extra: 32 padding + 8 offset from talkbox + 8 px bottom offset
		self.TalkBox:SetExtraOffset((height + 48) * L('elementscale')) 
		return
	end
	self:ResetElements()
end

function Events:QUEST_COMPLETE(...)
	self.IsAvailableQuestID = GetTitleText()
	self:PlayIntro('QUEST_COMPLETE')
	self:UpdateTalkingHead(API:GetTitleText(), API:GetRewardText(), 'ActiveQuest')
	self:AddQuestInfo('QUEST_REWARD')
end

function Events:QUEST_FINISHED(...)
	API:CloseQuest()
	self:PlayOutro()
--	if self:IsGossipAvailable(true) then
--		self:OnEvent('GOSSIP_SHOW')
--		self.TitleButtons:OnEvent('GOSSIP_SHOW')
--	end
	if L('hideui') and L('camerarotationenabled') then 
		MoveViewRightStop()
	end
end

function Events:QUEST_DETAIL(...)
	if self:IsQuestAutoAccepted(...) then
		self:PlayOutro()
		return
	end
	self.IsAvailableQuestID = GetTitleText()
	self.IsAvailableQuestObjective = GetObjectiveText()
	self:PlayIntro('QUEST_DETAIL')
	self:UpdateTalkingHead(API:GetTitleText(), API:GetQuestText(), 'AvailableQuest')
	self:AddQuestInfo('QUEST_DETAIL')
end


function Events:QUEST_ITEM_UPDATE()
	local questEvent = (self.lastEvent ~= 'QUEST_ITEM_UPDATE') and self.lastEvent or self.questEvent
	self.questEvent = questEvent

	if questEvent and self[questEvent] then
		self[questEvent](self)
		return questEvent
	end
end

function Events:ITEM_TEXT_BEGIN()
	local title = ItemTextGetItem()
	local creator = ItemTextGetCreator()
	if creator then
		title = title .. ' (' .. FROM .. ' ' .. creator .. ')'
	end
	self:PlayIntro('ITEM_TEXT_BEGIN')
	self:UpdateTalkingHead(title, '', 'TrainerGossip', 'BookReading')
end

function Events:ITEM_TEXT_READY()
	-- special case: pages need to be concatened together before displaying them.
	-- each new page re-triggers this event, so keep changing page until we run out.
	self.itemText = (self.itemText or '') .. '\n' .. (ItemTextGetText() or ''):gsub('%b<>', '')
	if ItemTextHasNextPage() then
		ItemTextNextPage()
		return
	end
	-- set text directly instead of updating talking head
	self.TalkBox.TextFrame.Text:SetText(self.itemText)
end


function Events:ITEM_TEXT_CLOSED()
	local time = GetTime()
	self.lastTextClosed = time
	self.itemText = nil
	self:PlayOutro()
end