require "lib.gooi"
dp = love.window.toPixels
lg = love.graphics
local nB = gooi.newButton
local sw, sh = lg.getDimensions()
local a = 0; local focus = 0
local isvis = false
require "styles"
Camera = require"lib.hump.camera"
touchx = nil
showfilemenu = false
function love.load()
	love.graphics.setDefaultFilter("nearest")
	lg.setBackgroundColor(200, 200, 200)
	gooi.setStyle(raisedbutton)
	zoomslider = gooi.newSlider({w = dp(122), h = dp(36), value = 0.1})
	redo = nB({text = "REDO", w = dp(112), h = dp(36)}):setIcon("icons/white/ic_redo_variant.png"):setOrientation("right")
	undo = nB({text = "UNDO", x = dp(112), y = dp(16), w = dp(112), h = dp(36)}):setIcon("icons/white/ic_undo_variant.png"):setOrientation("right")
	gooi.setStyle(flatbutton)
	file = nB("FILE", 0, 0, dp(88), dp(36)):onPress(function() showfilemenu = not showfilemenu isvis = not isvis gooi.setGroupVisible("filemenu", isvis) candraw = not candraw end)
	options = nB("OPTIONS", 0, 0, dp(88), dp(36))
	
	glo = gooi.newPanel(0, 0, sw, sh, "game")
	glo:add(redo, "b-r") glo:add(undo, "b-r") glo:add(options, "t-r")
	glo:add(file, "t-l")
	coordlabel = gooi.newLabel({w = dp(88), orientation = "left"})
	glo:add(coordlabel, "b-l")
	glo:add(zoomslider, "t-r")

	filemenu = gooi.newPanel(sw/8 * 3, sh/4, sw/8 * 2, sh/2, "grid 6x1")
	gooi.setStyle(header)
	filemenu:add(gooi.newLabel("File"):setOrientation("center"):setGroup("filemenu"), "1,1")
	gooi.setStyle(list)
	filemenu:add(gooi.newButton("New File"):setOrientation("right"):setIcon("icons/black/ic_plus.png"):setGroup("filemenu"), "2,1")
	filemenu:add(gooi.newButton({text = "Open File"}):setOrientation("right"):setIcon("icons/black/ic_file.png"):setGroup("filemenu"), "3,1")
	filemenu:add(nB("Save File"):setOrientation("right"):setIcon("icons/black/ic_file_image.png"):setGroup("filemenu"), "4,1")
	gooi.setGroupVisible("filemenu", isvis)
	newdata = love.image.newImageData(32, 32)
	camera = Camera(newdata:getWidth()/2, newdata:getHeight()/2, 4)
	do
		for i = 0, 31 do
			newdata:setPixel(i, 0, 255, 255, 255, 255)
			for i2 = 0, 31 do
				newdata:setPixel(i, i2, 255, 255, 255, 255)
			end
		end
	end
	currentimage = love.graphics.newImage(newdata)
	currentimage:setFilter("nearest", "nearest")
	candraw = true
	currentcolor = {0, 0, 0, 255}
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
	camera:zoomTo(zoomslider.value *20)
	gooi.update(dt)
end

function love.draw()
	lg.setColor(255, 255, 255)
	camera:attach()
	lg.draw(currentimage, 0, 0)
	camera:detach()
	lg.rectangle("fill", 0, 0, sw, dp(44))
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