class Stone extends Solid {
  Stone(int[] coords) {
    super(new int[] {105, 105, 105}, coords);
    col = randomize_color(new int[] {105, 105, 105}, 14);
  }
}
