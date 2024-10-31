const std = @import("std");
const spice = @import("spice");

pub const Router = struct {
    allocator: std.mem.Allocator,
    routes: std.StringHashMap(HandlerFn),

    const HandlerFn = *const fn(req: *spice.Request) anyerror!void;

    pub fn init(allocator: std.mem.Allocator) !Router {
        return Router{
            .allocator = allocator,
            .routes = std.StringHashMap(HandlerFn).init(allocator),
        };
    }

    pub fn deinit(self: *Router) void {
        self.routes.deinit();
    }

    pub fn get(self: *Router, path: []const u8, handler: HandlerFn) !void {
        try self.routes.put(path, handler);
    }

    pub fn ws(self: *Router, path: []const u8, handler: HandlerFn) !void {
        try self.routes.put(path, handler);
    }
};