toolbar = {}
local tb = toolbar
icpath = "icons/white/ic_"
function toolbar.load()
	tools = {}
	options = {}
	showingPencilSlider = false
	pencilSize = 1
	tools.pencil = gooi.newButton():setIcon(icpath.."pencil.png")
	:onRelease(function(self)
		tool = tools.pencil
		if tool == tools.pencil and not showingPencilSlider then
			showingPencilSlider = true
			gooi.setStyle(raisedbutton)
			pencilSlider = gooi.newSpinner({x = self.x + dp(48), y = self.y, w = self.w * 3, h= self.h, min = 1, max = 10, value = pencilSize})
		elseif tool == tools.pencil and showingPencilSlider then
			gooi.removeComponent(pencilSlider)
			showingPencilSlider = false
		end
	end)
	tools.eraser= gooi.newButton():setIcon(icpath.."eraser.png")
	:onRelease(function() tool = tools.eraser end)
	tools.eyedropper = gooi.newButton():setIcon(icpath.."eyedropper.png")
	:onRelease(function() tool = tools.eyedropper end)
	tools.fill = gooi.newButton():setIcon(icpath.."fill.png")
	:onRelease(function() tool = tools.fill end)
	tools.pan = gooi.newButton():setIcon(icpath.."cursor_pointer.png")
	:onRelease(function() tool = tools.pan end)
	
	for i, v in pairs(tools) do
		v:onPress(function() tool = none end)
	end
	
	--[[
	options.grid = gooi.newButton():setIcon(icpath.."grid.png")
	:onRelease(
	  function(self)
	    showgrid = not showgrid
	    if showgrid then self:setIcon(icpath.."grid.png")
	    elseif not showgrid then self:setIcon(icpath.."grid_off.png")
	    end
	  end)
	]]
	toolbar.layout = gooi.newPanel(0, dp(46), dp(46), dp(46*6), "grid 6x1")
	tb.layout:add(tools.pencil, "1,1")
	tb.layout:add(tools.eraser, "2,1")
	tb.layout:add(tools.eyedropper, "3,1")
	tb.layout:add(tools.fill, "4,1")
	tb.layout:add(tools.pan, "5,1")
	--tb.layout:add(options.grid, "6,1")
end