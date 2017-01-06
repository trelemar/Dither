colorpicker = {}

function colorpicker.load()
	colorpicker.enabled = false
	gooi.setStyle(window)
	colorpicker.layout = gooi.newPanel(defWindowArgs):setOpaque(true):setGroup("colorpicker")
	gooi.setStyle(raisedbutton)
	colorpicker.header = gooi.newLabel({text = "COLOR PICKER", orientation = "center"}):setGroup("colorpicker")
	colorpicker.colorbox = gooi.newLabel():setGroup("colorpicker"):setOpaque(true)
	colorpicker.rslider = gooi.newSlider({text = "R", value=0}):setGroup("colorpicker")
	colorpicker.rslider.bgColor = {200, 0, 0}
	colorpicker.gslider = gooi.newSlider({value = 0}):setGroup("colorpicker")
	colorpicker.gslider.bgColor = {0, 200, 0}
	colorpicker.bslider = gooi.newSlider({value = 0}):setGroup("colorpicker")
	colorpicker.bslider.bgColor = {0, 0, 200}
	colorpicker.confirm = gooi.newButton({text = "CONFIRM"}):setGroup("colorpicker"):setGroup("colorpicker"):onRelease(function() confirmColor() gui.toggleColorPicker() end)

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