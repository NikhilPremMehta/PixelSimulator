class Oil extends Liquid {

  int ticks = 0;
  int COLOR_CHANGE_TICK = 5;
  Oil(int[] coords) {
    super(new int[] {65, 107, 223}, coords);
    col = randomize_color(new int[] {25, 25, 25}, 10);
    MAX_MS_SPEED_IN_LIQUID = MAX_Y_SPEED/4;
    disp_rate = 1;
    density = 3;
  }

  void update(Grid grid) {
    super.update(grid);
    ticks+=1;
    if (ticks % COLOR_CHANGE_TICK==0)
      col = randomize_color(new int[] {25, 25, 25}, 10);
  }
}
