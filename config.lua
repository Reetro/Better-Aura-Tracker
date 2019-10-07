--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

--------------------------------------
-- Defaults 
--------------------------------------
local defaults = {
	theme = {
		r = 0, 
		g = 0.8, -- 204/255
		b = 1,
		hex = "00ccff"
	}
}

local A, L = ...

--------------------------------------
-- Config functions
--------------------------------------

function Config:GetThemeColor()
	local c = defaults.theme;
	return c.r, c.g, c.b, c.hex;
end

function AddText(frame, point, xoff,yoff,text,size)
	local t = frame.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE, MONOCHROME")
end

function AddSubText(frame, point, xoff,yoff,text,size)
	local t = frame.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\FRIZQT__.TTF", size, "OUTLINE, MONOCHROME")
end

function CreateButton(point, relativeFrame, relativePoint, xoffset, yOffset, width, height, text)
	local btn = CreateFrame("Button", nil, relativeFrame, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, xoffset, yOffset);
	btn:SetSize(width, height);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	return btn;
end


function Config:CreateMenu()
	-- Register in the Interface Addon Options GUI	
	BetterAuraTrackerPanel = {};
	BetterAuraTrackerPanel.panel = CreateFrame( "Frame", "BetterAuraTrackerPanel", UIParent );
	-- Title Text
	local title = AddText(BetterAuraTrackerPanel, "TOPLEFT", 16, -16, "BetterAuraTracker Options", 30)
	-- Unlock Button 
	local Unlock = CreateButton("TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -60, 140, 50, "Unlock")
	-- Reset Button 
	-- Unlock Button 
	local Unlock = CreateButton("TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -60, 140, 50, "Unlock")
	


	-- Set the name for the Category for the Options Panel
	BetterAuraTrackerPanel.panel.name = "BetterAuraTracker";

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.panel);
end