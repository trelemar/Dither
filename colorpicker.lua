colorpicker = {}

function colorpicker.load()
	gooi.setStyle(raisedbutton)
	colorpicker.rslider = gooi.newSlider({text = "R", value=1}):setGroup("colorpicker")
	colorpicker.layout = gooi.newPanel(sw/8 * 3, sh/4, sw/8 * 2, sh/2, "grid 6x1")
	colorpicker.layout:add(colorpicker.rslider, "3,1")
	
	gooi.setGroupVisible("colorpicker", false)
	gooi.setGroupEnabled("colorpicker", false)
	end