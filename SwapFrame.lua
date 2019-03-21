--[[
    SwapFrame
        Creates and manages individual character swap rows

--]]
SwapFrame = GroupSwapUtil:CreateWidgetClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('GroupSwap')

function SwapFrame:Create(parent, names, sets)
    local frame = self:New(CreateFrame('Frame', nil, parent))
    local text = ""

    frame.swaps = {}

    for i = 1,2 do
        local name, _, subgroup, _, _, fileName, = GetRaidRosterInfo(UnitInRaid(names[i]))
        local swap = {["name"] = name, class = fileName, group = subgroup}
        if(i == 1) then
            text..SwapFrame:getSwapString(swap)..'|r <> '
        else
            text..SwapFrame:getSwapString(swap)
        end
        tinsert(frame.swaps, swap)
    end

    frame.fontString = frame:CreateFontString(nil,"BACKGROUND","GameFontHighlight")
    frame.fontString:SetText(text)

    return frame
end

    





