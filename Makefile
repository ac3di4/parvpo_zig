rdebug: debug
	bin/debug

debug: prebuild
	cd bin && zig build-exe -O Debug ../src/main.zig && mv main debug

release: linux windows

linux: prebuild
	cd bin && zig build-exe --strip -O ReleaseFast ../src/main.zig && mv main linux

windows: prebuild
	cd bin && zig build-exe --strip -O ReleaseFast -target x86_64-windows ../src/main.zig && mv main.exe windows.exe

test:
	zig test src/config.zig

prebuild:
	mkdir -p bin

clean:
	rm -rf src/zig-cache bin