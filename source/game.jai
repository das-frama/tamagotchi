BASE_HUE :: 0.0;

base_radius := 620.0;
segments := 80;

center: Vector2;
c_mid: Color;
c_edge: Color;

simulate_game :: (dt: float) {
    center = Vector2.{ xx (window_width / 2), xx (window_height / 2) };

    current_hue := BASE_HUE + sin(dt * 2.0) * 20.0;
    c_mid  = ColorFromHSV(xx current_hue, 0.4, 1.0);
    c_edge = ColorFromHSV(xx current_hue, 0.8, 0.6);
}

draw_game :: (dt: float) {
    font := GetFontDefault();
    DrawTextEx(font, "Tamagotchi", .{ xx (window_width / 2) - 300.0, 100.0}, 100, 4.0, BLACK);

    rlBegin(RL_TRIANGLES);
    for i : 0..segments-1 {
        angle1 := (cast(float) i / cast(float)segments) * 2.0 * PI;
        angle2 := (cast(float) (i+1) / cast(float)segments) * 2.0 * PI;

        r1 := get_r(angle1, dt);
        r2 := get_r(angle2, dt);

        rlColor4ub(c_mid.r, c_mid.g, c_mid.b, c_mid.a);
        rlVertex2f(center.x, center.y);

        rlColor4ub(c_edge.r, c_edge.g, c_edge.b, c_edge.a);
        rlVertex2f(center.x + cos(angle2) * r2, center.y + sin(angle2) * r2);

        rlColor4ub(c_edge.r, c_edge.g, c_edge.b, c_edge.a);
        rlVertex2f(center.x + cos(angle1) * r1, center.y + sin(angle1) * r1);
    }
    rlEnd();
}

get_r :: (a: float, t: float64) -> float {
    breathing := sin(t * 2.0) * 20.0;
    wobble := sin(a * 8.0 + t * 2.0) * 12.0;
    // wobble := 1.0;
    micro_noise := cos(a * 4.0 - t * 3.5) * 6.0;
    // micro_noise := 1.0;
    return xx (base_radius + breathing + wobble + micro_noise);
}
