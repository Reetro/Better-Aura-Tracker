local A, L = ...
local _, core = ...;
core.Aura = {}
local Aura = core.Aura
local buffFrame;
local debuffFrame; 

BetterAuraTracker = LibStub("AceAddon-3.0"):NewAddon("BetterAuraTracker")

local function startup(self, event, arg2, ...)
	core.Config.CreateMenu()
end

function BetterAuraTracker:OnEnable()
  startup()
  getAura()
end

function Aura:UnlockFrames()
  buffFrame:SetMovable(true)
  buffFrame:EnableMouse(true)
  buffFrame:RegisterForDrag("LeftButton")
  buffFrame:SetScript("OnDragStart", buffFrame.StartMoving)
  buffFrame:SetScript("OnDragStop", buffFrame.StopMovingOrSizing)
end

function Aura:LockFrames()
  buffFrame:SetMovable(false)
  buffFrame:EnableMouse(false)
end

function Aura:ResetFrames()
  buffFrame:SetPoint("TOPRIGHT", Minimap, "TOPLEFT", -5, -5)
end

local startup = CreateFrame("FRAME", "startup");
startup:RegisterEvent("PLAYER_LOGIN");
startup:SetScript("OnEvent", getAura);


function CreateBuffFrame()
  local buffFrameConfig = {
    framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -5, -5 },
    frameScale      = core.Config.GetBuffFrameScale(),
    framePadding    = 5,
    buttonWidth     = core.Config:GetBuffButtonSize(),
    buttonHeight    = core.Config:GetBuffButtonSize(),
    buttonMargin    = 5,
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
  
  debuffFrame = rBuffFrame:CreateDebuffFrame(A, debuffFrameConfig)

end 

function getAura()
  CreateBuffFrame()
  CreateDebuffFrame()
end