flash:
	haxelib run nme test simple.nmml flash

neko:
	haxelib run nme test simple.nmml windows -neko

mneko:
	haxelib run nme test simple.nmml mac -neko

mac:
	haxelib run nme test simple.nmml mac

ios:
	haxelib run nme test simple.nmml ios

win:
	haxelib run nme test simple.nmml windows

clean:
	rm -rf bin
	rm -rf Export