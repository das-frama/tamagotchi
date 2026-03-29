#import "Basic";
#import "String";
#import "System";
#import "Math";
#import "raylib";

HPIXELS :: 380;
ASPECT  :: 16.0 / 10.0;

window_width: s32;
window_height: s32;
render_scale: float;

data_folder: string;
render_target: RenderTexture2D;

main :: () {
    base_path := path_strip_filename(get_path_of_running_executable());
    data_folder = join(base_path, "assets");

    defer free(data_folder);

    init_raylib_stuff();
    defer close_raylib_stuff();

    while (!WindowShouldClose()) {
        BeginDrawing();
            ClearBackground(RAYWHITE);
        EndDrawing();
        reset_temporary_storage();
    }

}

init_raylib_stuff :: () {
    SetConfigFlags(.FLAG_VSYNC_HINT);
    InitWindow(100, 100, "Tamagotchi");

    // Detect best monitor (bigger wins (for dev)).
    monitor := GetCurrentMonitor();
    for 0..GetMonitorCount()-1 {
        if GetMonitorWidth(it) > GetMonitorWidth(monitor) {
            monitor = it;
            break;
        }
    }

    init_window_dimensions(monitor);
    SetWindowSize(window_width, window_height);
    SetWindowPosition(
        (GetMonitorWidth(monitor) - window_width) / 2,
        (GetMonitorHeight(monitor) - window_height) / 2,
    );

    // Set refresh rate.
    SetTargetFPS(GetMonitorRefreshRate(monitor));

    SetWindowMonitor(monitor);

    // We are rendering in the render target texture.
    render_target = LoadRenderTexture(window_width, window_height);
    SetTextureFilter(render_target.texture, .TEXTURE_FILTER_POINT);
}

init_window_dimensions :: (monitor: s32) {
    display_w := GetMonitorWidth(monitor);
    display_h := GetMonitorHeight(monitor);
    max_window_h := display_h * 0.8;
    base_h := HPIXELS / ASPECT;

    scale := floor(max_window_h / base_h);
    if scale < 1.0 then scale = 1.0;

    render_scale = scale;

    window_height = cast(s32) (base_h * render_scale);
    window_width = cast(s32) (window_height * ASPECT);

    if window_width > display_w {
        window_width = cast(s32) (display_w * 0.9);
        window_height = cast(s32) (cast(float) window_width / ASPECT);
    }

}

close_raylib_stuff :: () {
    UnloadRenderTexture(render_target);
    CloseWindow();
}