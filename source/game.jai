BASE_HUE :: 210.0;

segments := 80;
base_radius := 240.0;

center: Vector2;
c_mid: Color;
c_edge: Color;

simulate_game :: (dt: float) {
    center = Vector2.{ xx (window_width / 2), xx (window_height / 2) };

    current_hue := BASE_HUE + sin(dt * 1.2) * 20.0;
    c_mid  = ColorFromHSV(xx current_hue, 0.4, 0.6);
    c_edge = ColorFromHSV(xx current_hue, 0.8, 0.6);
}

draw_game :: (dt: float) {
    font := GetFontDefault();
    DrawTextEx(font, "Tamagotchi", .{ xx (window_width / 2) - 300.0, 100.0}, 50, 4.0, BLACK);

    rlBegin(RL_TRIANGLES);
    mouse_pos := GetMousePosition();
    for i : 0..segments-1 {
        angle1 := (cast(float) i / cast(float)segments) * 2.0 * PI;
        angle2 := (cast(float) (i+1) / cast(float)segments) * 2.0 * PI;

        r1 := get_r(angle1, dt, mouse_pos, center);
        r2 := get_r(angle2, dt, mouse_pos, center);

        rlColor4ub(c_mid.r, c_mid.g, c_mid.b, c_mid.a);
        rlVertex2f(center.x, center.y);

        rlColor4ub(c_edge.r, c_edge.g, c_edge.b, c_edge.a);
        rlVertex2f(center.x + cos(angle2) * r2, center.y + sin(angle2) * r2);

        rlColor4ub(c_edge.r, c_edge.g, c_edge.b, c_edge.a);
        rlVertex2f(center.x + cos(angle1) * r1, center.y + sin(angle1) * r1);
    }
    rlEnd();
}

get_r :: (a: float, t: float64, mouse_pos: Vector2, center: Vector2) -> float {
    breathing := sin(t * 1.2) * 20.0;
    wobble := sin(a * 8.0 + t * 2.0) * 12.0;
    micro_noise := cos(a * 4.0 - t * 3.5) * 6.0;

    // Mouse attraction.
    mouse_rel := Vector2.{ mouse_pos.x - center.x, mouse_pos.y - center.y };
    angle_to_mouse := atan2(mouse_rel.y, mouse_rel.x);
    dist_to_mouse := length(mouse_rel);
    angle_diff := cos(a - angle_to_mouse);
    attraction_strentgh := 0.0;
    if attraction_strentgh < 600.0 {
        attraction_strentgh = (600.0 - dist_to_mouse) * 0.1;
    }

    mouse_pull := 0.0;
    if angle_diff > 0 {
        mouse_pull = pow(angle_diff, 4.0) * attraction_strentgh;
    }

    excitment: float64;
    if dist_to_mouse < 200.0 {
        excitment = sin(t * 5.0) * (200.0 - dist_to_mouse) * 0.1;
    }

    return xx (base_radius + breathing + wobble + micro_noise + mouse_pull + excitment);
}
