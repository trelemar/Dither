gui = {}

function gui.toggleFileMenu()
	 showfilemenu = not showfilemenu 
	 isvis = not isvis 
	 gooi.setGroupVisible("filemenu", isvis) 
	 candraw = not candraw
end