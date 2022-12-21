default:
	zig build-exe main.zig

fast:
	zig build-exe main.zig -O ReleaseFast

windows:
	zig build-exe main.zig -target x86_64-windows -O ReleaseFast

test:
	zig test main.zig

clean:
	rm -rf zig-cache main main.exe main.pdb