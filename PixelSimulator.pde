int grid_width = 150;
int grid_height = 100;

int pixel_size = 5;
int frame_rate = 300;

int brush_size = 5;
String type = "Sand";

void settings() {
  size(grid_width*pixel_size, grid_height*pixel_size);
}

Grid g;

void setup() {
  frameRate(frame_rate);
  g = new Grid(grid_height, grid_width);
  for (int i = 0; i < grid_width; i++) {
    g.cells[grid_height-1][i] = new Stone(new int[] {grid_height-1, i});
  }

  //for (int i = 0; i < grid_width;i++) {
  //  g.cells[0][i] = new Sand(new int[] {0,i});
  //}
}

void draw() {
  for (int i = grid_height-1; i>=0; i--) {
    for (int j = 0; j<grid_width; j++) {
      g.getElementAtIndex(new int[] {i, j}).updated = false;
    }
  }
  for (int i = grid_height-1; i>=0; i--) {
    if (int(random(2)) == 0) {
      for (int j = 0; j<grid_width; j++) {
        g.getElementAtIndex(new int[] {i, j}).update(g);
      }
    } else {
      for (int j = grid_width-1; j>=0; j--) {
        g.getElementAtIndex(new int[] {i, j}).update(g);
      }
    }
  }
  if (keyPressed) {
    if (key == '1') type = "Sand";
    else if (key == '2') type = "Water";
    else if (key == '3') type = "Stone";
    else if (key == '4') type = "Coal";
    //else if(key == '5') type = "Oil";
  }
  if (mousePressed) {
    if (mouseButton == LEFT) {
      for (int i = int(mouseY) / pixel_size-brush_size/2; i<=int(mouseY) / pixel_size+brush_size/2; i++) {
        for (int j = int(mouseX) / pixel_size-brush_size/2; j<=int(mouseX) / pixel_size+brush_size/2; j++) {
          if (i >= 0 && i < grid_height && j >= 0 && j < grid_width) {
            Pixel new_cell = brush(type, i, j);
            if (new_cell.getClass() == g.cells[i][j].getClass()) continue;
            g.cells[i][j] = new_cell;
          }
        }
      }
    }
    if (mouseButton == RIGHT) {
      for (int i = int(mouseY) / pixel_size-brush_size/2; i<=int(mouseY) / pixel_size+brush_size/2; i++) {
        for (int j = int(mouseX) / pixel_size-brush_size/2; j<=int(mouseX) / pixel_size+brush_size/2; j++) {
          if (i >= 0 && i < grid_height && j >= 0 && j < grid_width)
            g.cells[i][j] = new Air(new int[] {i, j});
        }
      }
    }
  }

  for (Pixel[] r : g.cells) {
    for (Pixel p : r) {
      p.draw_pixel(pixel_size);
    }
  }
}

Pixel brush(String t, int i, int j) {
  Pixel p = new Air(new int[] {i, j});
  if (t == "Sand") p = new Sand(new int[] {i, j});
  else if (t == "Water") p = new Water(new int[] {i, j});
  else if (t == "Stone") p = new Stone(new int[] {i, j});
  else if (t == "Coal") p = new Coal(new int[] {i, j});
  else if (t == "Oil") p = new Oil(new int[] {i, j});
  return p;
}
