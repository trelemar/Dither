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
showgrid = true
require "guifunctions"
require "colorpicker"
require "toolbar"
function love.load()

	love.graphics.setDefaultFilter("nearest")
	lg.setBackgroundColor(150, 150, 150)
	--gui.load()
	newdata = love.image.newImageData(32, 32)
	camera = Camera(newdata:getWidth()/2, newdata:getHeight()/2, 4)
	newdata:mapPixel(pixelFunction.allwhite)
	currentimage = love.graphics.newImage(newdata)
	candraw = true
	currentcolor = {0, 0, 0, 255}
	gui.load()
	colorpicker.load()
	toolbar.load()
	tool = tools.pencil
end

function love.update(dt)
	currentimage = love.graphics.newImage(newdata)
	if candraw and touchx ~= nil and touchx >= 0 and touchx <= currentimage:getWidth() and touchy >=0 and touchy <= currentimage:getHeight() then
		coordlabel.text = "x: " .. touchx
		if tool == tools.pencil then
			newdata:setPixel(touchx, touchy, currentcolor)
		elseif tool == tools.eraser then
			newdata:setPixel(touchx, touchy, 255, 255, 255)
		elseif tool == tools.eyedropper then
			currentcolor = {newdata:getPixel(touchx, touchy)}
		else
		end
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
		camera:zoomTo(zoomslider.value *50)
	end
	gooi.update(dt)
	do
		local c = colorpicker
	colorpicker.colorbox.bgColor = {c.rslider.value * 255, c.gslider.value * 255, c.bslider.value * 255}
	end
	cp.bgColor = currentcolor
	tool.bgColor = colors.secondary --sets currently selected tools background to red
	for i, v in pairs(tools) do
		if tool ~= v then
			v.bgColor = colors.primary
		end
	end
end

function love.draw()
	lg.setColor(255, 255, 255)
	camera:attach()
	lg.draw(currentimage, 0, 0)
	camera:detach()
	drawGrid()
	lg.setColor(255, 255, 255)
	lg.rectangle("fill", 0, 0, sw, dp(44)) --top bar
	gooi.draw()
	lg.setColor(0, 0, 0, focus)
	lg.rectangle("fill", 0, 0, sw, sh)
		lg.setColor(255, 255, 255, a)
		lg.rectangle("fill", sw/8 * 3, sh/4, sw/8 * 2, sh/2, dp(2), dp(2))
		gooi.draw("filemenu")
		gooi.draw("colorpicker")
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
	if tool ~= tools.pan then
		touchx, touchy = camera:worldCoords(x, y)
	elseif tool == tools.pan then
		newtouchx, newtouchy = camera:worldCoords(x, y)
		camera:move(touchx - newtouchx, touchy - newtouchy)
	end
end

function drawGrid()
if showgrid then
	love.graphics.setColor(0, 0, 255, 50)
	love.graphics.setLineWidth(dp(1))
	for i = 1, (currentimage:getWidth() - 1) do
		local x, y = camera:cameraCoords(i, 0)
		local x2, y2 = camera:cameraCoords(i, currentimage:getHeight())
		love.graphics.line(x, y, x2, y2)
	end
	for i = 1, (currentimage:getHeight() - 1) do
		local x, y = camera:cameraCoords(0, i)
		local x2, y2 = camera:cameraCoords(currentimage:getWidth(), i)
		love.graphics.line(x, y, x2, y2)
	end
end
end