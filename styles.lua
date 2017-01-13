
fonts = {
	rm = lg.newFont("fonts/Roboto-Medium.ttf", dp(14)),
	rr = lg.newFont("fonts/Roboto-Regular.ttf", dp(16)),
	header = lg.newFont("fonts/Roboto-Bold.ttf", dp(18))
}

colors = {
	primary = {80, 80, 100},
	primaryl = {160, 160, 180},
	secondary = {0, 140, 20},
	tertairy = {140, 0, 20},
	quadary = {0, 20, 140},
	--"#001CB4",
	primaryd = "#FF002C",
	white = {255,255,255},
	black = {0,0,0}
}

header = {
	font = fonts.header,
	fgColor = colors.black
}

raisedbutton = {
	font = fonts.rm,
	bgColor = colors.primary,
	fgColor = colors.white,
	round = .2,
}
	
raisedbuttonlight = {
	font = fonts.rm,
	bgColor = colors.white,
	fgColor = colors.black,
	round = .2,
	showBorder = true,
	borderWidth = dp(1),
	borderColor = colors.black,
}
	
flatbutton = {
	font = fonts.rm,
	bgColor = colors.primary,
	fgColor = colors.white,
}
	
list = {
	font = fonts.rr,
	bgColor = {200, 200, 200, 0},
	fgColor = colors.black,
	round = .2
}
	
dialog = {
	font = fonts.rr,
	bgColor = colors.white,
	fgColor = colors.black,
	showBorder = true,
	borderWidth = dp(2),
	borderColor = colors.black,
	round = 0
}

window = {
	font = fonts.rr,
	bgColor = colors.primaryl,
	round = 0,
	fgColor = colors.primary,
	showBorder = true,
	borderWidth = dp(4),
	borderColor = colors.primaryl
}

defWindowArgs = {
	x = sw/8 * 3, 
	y = sh/4, 
	w = sw/8 * 2, 
	h = sh/2, 
	layout = "grid 6x1"
}

compactWindowArgs = {
	x = sw/8 * 2, 
	y = sh/4, 
	w = sw/8 * 4, 
	h = sh/2, 
	layout = "grid 6x4"
}

largeWindowArgs = {
	x = sw/8* 1,
	y = sh/6,
	w = sw/8 * 6,
	h = sh/6 * 4,
	layout = "grid 8x3"
}