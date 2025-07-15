const std = @import("std");

const audio = @import("audio.zig");

pub fn main() !void {
    std.debug.print("Hello, {s}!\n", .{"Zig Build"});

    if (!audio.ntv_init()) {
        return;
    }

    std.debug.print("gen audio", .{});

    var count: i32 = 0;
    while (count < 3) : (count += 1) {
        audio.ntv_trigger_sound();
        // Replace with Zig sleep if needed
        std.time.sleep(1500 * std.time.ns_per_ms);
    }

    audio.ntv_quit();
}
