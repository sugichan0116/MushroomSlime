class Slime extends Article{
  private float playTime, cycleTime;
  protected float velocity;
  private String direction;
  protected boolean isMoving, isEating;
  private int initFrame;
  
  Slime() {
    r = new PVector(WIDTH / 2f, HEIGHT / 2f);
    size = 64f;
    playTime = 0f; cycleTime = 0.9f;
    velocity = 240f;
    direction = "RIGHT";
    isMoving = isEating = false;
    initFrame = 0;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg, r);
      PVector v = new PVector(velocity / frameRate * cos(playRate() * TAU), 0f);
      if(isMoving && !isEating) v.rotate(getAngle());
      else v.set(0f, 0f);
      pg.image(getImage(), v.x, v.y);
    pgClose(pg);
  }
  
  void Update() {
    super.Update();
    
    playTimeForAnime();
    Move();
    setDirection();
    ResistLocate();
  }
  
  private void ResistLocate() {
    if(isEating) v.x = v.y = 0f;
    r.x = constrain(r.x, 0, WIDTH);
    r.y = constrain(r.y, 0, HEIGHT);
  }
  
  void Move() {
    isMoving = isKeyPressed("ARROW");
    
    v = new PVector();
    if(isEating == false) {
      for(int n = 0; n < 4; n++) {
        if(isKeyPressed(getDirection(n))) {
          v.add(unitVector(n).mult(velocity));
        }
      }
    }
  }
  
  private void setDirection() {
    if(v.mag() < velocity) return;
    
    for(int n = 0; n < 4; n++) {
      if(PVector.angleBetween(v, unitVector(n)) <= PI / 4f) {
        direction = getDirection(n);
        println(direction);
      }
    }
  }
  
  void setEating() {
    isEating = true;
    setNowFrame(initFrame + 1);
  }
  
  private float getAngle() {
    for(int n = 0; n < 4; n++) {
      if(direction == getDirection(n)) return PI * float(n) / 2f;
    }
    
    return 0f;
  }
  
  private PVector unitVector(int n) {
    return (new PVector(1f, 0f)).rotate(PI * float(n) / 2f);
  }
  
  private String getDirection(int n) {
    switch(n) {
      case 0:
        return "RIGHT";
      case 1:
        return "DOWN";
      case 2:
        return "LEFT";
      case 3:
        return "UP";
    }
    return "";
  }
  
  private void playTimeForAnime() {
    if(getNowFrame() != initFrame || isMoving || isEating) playTime += 1f / frameRate;
    playTime %= cycleTime;
    
    if(getNowFrame() == initFrame) isEating = false;
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
  
  void setNowFrame(int frame) {
    playTime = float(frame) * cycleTime / float(getImages().length);
    playTime %= cycleTime;
  }
  
  private int getFrame(int sheets) {
    return int(playRate() * float(sheets));
  }
  
  private float playRate() {
    return playTime / cycleTime;
  }
}