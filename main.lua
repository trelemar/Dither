require "lib.gooi"
require "pixelfunctions"
dp = love.window.toPixels
lg = love.graphics
nB = gooi.newButton
sw, sh = lg.getDimensions()
a = 0; focus = 0
isvis = false
require "styles"
Camera = require"lib.hump.camera"
touchx = nil
showfilemenu = false
require "guifunctions"
require "colorpicker"
function love.load()
	love.graphics.setDefaultFilter("nearest")
	lg.setBackgroundColor(200, 200, 200)
	--gui.load()
	newdata = love.image.newImageData(32, 32)
	camera = Camera(newdata:getWidth()/2, newdata:getHeight()/2, 4)
	newdata:mapPixel(pixelFunction.allwhite)
	currentimage = love.graphics.newImage(newdata)
	candraw = true
	currentcolor = {0, 0, 0, 255}
	gui.load()
	colorpicker.load()
end

function love.update(dt)
	currentimage = love.graphics.newImage(newdata)
	--currentimage:setFilter("nearest", "nearest")
	if candraw and touchx ~= nil and touchx >= 0 and touchx <= currentimage:getWidth() and touchy >=0 and touchy <= currentimage:getHeight() then
		coordlabel.text = "x: " .. touchx
		newdata:setPixel(touchx, touchy, currentcolor)
	elseif touchx == nil then
		coordlabel.text = "x: "
	end
	if showfilemenu and a < 255 then
		a = a + 15
		focus = focus + 7.5
	elseif a <= 255 and not showfilemenu and a >= 0 then
		a = a - 15
		focus = focus - 7.5
	end
	if zoomslider.value <= 0.1 then
		camera:zoomTo(1)
	else
		camera:zoomTo(zoomslider.value *20)
	end
	gooi.update(dt)
end

function love.draw()
	lg.setColor(255, 255, 255)
	camera:attach()
	lg.draw(currentimage, 0, 0)
	camera:detach()
	lg.rectangle("fill", 0, 0, sw, dp(44)) --top bar
	gooi.draw()
	lg.setColor(0, 0, 0, focus)
	lg.rectangle("fill", 0, 0, sw, sh)
		lg.setColor(255, 255, 255, a)
		lg.rectangle("fill", sw/8 * 3, sh/4, sw/8 * 2, sh/2, dp(2), dp(2))
		gooi.draw("filemenu")
	lg.setColor(255, 255, 255)
	--gooi.draw()
end

function love.touchpressed(id, x, y)
	gooi.pressed(id, x, y)
	touchx, touchy = camera:worldCoords(x, y)
end

function love.touchreleased(id, x, y)
	gooi.released(id, x, y)
	touchx = nil
end

function love.touchmoved(id, x, y)
	gooi.moved(id, x, y)
	touchx, touchy = camera:worldCoords(x, y)
end