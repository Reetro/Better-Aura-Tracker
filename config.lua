--------------------------------------
-- Namespaces
--------------------------------------
local A, L = ...
local _, core = ...;
core.Config = {}; -- adds Config table to addon namespace

local Config = core.Config;
local UIConfig;

--------------------------------------
-- Saved Settings 
--------------------------------------

BetterAuraTrackerSettings = {
	BuffframePostionX = -200,
	BuffframePostionY = -5,
	BuffframeRelativePoint = "TOPRIGHT",
	BuffframePoint = "TOPRIGHT",
	BuffButtonSize = 64,
	BuffButtonScale = 1,
	BuffsPerRow = 10,
	BuffPadding = 1,
	DebuffPostionX = -200,
	DebuffPostionY = -100,
	DebufframeRelativePoint = "TOPRIGHT",
	DebuffframePoint = "TOPRIGHT",
	DebuffButtonSize = 32,
	DebuffButtonScale = 1,
	DebuffsPerRow = 10,
	DebuffPadding = 1,
	ZoomBuffs = false,
	ZoomDebuffs = false,
}

--------------------------------------
-- Config functions
--------------------------------------

StaticPopupDialogs["ReloadUI Box"] = {
	text = "Changing this value requires a reload to apply. Do you wish to reload now?",
	button1 = "Yes",
	button2 = "No",
	OnAccept = function()
		ReloadUI();
	end,
	timeout = 0,
	whileDead = true,
	hideOnEscape = true,
	preferredIndex = 3, 
  }

function Config:GetBuffButtonSize()
	return BetterAuraTrackerSettings.BuffButtonSize
end 

function Config:GetBuffFrameScale()
	return BetterAuraTrackerSettings.BuffButtonScale
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

function CreateSlider(name, title, point, relativeFrame, relativePoint, xoffset, yOffset, min, max, valuestep, start)
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

function CreateCheckBox(name, point, relativeFrame, relativePoint, xoff, yoff, state, title, tooltip)
	local c = CreateFrame("CheckButton", name, relativeFrame, "ChatConfigCheckButtonTemplate")
	c:SetPoint(relativePoint, xoff, yoff)
	getglobal(c:GetName() .. 'Text'):SetText(title);
	c:SetChecked(state)
	c.tooltip = tooltip
	return c
end

function CreateEditBox()
end

function Config:CreateMenu()
	-- Register in the Interface Addon Options GUI	
	BetterAuraTrackerPanel = {};
	BetterAuraTrackerPanel.panel = CreateFrame( "Frame", "BetterAuraTrackerPanel", UIParent );
	-- Title Text
	BetterAuraTrackerPanel.panel.title = AddText(BetterAuraTrackerPanel, "TOPLEFT", 16, -16, "BetterAuraTracker Options", 30)
	-- Unlock Button 
	BetterAuraTrackerPanel.panel.Unlock = CreateButton("TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -60, 140, 40, "Unlock")
	BetterAuraTrackerPanel.panel.Unlock:SetScript("OnClick", function(self, arg1)
	core.Aura:UnlockFrames()
	end)
	-- Reset Button 
	BetterAuraTrackerPanel.panel.Reset = CreateButton("TOP", BetterAuraTrackerPanel.panel.Unlock, "TOP", 150, 0, 140, 40, "Reset")
	BetterAuraTrackerPanel.panel.Reset:SetScript("OnClick", function(self, arg1)
	core.Aura:ResetFrames()
	core.Aura:LockFrames()
	end)
		
	-- Lock Button
	BetterAuraTrackerPanel.panel.Lock = CreateButton("TOP", BetterAuraTrackerPanel.panel.Reset, "TOP", 150, 0, 140, 40, "Lock")
	BetterAuraTrackerPanel.panel.Lock:SetScript("OnClick", function(self, arg1)
	core.Aura:LockFrames()
	end)
	-- Buff Sub Text 
	BetterAuraTrackerPanel.panel.BuffSub = AddSubText(BetterAuraTrackerPanel, "TOPLEFT", 20, -180, "Buff Options", 18)
	-- Buff Frame Scale Slider
    BetterAuraTrackerPanel.panel.BuffFrameSlider = CreateSlider("BuffScaleSlider", "Buff Scale", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -240, 1, 10, 1, Config:GetBuffFrameScale())
    local BuffSliderFrameText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffSliderFrameText:SetPoint("TOPLEFT", 90, -260)
	BuffSliderFrameText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffSliderFrameText:SetText( BetterAuraTrackerPanel.panel.BuffFrameSlider:GetValue())
	BetterAuraTrackerPanel.panel.BuffFrameSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.BuffButtonScale = value
		BuffSliderFrameText:SetText(value)
		StaticPopup_Show ("ReloadUI Box")
	end)
	-- Buff Button Size Slider 
	BetterAuraTrackerPanel.panel.ButtonSizeSlider = CreateSlider("BuffButtonSizeSlider", "Buff Button Size", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 300, -240, 32, 1024, 32, Config:GetBuffButtonSize())
    local BuffButtonSliderText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffButtonSliderText:SetPoint("TOPLEFT", 370, -260)
	BuffButtonSliderText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffButtonSliderText:SetText( BetterAuraTrackerPanel.panel.ButtonSizeSlider:GetValue())
	BetterAuraTrackerPanel.panel.ButtonSizeSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.BuffButtonSize = value
		BuffButtonSliderText:SetText(value)
		StaticPopup_Show ("ReloadUI Box")
	end)

	BetterAuraTrackerPanel.panel.BuffZoomBox = CreateCheckBox("BuffZoom", "BOTTOMRIGHT", BetterAuraTrackerPanel.panel.BuffFrameSlider, "BOTTOMRIGHT", -120, -80, BetterAuraTrackerSettings.ZoomBuffs, " Zoom", "Toggle Button Zoom haven't implement Masque yet")
	BetterAuraTrackerPanel.panel.BuffZoomBox:SetScript("OnClick", 
	function()
		BetterAuraTrackerSettings.ZoomBuffs = BetterAuraTrackerPanel.panel.BuffZoomBox:GetChecked()
		StaticPopup_Show ("ReloadUI Box")
	end)

	
	-- Set the name for the Category for the Options Panel
	BetterAuraTrackerPanel.panel.name = "BetterAuraTracker";

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.panel);
end