class Slime {
  private PVector r;
  private float playTime, cycleTime;
  private float velocity;
  private String direction;
  private boolean isMoving;
  private int initFrame;
  
  Slime() {
    r = new PVector(10, 10);
    playTime = 0f;
    cycleTime = 0.9f;
    velocity = 8;
    direction = "RIGHT";
    isMoving = false;
    initFrame = 0;
  }
  
  void Draw() {
    PGraphics pg = layers.get("UI");
    openSpace(pg, r);
      PVector v = new PVector(velocity * cos(playRate() * TAU), 0f);
      if(isMoving) v.rotate(getDirection());
      else v.set(0f, 0f);
      pg.image(getImage(), v.x, v.y);
      //println("* " + r.x);
    closeSpace(pg);
  }
  
  void Update() {
    playTimeForAnime();
    
    if(isKeyPressed("ARROW")) isMoving = true;
    else isMoving = false;
    
    if(isKeyPressed("RIGHT")) { r.x += velocity; direction = "RIGHT"; }
    if(isKeyPressed("LEFT"))  { r.x -= velocity; direction = "LEFT"; }
    if(isKeyPressed("UP"))    { r.y -= velocity; direction = "UP"; }
    if(isKeyPressed("DOWN"))  { r.y += velocity; direction = "DOWN"; }
  }
  
  private float getDirection() {
    if(direction == "RIGHT") return 0f;
    if(direction == "DOWN") return PI * 0.5f;
    if(direction == "LEFT") return PI;
    if(direction == "UP") return PI * 1.5f;
    
    return 0f;
  }
  
  private void playTimeForAnime() {
    if(getNowFrame() != initFrame || isMoving) playTime += 1f / frameRate;
    playTime %= cycleTime;
  }
  
  private PImage getImage() {
    PImage[] tiles = getImages();
    
    return tiles[getFrame(tiles.length)];
  }
  
  private PImage[] getImages() {
    return (icons.get("SLIME_" + direction));
  }
  
  int getNowFrame() {
    return getFrame(getImages().length);
  }
  
  private int getFrame(int sheets) {
    return int(playRate() * float(sheets));
  }
  
  private float playRate() {
    return playTime / cycleTime;
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