const stdin = @import("std").io.getStdIn().reader();
const parseInt = @import("std").fmt.parseInt;
const Allocator = @import("std").mem.Allocator;
var buf: [1024]u8 = undefined;

/// Read bool in one line
/// First non-zero symbol - true
pub fn readBool() !bool {
    const line = try stdin.readUntilDelimiter(buf[0..], '\n', 10);
    return line[0] != '0';
}

/// Read integer in one line
pub fn readInt(comptime T: type) !T {
    return try parseInt(T, try stdin.readUntilDelimiter(buf[0..], '\n'), 10);
}

/// Read slice of integers from one line
/// Integers must be separated by one space
pub fn readSlice(comptime T: type, allocator: Allocator) ![]T {
    const n = try readInt(usize);
    const slice = try stdin.readUntilDelimiter(buf[0..], '\n');
    var data = try allocator.alloc(T, n);

    var end: usize = 0;
    var i: usize = 0;
    while (end < slice.len) : (i += 1) {
        const begin = end;
        while (end < slice.len and slice[end] != ' ') end += 1;
        data[i] = try parseInt(T, slice[begin..end], 10);
        end += 1;
    }

    return data;
}
