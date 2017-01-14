#Dither
An Android pixel art editor made with [LÖVE](love2d.org).
![Screenshot](https://goo.gl/photos/KSbK2WDbvrqnsgNF9)
##Install
1. **Download** and install [**LÖVE** For Android](https://play.google.com/store/apps/details?id=org.love2d.android).

2. **Clone** this repository to your device. You can also download as a zip if you'd like, if you don't want seamless updates during alpha.
*(I recommend using [Pocket Git](https://play.google.com/store/apps/details?id=com.aor.pocketgit) to clone initially, and to pull for future updates. A decent free option on the Play Store is MGit)*

3. Using a file browser, like ES File Explorer, **Open "Dither.love"**. If your file explorer asks what application to use, choose LÖVE.

4. Profit?

##Features
- Pan and Scale Viewport.
- **Editing Tools:** Pencil, Eraser, Floodfill, Move, Eyedropper.
- Custom color palettes.
- Colorpicker with RGB slider
- Density independent GUI.
- **File Operations:**
New, Load, Save, Save As, Undo.

##Usage
#####Some useful information:
Due to the limitations of the current version of löve, file manipulation is limited to löve's app data directory. To find out this directory for your device, simply open Dither, then File > Open File. the directory will be the header of the file browser window. This means that currently you cannot save and load files from outside of this directory.