toolbar = {}
local tb = toolbar
icpath = "icons/white/ic_"
function toolbar.load()
	options = {}
	showingPencilSlider = false
	pencilSize = 1
	tools = {
	pencil = gooi.newButton():setIcon(icpath.."pencil.png")
	:onRelease(function(self)
		gui.toast("Pencil Tool")
		
		tool = tools.pencil
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
	toolbar.layout = gooi.newPanel(dp(2), dp(38), dp(46*2), dp(46*3), "grid 3x2")
	end
	toolbar.layout:add(tools.pencil, tools.eraser, tools.eyedropper, tools.fill, tools.move, tools.pan)
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
end
function drawFunctions()
	local xmirror, ymirror = menus.optionsMenu.components.xmirror.checked, menus.optionsMenu.components.ymirror.checked
	local w = currentData:getWidth()
	local cx = w/2
	local px = tmath.distanceFromCenter(touchx, w)
	local h = currentData:getHeight()
	local cy = h/2
	local py = tmath.distanceFromCenter(touchy, h)
	 if candraw and touchx ~= nil and touchx >= 0 and touchx <= currentimage:getWidth() and touchy >=0 and touchy <= currentimage:getHeight() then
		--coordlabel.text = "x: " .. touchx
		if tool == tools.pencil then
			if pencilSize == 1 then
				local color = currentcolor
				if xmirror and not ymirror then
					currentData:setPixel(px + cx, touchy, color)
					currentData:setPixel(cx - px, touchy, color)
				elseif ymirror and not xmirror then
					currentData:setPixel(touchx, py + cy, color)
					currentData:setPixel(touchx, cy - py, color)
				elseif xmirror and ymirror then
					currentData:setPixel(px + cx, py + cy, color)
					currentData:setPixel(px + cx, cy - py, color)
					currentData:setPixel(cx - px, cy - py, color)
					currentData:setPixel(cx - px, py + cy, color)
				else
				currentData:setPixel(touchx, touchy, color)
				end
			elseif pencilSize ~= 1 then
				biggerPencil(touchx, touchy, pencilSize, currentcolor)
			end
		elseif tool == tools.eraser then
			local color = {0, 0, 0, 0}
				if xmirror and not ymirror then
					currentData:setPixel(px + cx, touchy, color)
					currentData:setPixel(cx - px, touchy, color)
				elseif ymirror and not xmirror then
					currentData:setPixel(touchx, py + cy, color)
					currentData:setPixel(touchx, cy - py, color)
				elseif xmirror and ymirror then
					currentData:setPixel(px + cx, py + cy, color)
					currentData:setPixel(px + cx, cy - py, color)
					currentData:setPixel(cx - px, cy - py, color)
					currentData:setPixel(cx - px, py + cy, color)
				else
				currentData:setPixel(touchx, touchy, color)
				end
		elseif tool == tools.eyedropper then
			currentcolor = {currentData:getPixel(touchx, touchy)}
		elseif tool == tools.fill then
			targetcolor = currentData:getPixel(touchx, touchy)
			if currentData:getPixel(touchx, touchy) ~= currentcolor then
			floodFill(touchx, touchy, targetcolor, currentcolor)
			end
		--else
		end
	--elseif touchx == nil then
		--coordlabel.text = "x: "
	end
end