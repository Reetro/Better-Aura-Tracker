local A, L = ...
local _, core = ...;
core.Aura = {}
local Aura = core.Aura
local buffFrame;
local debuffFrame;
local DebuffOverlay;
local BuffOverlay;

buffFrameConfig = {
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

debuffFrameConfig = {
  framePoint      = { BetterAuraTrackerSettings.DebuffframePoint,nil, BetterAuraTrackerSettings.DebufframeRelativePoint, BetterAuraTrackerSettings.DebuffPostionX, BetterAuraTrackerSettings.DebuffPostionY},
  frameScale      = BetterAuraTrackerSettings.DebuffButtonScale,
  framePadding    = 5,
  buttonWidth     = BetterAuraTrackerSettings.DebuffButtonSize,
  buttonHeight    = BetterAuraTrackerSettings.DebuffButtonSize,
  buttonMargin    = 1,
  numCols         = 10,
  startPoint      = "TOPRIGHT",
  rowMargin       = 20,
}

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
  BuffOverlay:Show()
end

function Aura:LockFrames()
  SetBuffFrameLocation(buffFrame)

end

function Aura:ResetFrames()
  buffFrame:SetPoint("TOPRIGHT", nil, "TOPRIGHT", -180, -5)
end

local startup = CreateFrame("FRAME", "startup");
startup:RegisterEvent("PLAYER_LOGIN");
startup:SetScript("OnEvent", getAura);


function CreateBuffFrame()
  buffFrame = rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
end


function CreateDebuffFrame()
  debuffFrame = rBuffFrame:CreateDebuffFrame(A,debuffFrameConfig)
end 

function getAura()
  CreateBuffFrame()
  CreateDebuffFrame()
  AddOverlayToScreen()
end

function AddOverlayToScreen()
  DebuffOverlay = CreateOverlay(debuffFrameConfig.framePoint, "Debuff Frame")
  BuffOverlay = CreateOverlay(buffFrameConfig.framePoint, "Buff Frame")
  DebuffOverlay:Hide()
  BuffOverlay:Hide()
end

function SetBuffFrameLocation(frame)
  local point, relativeTo, relativePoint, xOfs, yOfs = BuffOverlay:GetPoint()
  frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
  print(point, relativeTo, relativePoint, xOfs, yOfs)
  BetterAuraTrackerSettings.BuffframePoint = point
  BetterAuraTrackerSettings.BuffframePostionX = xOfs
  BetterAuraTrackerSettings.BuffframePostionY = yOfs
  BetterAuraTrackerSettings.BuffframeRelativePoint = relativePoint
end

function CreateOverlay(location, overlaytext)
  local frame = CreateFrame("Frame", "FrameOverlay", UIParent)
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
  Text:SetText(overlaytext)
  Text:SetAllPoints(frame)
  Text:SetFont("Fonts\\ARIALN.ttf", 15, "OUTLINE")
  return frame
end