
# HTML5
rm ./builds/html5/build.zip
7z a ./builds/html5/build.zip ./builds/html5/*
butler push ./builds/html5/build.zip aquarock/mmqg:html5

# WINDOWS
rm ./builds/windows/build.zip
7z a ./builds/windows/build.zip ./builds/windows/*
butler push ./builds/windows/build.zip aquarock/mmqg:windows

# LINUX
rm ./builds/linux/build.zip
7z a ./builds/linux/build.zip ./builds/linux/*
butler push ./builds/linux/build.zip aquarock/mmqg:linux
