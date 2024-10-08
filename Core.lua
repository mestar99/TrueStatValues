local name,addon = ...;
local tcr = LibStub("AceAddon-3.0"):NewAddon("TrueCombatRatings", "AceConsole-3.0", "AceEvent-3.0")



--[[----------------------------------------------------------------------------
Defaults
------------------------------------------------------------------------------]]
local function Color(r,g,b,a)
	local t = {};
	t.r = r;
	t.g = g;
	t.b = b;
	t.a = a or 1;
	return t;
end

local defaults = {
	global = {
		showStatTooltips=true,
		showItemTooltips=true,
		fontColor=Color(68/255,173/255,255/255,1),
    }
}

local num_pattern = "%.2f";


--[[----------------------------------------------------------------------------
Options
------------------------------------------------------------------------------]]
local _TEST=nil;
local options = {
	name = "True Combat Ratings",
	handler = tcr,
	childGroups = "tab",
	type = "group",
	args = {
		optionsTab = { 
			name = "Options",
			type = "group",
			order = 1,
			args = {
				headerSettings = {
					name = "True Combat Ratings Settings",
					desc = "",
					type = "header",
					order = 1
				},
				showStatTooltips = {
					name = "Stat Tooltips",
					desc = "When checked, displays True Stat Rating information on Secondary-Stat tooltips.",
					type = "toggle",
					order = 3,
					width = "full",
					get = function(info) return tcr.db.global.showStatTooltips end,
					set = function(info,val) tcr.db.global.showStatTooltips = val; end
				},
				showItemTooltips = {
					name = "Item Tooltips",
					desc = "When checked, displays True Stat Rating information on Item tooltips.",
					type = "toggle",
					order = 5,
					width = "full",
					get = function(info) return tcr.db.global.showItemTooltips end,
					set = function(info,val) tcr.db.global.showItemTooltips = val; end
                },
				fontColor = {
					name = "Font Color",
					type = "color",
					order = 7,
					get = function(info) return tcr.db.global.fontColor.r,tcr.db.global.fontColor.g,tcr.db.global.fontColor.b,tcr.db.global.fontColor.a end,
					set = function(info,r,g,b,a) 
						tcr.db.global.fontColor = Color(r,g,b,a); --ignore alpha?
					end
				},
			}
		},
	}
}
local BlizOptionsTable = {
	name = "True Combat Ratings",
	type = "group",
	args = options
}



--[[----------------------------------------------------------------------------
Addon Initialized
------------------------------------------------------------------------------]]
function tcr:OnInitialize()
    self.db = LibStub("AceDB-3.0"):New("TCR_DB", defaults)
	LibStub("AceConfigRegistry-3.0"):RegisterOptionsTable("TCR_Bliz",options);
	self.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("TCR_Bliz", "True Combat Ratings");

	local tooltipEvents = {
        "OnShow"
    };

	C_Timer.After(0.2,function()
		for k,v in ipairs(tooltipEvents) do
			GameTooltip:HookScript(v,function(tooltip,...)
				tcr:OnTooltip(v,tooltip,...)
			end);
		end
	end);
end



local function OnTooltipSetItem(tooltip, data)
    if tooltip == GameTooltip then
		tcr:OnTooltip("OnTooltipSetItem", tooltip)
    end
end

local function OnTooltipSetSpell(tooltip, data)
    if tooltip == GameTooltip then
		tcr:OnTooltip("OnTooltipSetSpell",tooltip)
    end
end

TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Item, OnTooltipSetItem)
TooltipDataProcessor.AddTooltipPostCall(Enum.TooltipDataType.Spell, OnTooltipSetSpell)

addon.SegmentLabels = SegmentLabels;
addon.tcr = tcr;
