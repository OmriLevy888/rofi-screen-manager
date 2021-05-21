# rofi-screen-manager
A simple script wrapper for xrandr using rofi. To make it work with your WM,
make sure to change `refresh_wm()` (I use HerbstLuftWM so it's already in there)
to reload your window manager whenever a change is made (or leave it empty in
case your window manager updates automatically).

## Usage
Just bind to some key (`hc keybind $Mod-l spawn screen-manager.sh`) or run as is
`./screen-manager.sh`.
