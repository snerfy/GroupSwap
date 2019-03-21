--[[
	Bagnon Localization Information: English Language
		This file must be present to have partial translations
--]]

local L = LibStub('AceLocale-3.0'):NewLocale('GroupSwap', 'enUS', true)

L.GroupSwapToggle = "Toggle GroupSwap"

--slash commands
L.Commands = "Commands:"
L.ShowSwapConfig = "Toggle swap gui."
L.ShowSetSwap = "Create swap between two characters."
L.ShowSwap = "Swap the preset characters."
L.ShowListSwap = "List the swaps currently set."
L.ShowResetSwap = "Reset configured swaps."

--frame text
L.Title = "GroupSwap"
L.TitleGroup = "Group %s"
L.SwapButton = "Swap!"

--errors
L.ErrorNoSwapsConfigured = "Cannot initiate swap, no swaps configured."
L.ErrorNoRaidGroup = "Not in raid group."
L.ErrorIncorrectPermissions = "Insufficient raid privileges."

L.ResetSwap = "Reset"
