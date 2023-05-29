local _, L = ...
local PT = 'Interface\\AddOns\\' .. _ .. "\\Textures\\"

--[[ @type: type of frame   ]]
--[[ @name: name of frame   ]]
--[[ @index: (optional) id  ]]
--[[ @parent: parent frame  ]]
--[[ @inherit: add template ]]
--[[ @mixins: mixins to add ]]
--[[ @backdrop: bg info tbl ]]
function L.Create(cfg)
	local frame = CreateFrame(cfg.type, _ .. cfg.name .. (cfg.index or ''), cfg.parent, cfg.inherit)
	if cfg.backdrop then
		L.SetBackdrop(frame, cfg.backdrop)
	end
	if cfg.mixins then
		L.Mixin(frame, unpack(cfg.mixins))
	end
	return frame
end

function L.SetBackdrop(frame, backdrop)
	if BackdropTemplateMixin and not frame.OnBackdropLoaded then
		Mixin(frame, BackdropTemplateMixin)
		frame:HookScript('OnSizeChanged', frame.OnBackdropSizeChanged)
	end
	frame:SetBackdrop(backdrop)
	return frame
end

function L.MixinNormal(object, ...)
	for i = 1, select("#", ...) do
		local mixin = select(i, ...)
		for k, v in pairs(mixin) do
			object[k] = v
		end
	end

	return object
end

function L.Mixin(object, ...)
	object = L.MixinNormal(object, ...)
	if object.HasScript then
		for k, v in pairs(object) do
			if object:HasScript(k) then
				if object:GetScript(k) then
					object:HookScript(k, v)
				else
					object:SetScript(k, v)
				end
			end
		end
	end
	return object
end

function L.CreateFromMixins(...)
	return L.MixinNormal({}, ...)
end

L.UIHider = CreateFrame('Frame', _ .. 'UIHider')
L.UIHider:Hide()
function L.HideFrame(frame)
	frame:UnregisterAllEvents()
	frame:SetParent(L.UIHider)
	if UIPanelWindows then
		UIPanelWindows[frame:GetName()] = nil;
	end
end

--[[
function L.SetGradient(texture, orientation, ...)
	local isOldFormat = (select('#', ...) == 8)
	if texture.SetGradientAlpha then
		if isOldFormat then 
			return texture:SetGradientAlpha(orientation, ...)
		end
		local min, max = ...;
		local minR, minG, minB, minA = ColorMixinPool.GetRGBA(min)
		local maxR, maxG, maxB, maxA = ColorMixinPool.GetRGBA(max)
		return texture:SetGradientAlpha(orientation, minR, minG, minB, minA, maxR, maxG, maxB, maxA)
	end
	if texture.SetGradient then
		if isOldFormat then
			local minColor = CreateColor(...)
			local maxColor = CreateColor(select(5, ...))
			return texture:SetGradient(orientation, minColor, maxColor)
		end
		local min, max = ...;
		return texture:SetGradient(orientation, min, max)
	end
end

function L.SetLight(model, enabled, lightValues)
	if ImmersionAPI.IsWoW10 then
		return model:SetLight(enabled, lightValues)
	end

	local dirX, dirY, dirZ = lightValues.point:GetXYZ()
	local ambR, ambG, ambB = lightValues.ambientColor:GetRGB()
	local difR, difG, difB = lightValues.diffuseColor:GetRGB()

	return model:SetLight(enabled,
		lightValues.omnidirectional,
		dirX, dirY, dirZ,
		lightValues.diffuseIntensity,
		difR, difG, difB,
		lightValues.ambientIntensity,
		ambR, ambG, ambB
	)
end

ImmersionAPI.SetGradient = L.SetGradient; -- for XML
]]

function L.BreakUpLargeNumbers(value)
	local retString = "";
	if ( value < 1000 ) then
		if ( (value - math.floor(value)) == 0) then
			return value;
		end
		local decimal = (math.floor(value*100));
		retString = string.sub(decimal, 1, -3);
		retString = retString..DECIMAL_SEPERATOR;
		retString = retString..string.sub(decimal, -2);
		return retString;
	end
 
	value = math.floor(value);
	local strLen = strlen(value);
	if ( GetCVarBool("breakUpLargeNumbers") ) then
		if ( strLen > 6 ) then
			retString = string.sub(value, 1, -7)..LARGE_NUMBER_SEPERATOR;
		end
		if ( strLen > 3 ) then
			retString = retString..string.sub(value, -6, -4)..LARGE_NUMBER_SEPERATOR;
		end
		retString = retString..string.sub(value, -3, -1);
	else
		retString = value;
	end
	return retString;
end

function UtilMixin:GetCurrentModelSet()
	return L('hdmodels') and 'HD' or 'Original'
end

-- AtlasInfo = {
	-- ["QuestBG-Default"]={PT.."TalkingHeads", 570, 155, 0.000976562, 0.557617, 0.000976562, 0.152344},
	-- ["QuestBG-Alliance"]={PT.."TalkingHeads", 570, 155, 0.000976562, 0.557617, 158/1024, 313/1024},
	-- ["QuestBG-Horde"]={PT.."TalkingHeads", 570, 155, 0.000976562, 0.557617, 315/1024, 470/1024},
	-- ["QuestBG-Neutral"]={PT.."TalkingHeads", 570, 155, 0.000976562, 0.557617, 472/1024, 627/1024},
	-- ["QuestBG-Custom1"]={PT.."TalkingHeads", 570, 155, 0.000976562, 0.557617, 629/1024, 784/1024},
	-- ["QuestBG-Custom2"]={PT.."TalkingHeads", 570, 155, 0.000976562, 0.557617, 786/1024, 941/1024},
-- }

RAID_CLASS_COLORS.HUNTER.colorStr = "ffabd473"
RAID_CLASS_COLORS.WARLOCK.colorStr = "ff8788ee"
RAID_CLASS_COLORS.PRIEST.colorStr = "ffffffff"
RAID_CLASS_COLORS.PALADIN.colorStr = "fff58cba"
RAID_CLASS_COLORS.MAGE.colorStr = "ff3fc7eb"
RAID_CLASS_COLORS.ROGUE.colorStr = "fffff569"
RAID_CLASS_COLORS.DRUID.colorStr = "ffff7d0a"
RAID_CLASS_COLORS.SHAMAN.colorStr = "ff0070de"
RAID_CLASS_COLORS.WARRIOR.colorStr = "ffc79c6e"
RAID_CLASS_COLORS.DEATHKNIGHT.colorStr = "ffc41f3b"

function L.GetClassColor(classFilename)
	local color = RAID_CLASS_COLORS[classFilename];
	if color then
		return color.r, color.g, color.b, color.colorStr;
	end
	return 1, 1, 1, "ffffffff";
end

function L.DebugInfo(...)
    if L('debuginfo') then
        print('[debug]: ' .. '|cffff7d0a' .. tostring(table.concat({...}, ' ')))
    end
end

----------------------------------
-- Local backdrops
----------------------------------
L.Backdrops = {
	GOSSIP_TITLE_BG = {
		bgFile   = PT..'Backdrop_Gossip.tga',
		edgeFile = PT..'Edge_Gossip_BG.blp',
		edgeSize = 8,
		insets   = { left = 2, right = 2, top = 8, bottom = 8 }
	},
	GOSSIP_HILITE = {
		edgeFile = PT..'Edge_Gossip_Hilite.blp',
		edgeSize = 8,
		insets   = { left = 5, right = 5, top = 5, bottom = 6 }
	},
	GOSSIP_NORMAL = {
		edgeFile = PT..'Edge_Gossip_Normal.blp',
		edgeSize = 8,
		insets   = { left= 5, right = 5, top = -10, bottom = 7 }
	},
	TALKBOX = {
		bgFile   = PT..'Backdrop_Talkbox.blp',
		edgeFile = PT..'Edge_Talkbox_BG.blp',
		edgeSize = 16,
		insets   = { left = 16, right = 16, top = 16, bottom = 16 }
	},
	TALKBOX_HILITE = {
		edgeFile = PT..'Edge_Gossip_Hilite.blp',
		edgeSize = 8,
	},
	TALKBOX_SOLID = {
		bgFile   = PT..'Backdrop_Talkbox_Solid.blp',
		edgeFile = PT..'Edge_Talkbox_BG_Solid.blp',
		edgeSize = 16,
		insets   = { left = 16, right = 16, top = 16, bottom = 16 }
	},
	TOOLTIP_BG = {
		bgFile   = PT..'Backdrop_Talkbox.blp',
		edgeFile = PT..'Edge_Talkbox_BG.blp',
		edgeSize = 8,
		insets   = { left = 8, right = 8, top = 8, bottom = 8 }
	},
}