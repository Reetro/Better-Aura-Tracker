local A, L = ...
local _, core = ...;
core.Aura = {}
local Aura = core.Aura
local buffFrame;
local debuffFrame;
local DebuffOverlay;

BetterAuraTracker = LibStub("AceAddon-3.0"):NewAddon("BetterAuraTracker")

local function startup(self, event, arg2, ...)
  core.Config.CreateMenu()
end

function BetterAuraTracker:OnEnable()
  startup()
  getAura()
end

function Aura:UnlockFrames()
  DebuffOverlay:Show()
  rBuffFrame:UnlockFrames()
  buffFrame:SetMovable(true)
  buffFrame:EnableMouse(true)
  buffFrame:RegisterForDrag("LeftButton")
  buffFrame:SetScript("OnDragStart", buffFrame.StartMoving)
  buffFrame:SetScript("OnDragStop", buffFrame.StopMovingOrSizing)
  buffFrame:SetUserPlaced(true)
end

function Aura:LockFrames()
  SetBuffLocation(buffFrame)
  rBuffFrame:LockFrames()
  buffFrame:SetMovable(false)
  buffFrame:EnableMouse(false)
  DebuffOverlay:Hide()
end

function Aura:ResetFrames()
  buffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -5)
end

local startup = CreateFrame("FRAME", "startup");
startup:RegisterEvent("PLAYER_LOGIN");
startup:SetScript("OnEvent", getAura);


function CreateBuffFrame()
  local buffFrameConfig = {
    framePoint      = { BetterAuraTrackerSettings.BuffframePoint,nil, BetterAuraTrackerSettings.BuffframeRelativePoint, BetterAuraTrackerSettings.BuffframePostionX, BetterAuraTrackerSettings.BuffframePostionY},
    frameScale      = BetterAuraTrackerSettings.BuffButtonScale,
    framePadding    = 5,
    buttonWidth     = BetterAuraTrackerSettings.BuffButtonSize,
    buttonHeight    = BetterAuraTrackerSettings.BuffButtonSize,
    buttonMargin    = 1,
    numCols         = 10,
    startPoint      = "TOPRIGHT",
    rowMargin       = 20,
  }
  buffFrame = rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
end


function CreateDebuffFrame()
  local debuffFrameConfig = {
    framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -4, -100 },
    frameScale      = 1,
    framePadding    = 5,
    buttonWidth     = 32,
    buttonHeight    = 32,
    buttonMargin    = 5,
    numCols         = 8,
    startPoint      = "TOPRIGHT",
  }  
  DebuffOverlay = CreateDebuffOverlay(debuffFrameConfig.framePoint)  
  debuffFrame = rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)
  DebuffOverlay:Hide()
end 

function getAura()
  CreateBuffFrame()
  CreateDebuffFrame()
end

function CreateDebuffOverlay(location)
  local frame = CreateFrame("Frame", "DragFrame2", UIParent)
  frame:SetMovable(true)
  frame:EnableMouse(true)
  frame:RegisterForDrag("LeftButton")
  frame:SetScript("OnDragStart", frame.StartMoving)
  frame:SetScript("OnDragStop", frame.StopMovingOrSizing)
  -- The code below makes the frame visible, and is not necessary to enable dragging.
  frame:SetPoint(unpack(location)) 
  frame:SetWidth(80) 
  frame:SetHeight(80)
  local tex = frame:CreateTexture("ARTWORK");
  tex:SetAllPoints();
  tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
  local Text = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
  Text:SetText("DebuffFrame")
  Text:SetAllPoints(frame)
  Text:SetFont("Fonts\\ARIALN.ttf", 15, "OUTLINE")
  return frame
end

function SetBuffLocation(frame)
 local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
  frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
  BetterAuraTrackerSettings.BuffframePoint = point
  BetterAuraTrackerSettings.BuffframePostionX = xOfs
  BetterAuraTrackerSettings.BuffframePostionY = yOfs
  BetterAuraTrackerSettings.BuffframeRelativePoint = relativePoint
end