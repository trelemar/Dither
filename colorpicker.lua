colorpicker = {}

function colorpicker.load()
	colorpicker.enabled = false
	gooi.setStyle(window)
	colorpicker.layout = gooi.newPanel(compactWindowArgs):setOpaque(true):setGroup("colorpicker")
	:setColspan(1, 1, 4)
	:setColspan(2, 1, 2)
	:setColspan(2, 3, 2)
	:setColspan(3, 1, 3)
	:setColspan(4, 1, 3)
	:setColspan(5, 1, 3)
	colorpicker.header = gooi.newLabel({text = "COLOR PICKER", orientation = "center"}):setGroup("colorpicker")
	gooi.setStyle(raisedbutton)
	colorpicker.currentcolorbox = gooi.newLabel():setGroup("colorpicker"):setOpaque(true)
	colorpicker.colorbox = gooi.newLabel():setGroup("colorpicker"):setOpaque(true)
	colorpicker.rslider = gooi.newSlider({text = "R", value=0}):setGroup("colorpicker")
	colorpicker.rslider.bgColor = colors.tertairy
	colorpicker.rtext = gooi.newLabel():setGroup("colorpicker"):setOrientation("center")
	colorpicker.gslider = gooi.newSlider({value = 0}):setGroup("colorpicker")
	colorpicker.gslider.bgColor = colors.secondary
	colorpicker.gtext = gooi.newLabel():setGroup("colorpicker"):setOrientation("center")
	colorpicker.bslider = gooi.newSlider({value = 0}):setGroup("colorpicker")
	colorpicker.bslider.bgColor = colors.quadary
	colorpicker.btext = gooi.newLabel():setGroup("colorpicker"):setOrientation("center")
	colorpicker.confirm = gooi.newButton({text = "CONFIRM"}):setGroup("colorpicker"):setGroup("colorpicker"):onRelease(function() confirmColor() gui.toggleColorPicker() end)

	colorpicker.layout:add(colorpicker.header, "1,1")
	colorpicker.layout:add(colorpicker.currentcolorbox, "2,1")
	colorpicker.layout:add(colorpicker.colorbox, "2,3")
	colorpicker.layout:add(colorpicker.rslider, "3,1")
	colorpicker.layout:add(colorpicker.rtext, "3,4")
	colorpicker.layout:add(colorpicker.gslider, "4,1")
	colorpicker.layout:add(colorpicker.gtext, "4,4")
	colorpicker.layout:add(colorpicker.bslider, "5,1")
	colorpicker.layout:add(colorpicker.btext, "5,4")
	colorpicker.layout:add(colorpicker.confirm, "6,4")
	
	gooi.setGroupVisible("colorpicker", false)
	gooi.setGroupEnabled("colorpicker", false)
end

local c = colorpicker

function confirmColor()
	currentcolor = {c.rslider.value * 255, c.gslider.value * 255, c.bslider.value * 255, 255}
	cp.bgColor = currentcolor
end

function colorpicker.update(dt)
	if colorpicker.enabled then
		colorpicker.colorbox.bgColor = {c.rslider.value * 255, c.gslider.value * 255, c.bslider.value * 255}
		c.rtext.text = math.ceil(c.rslider.value * 255)
		c.gtext.text = math.ceil(c.gslider.value * 255)
		c.btext.text = math.ceil(c.bslider.value * 255)
	end
end

function colorpicker.updateSliders()
	c.rslider.value = currentcolor[1] / 255
	c.gslider.value = currentcolor[2] / 255
	c.bslider.value = currentcolor[3] / 255
	c.currentcolorbox.bgColor = currentcolor
end