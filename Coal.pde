class Coal extends MoveableSolid {
  Coal(int[] coords) {
    super(new int[] {200, 200, 200}, coords);
    col = randomize_color(new int[] {35, 35, 35}, 15);
    inert_res = 0.4;
    FRICTION = 0.7;
  }
}
