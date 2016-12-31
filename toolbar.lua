toolbar = {}
local tb = toolbar
local icpath = "icons/white/ic_"
function toolbar.load()
	tb.pencil = gooi.newButton():setIcon(icpath.."pencil.png")
	:onPress(function(self) tool = "pencil" end)
	tb.eraser= gooi.newButton():setIcon(icpath.."eraser.png")
	:onPress(function() tool = "eraser" end)
	tb.eyedropper = gooi.newButton():setIcon(icpath.."eyedropper.png")
	:onPress(function() tool = "eyedropper" end)
	
	
	toolbar.layout = gooi.newPanel(0, dp(46), dp(46), dp(276), "grid 6x1")
	tb.layout:add(tb.pencil, "1,1")
	tb.layout:add(tb.eraser, "2,1")
	tb.layout:add(tb.eyedropper, "3,1")
end