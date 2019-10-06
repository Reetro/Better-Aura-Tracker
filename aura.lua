function CreateBuffFrame()
  local buffFrameConfig = {
    framePoint      = { "TOPRIGHT", Minimap, "TOPLEFT", -5, -5 },
    frameScale      = 1,
    framePadding    = 5,
    buttonWidth     = 32,
    buttonHeight    = 32,
    buttonMargin    = 5,
    numCols         = 10,
    startPoint      = "TOPRIGHT",
    rowMargin       = 20,
  }
  --create
  return buffFrame = rBuffFrame:CreateBuffFrame("BetterAuraTracker", buffFrameConfig)
end


local frame = CreateFrame("FRAME", "AuraFrame");
frame:RegisterEvent("UNIT_AURA");
frame:SetScript("OnEvent", CreateBuffFrame);