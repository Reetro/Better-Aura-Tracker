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

--------------------------------------
-- Config functions
--------------------------------------
function Config:Toggle()
	local menu = UIConfig or Config:CreateMenu();
	menu:SetShown(not menu:IsShown());
end

function Config:GetThemeColor()
	local c = defaults.theme;
	return c.r, c.g, c.b, c.hex;
end

function Config:CreateButton(point, relativeFrame, relativePoint, yOffset, text)
	local btn = CreateFrame("Button", nil, UIConfig, "GameMenuButtonTemplate");
	btn:SetPoint(point, relativeFrame, relativePoint, 0, yOffset);
	btn:SetSize(140, 40);
	btn:SetText(text);
	btn:SetNormalFontObject("GameFontNormalLarge");
	btn:SetHighlightFontObject("GameFontHighlightLarge");
	return btn;
end

function Config:CreateSlider(point, relativeFrame, relativePoint, yOffset, startingValue, valueStep)
	local s = CreateFrame("SLIDER", nil, UIConfig, "OptionsSliderTemplate");
	s:SetPoint(point,relativeFrame,relativePoint,0,yOffset)
	s:SetMinMaxValues(1, 100);
	s:SetValue(startingValue)
	s:SetValueStep(valueStep)
	s:SetObeyStepOnDrag(true);
	return s; 
end

function Config:CreateCheckBox(point, relativeFrame, relativePoint, xoffset, yOffset, text, checked)
	local c = CreateFrame("CheckButton", nil, UIConfig, "UICheckButtonTemplate");
	c:SetPoint(point, relativeFrame, relativePoint, xoffset, yOffset)
	c.text:SetText(text)
	c:SetChecked(checked);
	return c; 
end

function Config:CreateMenu()
	UIConfig = CreateFrame("Frame", "BetterAuraTrackerConfig", UIParent, "BasicFrameTemplateWithInset");
	UIConfig:SetSize(260, 360);
	UIConfig:SetPoint("CENTER"); -- Doesn't need to be ("CENTER", UIParent, "CENTER")

	UIConfig.title = UIConfig:CreateFontString(nil, "OVERLAY", "GameFontHighlight");
	UIConfig.title:SetPoint("LEFT", UIConfig.TitleBg, "LEFT", 5, 0);
	UIConfig.title:SetText("Better Aura Tracker Options");

	----------------------------------
	-- Buttons
	----------------------------------
	-- Save Button:
	UIConfig.saveBtn = self:CreateButton("CENTER", UIConfig, "TOP", -70, "Save");

	-- Reset Button:	
	UIConfig.resetBtn = self:CreateButton("TOP", UIConfig.saveBtn, "BOTTOM", -10, "Reset");

	-- Load Button:	
	UIConfig.loadBtn = self:CreateButton("TOP", UIConfig.resetBtn, "BOTTOM", -10, "Load");

	----------------------------------
	-- Sliders
	----------------------------------
	
	-- Slider 1:
	UIConfig.slider1 = self:CreateSlider("TOP", UIConfig.loadBtn, "BOTTOM",-20, 50,30)
	-- Slider 2:
	UIConfig.slider2 = self:CreateSlider("TOP", UIConfig.slider1, "BOTTOM", -20, 40, 30)
	----------------------------------
	-- Check Buttons
	----------------------------------
	-- Check Button 1:
	UIConfig.checkBtn1 = self:CreateCheckBox("TOPLEFT", UIConfig.slider1, "BOTTOMLEFT", -10, -40, "PH", false)

	-- Check Button 2:
	UIConfig.checkBtn2 = self:CreateCheckBox("TOPLEFT", UIConfig.checkBtn1, "BOTTOMLEFT", 0, -10, "PH", true)
	
	UIConfig:Hide();
	return UIConfig;
end