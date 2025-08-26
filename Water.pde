class Water extends Liquid {
  
  
    int ticks = 0;
    int COLOR_CHANGE_TICK = 5;
    Water(int[] coords) {
      super(new int[] {65,107,223},coords);
      col = randomize_color(new int[] {65,107,223},20);
      MAX_MS_SPEED_IN_LIQUID = MAX_Y_SPEED/3;
      disp_rate = 5;
      density = 1;
    } 
    
    void update(Grid grid) {
      super.update(grid);
      ticks+=1;
      if(ticks % COLOR_CHANGE_TICK==0)
        col = randomize_color(new int[] {65,107,223},20);
    }
}
