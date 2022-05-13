import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics

local maxGlassesY = 68
local reminderDelay = 3000
local crankIndicatorStarted = false
local hasMovedCrank = false

local dogImage = gfx.image.new("images/dog.png")
local glassesImage = gfx.image.new("images/glasses.png")
local dealWithItImage = gfx.image.new("images/deal_with_it.png")

gfx.setBackgroundColor(gfx.kColorWhite)

local dog = gfx.sprite.new(dogImage)
dog:setCenter(0, 0)
dog:moveTo(0, 0)
dog:add()

local glasses = gfx.sprite.new(glassesImage)
glasses:setScale(11)
glasses:moveTo(180, 0 - glasses.height)
glasses:add()

local dealWithIt = gfx.sprite.new(dealWithItImage)
dealWithIt:setScale(5)
dealWithIt:moveTo(200, 210)
dealWithIt:setVisible(false)
dealWithIt:add()

playdate.timer.performAfterDelay(reminderDelay, function()
	playdate.ui.crankIndicator:start()
	crankIndicatorStarted = true
end)

function playdate.cranked()
	hasMovedCrank = true
end

function playdate.upButtonDown()
	hasMovedCrank = true
end

function playdate.downButtonDown()
	hasMovedCrank = true
end

function playdate.update()
	local ticks = playdate.getCrankTicks(12)
	local glassesDeltaY = 0

	if playdate.buttonIsPressed(playdate.kButtonUp) then
		glassesDeltaY = -2
	elseif playdate.buttonIsPressed(playdate.kButtonDown) then
		glassesDeltaY = 2
	elseif ticks ~= 0 then
		glassesDeltaY = ticks * 2
	end

	local glassesNewY = math.max(glasses.y + glassesDeltaY, 0 - glasses.height)
	glasses:moveTo(glasses.x, math.min(glassesNewY, maxGlassesY))
	if glasses.y >= maxGlassesY then
		dealWithIt:setVisible(true)
	else
		dealWithIt:setVisible(false)
	end

	gfx.sprite.update()
	if hasMovedCrank == false and crankIndicatorStarted then
		playdate.ui.crankIndicator:update()
	end
	playdate.timer.updateTimers()
end
