abstract class MoveableSolid extends Solid {

  boolean in_water;
  boolean free_falling = true;
  boolean flagged = false;
  float MIN_X_SPEED = 1;
  float inert_res = 0.0;

  MoveableSolid(int[] col, int[] coords) {
    super(col, coords);
  }

  void update(Grid grid) {
    if (updated) return;
    updated = true;

    int[] prev_coord = new int[] {coord[0], coord[1]};

    vel[0] += GRAV;
    if (vel[0] > MAX_Y_SPEED) vel[0] = MAX_Y_SPEED;
    Pixel belowCell = grid.getElementAtIndex(coord[0]+1, coord[1]);
    if (belowCell != null && !(belowCell instanceof Liquid)) in_water = false;
    vel[1] *= (belowCell != null && belowCell instanceof Solid ?((Solid)belowCell).FRICTION : 0.5);
    if (abs(vel[1]) <= 0.1) vel[1] = 0;


    for (int[] c : grid.getPath(coord[0], coord[1], round(coord[0]+vel[0]), round(coord[1]+vel[1]))) {
      Pixel targetCell = grid.getElementAtIndex(c);
      if (targetCell == null) break;
      if (targetCell instanceof Air) {
        grid.swapPixels(this, targetCell);
        freeFalling = true;
      } else if (targetCell instanceof Liquid) {
        grid.swapPixels(this, targetCell);
        if (vel[0] > ((Liquid)targetCell).MAX_MS_SPEED_IN_LIQUID) vel[0] = ((Liquid)targetCell).MAX_MS_SPEED_IN_LIQUID;
        in_water = true;
        freeFalling = true;
      } else if (targetCell instanceof Solid && (freeFalling || flagged)) {

        int rand = round(2*(int(random(2))-0.5));
        boolean place_found = false;

        Pixel newTarget = grid.getElementAtIndex(c[0], c[1]+rand);
        if (newTarget != null && (newTarget instanceof Air || newTarget instanceof Liquid)) {
          grid.swapPixels(this, newTarget);
          vel[1] = rand;
          freeFalling = true;
          place_found = true;
        }
        newTarget = grid.getElementAtIndex(c[0], c[1]-rand);
        if (!place_found &&newTarget != null && (newTarget instanceof Air || newTarget instanceof Liquid)) {
          grid.swapPixels(this, newTarget);
          vel[1] = -rand;
          freeFalling = true;
          place_found = true;
        }

        float absY = max(abs(vel[0]), MIN_X_SPEED);
        if (freeFalling) {
          if (vel[1] == 0) vel[1] = int(random(2)) == 0 ? absY : -absY;
          else vel[1] = vel[1] < 0 ? -absY : absY;
        }

        if (!place_found) {
          freeFalling = false;
        }

        if (!freeFalling) vel[0] = 0;
      }
      if (targetCell instanceof Solid) break;
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
    if (prev_coord[0] != coord[0] && prev_coord[1] != coord[1]) freeFalling = true;
    else freeFalling = false;
    flagged = false;
  }
}
