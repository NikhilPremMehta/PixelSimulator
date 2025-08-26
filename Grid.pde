class Grid {

  public Pixel[][] cells;

  Grid(int h, int w) {
    cells = new Pixel[h][w];
    for (int i = 0; i<h; i++) {
      for (int j = 0; j<w; j++) {
        cells[i][j] = new Air(new int[] {i, j});
      }
    }

    //for (int[] i : getPath(7, 15, 7, 16)) {
    //  println(i[0], i[1]);
    //}
  }

  void swapPixels(Pixel p1, Pixel p2) {
    cells[p1.coord[0]][p1.coord[1]] = p2;
    cells[p2.coord[0]][p2.coord[1]] = p1;
    int[] temp = p2.coord;
    p2.coord = p1.coord;
    p1.coord = temp;
  }

  void movePixel(Pixel p1, int[] coord) {
    cells[p1.coord[0]][p1.coord[1]] = new Air(new int[] {p1.coord[0], p1.coord[1]});
    cells[coord[0]][coord[1]] = p1;
    p1.coord = coord;
  }

  Pixel getElementAtIndex(int[] coord) {
    if (coord[0] >= 0 && coord[0] < cells.length && coord[1] >= 0 && coord[1] < cells[0].length)
      return cells[coord[0]][coord[1]];
    else
      return null;
  }

  Pixel getElementAtIndex(int y, int x) {
    if (y >= 0 && y < cells.length && x >= 0 && x < cells[0].length)
      return cells[y][x];
    else
      return null;
  }

  ArrayList<int[]> getPath(int y1, int x1, int y2, int x2) {
    int dif_y = y2-y1;
    int dif_x = x2-x1;
    int longer_dif = 0;
    ArrayList<int[]> path = new ArrayList<>();

    if (abs(dif_y) > abs(dif_x)) longer_dif = dif_y;
    else longer_dif = dif_x;

    for (int i = 1; i<= abs(longer_dif); i++) {
      int new_x = x1 + abs((longer_dif == dif_x ? round(i) : abs(round(i*dif_x/dif_y)))) * sign(dif_x);
      int new_y = y1 + (longer_dif == dif_y ? round(i) : abs(round(i*dif_y/dif_x)))* sign(dif_y);
      path.add(new int[] {new_y, new_x});
    }

    return path;
  }

  int sign(float num) {
    return (num>0 ? 1 : -1);
  }

  Pixel[][] getCells() {
    return cells;
  }
}
