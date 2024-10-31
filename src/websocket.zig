const std = @import("std");
const spice = @import("spice");

pub fn handleTrades(req: *spice.Request) !void {
    const query = try req.query();
    const contract_address = query.get("ca") orelse return error.MissingContractAddress;
    const trader_address = query.get("trader") orelse return error.MissingTraderAddress;

    var ws = try req.upgrade();
    defer ws.deinit();

    while (true) {
        // Handle WebSocket messages
        if (try ws.read()) |msg| {
            try ws.write(msg);
        } else break;
    }
}