
-- rBuffFrame: core
-- zork, 2016

-----------------------------
-- Variables
-----------------------------

local A, L = ...

L.addonName       = A
L.dragFrames      = {}
L.addonColor      = "0000FFFF"
L.addonShortcut   = "rbf"

-----------------------------
-- rBuffFrame Global
-----------------------------

rBuffFrame = {}
rBuffFrame.addonName = A

-----------------------------
-- Functions
-----------------------------

local function GetButtonList(buttonName,numButtons,buttonList)
  buttonList = buttonList or {}
  for i=1, numButtons do
    local button = _G[buttonName..i]
    if not button then break end
    if button:IsShown() then
      table.insert(buttonList, button)
    end
  end
  return buttonList
end

--points
--1. p1, f, fp1, fp2
--2. p2, rb-1, p3, bm1, bm2
--3. p4, b-1, p5, bm3, bm4
local function SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, p1, fp1, fp2, p2, p3, bm1, bm2, p4, p5, bm3, bm4)
  for index, button in next, buttonList do
    button:SetSize(buttonWidth, buttonHeight)
    button:ClearAllPoints()
    if index == 1 then
      button:SetPoint(p1, frame, fp1, fp2)
    elseif numCols == 1 or mod(index, numCols) == 1 then
      button:SetPoint(p2, buttonList[index-numCols], p3, bm1, bm2)
    else
      button:SetPoint(p4, buttonList[index-1], p5, bm3, bm4)
    end
  end
end

local function SetupButtonFrame(frame, framePadding, buttonList, buttonWidth, buttonHeight, buttonMargin, numCols, startPoint, rowMargin)
  local numButtons = # buttonList
  numCols = max(min(numButtons, numCols),1)
  local numRows = max(ceil(numButtons/numCols),1)
  if not rowMargin then
    rowMargin = buttonMargin
  end
  local frameWidth = numCols*buttonWidth + (numCols-1)*buttonMargin + 2*framePadding
  local frameHeight = numRows*buttonHeight + (numRows-1)*rowMargin + 2*framePadding
  frame:SetSize(frameWidth,frameHeight)
  --TOPLEFT
  --1. TL, f, p, -p
  --2. T, rb-1, B, 0, -m
  --3. L, b-1, R, m, 0
  if startPoint == "TOPLEFT" then
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, -framePadding, "TOP", "BOTTOM", 0, -rowMargin, "LEFT", "RIGHT", buttonMargin, 0)
  --end
  --TOPRIGHT
  --1. TR, f, -p, -p
  --2. T, rb-1, B, 0, -m
  --3. R, b-1, L, -m, 0
  elseif startPoint == "TOPRIGHT" then
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, -framePadding, "TOP", "BOTTOM", 0, -rowMargin, "RIGHT", "LEFT", -buttonMargin, 0)
  --end
  --BOTTOMRIGHT
  --1. BR, f, -p, p
  --2. B, rb-1, T, 0, m
  --3. R, b-1, L, -m, 0
  elseif startPoint == "BOTTOMRIGHT" then
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, -framePadding, framePadding, "BOTTOM", "TOP", 0, rowMargin, "RIGHT", "LEFT", -buttonMargin, 0)
  --end
  --BOTTOMLEFT
  --1. BL, f, p, p
  --2. B, rb-1, T, 0, m
  --3. L, b-1, R, m, 0
  --elseif startPoint == "BOTTOMLEFT" then
  else
    startPoint = "BOTTOMLEFT"
    SetupButtonPoints(frame, buttonList, buttonWidth, buttonHeight, numCols, startPoint, framePadding, framePadding, "BOTTOM", "TOP", 0, rowMargin, "LEFT", "RIGHT", buttonMargin, 0)
  end
end

function rBuffFrame:CreateBuffFrame(addonName,cfg)
  cfg.frameName = addonName.."BuffFrame"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = nil
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
  frame:SetPoint(unpack(cfg.framePoint))
  frame:SetScale(cfg.frameScale)
  local function UpdateAllBuffAnchors()
    --add temp enchant buttons
    local buttonList = GetButtonList("TempEnchant",BuffFrame.numEnchants)
    --add all other buff buttons
    buttonList = GetButtonList("BuffButton",BUFF_MAX_DISPLAY,buttonList)
    --adjust frame by button list
    SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint, cfg.rowMargin)
  end
  hooksecurefunc("BuffFrame_UpdateAllBuffAnchors", UpdateAllBuffAnchors)
  --add drag functions
  rLib:CreateDragFrame(frame, L.dragFrames, -2, true)
  SetupBuffOverlay(frame, cfg)
  return frame
end

function rBuffFrame:CreateDebuffFrame(addonName,cfg)
  cfg.frameName = addonName.."DebuffFrame"
  cfg.frameParent = cfg.frameParent or UIParent
  cfg.frameTemplate = nil
  --create new parent frame for buttons
  local frame = CreateFrame("Frame", cfg.frameName, cfg.frameParent, cfg.frameTemplate)
  frame:SetPoint(unpack(cfg.framePoint))
  frame:SetScale(cfg.frameScale)
  local function UpdateAllDebuffAnchors(buttonName, index)
    --add all other debuff buttons
    local buttonList = GetButtonList("DebuffButton",DEBUFF_MAX_DISPLAY)
    --adjust frame by button list
    SetupButtonFrame(frame, cfg.framePadding, buttonList, cfg.buttonWidth, cfg.buttonHeight, cfg.buttonMargin, cfg.numCols, cfg.startPoint)
  end
  hooksecurefunc("DebuffButton_UpdateAnchors", UpdateAllDebuffAnchors)
  --add drag functions
  local relativeToName, _, relativeTo  = nil, unpack(cfg.framePoint)
  if type(relativeTo) == "table" then
    relativeToName = relativeTo:GetName()
  elseif type(relativeTo) == "string" and _G[relativeTo] then
    relativeToName = relativeTo
  end
  if relativeToName ~= addonName.."BuffFrame" then
    rLib:CreateDragFrame(frame, L.dragFrames, -2, true)
  end
  SetupDebuffOverlay(frame, cfg)
  return frame
end

-----------------------------
-- Setup Unlock overlay
-----------------------------

function SetupBuffOverlay(frame, cfg)
  buffoverlay = CreateFrame("Frame", "BuffOverlay", frame)
  buffTexture = buffoverlay:CreateTexture(nil, "OVERLAY", nil, 6)
  buffTexture:SetPoint(unpack(cfg.framePoint))
  buffTexture:SetTexture(1.0, 0.0, 0.0)
  buffTexture:SetAlpha(0.5)
  buffoverlay:SetAllPoints(frame)
  buffTexture:SetAllPoints(buffoverlay)
  buffoverlayText = buffoverlay:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  buffoverlayText:SetText("BuffFrame")
  buffoverlayText:SetAllPoints(buffoverlay)
  buffoverlayText:SetFont("Fonts\\ARIALN.ttf", 15, "OUTLINE")
  buffoverlay:Hide()
  buffoverlayText:Hide()
end

function SetupDebuffOverlay(frame,cfg)
  debuffoverlay = CreateFrame("Frame", "debuffOverlay", frame)
  debuffTexture = debuffoverlay:CreateTexture(nil, "OVERLAY", nil, 6)
  debuffTexture:SetPoint(unpack(cfg.framePoint))
  debuffTexture:SetTexture(1.0, 0.0, 0.0)
  debuffTexture:SetAlpha(0.5)
  debuffoverlay:SetAllPoints(frame)
  debuffTexture:SetAllPoints(debuffoverlay)
  debuffoverlayText = debuffoverlay:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  debuffoverlayText:SetText("DebuffFrame")
  debuffoverlayText:SetAllPoints(debuffoverlay)
  debuffoverlayText:SetFont("Fonts\\ARIALN.ttf", 15, "OUTLINE")
  debuffoverlay:Hide()
  debuffoverlayText:Hide()
  frame:SetHeight(cfg.buttonWidth)
  frame:SetWidth(cfg.buttonHeight)
end

function rBuffFrame:UnlockFrames()
  buffoverlay:Show()
  buffoverlayText:Show()
  debuffoverlay:Show()
  debuffoverlayText:Show()
end

function rBuffFrame:LockFrames()
  buffoverlay:Hide()
  buffoverlayText:Hide()
  debuffoverlay:Hide()
  debuffoverlayText:Hide()
end