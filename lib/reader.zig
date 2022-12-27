const std = @import("std");

/// Windows can't get stdin at compile-time
pub var stdin: std.fs.File.Reader = undefined;
pub fn init() void {
    stdin = std.io.getStdIn().reader();
}

pub var buf: [1024]u8 = undefined;

/// Read value of any type
/// For structs .fromIO() is called
pub fn read(comptime T: type) !T {
    return switch (@typeInfo(T)) {
        .Bool => readBool(),
        .Int => readInt(T),
        .Struct, .Enum => if (comptime std.meta.trait.hasFn("fromIO")(T))
            try T.fromIO()
        else
            @compileError("fromIO() is not defined for '" ++ @typeName(T) ++ "'"),
        else => @compileError("read() is not defined for '" ++ @typeName(T) ++ "'"),
    };
}

/// Read and allocate value of any type
/// For structs .fromIOAlloc(allocator) is called
pub fn readAlloc(comptime T: type, allocator: std.mem.Allocator) !*T {
    return switch (@typeInfo(T)) {
        .Struct, .Enum => if (comptime std.meta.trait.hasFn("fromIOAlloc")(T))
            T.fromIOAlloc(allocator)
        else
            @compileError("fromIOAlloc() is not defined for '" ++ @typeName(T) ++ "'"),
        else => @compileError("readAlloc() is not defined for '" ++ @typeName(T) ++ "'"),
    };
}

/// Read boolean (0 for false, everything else is a true)
fn readBool() !bool {
    const byte = try stdin.readByte();
    return byte != '0';
}

/// Read integer (unsigned only)
fn readInt(comptime T: type) !T {
    if (@typeInfo(T).Int.signedness == .signed)
        @compileError("readInt only defined for unsigned");

    var i: usize = 0;
    while (i < buf.len) : (i += 1) {
        if (stdin.readByte()) |byte| {
            buf[i] = byte;
            if (byte < '0' or byte > '9')
                return std.fmt.parseInt(T, buf[0..i], 10);
        } else |err| {
            if (i != 0)
                return std.fmt.parseInt(T, buf[0..i], 10);
            return err;
        }
    }
    return error.IntTooBig;
}
