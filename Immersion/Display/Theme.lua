local _, L = ...
-------------------------------------------
local regions = {
	background 	= ImmersionFrame.TalkBox.BackgroundFrame.TextBackground;
	portrait 	= ImmersionFrame.TalkBox.PortraitFrame.Portrait;
	title 		= ImmersionFrame.TalkBox.NameFrame.Name;
}
-------------------------------------------
local themes = {
	DEFAULT = {
		background 	= 'TalkingHeads-TextBackground';
		portrait 	= 'TalkingHeads-Alliance-PortraitFrame';
		title 		= {1, .82, 0, 1};
	};
	ALLIANCE = {
		background 	= 'TalkingHeads-Alliance-TextBackground';
		portrait 	= 'TalkingHeads-Alliance-PortraitFrame';
		title 		= {0, 0, .25, 1};
	};
	HORDE = {
		background 	= 'TalkingHeads-Horde-TextBackground';
		portrait 	= 'TalkingHeads-Horde-PortraitFrame';
		title 		= {1, .82, 0, 1};
	};
}
-------------------------------------------
local function SetFontColor(font, color)
	if C_Widget.IsWidget(font) then
		font:SetTextColor(unpack(color))
	else
		for i, object in pairs(font) do
			print(i, "test")
			object:SetTextColor(unpack(color))
		end
	end
end

local function SetTheme(theme)
	for id, data in pairs(theme) do
		local region = regions[id]
		if region and region.IsObjectType and region:IsObjectType('texture') then
			region:SetAtlas(data)
		elseif region then
			SetFontColor(region, data)
		end
	end
end

function IMApplyTheme(theme)
	SetTheme(themes[theme] or themes.DEFAULT)
end

--[[
	DEFAULT 	= DEFAULT;
	ALLIANCE 	= ALLIANCE_CHEER;
	HORDE 		= HORDE_CHEER;
	NEUTRAL		= BUG_CATEGORY8;
]]