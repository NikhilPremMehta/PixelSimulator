class Sand extends MoveableSolid {
  Sand(int[] coords) {
    super(new int[] {194, 178, 128}, coords);
    col = randomize_color(new int[] {194, 178, 128}, 10);
    inert_res = 0.0;
    FRICTION = 0.4;
  }
}
