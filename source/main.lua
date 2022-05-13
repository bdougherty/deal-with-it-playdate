import "CoreLibs/graphics"
import "CoreLibs/sprites"
import "CoreLibs/timer"
import "CoreLibs/ui"
import "CoreLibs/crank"

local gfx <const> = playdate.graphics

local maxGlasses = 68
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

function playdate.update()
	local ticks = playdate.getCrankTicks(12)

	if ticks ~= 0 then
		local newY = math.max(glasses.y + ticks * 2, 0 - glasses.height)
		glasses:moveTo(glasses.x, math.min(newY, maxGlasses))
	end

	if glasses.y >= maxGlasses then
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
