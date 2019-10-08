--------------------------------------
-- Namespaces
--------------------------------------
local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

--------------------------------------
-- Saved Settings 
--------------------------------------
BetterAuraTrackerDB = LibStub("AceAddon-3.0"):NewAddon("BetterAuraTrackerDB")

local defaults = {
	profile = {
		buffButtonSize = 64,
		buffFrameScale = 1
	  }
}

function BetterAuraTrackerDB:OnInitialize()
	self.db = LibStub("AceDB-3.0"):New("BetterAuraTrackerDB", defaults, true)
end
  
function BetterAuraTrackerDB:OnEnable()
if self.db.profile.optionA then
    self.db.profile.playerName = UnitName("player")
  end
end

local A, L = ...


--------------------------------------
-- Config functions
--------------------------------------

function Config:GetBuffButtonSize()
	local b = defaults.profile
	return b.buffButtonSize
end 

function Config:GetBuffFrameScale()
	local b = defaults.profile
	return b.buffFrameScale
end

function AddText(frame, point, xoff,yoff,text,size)
	local t = frame.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\MORPHEUS.ttf", size)
	return t
end

function AddSubText(frame, point, xoff,yoff,text,size)
	local t = frame.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\MORPHEUS.ttf", size)
	return t
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

function CreateSlider(name, title, point, relativeFrame, relativePoint, xoffset, yOffset, min, max, valuestep, start, script)
	local s = CreateFrame("SLIDER", name, relativeFrame, "OptionsSliderTemplate")
	s.text = _G[name.."Text"]
	s.text:SetText(title)
	s.textLow = _G[name.."Low"]
    s.textHigh = _G[name.."High"]
    s.textLow:SetText(floor(min))
	s.textHigh:SetText(floor(max))
	s.textLow:SetTextColor(0.4,0.4,0.4)
    s.textHigh:SetTextColor(0.4,0.4,0.4)
	s:SetPoint(point, relativeFrame, relativePoint, xoffset, yOffset)
	s:SetMinMaxValues(min,max)
	s:SetValue(start)
	s:SetValueStep(valuestep)
	s:SetObeyStepOnDrag(true)	
    return s
end

function Config:CreateMenu()
	-- Register in the Interface Addon Options GUI	
	BetterAuraTrackerPanel = {};
	BetterAuraTrackerPanel.panel = CreateFrame( "Frame", "BetterAuraTrackerPanel", UIParent );
	-- Title Text
	BetterAuraTrackerPanel.panel.title = AddText(BetterAuraTrackerPanel, "TOPLEFT", 16, -16, "BetterAuraTracker Options", 30)
	-- Unlock Button 
	BetterAuraTrackerPanel.panel.Unlock = CreateButton("TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -60, 140, 40, "Unlock")
	-- Reset Button 
	BetterAuraTrackerPanel.panel.Reset = CreateButton("TOP", BetterAuraTrackerPanel.panel.Unlock, "TOP", 150, 0, 140, 40, "Reset")
	-- Lock Button
	BetterAuraTrackerPanel.panel.Lock = CreateButton("TOP", BetterAuraTrackerPanel.panel.Reset, "TOP", 150, 0, 140, 40, "Lock")
	-- Buff Sub Text 
	BetterAuraTrackerPanel.panel.BuffSub = AddSubText(BetterAuraTrackerPanel, "TOPLEFT", 20, -180, "Buff Options", 18)
	-- Buff Frame Scale Slider
    BetterAuraTrackerPanel.panel.BuffFrameSlider = CreateSlider("BuffScaleSlider", "Buff Scale", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -240, 1, 10, 1, 1)
    local BuffSliderFrameText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffSliderFrameText:SetPoint("TOPLEFT", 90, -260)
	BuffSliderFrameText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffSliderFrameText:SetText( BetterAuraTrackerPanel.panel.BuffFrameSlider:GetValue())
	BetterAuraTrackerPanel.panel.BuffFrameSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BuffSliderFrameText:SetText(value)
		defaults.profile.buffFrameScale = value
		core.Aura.getAura()
	end)
	-- Buff Button Size Slider 
	BetterAuraTrackerPanel.panel.ButtonSizeSlider = CreateSlider("BuffButtonSizeSlider", "Buff Button Size", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 300, -240, 32, 1024, 32, 32)
    local BuffButtonSliderText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffButtonSliderText:SetPoint("TOPLEFT", 370, -260)
	BuffButtonSliderText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffButtonSliderText:SetText( BetterAuraTrackerPanel.panel.ButtonSizeSlider:GetValue())
	BetterAuraTrackerPanel.panel.ButtonSizeSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BuffButtonSliderText:SetText(value)
		defaults.profile.buffButtonSize = value
		core.Aura.getAura()
	end)
	
	-- Set the name for the Category for the Options Panel
	BetterAuraTrackerPanel.panel.name = "BetterAuraTracker";

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.panel);
end