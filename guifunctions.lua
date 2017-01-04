gui = {}

function gui.load()
	gooi.desktopMode()
	gooi.setStyle(raisedbutton)
	zoomslider = gooi.newSlider({w = dp(122), h = dp(36), value = 0.1})
	redo = nB({text = "REDO", w = dp(112), h = dp(36)}):setIcon("icons/white/ic_redo_variant.png"):setOrientation("right")
	undo = nB({text = "UNDO", x = dp(112), y = dp(16), w = dp(112), h = dp(36)}):setIcon("icons/white/ic_undo_variant.png"):setOrientation("right")
	gooi.setStyle(flatbutton)
	file = nB("FILE", 0, 0, dp(60), dp(36)):onRelease(function() gui.toggleFileMenu() end):setOrientation("left")
	options = nB("OPTIONS", 0, 0, dp(60), dp(36))--:setIcon("icons/black/ic_cog.png")
	edit = nB("EDIT", 0, 0, dp(60), dp(36)):setOrientation("left")
	view = nB("VIEW", 0, 0, dp(60), dp(36)):setOrientation("left")
	:onPress(function(self)
		if viewWindow == nil then
			gooi.setStyle(window)
			viewWindow = gooi.newPanel({x = sw/8 * 3, y = sh/4, w = sw/8 * 2, h = sh/2, layout = "grid 6x1"}):setOpaque(true)
			gooi.setStyle(raisedbutton)
			viewWindowLabel = gooi.newLabel({text = "VIEW", orientation = "center"})
			gridCheck = gooi.newCheck({text= "Show Grid", checked = showgrid})
			--paletteScaleLabel = gooi.newLabel({text = "Color Palette Scale:", orientation = "center"}):setOpaque(true)
			recenterImage = nB("RECENTER IMAGE"):onPress(function() camera:lookAt(newdata:getWidth()/2, newdata:getHeight()/2) end)
			close = gooi.newButton("CLOSE")
			:onPress(function()
				gooi.removeComponent(viewWindow) viewWindow = nil 
			end)
			--viewWindow:setRowspan(1, 1, 6)
			viewWindow:add(viewWindowLabel, "1,1")
			--viewWindow:add(paletteScaleLabel, "2,1")
			viewWindow:add(recenterImage, "3,1")
			viewWindow:add(gridCheck, "4,1")
			viewWindow:add(close, "6,1")
			close.bgColor = colors.secondary
		else gooi.removeComponent(viewWindow) viewWindow = nil
		end
	end)
	selection = nB("SELECTION", 0, 0, dp(60), dp(36)):setOrientation("left")
	glo = gooi.newPanel(0, 0, sw, sh, "game")
	glo:add(redo, "b-r") glo:add(undo, "b-r") glo:add(options, "t-r")
	glo:add(file, "t-l") glo:add(edit, "t-l") glo:add(view, "t-l")
	glo:add(selection, "t-l")
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

function gui.openFileMenu()
	 showfilemenu = not showfilemenu 
	 isvis = not isvis 
	 gooi.setGroupVisible("filemenu", isvis) 
	 candraw = not candraw
end

function gui.toggleFileMenu()
	if fileWindow == nil then
		gooi.setStyle(window)
		--fileWindow = gooi.newPanel({x = sw/8 * 3, y = sh/4, w = sw/8 * 2, h = sh/2, layout = "grid 6x1"}):setOpaque(true)
		fileWindow = gooi.newPanel(defWindowArgs):setOpaque(true)
		fileWindow.components = {}
		local comps = fileWindow.components
		gooi.setStyle(raisedbutton)
		comps.Label = gooi.newLabel("FILE"):setOpaque(false):setOrientation("center")
		comps.newFile = nB("NEW FILE")
		:onRelease(function()
			gooi.confirm("Start a new file?", function() newdata:mapPixel(pixelFunction.allwhite) end)
		end)
		comps.openFile = gooi.newButton("OPEN FILE")
		:onPress(function()
			gui.toggleFileMenu()
			--[[
			local dir = ""
			local files = love.filesystem.getDirectoryItems(dir)
			fileBrowser = gooi.newPanel(defWindowArgs)
			for i, v in pairs(files) do
				fileBrowser:add(gooi.newButton(v))
			end
			]]
			gui.toggleFileBrowser()
		end)
		comps.saveFile = gooi.newButton("SAVE FILE")
		:onRelease(function()
			newdata:encode("png", fn)
		end)
		fileWindow:add(comps.Label, "1,1")
		fileWindow:add(comps.newFile, "2,1")
		fileWindow:add(comps.openFile, "3,1")
		fileWindow:add(comps.saveFile, "4,1")
	else gooi.removeComponent(fileWindow) fileWindow = nil
	end
end

function gui.toggleFileBrowser()
	if fileBrowser == nil then
		gooi.setStyle(window)
		fileBrowser = gooi.newPanel(largeWindowArgs):setOpaque(true)
		:setColspan(1, 1, 3)
		gooi.setStyle(raisedbutton)
		local dir = love.filesystem.getSaveDirectory()
		local cwdLabel = gooi.newLabel(dir):setOrientation("center")
		fileBrowser:add(cwdLabel, "1,1")
		gooi.setStyle(flatbutton)
		local items = love.filesystem.getDirectoryItems("")
		for i,filename in pairs(items) do
			if string.find(filename, ".png") then
				fileBrowser:add(gooi.newButton({text = filename, orientation = "right"})
				:onRelease(function()
					newdata = love.image.newImageData(filename)
					currentimage = love.graphics.newImage(newdata)
					fn = filename
					gooi.removeComponent(fileBrowser) fileBrowser = nil
				end))
			end
		end
	else gooi.removeComponent(fileBrowser) fileBrowser = nil
	end
end

function gui.toggleColorPicker()
	showfilemenu = not showfilemenu
	isvis = not isvis
	gooi.setGroupVisible("colorpicker", isvis)
	gooi.setGroupEnabled("colorpicker", isvis)
	candraw = not candraw
end