#!/bin/fish

# DEPLOY TO ITCHIO
# exports the game on multiple platforms, then archives and uploads them

if test -x /bin/timg
	/bin/timg ./app_icon.ico
end

echo HTML5
# godot3 --no-window --export HTML5 builds/html5/mmqg.exe
rm ./builds/html5/build.zip
7z a ./builds/html5/build.zip ./builds/html5/*
butler push ./builds/html5/build.zip aquarock/mmqg:html5

echo WINDOWS
# godot3 --no-window --export "Windows Desktop" builds/windows/mmqg.exe
rm ./builds/windows/build.zip
7z a ./builds/windows/build.zip ./builds/windows/*
butler push ./builds/windows/build.zip aquarock/mmqg:windows

echo LINUX
# godot3 --no-window --export Linux/X11 builds/linux/mmqg.x86_64
rm ./builds/linux/build.zip
7z a ./builds/linux/build.zip ./builds/linux/*
butler push ./builds/linux/build.zip aquarock/mmqg:linux
