local A, L = ...
local _, core = ...;
core.Aura = {}
local Aura = core.Aura
local buffFrame;
local debuffFrame;

local defaults = {
  BuffframePostionX = -200,
	BuffframePostionY = -5,
	BuffframeRelativePoint = "TOPRIGHT",
	BuffframePoint = "TOPRIGHT",
	BuffButtonSize = 64,
	BuffButtonScale = 1,
	BuffsPerRow = 10,
	BuffPadding = 0,
	DebuffPostionX = -200,
	DebuffPostionY = -100,
	DebufframeRelativePoint = "TOPRIGHT",
	DebuffframePoint = "TOPRIGHT",
	DebuffButtonSize = 32,
	DebuffButtonScale = 1,
	DebuffsPerRow = 10,
	DebuffPadding = 0,
	ZoomBuffs = false,
	ZoomDebuffs = false,
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
  rBuffFrame:UnlockFrames()
  buffFrame:SetMovable(true)
  buffFrame:EnableMouse(true)
  buffFrame:RegisterForDrag("LeftButton")
  buffFrame:SetScript("OnDragStart", buffFrame.StartMoving)
  buffFrame:SetScript("OnDragStop", buffFrame.StopMovingOrSizing)
  buffFrame:SetUserPlaced(true)

  debuffFrame:SetMovable(true)
  debuffFrame:EnableMouse(true)
  debuffFrame:RegisterForDrag("LeftButton")
  debuffFrame:SetScript("OnDragStart", debuffFrame.StartMoving)
  debuffFrame:SetScript("OnDragStop", debuffFrame.StopMovingOrSizing)
  debuffFrame:SetUserPlaced(true)
end

function Aura:LockFrames()
  SetBuffLocation(buffFrame)
  rBuffFrame:LockFrames()
  -- Disable Buff moving and save postion
  buffFrame:SetMovable(false)
  buffFrame:EnableMouse(false)
  -- Disable Debuff moving and save postion
  SetDebuffLocation(debuffFrame)
  debuffFrame:SetMovable(false)
  debuffFrame:EnableMouse(false)
end

function Aura:ResetFrames()
  -- Reset Buff Frame
  buffFrame:SetPoint(defaults.BuffframePoint, nil, defaults.BuffframeRelativePoint, defaults.BuffframePostionX, defaults.BuffframePostionY)
  BetterAuraTrackerSettings.BuffframePoint = defaults.BuffframePoint
  BetterAuraTrackerSettings.BuffframeRelativePoint = defaults.BuffframeRelativePoint
  BetterAuraTrackerSettings.BuffframePostionX = defaults.BuffframePostionX
  BetterAuraTrackerSettings.BuffframePostionY = defaults.BuffframePostionY
  -- Reset Debuff Frame
  debuffFrame:SetPoint(defaults.DebuffframePoint, nil, defaults.DebufframeRelativePoint, defaults.DebuffPostionX, defaults.DebuffPostionY)
  BetterAuraTrackerSettings.DebuffframePoint = defaults.DebuffframePoint
  BetterAuraTrackerSettings.DebufframeRelativePoint = defaults.DebufframeRelativePoint
  BetterAuraTrackerSettings.DebuffPostionX = defaults.DebuffPostionX
  BetterAuraTrackerSettings.DebuffPostionY = defaults.DebuffPostionY
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
    buttonMargin    = BetterAuraTrackerSettings.BuffPadding,
    numCols         = BetterAuraTrackerSettings.BuffsPerRow,
    startPoint      = "TOPRIGHT",
  }
  buffFrame = rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
end


function CreateDebuffFrame()
  local debuffFrameConfig = {
    framePoint      = { BetterAuraTrackerSettings.DebuffframePoint, nil, BetterAuraTrackerSettings.DebufframeRelativePoint, BetterAuraTrackerSettings.DebuffPostionX, BetterAuraTrackerSettings.DebuffPostionY },
    frameScale      = BetterAuraTrackerSettings.DebuffButtonScale,
    framePadding    = 5,
    buttonWidth     = BetterAuraTrackerSettings.DebuffButtonSize,
    buttonHeight    = BetterAuraTrackerSettings.DebuffButtonSize,
    buttonMargin    = BetterAuraTrackerSettings.DebuffPadding,
    numCols         = BetterAuraTrackerSettings.DebuffsPerRow,
    startPoint      = "TOPRIGHT",
  }   
  debuffFrame = rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)
end 

function getAura()
  CreateBuffFrame()
  CreateDebuffFrame()
end

function SetBuffLocation(frame)
 local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
  frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
  BetterAuraTrackerSettings.BuffframePoint = point
  BetterAuraTrackerSettings.BuffframePostionX = xOfs
  BetterAuraTrackerSettings.BuffframePostionY = yOfs
  BetterAuraTrackerSettings.BuffframeRelativePoint = relativePoint
end

function SetDebuffLocation(frame)
  local point, relativeTo, relativePoint, xOfs, yOfs = frame:GetPoint()
   frame:SetPoint(point, relativeTo, relativePoint, xOfs, yOfs)
   BetterAuraTrackerSettings.DebuffframePoint = point
   BetterAuraTrackerSettings.DebuffPostionX = xOfs
   BetterAuraTrackerSettings.DebuffPostionY = yOfs
   BetterAuraTrackerSettings.DebufframeRelativePoint = relativePoint
 end