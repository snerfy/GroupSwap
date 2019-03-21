--[[
    GroupSwapUtil
        A library of functions for group swapping

--]]
GroupSwapUtil = CreateFrame('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('GroupSwap')
local colors = {
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

--[[ Frame super class ]] --
--creates a new class of objects that inherits from objects of <type>, ex 'Frame', 'Button', 'StatusBar'
--does not chain inheritance
function GroupSwapUtil:CreateWidgetClass(type)
	local class = CreateFrame(type)
	local mt = {__index = class}

	function class:New(o)
		if o then
			local type, cType = o:GetFrameType(), self:GetFrameType()
			assert(type == cType, format("'%s' expected, got '%s'", cType, type))
		end
		return setmetatable(o or CreateFrame(type), mt)
	end

	return class
end

-- [[ GetSwapString]] --
-- Returns a string with the escape sequence hex code corresponding
-- to class color
-- ex: '|cffFF8C00DruidName' 
function GroupSwapUtil:GetSwapString(swap)
	return colors[swap.class] .. swap.name
end

