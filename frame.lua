--[[
    GroupSwapFrame
        Container frame for groups, swap buttons and configuration
--]]

GroupSwapFrame = GroupSwapUtil:CreateWidgetClass('Frame')
local L = LibStub('AceLocale-3.0'):GetLocale('GroupSwap')
local DEFAULT_COLS = 8
local DEFAULT_SPACING = 1
local DEFAULT_STRATA = 'HIGH'

--[[ TitleFrame Object ]]--

local TitleFrame = {}
do
	function TitleFrame:Create(parent)
		local title = CreateFrame('Button', nil, parent)

		local text = title:CreateFontString()
		text:SetAllPoints(title)
		text:SetJustifyH('LEFT')
		text:SetFontObject('GameFontNormal')
		title:SetFontString(text)

		title:SetHighlightTextColor(1, 1, 1)
		title:SetTextColor(1, 0.82, 0)
		title:RegisterForClicks('anyUp')

		title:SetScript('OnEnter', self.OnEnter)
		title:SetScript('OnLeave', self.OnLeave)
		title:SetScript('OnMouseUp', self.OnMouseUp)
		title:SetScript('OnMouseDown', self.OnMouseDown)

		return title
    end

	function TitleFrame:OnMouseDown()
        self.isMoving = true
        self:GetParent():StartMoving()
	end

	function TitleFrame:OnMouseUp()
		if self.isMoving then
			self.isMoving = nil

			self:GetParent():StopMovingOrSizing()
			self:GetParent():SavePosition()
		end
	end

	function TitleFrame:OnEnter()
		if self:GetRight() > (GetScreenWidth() / 2) then
			GameTooltip:SetOwner(self, 'ANCHOR_LEFT')
		else
			GameTooltip:SetOwner(self, 'ANCHOR_RIGHT')
		end

		GameTooltip:SetText(self:GetText(), 1, 1, 1)
		GameTooltip:Show()
	end
    
	function TitleFrame:OnLeave()
		GameTooltip:Hide()
    end
end

local id = 0
function GroupSwapFrame:Create(sets)
    local frame = self:New(CreateFrame('Frame', format('GroupSwapFrame%d', id), UIParent))
	frame:SetClampedToScreen(false)
	frame:SetMovable(true)
    frame:EnableMouse(true)

	frame:SetBackdrop{
	  bgFile = 'Interface/ChatFrame/ChatFrameBackground',
	  edgeFile = 'Interface/Tooltips/UI-Tooltip-Border',
	  edgeSize = 16,
	  tile = true, tileSize = 16,
	  insets = {left = 4, right = 4, top = 4, bottom = 4}
	}

	frame.borderSize = 16
    frame.paddingY = 24

	frame:LoadSettings(sets)
	frame:SetScript('OnShow', self.OnShow)
	frame:SetScript('OnHide', self.OnHide)
    frame:SetScript('OnEvent', self.OnEvent)

	local close = CreateFrame('Button', 'Close', frame, 'UIPanelCloseButton')
    close:SetPoint('TOPRIGHT', 6 - frame.borderSize/2, 6 - frame.borderSize/2)
    
    frame.title = TitleFrame:Create(frame)
    frame.title:SetPoint('TOPLEFT', 6 + frame.borderSize/2, -10)
	frame.title:SetPoint('BOTTOMRIGHT', frame, 'TOPRIGHT', -24, -16 - frame.borderSize/2)
    frame:SetTitleText(L.Title)

    frame:Regenerate(true)
    
    id = id + 1
    return frame
end

--[[ Frame Updating ]]--

--update all visible slots in the given frame
function GroupSwapFrame:Regenerate(forceLayout)
	if forceLayout then
		self:Layout()
	end
end
--[[ Player Selection ]]--

function GroupSwapFrame:SetPlayer(player)
	if player ~= self:GetPlayer() then
		self.player = player
		self:UpdateTitleText()

		if self:IsShown() then
			self:Regenerate()
		end
	end
end

function GroupSwapFrame:GetPlayer()
	return self.player or UnitName('player')
end

--[[ Frame Layout ]]--

function GroupSwapFrame:Layout(cols, space)
	cols = cols or self.sets.cols or DEFAULT_COLS
	space = space or self.sets.space or DEFAULT_SPACING
	self.sets.cols = cols
	self.sets.space = space

	local borderSize = self.borderSize or 0
	local paddingY = self.paddingY or 0

	local width, height = self:LayoutItems(cols, space, borderSize/2, borderSize/2 + paddingY)

	width = max(width + borderSize, 48)
	height = max(height + borderSize + paddingY, 48)

	self:SetHeight(height)
	self:SetWidth(width)
end

function GroupSwapFrame:LayoutItems(cols, space, offX, offY)
    return 15 * cols - space, 15 * cols - space
end

function GroupSwapFrame:GetLayout()
    return self.sets.cols, self.sets.space
end

--[[ Frame Events ]] --

function GroupSwapFrame:OnShow()
    self:Regenerate()
end

function GroupSwapFrame:OnHide()
    self:SetPlayer(UnitName('player'))
end


--[[ Settings Loading ]]--

function GroupSwapFrame:LoadSettings(sets)
	self.sets  = sets

	local r,g,b,a = self:GetBackgroundColor()
	self:SetBackdropColor(r, g, b, a)
	self:SetBackdropBorderColor(1, 1, 1, a)

	self:SetAlpha(sets.alpha or 1)
	self:SetScale(sets.scale or 1)

	self:SetToplevel(sets.topLevel)
	self:SetFrameStrata(sets.strata or DEFAULT_STRATA)
	self:Reposition()

	if not self:IsUserPlaced() then
		self:SetPoint('CENTER')
	end
end

--[[ positioning ]]--

function GroupSwapFrame:Lock(enable)
	self.sets.lock = enable or nil
end

function GroupSwapFrame:IsLocked()
	return self.sets.lock
end

function GroupSwapFrame:Reposition()
	local x, y, scale, parentScale = self:GetPosition()

	if x and y then
		local parent = self:GetParent()

		local ratio
		if parentScale then
			ratio = parentScale / parent:GetScale()
		else
			ratio = 1
		end

		self:ClearAllPoints()
		self:SetScale(scale)
		self:SetPoint('TOPLEFT', parent, 'BOTTOMLEFT', x * ratio, y * ratio)
		self:SetUserPlaced(true)
	else
		self:SetUserPlaced(false)
		if not self:IsUserPlaced() then
			self:SetPoint('CENTER')
		end
	end
end

function GroupSwapFrame:SavePosition()
	local sets = self.sets
	if sets then
		sets.x = self:GetLeft()
		sets.y = self:GetTop()
		sets.scale = self:GetScale()
		sets.parentScale = self:GetParent():GetScale()
	end
end

function GroupSwapFrame:GetPosition()
	local sets = self.sets
	if sets then
		return sets.x, sets.y, sets.scale, sets.parentScale
	end
end

--[[ coloring ]]--

function GroupSwapFrame:GetBackgroundColor()
	local bg = self.sets.bg
	return bg.r, bg.g, bg.b, bg.a
end

function GroupSwapFrame:SetBackgroundColor(r, g, b, a)
	local bg = self.sets.bg
	bg.r = r; bg.g = g; bg.b = b; bg.a = a
	
	self:SetBackdropColor(r, g, b, a)
	self:SetBackdropBorderColor(1, 1, 1, a)
end


--[[ title ]]--

function GroupSwapFrame:SetTitleText(text)
	self.titleText = text
	self:UpdateTitleText()
end

function GroupSwapFrame:UpdateTitleText()
	self.title:SetText(self:GetTitleText())
end

function GroupSwapFrame:GetTitleText()
	return format(self.titleText or self:GetName(), self:GetPlayer())
end