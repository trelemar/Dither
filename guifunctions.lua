gui = {}

function gui.load()
	gooi.desktopMode()
	gooi.setStyle(raisedbutton)
	zoomslider = gooi.newSlider({w = dp(122), h = dp(36), value = 0.1})
	redo = nB({text = "REDO", w = dp(112), h = dp(36)}):setIcon("icons/white/ic_redo_variant.png"):setOrientation("right")
	undo = nB({text = "UNDO", x = dp(112), y = dp(16), w = dp(112), h = dp(36)}):setIcon("icons/white/ic_undo_variant.png"):setOrientation("right")
	gooi.setStyle(flatbutton)
	file = nB("FILE", 0, 0, dp(88), dp(36)):onRelease(function() gui.toggleFileMenu() end)
	options = nB("OPTIONS", 0, 0, dp(88), dp(36))--:setIcon("icons/black/ic_cog.png")
	edit = nB("EDIT", 0, 0, dp(88), dp(36))
	view = nB("VIEW", 0, 0, dp(88), dp(36))
	glo = gooi.newPanel(0, 0, sw, sh, "game")
	glo:add(redo, "b-r") glo:add(undo, "b-r") glo:add(options, "t-r")
	glo:add(file, "t-l") glo:add(edit, "t-l") glo:add(view, "t-l")
	--coordlabel = gooi.newLabel({w = dp(88), orientation = "left"})
	--glo:add(coordlabel, "b-l")
	glo:add(zoomslider, "t-r")
	glo:add(gooi.newLabel("ZOOM:"), "t-r")


	filemenu = gooi.newPanel(sw/8 * 3, sh/4, sw/8 * 2, sh/2, "grid 6x1")
	gooi.setStyle(header)
	filemenu:add(gooi.newLabel("File"):setOrientation("center"):setGroup("filemenu"), "1,1")
	gooi.setStyle(list)
	filemenu:add(gooi.newButton("New File"):setOrientation("right"):setIcon("icons/black/ic_plus.png"):setGroup("filemenu")
	:onRelease(function()
		gooi.setStyle(dialog)
		gooi.confirm("Start a new file?", function() newdata:mapPixel(pixelFunction.allwhite) gui.toggleFileMenu() end)
		--gui.toggleFileMenu()
		--newdata:mapPixel(pixelFunction.allwhite) 
	end), "2,1")
	filemenu:add(gooi.newButton({text = "Open File"}):setOrientation("right"):setIcon("icons/black/ic_file.png"):setGroup("filemenu"), "3,1")
	save = nB("Save File"):setOrientation("right"):setIcon("icons/black/ic_content_save.png"):setGroup("filemenu")
	:onRelease(function()
		filedata = newdata:encode("png", "test2.png")
		success = love.filesystem.write("test.png", filedata)
		if success then gooi.setStyle(dialog) gooi.alert("Save Successful!") gui.toggleFileMenu() end
	end)
	filemenu:add(save, "4,1")
	gooi.setGroupVisible("filemenu", isvis)
	gooi.setStyle(raisedbutton)
	cp = nB({x = sw - dp(46), y = sh/2 - dp(23), w = dp(46), h = dp(46)}):onRelease(function() gui.toggleColorPicker() end)
	cp.bgColor = currentcolor
end 

function gui.toggleFileMenu()
	 showfilemenu = not showfilemenu 
	 isvis = not isvis 
	 gooi.setGroupVisible("filemenu", isvis) 
	 candraw = not candraw
end

function gui.toggleColorPicker()
	showfilemenu = not showfilemenu
	isvis = not isvis
	gooi.setGroupVisible("colorpicker", isvis)
	gooi.setGroupEnabled("colorpicker", isvis)
	candraw = not candraw
end