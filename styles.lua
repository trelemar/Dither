
fonts = {
	rm = lg.newFont("fonts/Roboto-Medium.ttf", dp(14)),
	rr = lg.newFont("fonts/Roboto-Regular.ttf", dp(16)),
	header = lg.newFont("fonts/Roboto-Bold.ttf", dp(16))
}

colors = {
	primary = {80, 80, 80},
	secondary = {0, 200, 0},
	tertairy = {200, 0, 0},
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
		--showBorder = true,
		--borderColor = {0, 0, 0},
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
	bgColor = {120, 120, 120},
	round = 0
}
defWindowArgs = {
	x = sw/8 * 3, 
	y = sh/4, 
	w = sw/8 * 2, 
	h = sh/2, 
	layout = "grid 6x1"
}
largeWindowArgs = {
	x = sw/8* 1,
	y = sh/6,
	w = sw/8 * 6,
	h = sh/6 * 4,
	layout = "grid 8x3"
}