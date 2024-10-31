const std = @import("std");
const spice = @import("spice");
const Router = @import("router.zig").Router;
const handlers = @import("handlers.zig");
const websocket = @import("websocket.zig");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Initialize thread pool
    var pool = try spice.ThreadPool.init(.{
        .max_threads = 32,
        .max_connections = 100_000,
    });
    defer pool.deinit();

    // Initialize router
    var router = try Router.init(allocator);
    defer router.deinit();

    // Register routes
    try router.get("/trending", handlers.getTrending);
    try router.get("/explore", handlers.getExplore);
    try router.get("/traders", handlers.getTraders);
    try router.get("/markets", handlers.getMarkets);
    try router.ws("/ws-trades", websocket.handleTrades);

    // Start server
    const address = try std.net.Address.parseIp("0.0.0.0", 8080);
    try pool.listen(address);

    std.log.info("Server listening on http://0.0.0.0:8080", .{});
    try pool.run();
}