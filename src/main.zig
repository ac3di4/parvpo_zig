const std = @import("std");
const log = std.log.debug;

const findmax = @import("findmax.zig").run;
const sortarr = @import("sortarr.zig").run;
const sortll = @import("sortll.zig").run;

const TaskId = struct {
    id: u8,
    subid: u8,

    fn fromIO(reader: std.fs.File.Reader) !TaskId {
        // read ID
        const id = try reader.readByte();
        // skip dot
        _ = try reader.readByte();
        // read second id
        const subid = try reader.readByte();
        // skip '\n'
        _ = try reader.readByte();
        
        return .{ .id = id, .subid = subid };
    }
};

pub fn main() !void {
    const stdin = std.io.getStdIn().reader();

    log("enter task id", .{});
    const tid = try TaskId.fromIO(stdin);

    log("enter output flag", .{});
    const flag = try stdin.readByte();
    _ = try stdin.readByte();

    const allocator = std.heap.page_allocator;
    const out = if (flag == '0') false else true;
    try switch (tid.id) {
        '1' => if (tid.subid == '1') findmax(allocator, out) else sortarr(allocator, out),
        '2' => sortll(allocator, out),
        else => error.UnrecognizedTaskId,
    };
}
