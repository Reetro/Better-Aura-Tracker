--------------------------------------
-- Namespaces
--------------------------------------
local A, L = ...
local _, core = ...;
core.BetterConfig = {}; -- adds BetterConfig table to addon namespace

local BetterConfig = core.BetterConfig;
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
	BuffPadding = 0,
	BuffFont = "Fonts\\FRIZQT__.TTF",
	BuffFontSize = 11,
	BuffFontOutline = "OUTLINE, MONOCHROME",
	DebuffPostionX = -200,
	DebuffPostionY = -100,
	DebufframeRelativePoint = "TOPRIGHT",
	DebuffframePoint = "TOPRIGHT",
	DebuffButtonSize = 32,
	DebuffButtonScale = 1,
	DebuffsPerRow = 10,
	DebuffPadding = 0,
	DebuffFont = "Fonts\\FRIZQT__.TTF",
	DebuffFontSize = 11,
	DebuffFontOutline = "OUTLINE, MONOCHROME",
}

--------------------------------------
-- BetterConfig functions
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

local SimpleRound = function(val,valStep)
    return floor(val/valStep)*valStep
end

function BetterConfig:GetBuffButtonSize()
	return BetterAuraTrackerSettings.BuffButtonSize
end 

function BetterConfig:GetBuffFrameScale()
	return BetterAuraTrackerSettings.BuffButtonScale
end

function AddText(frame, point, xoff,yoff,text,size)
	local t = frame:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\MORPHEUS.ttf", size)
	return t
end

function AddSubText(frame, point, xoff,yoff,text,size)
	local t = frame:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
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

function CreateEditBox(sizeX , sizeY, name, point, relativePoint, parent, xoff, yoff, useValue)
	local E = CreateFrame("EditBox", name, parent, "InputBoxTemplate")
	E:SetSize(sizeX,sizeY)
    E:ClearAllPoints()
    E:SetPoint(point, parent, relativePoint, xoff, yoff)
	if (useValue)
	then E:SetText(parent:GetValue()) end
	E:SetAutoFocus(false)
	return E
end

local OutLineOptions = {
    { text = "Select an Option", isTitle = true},
    { text = "Option 1", func = function() print("You've chosen option 1"); end },
    { text = "Option 2", func = function() print("You've chosen option 2"); end },
    { text = "More Options", hasArrow = true,
        menuList = {
            { text = "Option 3", func = function() print("You've chosen option 3"); end }
        } 
    }
}

function BetterConfig:CreateMenu()
	-- Register in the Interface Addon Options GUI	
	BetterAuraTrackerPanel = {};
	BetterAuraTrackerPanel.panel = CreateFrame( "Frame", "BetterAuraTrackerPanel", UIParent )
	-- Title Text
	BetterAuraTrackerPanel.panel.title = AddText(BetterAuraTrackerPanel.panel, "TOPLEFT", 16, -16, "BetterAuraTracker Options", 30)
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
	BetterAuraTrackerPanel.panel.BuffSub = AddSubText(BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -120, "Buff Options", 18)
	-- Buff Frame Scale Slider
	BetterAuraTrackerPanel.panel.BuffFrameSlider = CreateSlider("BuffScaleSlider", "Buff Scale", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -180, 1, 10, 1, BetterConfig:GetBuffFrameScale())
	local ScaleEditbox = CreateEditBox(50,30, "ScaleEditBox", "LEFT", "Right", BetterAuraTrackerPanel.panel.BuffFrameSlider, 15,0, true)
    local BuffSliderFrameText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffSliderFrameText:SetPoint("TOPLEFT", 90, -195)
	BuffSliderFrameText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffSliderFrameText:SetText( BetterAuraTrackerPanel.panel.BuffFrameSlider:GetValue())
	BetterAuraTrackerPanel.panel.BuffFrameSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.BuffButtonScale = value
		local step = BetterAuraTrackerPanel.panel.BuffFrameSlider:GetValueStep()
		BuffSliderFrameText:SetText(value)
		ScaleEditbox:SetText(SimpleRound(value,step))
	end)
	ScaleEditbox:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BetterAuraTrackerPanel.panel.BuffFrameSlider:SetValue(val)
		end
	  end)
	ScaleEditbox:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BetterAuraTrackerPanel.panel.BuffFrameSlider:SetValue(val)
		end
	end)
	-- Buff Button Size Slider 
	BetterAuraTrackerPanel.panel.ButtonSizeSlider = CreateSlider("BuffButtonSizeSlider", "Buff Button Size", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 300, -180, 32, 1024, 1, BetterConfig:GetBuffButtonSize())
	local BuffButtonSliderText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	local BuffButtonEditBox = CreateEditBox(50,30, "BuffButtonSizeBox", "LEFT", "RIGHT", BetterAuraTrackerPanel.panel.ButtonSizeSlider, 15,0, true)
	BuffButtonSliderText:SetPoint("TOPLEFT", 370, -195)
	BuffButtonSliderText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffButtonSliderText:SetText( BetterAuraTrackerPanel.panel.ButtonSizeSlider:GetValue())
	BetterAuraTrackerPanel.panel.ButtonSizeSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.BuffButtonSize = value
		BuffButtonSliderText:SetText(value)
		StaticPopup_Show ("ReloadUI Box")
	end)
	BuffButtonEditBox:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BetterAuraTrackerPanel.panel.ButtonSizeSlider:SetValue(val)
		end
	  end)
	  BuffButtonEditBox:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BetterAuraTrackerPanel.panel.ButtonSizeSlider:SetValue(val)
		end
	end)
	-- Buff Button Padding
	local BuffButtonPaddingS = CreateSlider("PaddingSlider", "Buff Padding", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 300, -250, 0, 10, 1, BetterAuraTrackerSettings.BuffPadding)
	local BuffPaddingEditBox = CreateEditBox(50,30, "PaddingEditBox", "LEFT", "RIGHT", BuffButtonPaddingS, 15, 0)
	local BuffPaddingText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffPaddingText:SetPoint("TOPLEFT", 379, -270)
	BuffPaddingText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffPaddingText:SetText(BuffButtonPaddingS:GetValue())
	BuffButtonPaddingS:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.BuffPadding = value
		BuffPaddingText:SetText(value)
		StaticPopup_Show ("ReloadUI Box")
	end)
	BuffPaddingEditBox:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BuffButtonPaddingS:SetValue(val)
		end
	  end)
	  BuffPaddingEditBox:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BuffButtonPaddingS:SetValue(val)
		end
	end)
	-- Buffs per row slider
	local BuffsPerRowS = CreateSlider("BuffsPerRowS", "BuffS Per Row", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -250, 1, 12, 1, BetterAuraTrackerSettings.BuffsPerRow)
	local BuffsPerRowE = CreateEditBox(50,30, "BuffsPerRowE", "LEFT", "RIGHT", BuffsPerRowS, 15, 0, true)
	local BuffsPerRowT = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	BuffsPerRowT:SetPoint("TOPLEFT", 80, -270)
	BuffsPerRowT:SetFont("Fonts\\MORPHEUS.ttf", 15)
	BuffsPerRowT:SetText(BuffsPerRowS:GetValue())
	BuffsPerRowS:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.BuffsPerRow = value
		BuffsPerRowT:SetText(value)
		StaticPopup_Show ("ReloadUI Box")
	end)
	BuffsPerRowE:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BuffsPerRowS:SetValue(val)
		end
	  end)
	  BuffsPerRowE:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			BuffsPerRowS:SetValue(val)
		end
	end)
	-- Debuff Sub Text
	BetterAuraTrackerPanel.panel.DebuffSub = AddSubText(BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -320, "Debuff Options", 18)
	-- Debuff Scale Slider
	local DebuffFrameSlider = CreateSlider("DebuffScaleSlider", "Debuff Scale", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -380, 1, 10, 1, BetterAuraTrackerSettings.DebuffButtonScale)
	local DeScaleEditbox = CreateEditBox(50,30, "ScaleEditBox", "LEFT", "Right", DebuffFrameSlider, 15,0, true)
    local DebuffSliderFrameText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	DebuffSliderFrameText:SetPoint("TOPLEFT", 90, -400)
	DebuffSliderFrameText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	DebuffSliderFrameText:SetText( DebuffFrameSlider:GetValue())
	DebuffFrameSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.DebuffButtonScale = value
		local step = DebuffFrameSlider:GetValueStep()
		DebuffSliderFrameText:SetText(value)
		DeScaleEditbox:SetText(SimpleRound(value,step))
		StaticPopup_Show ("ReloadUI Box")
	end)
	DeScaleEditbox:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffFrameSlider:SetValue(val)
		end
	  end)
	  DeScaleEditbox:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffFrameSlider:SetValue(val)
		end
	end)
	-- Debuff Size Slider
	local DebuffSizeSlider = CreateSlider("DebuffSizeSlider", "Debuff Button Size", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 300, -380, 32, 1024, 1, BetterAuraTrackerSettings.DebuffButtonSize)
	local DeSizeEditbox = CreateEditBox(50,30, "DeSizeEditbox", "LEFT", "Right", DebuffSizeSlider, 15,0, true)
    local DebuffSizeText = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	DebuffSizeText:SetPoint("TOPLEFT", 370, -400)
	DebuffSizeText:SetFont("Fonts\\MORPHEUS.ttf", 15)
	DebuffSizeText:SetText( DebuffSizeSlider:GetValue())
	DebuffSizeSlider:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.DebuffButtonSize = value
		local step = DebuffSizeSlider:GetValueStep()
		DebuffSizeText:SetText(value)
		DeSizeEditbox:SetText(SimpleRound(value,step))
		StaticPopup_Show ("ReloadUI Box")
	end)
	DeSizeEditbox:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffSizeSlider:SetValue(val)
		end
	  end)
	  DeSizeEditbox:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffSizeSlider:SetValue(val)
		end
	end)
	-- Debuffs Per Row
	local DebuffsPerRowS = CreateSlider("DebuffsPerRowS", "Debuffs Per Row", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -450, 1, 12, 1, BetterAuraTrackerSettings.DebuffsPerRow)
	local DebuffsPerRowE = CreateEditBox(50,30, "DeSizeEditbox", "LEFT", "Right", DebuffsPerRowS, 15,0, true)
    local DebuffsPerRowT = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	DebuffsPerRowT:SetPoint("TOPLEFT", 90, -470)
	DebuffsPerRowT:SetFont("Fonts\\MORPHEUS.ttf", 15)
	DebuffsPerRowT:SetText( DebuffsPerRowS:GetValue())
	DebuffsPerRowS:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.DebuffsPerRow = value
		local step = DebuffsPerRowS:GetValueStep()
		DebuffsPerRowT:SetText(value)
		DebuffsPerRowE:SetText(SimpleRound(value,step))
		StaticPopup_Show ("ReloadUI Box")
	end)
	DebuffsPerRowE:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffsPerRowS:SetValue(val)
		end
	  end)
	  DebuffsPerRowE:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffsPerRowS:SetValue(val)
		end
	end)

	-- Debuffs Padding
	local DebuffsPaddingS = CreateSlider("DebuffsPaddingS", "Debuffs Padding", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 300, -450, 0, 12, 1, BetterAuraTrackerSettings.DebuffPadding)
	local DebuffsPaddingE = CreateEditBox(50,30, "DebuffsPaddingE", "LEFT", "Right", DebuffsPaddingS, 15,0, true)
	local DebuffsPaddingT = BetterAuraTrackerPanel.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	DebuffsPaddingT:SetPoint("TOPLEFT", 370, -470)
	DebuffsPaddingT:SetFont("Fonts\\MORPHEUS.ttf", 15)
	DebuffsPaddingT:SetText( DebuffsPaddingS:GetValue())
	DebuffsPaddingS:SetScript("OnValueChanged", function(self)
		local value = self:GetValue()
		BetterAuraTrackerSettings.DebuffPadding = value
		local step = DebuffsPaddingS:GetValueStep()
		DebuffsPaddingT:SetText(value)
		DebuffsPaddingE:SetText(SimpleRound(value,step))
		StaticPopup_Show ("ReloadUI Box")
	end)
	DebuffsPaddingE:SetScript("OnTextChanged", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffsPaddingS:SetValue(val)
		end
	end)
	DebuffsPaddingE:SetScript("OnEnterPressed", function(self)
		local val = self:GetText()
		if tonumber(val) then
			DebuffsPaddingS:SetValue(val)
		end
	end)


	-- Setup buff font options menu
	BetterAuraTrackerPanel.BuffFontOptionsPanel = CreateFrame( "Frame", "BuffFontOptionsPanel", BetterAuraTrackerPanel.panel)
	BetterAuraTrackerPanel.BuffFontOptionsPanel.name = "Buff Font Options"

	-- Buff Font Options Title
	BetterAuraTrackerPanel.BuffFontOptionsPanel.title = AddText(BetterAuraTrackerPanel.BuffFontOptionsPanel, "TOPLEFT", 16, -16, "Buff Font Options", 30)
	-- Setup Buff font drop down
	BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop = CreateFrame("Frame", "BuffDropDown", BetterAuraTrackerPanel.BuffFontOptionsPanel, "UIDropDownMenuTemplate")
	BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop:SetPoint("TOPLEFT", BetterAuraTrackerPanel.BuffFontOptionsPanel, "TOPLEFT", 0, -70)
	BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop.title = AddSubText(BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop, "TOPLEFT", 20, 15, "Font Option", 15)
	EasyMenu(core.Fonts.GetAllFonts(), BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop, BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop, 0 , 0, nil)

	-- Buff Outline Options
	BetterAuraTrackerPanel.BuffFontOptionsPanel.OutDrop = CreateFrame("Frame", "BuffDropDown", BetterAuraTrackerPanel.BuffFontOptionsPanel, "UIDropDownMenuTemplate")
	BetterAuraTrackerPanel.BuffFontOptionsPanel.OutDrop:SetPoint("TOPLEFT", BetterAuraTrackerPanel.BuffFontOptionsPanel, "TOPLEFT", 300, -70)
	BetterAuraTrackerPanel.BuffFontOptionsPanel.OutDroptitle = AddSubText(BetterAuraTrackerPanel.BuffFontOptionsPanel.BuffDrop, "TOPLEFT", 320, 15, "OutLine Option", 15)
	EasyMenu(OutLineOptions, BetterAuraTrackerPanel.BuffFontOptionsPanel.OutDrop, BetterAuraTrackerPanel.BuffFontOptionsPanel.OutDrop, 0 , 0, nil)

	-- Setup debuff font options menu
	BetterAuraTrackerPanel.DebuffFontOptionsPanel = CreateFrame( "Frame", "DebuffFontOptionsPanel", BetterAuraTrackerPanel.panel)
	BetterAuraTrackerPanel.DebuffFontOptionsPanel.name = "Debuff Font Options"
	
	-- Debuff Font Options Title
	BetterAuraTrackerPanel.DebuffFontOptionsPanel.title = AddText(BetterAuraTrackerPanel.DebuffFontOptionsPanel, "TOPLEFT", 16, -16, "Debuff Font Options", 30)


	-- Set addon name in blizz's addon interface
	BetterAuraTrackerPanel.panel.name = "BetterAuraTracker";
	BetterAuraTrackerPanel.BuffFontOptionsPanel.parent = BetterAuraTrackerPanel.panel.name;
	BetterAuraTrackerPanel.DebuffFontOptionsPanel.parent = BetterAuraTrackerPanel.panel.name;
	-- Add the panels to the Interface Options screen
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.panel);
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.BuffFontOptionsPanel);
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.DebuffFontOptionsPanel);
end