rm ./builds/html5/build.zip
7z a ./builds/html5/build.zip ./builds/html5/*
butler push ./builds/html5/build.zip aquarock/mmqg:html5
