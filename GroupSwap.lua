--[[
    GroupSwap
        Handles viewing of Frames and settings management
--]]

GroupSwap = LibStub('AceAddon-3.0'):NewAddon('GroupSwap', 'AceEvent-3.0', 'AceConsole-3.0')
local L = LibStub('AceLocale-3.0'):GetLocale('GroupSwap')
local CURRENT_VERSION = GetAddOnMetadata("GroupSwap", "Version")

--bindings
BINDING_HEADER_GROUPSWAP = "GroupSwap"
BINDING_NAME_GROUPSWAP_TOGGLE = L.GroupSwapToggle

function GroupSwap:OnInitialize()
	local defaults = {
        bg = {r = 0, g = 0.2, b = 0, a = 0.5},
        colors = {
            ["Class"] = {
                ["HUNTER"] = '|cff6B8E23',
                ["WARLOCK"] = '|cff6A5ACD',
                ["PRIEST"] = '|cffFFFFFF',
                ["PALADIN"] = '|cffFFB6C1',
                ["MAGE"] = '|cff87CEFA',
                ["ROGUE"] = '|cffFFD700',
                ["DRUID"] = '|cffFF8C00',
                ["SHAMAN"] = '|cff0000FF',
                ["WARRIOR"] = '|cffCD853F', 
            }
        }

		version = CURRENT_VERSION,
    }

    if not(GroupSwapSets and GroupSwapSets.version) then
        GroupSwapSets = defaults
    end
    self.sets = GroupSwapSets
    self:RegisterEvent('PLAYER_LOGOUT')
end

function GroupSwap:OnEnable()

    self:RegisterSlashCommands()
end

--[[ Frame Display ]]--
function GroupSwap:CreateFrame()
    local frame = GroupSwapFrame:Create(self.sets)
	table.insert(UISpecialFrames, frame:GetName())

    local OnShow = frame:GetScript("OnShow")
    frame:SetScript("OnShow", function(self)
		PlaySound("igBackPackOpen")
        OnShow(self)
    end)

    local OnHide = frame:GetScript("OnHide")
    frame:SetScript("OnHide", function(self)
		PlaySound("igBackPackClose")
		OnHide(self)
    end)

    if not frame:IsUserPlaced() then
        frame:SetPoint('RIGHT', UIParent)
    end

    self.frame = frame
    
    return frame
end

function GroupSwap:ShowFrame()
	local frame = self.frame
	if frame then
		if not frame:IsVisible() then
			frame:Show()
		end
	else
		frame = self:CreateFrame()
	end
end

function GroupSwap:HideFrame()
	local frame = self.frame
	if frame then
        frame:Hide()
    end
end

function GroupSwap:ToggleGroupSwap()
    local frame = self.frame
    if frame and frame:IsVisible() then
        self:HideFrame()
    else
        self:ShowFrame()
    end
end


--[[  Slash Commands ]]--
function GroupSwap:RegisterSlashCommands()
    self:RegisterChatCommand('groupswap', 'OnCmd')
    self:RegisterChatCommand('gsp', 'OnCmd')
end

function GroupSwap:OnCmd(cmd)
	if cmd ~= '' then
        cmd = cmd:lower()
        if cmd == 'toggle' then 
            self:ToggleGroupSwap()
        elseif cmd == 'set' then
            self:SetGroupSwap()
        elseif cmd == 'reset' then
            self:ResetGroupSwap()
        elseif cmd == 'swap' then
            self:InitiateSwap()
        elseif cmd == 'list' then
            self:ListSwaps()
        else
            self:PrintHelp()
        end
    else
        self:PrintHelp()
    end
end

function GroupSwap:PrintHelp(cmd)
	local function PrintCmd(cmd, desc)
		DEFAULT_CHAT_FRAME:AddMessage(format(' - |cFF33FF99%s|r: %s', cmd, desc))
	end

	self:Print(L.Commands)
	PrintCmd('toggle', L.ShowSwapConfig)
	PrintCmd('set', L.ShowSetSwap)
	PrintCmd('reset', L.ShowResetSwap)
	PrintCmd('swap', L.ShowSwap)
	PrintCmd('list', L.ShowListSwap)
end
