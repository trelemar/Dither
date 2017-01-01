colorpicker = {}

function colorpicker.load()
	gooi.setStyle(header)
	colorpicker.header = gooi.newLabel({text = "COLOR PICKER", orientation = "center"}):setGroup("colorpicker")
	gooi.setStyle(raisedbutton)
	colorpicker.colorbox = gooi.newButton():setGroup("colorpicker")
	colorpicker.rslider = gooi.newSlider({text = "R", value=0}):setGroup("colorpicker")
	colorpicker.rslider.bgColor = {100, 0, 0}
	colorpicker.gslider = gooi.newSlider({value = 0}):setGroup("colorpicker")
	colorpicker.gslider.bgColor = {0, 100, 0}
	colorpicker.bslider = gooi.newSlider({value = 0}):setGroup("colorpicker")
	colorpicker.bslider.bgColor = {0, 0, 100}
	colorpicker.confirm = gooi.newButton({text = "CONFIRM"}):setGroup("colorpicker"):setGroup("colorpicker"):onRelease(function() confirmColor() gui.toggleColorPicker() end)
	colorpicker.layout = gooi.newPanel(sw/8 * 3, sh/4, sw/8 * 2, sh/2, "grid 6x1")
	colorpicker.layout:add(colorpicker.header, "1,1")
	colorpicker.layout:add(colorpicker.colorbox, "2,1")
	colorpicker.layout:add(colorpicker.rslider, "3,1")
	colorpicker.layout:add(colorpicker.gslider, "4,1")
	colorpicker.layout:add(colorpicker.bslider, "5,1")
	colorpicker.layout:add(colorpicker.confirm, "6,1")
	
	gooi.setGroupVisible("colorpicker", false)
	gooi.setGroupEnabled("colorpicker", false)
end
	
function confirmColor()
	local c = colorpicker
	currentcolor = {c.rslider.value * 255, c.gslider.value * 255, c.bslider.value * 255}
	cp.bgColor = currentcolor
end