require "lib.gooi"
dp = love.window.toPixels
lg = love.graphics
local nB = gooi.newButton
local sw, sh = lg.getDimensions()
local a = 0; local focus = 0
local isvis = false
require "styles"

showfilemenu = false
function love.load()
	lg.setBackgroundColor(200, 200, 200)
	gooi.setStyle(raisedbutton)
	redo = nB({text = "REDO", w = dp(112), h = dp(36)}):setIcon("icons/white/ic_redo_variant.png"):setOrientation("right")
	undo = nB({text = "UNDO", x = dp(112), y = dp(16), w = dp(112), h = dp(36)}):setIcon("icons/white/ic_undo_variant.png"):setOrientation("right")
	gooi.setStyle(flatbutton)
	file = nB("FILE", 0, 0, dp(88), dp(36)):onPress(function() showfilemenu = not showfilemenu isvis = not isvis gooi.setGroupVisible("filemenu", isvis) end)
	options = nB("OPTIONS", 0, 0, dp(88), dp(36))
	
	glo = gooi.newPanel(0, 0, sw, sh, "game")
	glo:add(redo, "b-r") glo:add(undo, "b-r") glo:add(options, "t-r")
	glo:add(file, "t-l")

	filemenu = gooi.newPanel(sw/8 * 3, sh/4, sw/8 * 2, sh/2, "grid 6x1")
	gooi.setStyle(header)
	filemenu:add(gooi.newLabel("File"):setOrientation("center"):setGroup("filemenu"), "1,1")
	gooi.setStyle(list)
	filemenu:add(gooi.newButton("New File"):setOrientation("right"):setIcon("icons/black/ic_plus.png"):setGroup("filemenu"), "2,1")
	filemenu:add(gooi.newButton({text = "Open File"}):setOrientation("right"):setIcon("icons/black/ic_file.png"):setGroup("filemenu"), "3,1")
	filemenu:add(nB("Save File"):setOrientation("right"):setIcon("icons/black/ic_file_image.png"):setGroup("filemenu"), "4,1")
	gooi.setGroupVisible("filemenu", isvis)
	newdata = love.image.newImageData(32, 32)
	do
		for i = 0, 31 do
			newdata:setPixel(i, 0, 255, 255, 255, 255)
			for i2 = 0, 31 do
				newdata:setPixel(i, i2, 255, 255, 255, 255)
			end
		end
	end
	currentimage = love.graphics.newImage(newdata)
end

function love.update(dt)
	if showfilemenu and a < 255 then
		a = a + 15
		focus = focus + 7.5
	elseif a <= 255 and not showfilemenu and a >= 0 then
		a = a - 15
		focus = focus - 7.5
	end
	gooi.update(dt)
end

function love.draw()
	lg.setColor(255, 255, 255)
	lg.draw(currentimage, (sw/2) -(currentimage:getWidth()/2), (sh/2)-(currentimage:getHeight()/2))
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
end

function love.touchreleased(id, x, y)
	gooi.released(id, x, y)
end

function love.touchmoved(id, x, y)
	gooi.moved(id, x, y)
end