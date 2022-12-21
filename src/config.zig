const std = @import("std");

pub const ProgId = enum {
    rand_gen,
    search_max,
    merge_sort_array,
    merge_sort_list,
    matrix_mul,
    search_prime,
    read_file,
    iter_gen,

    pub fn fromBytes(s: []const u8) !ProgId {
        if (s.len == 1)
            return switch (s[0]) {
                '0' => ProgId.rand_gen,
                '2' => ProgId.merge_sort_list,
                '3' => ProgId.matrix_mul,
                '4' => ProgId.search_prime,
                '5' => ProgId.read_file,
                '6' => ProgId.iter_gen,
                else => error.InvalidProgramId,
            };
        if (s.len != 3 or s[0] != '1' or s[1] != '.')
            return error.InvalidProgramId;
        return switch (s[2]) {
            '1' => ProgId.search_max,
            '2' => ProgId.merge_sort_array,
            else => error.InvalidProgramId,
        };
    }
};

test "ProgId" {
    const expectEq = std.testing.expectEqual;
    const expectErr = std.testing.expectError;
    const parse = ProgId.fromBytes;

    try expectEq(parse(&[_]u8{'0'}), ProgId.rand_gen);
    try expectEq(parse(&[_]u8{'1', '.', '1'}), ProgId.search_max);
    try expectEq(parse(&[_]u8{'1', '.', '2'}), ProgId.merge_sort_array);
    try expectEq(parse(&[_]u8{'2'}), ProgId.merge_sort_list);
    try expectEq(parse(&[_]u8{'3'}), ProgId.matrix_mul);
    try expectEq(parse(&[_]u8{'4'}), ProgId.search_prime);
    try expectEq(parse(&[_]u8{'5'}), ProgId.read_file);
    try expectEq(parse(&[_]u8{'6'}), ProgId.iter_gen);

    try expectErr(error.InvalidProgramId, parse(&[_]u8{'0', '1', '2', '3'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{'0', '.', '2', '3'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{'0', '.', '2'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{'1', '.', '3'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{'1', '.'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{'1', '1'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{'9'}));
    try expectErr(error.InvalidProgramId, parse(&[_]u8{}));
}