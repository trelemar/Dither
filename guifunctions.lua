gui = {}
function gui.load()
	menus = {}
	gooi.desktopMode()
	gooi.setStyle(raisedbutton)
	--redo = nB({text = "REDO", w = dp(112), h = dp(36)}):setIcon("icons/white/ic_redo_variant.png"):setAlign("right")
	undo = nB({text = "UNDO", x = dp(112), y = dp(16), w = dp(112), h = dp(36)}):setIcon("icons/white/ic_undo_variant.png"):setAlign("right")
	:onRelease(function()

		if history[h - 1] ~= nil then
		h = h - 1
		--gui.toast(tostring(h - 1))
		newdata = love.image.newImageData(history[h])
		
		currentimage = love.graphics.newImage(newdata)
		table.remove(history, h + 1)
		end
	end)
	undo.bgColor = colors.tertairy
	gooi.setStyle(flatbutton)
	menuBar = gooi.newPanel(0, 0, sw, dp(34), "grid 1x10"):setOpaque(true)
	:setColspan(1, 8, 2)
	menuBar.components = {
	file = nB("FILE"):onRelease(function() gui.toggleMenu(menus.fileWindow) end),
	options = nB("OPTIONS"):onRelease(function() gui.toggleMenu(menus.optionsMenu) end),
	image = nB("IMAGE"),
	view = nB("VIEW"):onPress(function() gui.toggleMenu(menus.viewMenu) end),
	zoomslider = gooi.newSlider({w = dp(122), h = dp(36), value = 0.1}),
	selection = nB("SELECT")
	}
	do local comps = menuBar.components
	comps.zoomslider.fgColor = colors.primaryl
	menuBar.radius = 0
	menuBar:add(comps.file, "1,1")
	:add(comps.image, "1,2")
	:add(comps.view, "1,3")
	:add(comps.selection, "1,4")
	:add(comps.zoomslider, "1,8")
	:add(gooi.newLabel("ZOOM"):setAlign("center"), "1,8")
	:add(comps.options, "1,10")
	end
	glo = gooi.newPanel(0, 0, sw, sh, "game")
	--glo:add(redo, "b-r")
	glo:add(undo, "b-r")
	gooi.setStyle(raisedbutton)
	cp = nB({x = sw - dp(50), y = undo.y - dp(50), w = dp(46), h = dp(46)}):onRelease(function() gui.toggleColorPicker() colorpicker.updateSliders() end)
	cp.showBorder, cp.borderWidth, cp.borderColor = true, dp(2), colors.black
	cp.bgColor = currentcolor
	gui.loadFileMenu()
	gui.loadSaveMenu()
	gui.loadViewMenu()
	gui.loadOptionsMenu()
	gui.loadNewFileMenu()
	gui.loadPaletteManager()
	gui.loadGridManager()
	do local tbs = gooi.getByType("text")
		for i, v in pairs(tbs) do
		v:setStyle(tb)
		end
	end
end 

function gui.loadFileMenu()
		gooi.setStyle(window)
		menus.fileWindow = gooi.newPanel(defWindowArgs):setOpaque(true):setGroup("fileMenu")
		menus.fileWindow.components = {}
		local comps = menus.fileWindow.components
		comps.Label = gooi.newLabel("FILE"):setOpaque(false):setAlign("center")
		gooi.setStyle(raisedbutton)
		comps.newFile = nB("NEW FILE")
		:onRelease(function()
			gooi.confirm("Start a new file?", function()
			gui.toggleMenu(menus.fileWindow)
			gui.toggleMenu(menus.newFileMenu)
			end)
		end)
		comps.openFile = gooi.newButton("OPEN FILE")
		:onRelease(function()
			gui.toggleMenu(menus.fileWindow)
			gui.toggleFileBrowser()
		end)
		comps.saveFile = gooi.newButton("SAVE FILE")
		:onRelease(function()
			if fn == nil then
				gui.toggleMenu(menus.fileWindow)
				gui.toggleMenu(menus.saveMenu)
			else
				newdata:encode("png", fn)
				gui.toast(fn.." Saved!")
				gui.toggleMenu(menus.fileWindow)
			end
		end)
		comps.saveFileAs = gooi.newButton("SAVE AS"):
		onRelease(function()
			gui.toggleMenu(menus.fileWindow)
			gui.toggleMenu(menus.saveMenu)
		end)
		for i, v in pairs(comps) do
		v:setGroup("fileMenu")
		end
		menus.fileWindow:add(comps.Label, "1,1")
		menus.fileWindow:add(comps.newFile, "2,1")
		menus.fileWindow:add(comps.openFile, "3,1")
		menus.fileWindow:add(comps.saveFile, "4,1")
		menus.fileWindow:add(comps.saveFileAs, "5,1")
		
		gooi.setGroupVisible("fileMenu", false)
		gooi.setGroupEnabled("fileMenu", false)
end
function gui.toggleMenu(name)
	local bool = name.enabled
	local group = name.group
	gooi.setGroupEnabled(group, not bool)
	gooi.setGroupVisible(group, not bool)
end

function gui.toggleFileBrowser()
	if fileBrowser == nil then
		gooi.setStyle(window)
		fileBrowser = gooi.newPanel(largeWindowArgs):setOpaque(true)
		:setColspan(1, 1, 5)
		:setColspan(8, 2, 2)
		local dir = love.filesystem.getSaveDirectory()
		local Label = gooi.newLabel(dir):setAlign("left")
		Label.font = fonts.rn
		gooi.setStyle(raisedbutton)
		local textBox = gooi.newText(""):setStyle(tb)
		local Cancel = gooi.newButton("CANCEL")
		:onRelease(function()
			gui.toggleFileBrowser()
		end)
		Cancel.bgColor = colors.tertairy
		fileBrowser:add(Label, "1,1")
		fileBrowser:add(Cancel, "8,1")
		fileBrowser:add(textBox, "8,2")
		gooi.setStyle(list)
		local items = love.filesystem.getDirectoryItems("")
		for i,filename in pairs(items) do
			if string.find(filename, ".png") then
				fileBrowser:add(gooi.newButton({text = string.sub(filename, 1, 8).."...", align = "right"})
				:onRelease(function()
					newdata = love.image.newImageData(filename)
					currentimage = love.graphics.newImage(newdata)
					imgQuad = love.graphics.newQuad(0, 0, newdata:getWidth(), newdata:getHeight(), newdata:getWidth(), newdata:getHeight())
					updateAlphaQuad()
					fn = filename
					gui.toast("'"..fn.."'")
					clearHistory()
					table.insert(history, newdata:encode("png"))
					h = #history
					gooi.removeComponent(fileBrowser) fileBrowser = nil
					centerImage()
				end))
			end
		end
		gooi.setStyle(raisedbutton)
	else gooi.removeComponent(fileBrowser) fileBrowser = nil
	end
end

function gui.loadPaletteManager()
	gooi.setStyle(window)
	menus.paletteManager = gooi.newPanel(compactWindowArgs):setGroup("paletteManager"):setOpaque(true)
	:setColspan(1, 1, 4)
	menus.paletteManager.components = {}; local comps = menus.paletteManager.components
	local layout = menus.paletteManager
	comps.Label = gooi.newLabel("SELECT PALETTE"):setAlign("center"):setGroup("paletteManager")
	layout:add(comps.Label, "1,1")
	gooi.setStyle(list)
	local palettes = love.filesystem.getDirectoryItems("palettes/")
	for i, v in pairs(palettes) do
		layout:add(gooi.newButton({text = string.gsub(v, ".png", ""), align = "center"}):setGroup("paletteManager")
			:onRelease(function()
				loadPalette("palettes/"..v)
				gui.toggleMenu(menus.paletteManager)
				gui.toggleColorPicker()
			end))
	end
	
	gui.toggleMenu(menus.paletteManager)
end

function gui.loadSaveMenu()
		gooi.setStyle(window)
		menus.saveMenu = gooi.newPanel(defWindowArgs):setOpaque(true):setGroup("saveMenu")
		menus.saveMenu.components = {}
		local comps = menus.saveMenu.components
		
		comps.Label = gooi.newLabel("SAVE NEW FILE"):setAlign("center")
		gooi.setStyle(raisedbutton)
		comps.TextBox = gooi.newText("")
		comps.Cancel = gooi.newButton("CANCEL")
		:onRelease(function()
			gui.toggleMenu(menus.saveMenu)
		end)
		comps.Save = gooi.newButton("SAVE")
		:onRelease(function()
			fn = comps.TextBox.text
			newdata:encode("png", fn..".png")
			gui.toggleMenu(menus.saveMenu)
			gooi.alert("Save Succesful!")
		end)
		for i, v in pairs(comps) do
			v:setGroup("saveMenu")
		end
		menus.saveMenu:add(comps.Label, "1,1")
		menus.saveMenu:add(comps.TextBox, "3,1")
		menus.saveMenu:add(comps.Cancel, "5,1")
		menus.saveMenu:add(comps.Save, "6,1")
		
		gooi.setGroupEnabled("saveMenu", false)
		gooi.setGroupVisible("saveMenu", false)
end

function gui.loadImageMenu()
	gooi.setStyle(window)
	menus.imageMenu = gooi.newPanel(compactWindowArgs):setOpaque(true):setGroup("imageMenu")
	menus.imageMenu.components = {}
	local comps = menus.imageMenu.components
end

function gui.loadOptionsMenu()
	gooi.setStyle(window)
	menus.optionsMenu = gooi.newPanel(compactWindowArgs):setOpaque(true):setGroup("optionsMenu")
	:setColspan(1, 1, 4)
	:setColspan(2, 1, 2)
	:setColspan(3, 1, 2)
	:setColspan(3, 3, 2)
	menus.optionsMenu.components = {}
	local comps = menus.optionsMenu.components
	comps.Label = gooi.newLabel("OPTIONS"):setAlign("center")
	gooi.setStyle(raisedbutton)
	comps.gridcfg = gooi.newButton("CONFIGURE GRIDS"):setAlign("center")
	:onRelease(function()
		gui.toggleMenu(menus.optionsMenu)
		gui.toggleMenu(menus.gridManager)
	end)
	comps.xmirror = gooi.newCheck("MIRROR X")
	comps.ymirror = gooi.newCheck("MIRROR Y")
	
	for i, v in pairs(comps) do
		v:setGroup("optionsMenu")
	end
	menus.optionsMenu:add(comps.Label, "1,1")
	:add(comps.gridcfg, "2,1")
	:add(comps.xmirror, "3,1")
	:add(comps.ymirror, "3,3")
	gui.toggleMenu(menus.optionsMenu)
end

function gui.loadGridManager()
	gooi.setStyle(window)
	menus.gridManager = gooi.newPanel(largeWindowArgs):setGroup("gridManager"):setOpaque(true)
	:setColspan(1,1,5)
	:setColspan(8,1,2)
	:setColspan(8,4,2)
	menus.gridManager.components = {}
	local comps = menus.gridManager.components
	comps.Label = gooi.newLabel("CONFIGURE GRIDS"):setGroup("gridManager"):setAlign("center")
	gooi.setStyle(list)
	comps.eLabel = gooi.newLabel("ENABLED"):setGroup("gridManager"):setAlign("center")
	comps.sxLabel = gooi.newLabel("WIDTH"):setGroup("gridManager"):setAlign("center")
	comps.syLabel = gooi.newLabel("HEIGHT"):setGroup("gridManager"):setAlign("center")
	comps.tLabel = gooi.newLabel("THICKNESS"):setGroup("gridManager"):setAlign("center")
	comps.cLabel = gooi.newLabel("COLOR"):setGroup("gridManager"):setAlign("center")
	gooi.setStyle(raisedbutton)
	comps.apply = gooi.newButton("APPLY"):setGroup("gridManager"):onRelease(function()
		gui.toggleMenu(menus.gridManager)
		grids[1][1] = comps.g1sx:getText()
		grids[2][1] = comps.g2sx:getText()
		grids[3][1] = comps.g3sx:getText()
		grids[1][2] = comps.g1sy:getText()
		grids[2][2] = comps.g2sy:getText()
		grids[3][2] = comps.g3sy:getText()
		grids[1][4] = comps.g1e.checked
		grids[2][4] = comps.g2e.checked
		grids[3][4] = comps.g3e.checked
		grids[1][5] = comps.g1thickness.value
		grids[2][5] = comps.g2thickness.value
		grids[3][5] = comps.g3thickness.value
		grids[1][3] = comps.g1color.bgColor
		grids[2][3] = comps.g2color.bgColor
		grids[3][3] = comps.g3color.bgColor
	end)
	comps.apply.bgColor = colors.secondary
	comps.cancel = gooi.newButton("CANCEL"):setGroup("gridManager"):onRelease(function()
		gui.toggleMenu(menus.gridManager)
	end)
	comps.cancel.bgColor = colors.tertairy
	
	comps.g1sx = gooi.newText(tostring(grids[1][1])):setGroup("gridManager")
	comps.g1sy = gooi.newText(tostring(grids[1][2])):setGroup("gridManager")
	comps.g1e = gooi.newCheck({text = "", checked = grids[1][4]}):setGroup("gridManager"):setOpaque(false)
	comps.g1thickness = gooi.newSpinner({min = 1, max = 8, value = 1, group = "gridManager"})
	comps.g1color = gooi.newButton(""):setGroup("gridManager"):onPress(function(self) self.bgColor = currentcolor end); comps.g1color.bgColor = gridcolors.black
	comps.g2sx = gooi.newText(tostring(grids[2][1])):setGroup("gridManager")
	comps.g2sy = gooi.newText(tostring(grids[2][2])):setGroup("gridManager")
	comps.g2e = gooi.newCheck({text = "", checked = grids[2][4]}):setGroup("gridManager"):setOpaque(false)
	comps.g2thickness = gooi.newSpinner({min = 1, max = 8, value = 1, group = "gridManager"})
	comps.g2color = gooi.newButton(""):setGroup("gridManager"):onPress(function(self) self.bgColor = currentcolor end); comps.g2color.bgColor = gridcolors.red
	comps.g3sx = gooi.newText(tostring(grids[3][1])):setGroup("gridManager")
	comps.g3sy = gooi.newText(tostring(grids[3][2])):setGroup("gridManager")
	comps.g3e = gooi.newCheck({text = "", checked = grids[3][4]}):setGroup("gridManager"):setOpaque(false)
	comps.g3thickness = gooi.newSpinner({min = 1, max = 8, value = 1, group = "gridManager"})
	comps.g3color = gooi.newButton(""):setGroup("gridManager"):onPress(function(self) self.bgColor = currentcolor end); comps.g3color.bgColor = gridcolors.blue
	menus.gridManager:add(comps.Label, "1,1")
	:add(comps.eLabel, "2,1")
	:add(comps.sxLabel, "2,2")
	:add(comps.syLabel, "2,3")
	:add(comps.tLabel, "2,4")
	:add(comps.cLabel, "2,5")
	menus.gridManager:add(comps.g1sx, "3,2")
	:add(comps.g2sx, "4,2")
	:add(comps.g3sx, "5,2")
	:add(comps.g1sy, "3,3")
	:add(comps.g2sy, "4,3")
	:add(comps.g3sy, "5,3")
	:add(comps.g1e, "3,1")
	:add(comps.g2e, "4,1")
	:add(comps.g3e, "5,1")
	:add(comps.g1thickness, "3,4")
	:add(comps.g2thickness, "4,4")
	:add(comps.g3thickness, "5,4")
	:add(comps.g1color, "3,5")
	:add(comps.g2color, "4,5")
	:add(comps.g3color, "5,5")
	menus.gridManager:add(comps.apply, "8,4")
	:add(comps.cancel, "8,1")
	gui.toggleMenu(menus.gridManager)
end

function gui.loadViewMenu()
			gooi.setStyle(window)
			menus.viewMenu = gooi.newPanel(defWindowArgs):setOpaque(true):setGroup("viewMenu")
			menus.viewMenu.components = {}
			local comps = menus.viewMenu.components
			
			comps.viewMenuLabel = gooi.newLabel({text = "VIEW", align = "center"})
			 gooi.setStyle(raisedbutton)
			comps.gridCheck = gooi.newCheck({text= "SHOW GRID", checked = showgrid, align = "center"})
			comps.alphaBgCheck = gooi.newCheck({text = "SHOW ALPHA BG", checked = showAlphaBG})
			comps.changeBgColor = gooi.newButton("SET BG COLOR")
			:onRelease(function()
				love.graphics.setBackgroundColor(currentcolor)
			end)
			comps.recenterImage = nB("RECENTER")
			:onRelease(function()
				centerImage()
			end)
			comps.close = gooi.newButton("CLOSE")
			:onRelease(function()
				gui.toggleMenu(menus.viewMenu)
			end)
			
			for i, v in pairs(comps) do
				v:setGroup("viewMenu")
			end
			
			menus.viewMenu:add(comps.viewMenuLabel, "1,1")
			menus.viewMenu:add(comps.recenterImage, "2,1")
			menus.viewMenu:add(comps.alphaBgCheck, "3,1")
			menus.viewMenu:add(comps.gridCheck, "4,1")
			menus.viewMenu:add(comps.changeBgColor, "5,1")
			menus.viewMenu:add(comps.close, "6,1")
			comps.close.bgColor = colors.tertairy
			gooi.setGroupEnabled("viewMenu", false)
			gooi.setGroupVisible("viewMenu", false)
end

function gui.loadNewFileMenu()
	local def = defWindowArgs
		gooi.setStyle(window)
		menus.newFileMenu = gooi.newPanel(def.x, def.y, def.w, def.h, "grid 6x2"):setOpaque(true):setGroup("newFileMenu")
		:setColspan(1, 1, 2)
		:setColspan(6, 1, 2)
		menus.newFileMenu.components = {}
		local comp = menus.newFileMenu.components
		
		comp.Label = gooi.newLabel("NEW FILE"):setAlign("center")
		gooi.setStyle(raisedbutton)
		comp.wLabel = gooi.newLabel("WIDTH"):setAlign("center")
		comp.wText = gooi.newText("32")
		comp.hLabel = gooi.newLabel("HEIGHT"):setAlign("center")
		comp.hText = gooi.newText("32")
		comp.confirm = gooi.newButton("CONFIRM")
		:onRelease(function()
			if tonumber(comp.wText.text) == nil or tonumber(comp.hText.text) == nil then
				gooi.alert(comp.wText.text.."x"..comp.hText.text.."\nIS NOT A VALID SIZE")
			elseif tonumber(comp.wText.text) <= 0 or tonumber(comp.hText.text) <= 0 then
				gooi.alert("SIZE MUST BE\nGREATER THAN 0!")
			else
			newdata = love.image.newImageData(comp.wText.text, comp.hText.text)
			currentimage = love.graphics.newImage(newdata)
			updateAlphaQuad()
			imgQuad = love.graphics.newQuad(0, 0, newdata:getWidth(), newdata:getHeight(), newdata:getWidth(), newdata:getHeight())
			gui.toggleMenu(menus.newFileMenu)
			clearHistory()
			fn = nil
			table.insert(history, newdata:encode("png"))
			h = #history
			centerImage()
			end
		end)
		comp.confirm.bgColor = colors.secondary
		
		for i, v in pairs(comp) do
			v:setGroup("newFileMenu")
		end
		
		menus.newFileMenu:add(comp.Label, "1,1")
		menus.newFileMenu:add(comp.wLabel, "3,1")
		menus.newFileMenu:add(comp.wText, "3,2")
		menus.newFileMenu:add(comp.hLabel, "4,1")
		menus.newFileMenu:add(comp.hText, "4,2")
		menus.newFileMenu:add(comp.confirm, "6,1")
		
		gooi.setGroupEnabled("newFileMenu", false)
		gooi.setGroupVisible("newFileMenu", false)
end

function gui.toggleColorPicker()
	--showfilemenu = not showfilemenu
	--isvis = not isvis
	gooi.setGroupVisible("colorpicker", not colorpicker.enabled)
	gooi.setGroupEnabled("colorpicker", not colorpicker.enabled)
	colorpicker.enabled = not colorpicker.enabled
	--candraw = not candraw
end

function gui.toast(message)
	local toast = gooi.newLabel(message):setOpaque(true)
	toast.align = "center"
	toast.w = toast.w + dp(8)
	toast.x, toast.y = sw/2 - toast.w/2, sh - toast.h - dp(4)
	toast.radius = toast.h / 2
	Timer.after(1, function() gooi.removeComponent(toast) end)
end

function clearHistory()
 for i, v in pairs(history) do
  history[i] = nil
 end
end

function gui.checkOpenMenus()
	for i, v in pairs(menus) do
		if v.enabled then return true
		end
	end
end

function centerImage()
	camera:lookAt(newdata:getWidth()/2, newdata:getHeight()/2)
	alphaCamera:lookAt(newdata:getWidth(), newdata:getHeight())
end