abstract class Liquid extends Pixel {

  int disp_rate = 5;
  boolean free_falling = true;
  float MAX_MS_SPEED_IN_LIQUID = MAX_Y_SPEED/2;
  int flow_direction = 0;
  float density = 1;

  Liquid(int[] col, int[] coords) {
    super(col, coords);
  }

  void update(Grid grid) {
    if (updated) return;
    updated = true;

    vel[0] += GRAV;
    if (vel[0] > MAX_Y_SPEED) vel[0] = MAX_Y_SPEED;
    vel[1] *= 0.5;
    if (abs(vel[1]) <= 0.1) vel[1] = 0;

    for (int[] c : grid.getPath(coord[0], coord[1], round(coord[0]+vel[0]), round(coord[1]+vel[1]))) {
      Pixel targetCell = grid.getElementAtIndex(c);
      if (targetCell == null) break;
      if (targetCell instanceof Air || (targetCell instanceof Liquid && ((Liquid) targetCell).density < density)) {
        grid.swapPixels(this, targetCell);
        freeFalling = true;
        flow_direction = 0;
      } else if (targetCell instanceof Solid || targetCell instanceof Liquid) {
        if (!targetCell.freeFalling) {
          vel[0] = 0;
          freeFalling = false;
        }
        Pixel newTarget = grid.getElementAtIndex(c[0], c[1]+1);
        if (newTarget != null && newTarget instanceof Air) {
          grid.swapPixels(this, newTarget);
          freeFalling = true;
          flow_direction = 1;
          break;
        }
        newTarget = grid.getElementAtIndex(c[0], c[1]-1);
        if (newTarget != null && newTarget instanceof Air) {
          grid.swapPixels(this, newTarget);
          freeFalling = true;
          flow_direction = -1;
          break;
        }
        disperse(grid, new int[] {c[0]-1, c[1]});
        break;
      }
    }
    if (freeFalling) {
      for (int i = -1; i<2; i++) {
        for (int j = -1; j<2; j++) {
          Pixel neighbor = grid.getElementAtIndex(coord[0]+i, coord[1]+j);
          if (neighbor != null && neighbor instanceof MoveableSolid && random(1)>((MoveableSolid)neighbor).inert_res && (i!= 0 && j != 0))
            if (((MoveableSolid)neighbor).inert_res == 0) {
              ((MoveableSolid)neighbor).freeFalling = true;
            } else {
              ((MoveableSolid)neighbor).flagged = true;
            }
        }
      }
    }
  }

  void disperse(Grid grid, int[] coord) {
    boolean spot_found = false;
    int rand = (flow_direction == 0 ? round((int(random(2)) - 0.5)*2) : flow_direction);

    for (int[] c : grid.getPath(coord[0], coord[1], coord[0], coord[1]+disp_rate*rand)) {
      Pixel targetCell = grid.getElementAtIndex(c);
      if (targetCell != null && targetCell instanceof Air) {
        grid.swapPixels(this, targetCell);
        spot_found = true;
        flow_direction = rand;
        //vel[1] = c[1]-coord[1];

        Pixel cell_below = grid.getElementAtIndex(c[0]+1, c[1]);
        Pixel cell_diag_below = grid.getElementAtIndex(c[0]+1, c[1]-rand);
        if (cell_below instanceof Gas&& !(cell_diag_below instanceof Solid || cell_diag_below instanceof Solid)) break;
      } else if (targetCell instanceof Solid) break;
    }
    if (spot_found) return;
    for (int[] c : grid.getPath(coord[0], coord[1], coord[0], coord[1]-disp_rate*rand)) {
      Pixel targetCell = grid.getElementAtIndex(c);
      if (targetCell != null && targetCell instanceof Air) {
        grid.swapPixels(this, targetCell);
        spot_found = true;
        flow_direction = -rand;
        //vel[1] = c[1]-coord[1];

        Pixel cell_below = grid.getElementAtIndex(c[0]+1, c[1]);
        Pixel cell_diag_below = grid.getElementAtIndex(c[0]+1, c[1]-rand);
        if (cell_below instanceof Gas && !(cell_diag_below instanceof Solid || cell_diag_below instanceof Water)) break;
      } else if (targetCell instanceof Solid) break;
    }
  }
}
