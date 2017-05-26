toolbar = {}
local tb = toolbar
local onMobile = false
icpath = "icons/drawable-"..tmath.getDPI().."/ic_"
function toolbar.load()
	options = {}
	showingPencilSlider = false
	showPixPerfectBtn = false
	usePixelPerfect = false
	pencilSize = 1
	tools = {
	pencil = gooi.newButton():setIcon(icpath.."pencil.png")
	:onRelease(function(self)
		gui.toast("Pencil Tool")

		tool = tools.pencil
		toolbar.pixelPerfectBtn()

		--[[
		if tool == tools.pencil and not showingPencilSlider then
			showingPencilSlider = true
			gooi.setStyle(raisedbutton)
			pencilSlider = gooi.newSpinner({x = self.x + dp(48), y = self.y, w = self.w * 3, h= self.h, min = 1, max = 10, value = pencilSize})
			pencilSlider.bgColor = colors.secondary
		elseif tool == tools.pencil and showingPencilSlider then
			gooi.removeComponent(pencilSlider)
			showingPencilSlider = false
		end
		--]]
	end),
	eraser= gooi.newButton():setIcon(icpath.."eraser.png")
	:onRelease(function(self) gui.toast("Eraser Tool") tool = self end),
	eyedropper = gooi.newButton():setIcon(icpath.."eyedropper.png")
	:onRelease(function(self) gui.toast("Eyedropper") tool = self end),
	fill = gooi.newButton():setIcon(icpath.."fill.png")
	:onRelease(function(self) gui.toast("Flood Fill") tool = self end),
	pan = gooi.newButton():setIcon(icpath.."cursor_move.png")
	:onRelease(function(self) gui.toast("Pan Camera") tool = self end),
	move = gooi.newButton():setIcon(icpath.."cursor_pointer.png")
	:onRelease(function(self) gui.toast("Move") tool = self end)
	}

	for i, v in pairs(tools) do
		v:setGroup("toolbar")
		v:onPress(function() tool = none end)
	end

	toolbar.layout = gooi.newPanel(dp(2), dp(38), dp(46), dp(46*6), "grid 6x1")
	if toolbar.layout.y + toolbar.layout.h > cellWidget.y then
		gooi.removeComponent(toolbar.layout)
		onMobile = true
		toolbar.layout = gooi.newPanel(dp(2), dp(38), dp(46*2), dp(46*3), "grid 3x2")
	end
	toolbar.layout:add(tools.pencil, tools.eraser, tools.eyedropper, tools.fill, tools.move, tools.pan)
end

function toolbar.pixelPerfectBtn()
	self = tools.pencil
	if tool == tools.pencil and not showPixPerfectBtn then
		showPixPerfectBtn = true
		gooi.setStyle(raisedbutton)

		if onMobile then
			gui.toast(toolbar.layout.y .. " " .. toolbar.layout.h .. " " ..cellWidget.y)
			pixPerfectBtn = gooi.newButton({x = self.x + dp(48*2), y = self.y, w = self.w, h = self.h}):setIcon(icpath.."pixelperfect.png")
		else
			gui.toast(toolbar.layout.y .. " " .. toolbar.layout.h .. " " ..cellWidget.y)
			pixPerfectBtn = gooi.newButton({x = self.x + dp(48), y = self.y, w = self.w, h = self.h}):setIcon(icpath.."pixelperfect.png")
		end
		pixPerfectBtn = pixPerfectBtn
		:onRelease(function()
			usePixelPerfect = not usePixelPerfect
			gui.tglSubButtons()
		end)
		gui.tglSubButtons()
	end
end


function toolbar.update(dt)
	if tool ~= none then
		tool.bgColor = colors.secondary --sets currently selected tools backround to colors.secondary
	end

	for i, v in pairs(tools) do
		if tool ~= v then
			v.bgColor = colors.primary
		end
	end

	if pencilSlider ~= nil then
		pencilSize = pencilSlider.value
	end

	if tool ~= tools.pencil then
		gooi.removeComponent(pixPerfectBtn)
		showPixPerfectBtn = false
	end
end

local lastPixX, lastPixY = 0,0
local _lastPixX, _lastPixY = 0,0
function drawFunctions()
	if isTouch == true then coordx = touchx coordy = touchy end
	if #touches == 1 then
		local xmirror, ymirror = menus.optionsMenu.components.xmirror.checked, menus.optionsMenu.components.ymirror.checked
		local w = currentData:getWidth()
		local cx = w/2
		local px = tmath.distanceFromCenter(coordx, w)
		local h = currentData:getHeight()
		local cy = h/2
		local py = tmath.distanceFromCenter(coordy, h)
	end
	 if candraw and coordx ~= nil and coordx >= 0 and coordx < currentimage:getWidth() and coordy >=0 and coordy < currentimage:getHeight() then
		if tool == tools.pencil then
			if pencilSize == 1 then
				color = currentcolor
				if xmirror and not ymirror then
					currentData:setPixel(px + cx, coordy, color)
					currentData:setPixel(cx - px, coordy, color)
				elseif ymirror and not xmirror then
					currentData:setPixel(coordx, py + cy, color)
					currentData:setPixel(coordx, cy - py, color)
				elseif xmirror and ymirror then
					currentData:setPixel(px + cx, py + cy, color)
					currentData:setPixel(px + cx, cy - py, color)
					currentData:setPixel(cx - px, cy - py, color)
					currentData:setPixel(cx - px, py + cy, color)
				else
					coorIntX = math.floor(coordx)
					coorIntY = math.floor(coordy)
					if (usePixelPerfect) then
						pixelPerfect()
					else
						currentData:setPixel(coorIntX,coorIntY,color)
					end
				end
			elseif pencilSize ~= 1 then
				biggerPencil(coordx, coordy, pencilSize, currentcolor)
			end
		elseif tool == tools.eraser then
			local color = {0, 0, 0, 0}
				if xmirror and not ymirror then
					currentData:setPixel(px + cx, coordy, color)
					currentData:setPixel(cx - px, coordy, color)
				elseif ymirror and not xmirror then
					currentData:setPixel(coordx, py + cy, color)
					currentData:setPixel(coordx, cy - py, color)
				elseif xmirror and ymirror then
					currentData:setPixel(px + cx, py + cy, color)
					currentData:setPixel(px + cx, cy - py, color)
					currentData:setPixel(cx - px, cy - py, color)
					currentData:setPixel(cx - px, py + cy, color)
				else
				currentData:setPixel(coordx, coordy, color)
				end
		elseif tool == tools.eyedropper then
			currentcolor = {currentData:getPixel(coordx, coordy)}
		elseif tool == tools.fill then
			targetcolor = {currentData:getPixel(coordx, coordy)}
			floodFill(math.floor(coordx), math.floor(coordy), targetcolor, currentcolor)
		--else
		end
	--elseif touchx == nil then
		--coordlabel.text = "x: "
	end
end