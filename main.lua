require "lib.gooi"
require "pixelfunctions"
dp = love.window.toPixels
fd = love.window.fromPixels
lg = love.graphics
nB = gooi.newButton
sw, sh = lg.getDimensions()
--a, focus = 0, 0
--isvis = false
require "styles"
Camera = require"lib.hump.camera"
--showfilemenu = false
showgrid = true
showAlphaBG = true
Timer = require"lib.hump.timer"
require "guifunctions"
require "colorpicker"
require "toolbar"
function love.load()
	history = {}
	lg.setFont(fonts.rr)
	love.graphics.setDefaultFilter("nearest")
	lg.setBackgroundColor(150, 150, 150)
	newdata = love.image.newImageData(32, 32)
	camera = Camera(newdata:getWidth()/2, newdata:getHeight()/2, 4)
	--newdata:mapPixel(pixelFunction.allwhite)
	currentimage = love.graphics.newImage(newdata)
	palettedata = love.image.newImageData("palettes/todayland.png")
	paletteImage = love.graphics.newImage(palettedata)
	paletteCamera = Camera(0,0)
	paletteCamera:zoomTo(dp(22))
	alphaBG = love.graphics.newImage("bg.png")
	alphaBG:setWrap("repeat")
	updateAlphaQuad()
	alphaCamera = Camera(newdata:getWidth(), newdata:getHeight())
	local cx, cy = paletteCamera:worldCoords(sw - dp(4), sh)
	local wx, wy = paletteCamera:worldCoords(0, dp(48))
	paletteCamera:lookAt(paletteImage:getWidth() - cx, (-wy))
	candraw = true
	currentcolor = {0, 0, 0, 255}
	gui.load()
	colorpicker.load()
	toolbar.load()
	table.insert(history, 1, newdata:encode("png"))
	--currentimage:setWrap("repeat")
	imgx, imgy = 0, 0
	xamm = 0
	yamm = 0
	imgQuad = love.graphics.newQuad(0, 0, newdata:getWidth(), newdata:getHeight(), newdata:getWidth(), newdata:getHeight())
end

function love.update(dt)
	Timer.update(dt)
	if zoomslider.value <= 0.01 then
		camera:zoomTo(1)
		alphaCamera:zoomTo(.5)
	else
		camera:zoomTo(zoomslider.value *dp(50))
		alphaCamera:zoomTo(zoomslider.value *dp(25))
	end
	gooi.update(dt)
	do
		local c = colorpicker
		if colorpicker.enabled then
			colorpicker.colorbox.bgColor = {c.rslider.value * 255, c.gslider.value * 255, c.bslider.value * 255}
		end
	end
	cp.bgColor = currentcolor
	
	if tool ~= none then
		tool.bgColor = colors.secondary --sets currently selected tools background to colors.secondary
	end
	
	for i, v in pairs(tools) do
		if tool ~= v then
			v.bgColor = colors.primary
		end
	end
	
	if pencilSlider ~= nil then
		pencilSize = pencilSlider.value
	end
	
	showgrid = menus.viewMenu.components.gridCheck.checked
end

function love.draw()
	lg.setColor(255, 255, 255)
	
	alphaCamera:attach()
	lg.draw(alphaBG, alphaQuad, 0, 0)
	alphaCamera:detach()
	
	camera:attach()
	--lg.draw(currentimage, 0, 0)
	lg.draw(currentimage, imgQuad, 0, 0)
	camera:detach()
	
	drawGrid(1, 1, {0, 0, 0, 50})
	drawGrid(8, 8, {255, 0, 0, 250})
	drawGrid(16, 16, {0, 0, 255, 250})
	lg.setColor(255, 255, 255)
	paletteCamera:attach()
	lg.draw(paletteImage, 0, 0)
	paletteCamera:detach()
	drawPaletteGrid(colors.black)
	lg.setColor(colors.primary)
	lg.rectangle("fill", 0, 0, sw, dp(44)) --top bar
	gooi.draw()
	gooi.draw("fileMenu")
	gooi.draw("saveMenu")
	gooi.draw("viewMenu")
	gooi.draw("newFileMenu")
	gooi.draw("colorpicker")
	lg.setColor(255, 255, 255)
	lg.print(tostring(xamm)..tostring(yamm), 0, sh - 50)
end

function love.touchpressed(id, x, y)
	gooi.pressed(id, x, y)
	touchx, touchy = camera:worldCoords(x, y)
	if y <= dp(46) or y >= undo.y or x <= dp(44) or gui.checkOpenMenus() or fileBrowser ~= nil or colorpicker.enabled then candraw = false
	elseif y > dp(46) or x > dp(44) then candraw = true
	end
	local palx, paly = paletteCamera:worldCoords(x, y)
	if palx >= 0 and palx <= paletteImage:getWidth() and paly >= 0 and paly <= paletteImage:getHeight() then
		candraw = false
		currentcolor = {palettedata:getPixel(palx, paly)}
	end
	
	drawFunctions()
	currentimage:refresh()
end
h = 0
function love.touchreleased(id, x, y)
	gooi.released(id, x, y)
	if candraw and touchx >= 0 and touchx <= newdata:getWidth() and touchy >= 0 and touchy <= newdata:getHeight() and tool ~= tools.pan and tool ~= none then
	--history[#history + 1] = newdata:encode("png")
	table.insert(history, #history + 1, newdata:encode("png"))
		if #history >= 10 then 
			table.remove(history, 1) 
		end
	h = #history
	end
	if tool == tools.move and x > dp(46) and candraw then
		imgQuad:setViewport(0, 0, 32, 32)
		newdata:mapPixel(pixelFunction.allwhite)
		pastedata = love.image.newImageData(history[h])
		newdata:paste(pastedata, xamm, yamm, 0, 0, 32, 32)
		xamm, yamm = 0, 0
	else
	end
	touchx, touchy = nil, nil
	currentimage:refresh()
end

local ql, qr, qu, qd = 0, 0, 0, 0
function love.touchmoved(id, x, y)
	gooi.moved(id, x, y)
	if tool ~= tools.pan and tool ~= tools.move then
		touchx, touchy = camera:worldCoords(x, y)
	elseif tool == tools.pan and y > dp(46) then
		local newtouchx, newtouchy = camera:worldCoords(x, y)
		camera:move(touchx - newtouchx, touchy - newtouchy)
		alphaCamera:move((touchx-newtouchx)*2, (touchy - newtouchy)*2)
	end
	if tool == tools.move and y > dp(46) then
		
		local newtouchx, newtouchy = camera:worldCoords(x, y)
		
		imgQuad:setViewport(math.ceil(touchx - newtouchx), math.ceil(touchy - newtouchy), 32, 32)
		xamm = (math.ceil(touchx - newtouchx) * -1)
		yamm = (math.ceil(touchy - newtouchy) * -1)
		--imgQuad:setViewport(xamm * -1, yamm * - 1, 32, 32)
		--gui.toast("x: "..tostring(xamm).." y: "..tostring(yamm))
		--touchx = touchx - newtouchx
		
		
	end
	 drawFunctions()
	 currentimage:refresh()
end

function love.textinput(text)
	gooi.textinput(text)
end

function love.keypressed(key)
	gooi.keypressed(key)
end

function drawGrid(xsize, ysize, color)
	if showgrid then
		love.graphics.setColor(color)
		love.graphics.setLineWidth(dp(1))
		for i = xsize, (currentimage:getWidth() - 1), xsize do
			local x, y = camera:cameraCoords(i, 0)
			local x2, y2 = camera:cameraCoords(i, currentimage:getHeight())
			love.graphics.line(x, y, x2, y2)
		end
		for i = ysize, (currentimage:getHeight() - 1), ysize do
			local x, y = camera:cameraCoords(0, i)
			local x2, y2 = camera:cameraCoords(currentimage:getWidth(), i)
			love.graphics.line(x, y, x2, y2)
		end
	end
end

function drawPaletteGrid(color)
		love.graphics.setColor(color)
		love.graphics.setLineWidth(dp(3))
		for i = 0, (paletteImage:getWidth()) do
			local x, y = paletteCamera:cameraCoords(i, 0)
			local x2, y2 = paletteCamera:cameraCoords(i, paletteImage:getHeight())
			love.graphics.line(x, y, x2, y2)
		end
		for i = 0, (paletteImage:getHeight()) do
			local x, y = paletteCamera:cameraCoords(0, i)
			local x2, y2 = paletteCamera:cameraCoords(paletteImage:getWidth(), i)
			love.graphics.line(x, y, x2, y2)
		end
		
end

function updateAlphaQuad()
	alphaQuad = love.graphics.newQuad(0, 0, (newdata:getWidth() * 2), (newdata:getHeight() * 2), 2, 2)
end