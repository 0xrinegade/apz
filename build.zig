.{
    .name = "apz",
    .version = "0.1.0",
    .minimum_zig_version = "0.13.0",
    .dependencies = .{
        .spice = .{
            .url = "https://github.com/judofyr/spice/archive/refs/heads/main.tar.gz",
            .hash = "12345", // Replace with actual hash
        },
    },
    .paths = .{
        "src",
        "benchmark",
        "build.zig",
        "build.zig.zon",
        "LICENSE",
        "README.md",
    },
}