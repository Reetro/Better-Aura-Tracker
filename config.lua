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

local SimpleRound = function(val,valStep)
    return floor(val/valStep)*valStep
  end


function AddText(frame, point, xoff,yoff,text,size)
	local t = frame.panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\MORPHEUS.ttf", size, "OUTLINE, MONOCHROME")
	return t
end

function AddSubText(frame, point, xoff,yoff,text,size)
	local t = frame.panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	t:SetPoint(point, xoff, yoff)
	t:SetText(text)
	t:SetFont("Fonts\\MORPHEUS.ttf", size, "OUTLINE, MONOCHROME")
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
	local editbox = CreateFrame("EditBox",  "$parentEditBox", s, "InputBoxTemplate")
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
	editbox:SetSize(50,30)
    editbox:ClearAllPoints()
    editbox:SetPoint("LEFT", s, "RIGHT", 15, 0)
    editbox:SetText(s:GetValue())
    editbox:SetAutoFocus(false)
    s:SetScript("OnValueChanged", function(self,value)
      self.editbox:SetText(SimpleRound (value,valuestep))
    end)
    editbox:SetScript("OnTextChanged", function(self)
      local val = self:GetText()
      if tonumber(val) then
         self:GetParent():SetValue(val)
      end
    end)
    editbox:SetScript("OnEnterPressed", function(self)
      local val = self:GetText()
      if tonumber(val) then
         self:GetParent():SetValue(val)
         self:ClearFocus()
      end
    end)
    s.editbox = editbox
    return slider
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
	-- Buff Scale Slider
	BetterAuraTrackerPanel.panel.BuffSlider = CreateSlider("BuffScaleSlider", "Buff Scale", "TOPLEFT", BetterAuraTrackerPanel.panel, "TOPLEFT", 20, -240, 1, 10, 1, 1)

	
	-- Set the name for the Category for the Options Panel
	BetterAuraTrackerPanel.panel.name = "BetterAuraTracker";

	-- Add the panel to the Interface Options
	InterfaceOptions_AddCategory(BetterAuraTrackerPanel.panel);
end