--[[
    GroupSwapUtil
        A library of functions for group swapping

--]]
GroupSwapUtil = CreateFrame('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('GroupSwap')


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