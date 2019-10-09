local A, L = ...
local _, core = ...;
core.Aura = {}
local Aura = core.Aura
local buffFrame;
local debuffFrame;
local DebuffOverlay;

local buffFrameConfig = {
  framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -5, -5 },
  frameScale      = core.Config:GetBuffFrameScale(),
  framePadding    = 5,
  buttonWidth     = core.Config:GetBuffButtonSize(),
  buttonHeight    = core.Config:GetBuffButtonSize(),
  buttonMargin    = 5,
  numCols         = 10,
  startPoint      = "TOPRIGHT",
  rowMargin       = 20,
}

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

BetterAuraTracker = LibStub("AceAddon-3.0"):NewAddon("BetterAuraTracker")

local function startup(self, event, arg2, ...)
  core.Config.CreateMenu()
  DebuffOverlay = CreateDebuffOverlay(debuffFrameConfig.framePoint)
  DebuffOverlay:Hide()
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
end

function Aura:LockFrames()
  debuffFrameConfig.framePoint = GetDebuffFramePoint(DebuffOverlay)
  rBuffFrame:LockFrames()
  buffFrame:SetMovable(false)
  buffFrame:EnableMouse(false)
  DebuffOverlay:Hide()
end

function Aura:ResetFrames()
  buffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -5)
  debuffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -4, -100)
  DebuffOverlay:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -4, -100)
end

local startup = CreateFrame("FRAME", "startup");
startup:RegisterEvent("PLAYER_LOGIN");
startup:SetScript("OnEvent", getAura);


function CreateBuffFrame()
  buffFrame = rBuffFrame:CreateBuffFrame(A,buffFrameConfig)
end


function CreateDebuffFrame()  
  debuffFrame = rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)
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


function GetDebuffFramePoint(frame)
  return frame:GetPoint()
end
