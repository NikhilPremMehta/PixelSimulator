abstract class Pixel {

  int[] col;
  int[] coord;
  boolean updated;
  float[] vel= new float[2];
  boolean freeFalling;
  float GRAV = 0.2;
  float MAX_Y_SPEED = 5;

  Pixel(int[] col, int[] coords) {
    this.col = col;
    this.coord = coords;
  }

  void update(Grid grid) {
  }

  void draw_pixel(int grid_size) {
    fill(col[0], col[1], col[2]);
    stroke(col[0], col[1], col[2]);
    square(coord[1]*grid_size, coord[0]*grid_size, grid_size);
  }

  int[] randomize_color(int[] c, int rand) {
    return new int[] {min(max(c[0] + int(random(rand)-rand/2), 0), 255), min(max(c[1] + int(random(rand)-rand/2), 0), 255), min(max(c[2] + int(random(rand)-rand/2), 0), 255)};
  }
}
