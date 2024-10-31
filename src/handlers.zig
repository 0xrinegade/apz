const std = @import("std");
const spice = @import("spice");

pub fn getTrending(req: *spice.Request) !void {
    const query = try req.query();
    const chain = query.get("c") orelse "solana";
    const sortBy = query.get("sortBy") orelse "vol24h";
    const sort = query.get("sort") orelse "desc";

    // Implementation for trending data
    try req.respond(.{
        .status = .ok,
        .body = "Trending data",
    });
}

pub fn getExplore(req: *spice.Request) !void {
    const query = try req.query();
    const chain = query.get("c") orelse "solana";
    const sortBy = query.get("sortBy") orelse "mcap";
    const sort = query.get("sort") orelse "desc";
    const limit = std.fmt.parseInt(u32, query.get("limit") orelse "1000", 10) catch 1000;
    const page = std.fmt.parseInt(u32, query.get("page") orelse "1", 10) catch 1;

    try req.respond(.{
        .status = .ok,
        .body = "Explore data",
    });
}

pub fn getTraders(req: *spice.Request) !void {
    const query = try req.query();
    const chain = query.get("c") orelse "solana";
    const sortBy = query.get("sortBy") orelse "pnl";
    const sort = query.get("sort") orelse "desc";
    const limit = std.fmt.parseInt(u32, query.get("limit") orelse "1000", 10) catch 1000;
    const page = std.fmt.parseInt(u32, query.get("page") orelse "1", 10) catch 1;

    try req.respond(.{
        .status = .ok,
        .body = "Traders data",
    });
}

pub fn getMarkets(req: *spice.Request) !void {
    try req.respond(.{
        .status = .ok,
        .body = "Markets data",
    });
}