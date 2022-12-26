const std = @import("std");

pub const LList = struct {
    item: u32,
    next: ?*LList,

    // no set guarties
    pub fn init(allocator: std.mem.Allocator) !*LList {
        var list: *LList = try allocator.create(LList);
        list.item = 0;
        list.next = null;
        return list;
    }

    /// add node to current
    /// return added node
    pub fn chain(self: *LList, allocator: std.mem.Allocator) !*LList {
        var node: *LList = try allocator.create(LList);
        node.item = 0;
        node.next = self.next;
        self.next = node;
        return node;
    }

    // pub fn deinit(allocator: std.mem.Allocator) 
};
