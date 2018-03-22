class Slime {
  private PVector r;
  private float playTime, cycleTime;
  private String direction;
  
  Slime() {
    r = new PVector(10, 10);
    playTime = 0f;
    cycleTime = 0.9f;
    direction = "RIGHT";
  }
  
  void Draw() {
    PGraphics pg = layers.get("UI");
    openSpace(pg, r);
      pg.stroke(128 + 128 * sin(frameRate / 30f), 128, 128);
      pg.image(getImage(), 0, 0);
      //println("* " + r.x);
    closeSpace(pg);
  }
  
  void Update() {
    playTime += 1f / frameRate;
    playTime %= cycleTime;
    
    if(checkKeyPressed("RIGHT")) { r.x += 8; direction = "RIGHT"; }
    if(checkKeyPressed("LEFT")) { r.x -= 8; direction = "LEFT"; }
    if(checkKeyPressed("UP")) { r.y -= 8; direction = "UP"; }
    if(checkKeyPressed("DOWN")) { r.y += 8; direction = "DOWN"; }
  }
  
  PImage getImage() {
    PImage[] tiles = (icons.get("SLIME_" + direction));
    
    return tiles[getImageID(tiles.length)];
  }
  
  int getImageID(int sheets) {
    return int(playTime / cycleTime * float(sheets));
  }
}

void openSpace(PGraphics pg, PVector r) {
  openSpace(pg);
  pg.translate(r.x, r.y);
  pg.imageMode(CENTER);
}

void openSpace(PGraphics pg) {
  pg.beginDraw();
  pg.pushMatrix();
  pg.pushStyle();
}

void closeSpace(PGraphics pg) {
  pg.popMatrix();
  pg.popStyle();
  pg.endDraw();
}