const std = @import("std");
const fmt = std.fmt;
const os = std.os;
const io = std.io;
const eql = std.mem.eql;
const warn = std.debug.warn;

pub fn main() !void {
    var args_it = os.args();
    if (args_it.inner.count < 3) {
        warn(
            \\
            \\Should be called with at least 2 args: 'convert from' and 'convert to' bases.
            \\An optional `-i` at the end will keep it alive and make it interactive.
            \\Direct usage: `echo 1001 | ./zb2b 2 10` outputs `9`.
            \\Interactive usage: `./zb2b 10 2` reads, converts and outputs from base 10 to base 2.
            \\
        );
        return;
    }
    var direct_allocator = std.heap.DirectAllocator.init();
    defer direct_allocator.deinit();

    var arena = std.heap.ArenaAllocator.init(&direct_allocator.allocator);
    defer arena.deinit();
    const allocator = &arena.allocator;

    const exe = try args_it.next(allocator).?;
    const from_base = try fmt.parseUnsigned(u8, try args_it.next(allocator).?, 10);
    const to_base = try fmt.parseUnsigned(u8, try args_it.next(allocator).?, 10);

    const default = "-k";
    const interactive = (args_it.next(allocator) orelse error.InvalidMode) catch default[0..];

    while (eql(u8, interactive, "-i"[0..2])) {
        warn("{}\n", workOneLine(from_base, to_base) catch {
            break;
        });
    } else {
        warn("{}\n", try workOneLine(from_base, to_base));
    }
}

fn workOneLine(from_base: u8, to_base: u8) ![]u8 {
    var buffer: [100]u8 = undefined;
    const line = try io.readLineSlice(buffer[0..]);
    const num = try fmt.parseInt(isize, line, from_base);
    const idx = fmt.formatIntBuf(buffer[0..], num, to_base, false, 0);
    return buffer[0..idx];
}
