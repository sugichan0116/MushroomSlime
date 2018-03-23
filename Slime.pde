class Slime extends Article{
  private float playTime, cycleTime;
  private float velocity;
  private String direction;
  private boolean isMoving, isEating;
  private int initFrame;
  
  Slime() {
    r = new PVector(10, 10);
    playTime = 0f;
    cycleTime = 0.9f;
    velocity = 8;
    direction = "RIGHT";
    isMoving = isEating = false;
    initFrame = 0;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg, r);
      PVector v = new PVector(velocity * cos(playRate() * TAU), 0f);
      if(isMoving) v.rotate(getDirection());
      else v.set(0f, 0f);
      pg.image(getImage(), v.x, v.y);
      //println("* " + r.x);
    pgClose(pg);
  }
  
  void Update() {
    playTimeForAnime();
    
    isMoving = isKeyPressed("ARROW");
    if(isKeyPressed("ALT")) isEating = true;
    else if(getNowFrame() == initFrame) isEating = false;
    //println("@" + isEating + "," + keyCode + ", " + isKeyPressed("ALT"));
    
    if(!isEating) {
      if(isKeyPressed("RIGHT")) { r.x += velocity; direction = "RIGHT"; }
      if(isKeyPressed("LEFT"))  { r.x -= velocity; direction = "LEFT"; }
      if(isKeyPressed("UP"))    { r.y -= velocity; direction = "UP"; }
      if(isKeyPressed("DOWN"))  { r.y += velocity; direction = "DOWN"; }
    }
  }
  
  private float getDirection() {
    if(direction == "RIGHT") return 0f;
    if(direction == "DOWN") return PI * 0.5f;
    if(direction == "LEFT") return PI;
    if(direction == "UP") return PI * 1.5f;
    
    return 0f;
  }
  
  private void playTimeForAnime() {
    if(getNowFrame() != initFrame || isMoving || isEating) playTime += 1f / frameRate;
    playTime %= cycleTime;
  }
  
  private PImage getImage() {
    PImage[] tiles = getImages();
    
    return tiles[getFrame(tiles.length)];
  }
  
  private PImage[] getImages() {
    return (icons.get("SLIME_" + ((isEating) ? "EAT" : direction)));
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