tmath = require "tmath"
require "lib.gooi"
require "pixelfunctions"
dp = love.window.toPixels
fd = love.window.fromPixels
lg = love.graphics
nB = gooi.newButton
sw, sh = lg.getDimensions()
require "styles"
Camera = require"lib.hump.camera"
showgrid = true
showAlphaBG = true
isTouch = false
Timer = require"lib.hump.timer"
require "lib.copytable"
require "guifunctions"
require "colorpicker"
require "toolbar"
serialize = require "lib.ser"
--tmath = require "tmath"
function love.load()
	grids = {}
	table.insert(grids, {1, 1, gridcolors.black, true, 1})
	table.insert(grids, {8, 8, gridcolors.red, true, .1})
	table.insert(grids, {16, 16, gridcolors.blue, true, 1})
	love.filesystem.createDirectory("palettes/")
	touches = {}
	history = {}
	lg.setFont(fonts.rr)
	love.graphics.setDefaultFilter("nearest")
	lg.setBackgroundColor(120, 120, 140)
	Frames = {{love.image.newImageData(32, 32)}}
	currentFrame = Frames[1]
	currentData = currentFrame[1]
	currentLayer = 1
	FrameImages = {{love.graphics.newImage(currentData)}}
	camera = Camera(currentData:getWidth()/2, currentData:getHeight()/2, 4)
	currentimage = FrameImages[1][1]
	loadPalette("palettes/todayland.png")
	alphaBG = love.graphics.newImage("bg.png")
	alphaBG:setWrap("repeat")
	updateAlphaQuad()
	alphaCamera = Camera(currentData:getWidth(), currentData:getHeight())
	candraw = true
	currentcolor = {0, 0, 0, 255}
	gui.load()
	colorpicker.load()
	--toolbar.load()
	table.insert(history, 1, currentData:encode("png"))
	imgx, imgy = 0, 0
	xamm = 0
	yamm = 0
	imgQuad = love.graphics.newQuad(0, 0, currentData:getWidth(), currentData:getHeight(), currentData:getWidth(), currentData:getHeight())
	gridCanvas = love.graphics.newCanvas()
	--shapeCanvas = love.graphics.newCanvas(currentData:getWidth(), currentData:getHeight())
	isPlaying = false
	firstStroke = false
	--loadDSF("yeasss.lua")
end

function love.update(dt)
	Timer.update(dt)
	if menuBar.components.zoomslider.value <= 0.01 then
		camera:zoomTo(1)
		alphaCamera:zoomTo(.5)
	else
		camera:zoomTo(menuBar.components.zoomslider.value *80)
		alphaCamera:zoomTo(menuBar.components.zoomslider.value *40)
	end
	
	if menus.viewMenu.components.gridCheck.checked then
		lg.setCanvas(gridCanvas)
		lg.clear()
		for i, v in pairs(grids) do
			drawGrid(grids[i][1], grids[i][2], grids[i][3], grids[i][4], grids[i][5])
		end
		lg.setCanvas()
		for i, v in pairs(FrameImages[FrameSpinner.value]) do
			v:refresh()
		end
	end
	
	
	gooi.update(dt)
	gui.update(dt)
	colorpicker.update(dt)
	cp.bgColor = currentcolor
	toolbar.update(dt)
	currentFrame = Frames[FrameSpinner.value]
	showgrid = menus.viewMenu.components.gridCheck.checked
	currentLayer = LayerSpinner.value
	currentData = currentFrame[LayerSpinner.value]
	currentimage = FrameImages[FrameSpinner.value][LayerSpinner.value]
	currentFrame = Frames[FrameSpinner.value]
	PlayAnimation(dt)
end

function love.draw()
	lg.setColor(255, 255, 255)
	
	if menus.viewMenu.components.alphaBgCheck.checked then
	alphaCamera:attach()
	lg.draw(alphaBG, alphaQuad, 0, 0)
	alphaCamera:detach()
	end
	
	lg.setColor(255, 255, 255, 255)
	camera:attach()
	for i, v in pairs(currentFrame) do
		if i < currentLayer then
			lg.draw(FrameImages[FrameSpinner.value][i], 0, 0)
		elseif i > currentLayer then
			lg.draw(FrameImages[FrameSpinner.value][i], 0, 0)
		end
	end
	lg.draw(currentimage, imgQuad, 0, 0)
	camera:detach()
	
	if showgrid then
		lg.draw(gridCanvas)
	end
	lg.setColor(255, 255, 255)
	paletteCamera:attach()
	lg.draw(paletteImage, 0, 0)
	paletteCamera:detach()
	drawPaletteGrid(colors.black)
	--lg.setColor(colors.primary)
	--lg.rectangle("fill", 0, 0, sw, dp(44))
	gooi.draw()
	do local zs = menuBar.components.zoomslider
		lg.setColor(colors.white)
		lg.setLineWidth(2)
		lg.line(zs.x, zs.y + dp(4), zs.x, zs.h - dp(4))
		lg.line(zs.x + zs.w, zs.y + dp(4), zs.x + zs.w, zs.h - dp(4))
	end
	gooi.draw("toolbar")
	gooi.draw("fileMenu")
	gooi.draw("saveMenu")
	gooi.draw("viewMenu")
	gooi.draw("optionsMenu")
	gooi.draw("newFileMenu")
	gooi.draw("colorpicker")
	gooi.draw("paletteManager")
	gooi.draw("gridManager")
	gooi.draw("layerMenu")
	gooi.draw("frameMenu")
	lg.setColor(0, 0, 0, 255)

	--[[
	if touchx and touchy then
	lg.setFont(fonts.rr)
	lg.print(touchx.."\n"..touchy, sw/2, sh/2)
	end
	lg.setColor(255, 255, 255)
	
	--love.graphics.print("Current FPS: "..tostring(love.timer.getFPS( )), 10, 10)
	lg.setColor(0, 0, 0)
	lg.rectangle("fill", sw - 250, sh - 200, 250, 200)
	lg.setColor(255, 255, 255)
	lg.print(
	"currentLayer: "..currentLayer.."\n"..
	tostring(currentData)
	
	, sw - 250, sh - 200)
	--]]
end

function love.mousepressed(x, y, button, isTouch)
	isTouch = false
	firstStroke = true
	gooi.pressed()
	coordx, coordy = camera:worldCoords(math.ceil(x), math.ceil(y))
	if y <= dp(36) or y >= undo.y or x <= dp(44) or gui.checkOpenMenus() or fileBrowser ~= nil or colorpicker.enabled then 
		candraw = false
	elseif y > dp(46) or x > dp(44) then 
		candraw = true
	end
	local palx, paly = paletteCamera:worldCoords(x, y)
	if palx >= 0 and palx <= paletteImage:getWidth() and paly >= 0 and paly <= paletteImage:getHeight() then
		candraw = false
		if not colorpicker.enabled then
			currentcolor = {palettedata:getPixel(palx, paly)}
			colorpicker.updateSliders()
		else
			colorpicker.rslider.value, colorpicker.gslider.value, colorpicker.bslider.value = palettedata:getPixel(palx, paly)
			colorpicker.rslider.value = colorpicker.rslider.value / 255
			colorpicker.gslider.value = colorpicker.gslider.value / 255
			colorpicker.bslider.value = colorpicker.bslider.value / 255
		end
	end
	
	drawFunctions()
	currentimage:refresh()
	for i, v in pairs(FrameImages[FrameSpinner.value]) do
		v:refresh()
	end
end

function love.mousereleased(x, y, button, isTouch)
	gooi.released()
	if coordx ~= nil and coordy ~= nil then
		if candraw and coordx >= 0 and coordx <= currentData:getWidth() and coordy >= 0 and coordy <= currentData:getHeight() and tool ~= tools.pan and tool ~= none or tool == tools.move then
  			table.insert(history, #history + 1, currentData:encode("png"))
			if #history >= 10 then 
				table.remove(history, 1) 
			end
		h = #history
		end
	end
	
	if tool == tools.move and candraw then
		imgQuad:setViewport(0, 0, currentData:getWidth(), currentData:getHeight())
		currentData:mapPixel(pixelFunction.allwhite)
		pastedata = love.image.newImageData(history[h])
		currentData:paste(pastedata, xamm, yamm, 0, 0, pastedata:getWidth(), pastedata:getHeight())
		xamm, yamm = 0, 0
	else
	end
	
	currentimage:refresh()
end

function love.mousemoved(x, y, dx, dy, isTouch)
	mouseDown = love.mouse.isDown(1)
	gooi.moved()
	if tool ~= tools.pan and tool ~= tools.move then
		coordx, coordy = camera:worldCoords(math.ceil(x), math.ceil(y))
	elseif candraw and tool == tools.pan and y > dp(46) and mouseDown == true then
		local newcoordx, newcoordy = camera:worldCoords(math.ceil(x), math.ceil(y))
		camera:move(coordx - newcoordx, coordy - newcoordy)
		alphaCamera:move((coordx-newcoordx)*2, (coordy - newcoordy)*2)
	end
	if candraw and tool == tools.move and y > dp(46) and mouseDown == true then
		
		local newcoordx, newcoordy = camera:worldCoords(math.ceil(x), math.ceil(y))
		xamm = (math.ceil(coordx - newcoordx) * -1)
		yamm = (math.ceil(coordy - newcoordy) * -1)
		imgQuad:setViewport(xamm * -1, yamm * - 1, currentData:getWidth(), currentData:getHeight())
	end
	
	if mouseDown == true then
	 	drawFunctions()
	 	firstStroke = false
	end
	currentimage:refresh()

end

function love.touchpressed(id, x, y)
	isTouch = true
	table.insert(touches, #touches + 1, id)
	gooi.pressed(id, x, y)
	if id == touches[1] then
	touchx, touchy = camera:worldCoords(math.ceil(x), math.ceil(y))
	end
	if y <= dp(36) or y >= undo.y or x <= dp(44) or gui.checkOpenMenus() or fileBrowser ~= nil or colorpicker.enabled then candraw = false
	elseif y > dp(46) or x > dp(44) then candraw = true
	end
	local palx, paly = paletteCamera:worldCoords(x, y)
	if palx >= 0 and palx <= paletteImage:getWidth() and paly >= 0 and paly <= paletteImage:getHeight() then
		candraw = false
		if not colorpicker.enabled then
		currentcolor = {palettedata:getPixel(palx, paly)}
		colorpicker.updateSliders()
		else
		colorpicker.rslider.value, colorpicker.gslider.value, colorpicker.bslider.value = palettedata:getPixel(palx, paly)
		colorpicker.rslider.value = colorpicker.rslider.value / 255
		colorpicker.gslider.value = colorpicker.gslider.value / 255
		colorpicker.bslider.value = colorpicker.bslider.value / 255
		end
	end
	drawFunctions()
	currentimage:refresh()
	for i, v in pairs(FrameImages[FrameSpinner.value]) do
		v:refresh()
	end
end
h = 0
function love.touchreleased(id, x, y)
	
	gooi.released(id, x, y)
	if touchx ~= nil and touchy ~= nil then
		if candraw and touchx >= 0 and touchx <= currentData:getWidth() and touchy >= 0 and touchy <= currentData:getHeight() and tool ~= tools.pan and tool ~= none or tool == tools.move then
			table.insert(history, #history + 1, currentData:encode("png"))
			if #history >= 10 then 
				table.remove(history, 1) 
			end
		h = #history
		end
	end
	
	if tool == tools.move and candraw then
		imgQuad:setViewport(0, 0, currentData:getWidth(), currentData:getHeight())
		currentData:mapPixel(pixelFunction.allwhite)
		pastedata = love.image.newImageData(history[h])
		currentData:paste(pastedata, xamm, yamm, 0, 0, pastedata:getWidth(), pastedata:getHeight())
		xamm, yamm = 0, 0
	else
	end
	
	if touches[1] == id then
	touchx, touchy = nil, nil
	end
	
	for i, v in pairs(touches) do
		if id == v then touches[i] = nil end
	end
	
	currentimage:refresh()
end

local ql, qr, qu, qd = 0, 0, 0, 0
function love.touchmoved(id, x, y)
	gooi.moved(id, x, y)
	if tool ~= tools.pan and tool ~= tools.move and id == touches[1] then
		touchx, touchy = camera:worldCoords(math.ceil(x), math.ceil(y))
	elseif candraw and tool == tools.pan and y > dp(46) and id == touches[1] then
		local newtouchx, newtouchy = camera:worldCoords(math.ceil(x), math.ceil(y))
		camera:move(touchx - newtouchx, touchy - newtouchy)
		alphaCamera:move((touchx-newtouchx)*2, (touchy - newtouchy)*2)
	end
	if candraw and tool == tools.move and y > dp(46) and id == touches[1] then
		
		local newtouchx, newtouchy = camera:worldCoords(math.ceil(x), math.ceil(y))
		xamm = (math.ceil(touchx - newtouchx) * -1)
		yamm = (math.ceil(touchy - newtouchy) * -1)
		imgQuad:setViewport(xamm * -1, yamm * - 1, currentData:getWidth(), currentData:getHeight())
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

function drawGrid(xsize, ysize, color, enabled, thickness)
		love.graphics.setColor(color)
		love.graphics.setLineWidth(thickness)
		for i = xsize, (currentimage:getWidth() - 1), xsize do
			if enabled then
			local x, y = camera:cameraCoords(i, 0)
			local x2, y2 = camera:cameraCoords(i, currentimage:getHeight())
			love.graphics.line(x, y, x2, y2)
			end
		end
		
		for i = ysize, (currentimage:getHeight() - 1), ysize do
			if enabled then
			local x, y = camera:cameraCoords(0, i)
			local x2, y2 = camera:cameraCoords(currentimage:getWidth(), i)
			love.graphics.line(x, y, x2, y2)
			end
		end
end

function loadPalette(path)
	palettedata = love.image.newImageData(path)
	paletteImage = love.graphics.newImage(palettedata)
	paletteCamera = Camera(0,0)
	paletteCamera:zoomTo(dp(22))
	local cx, cy = paletteCamera:worldCoords(sw - dp(4), sh)
	local wx, wy = paletteCamera:worldCoords(0, dp(40))
	paletteCamera:lookAt(paletteImage:getWidth() - cx, (-wy))
end

function drawPaletteGrid(color)
		love.graphics.setColor(color)
		love.graphics.setLineWidth(dp(2))
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
	alphaQuad = love.graphics.newQuad(0, 0, (Frames[1][1]:getWidth() * 2), (Frames[1][1]:getHeight() * 2), 8, 8)
end