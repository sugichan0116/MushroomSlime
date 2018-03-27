class Slime extends Article{
  private float playTime, cycleTime;
  protected float velocity;
  private String direction;
  protected boolean isMoving, isEating;
  private int initFrame;
  private float energy;
  private final float maxEnergy = 8.0f; 
  private String inputPort;
  private color tintColor;
  private PImage gaugeImage;
  private float gaugeVisibleTime;
  private final float gaugeMaxTime = 1.2f;
  
  Slime() {
    this("ARROWS");
  }
  
  Slime(String port) {
    r = new PVector(WIDTH / 2f, HEIGHT / 2f);
    size = 64f;
    playTime = 0f; cycleTime = 0.9f;
    velocity = 240f;
    direction = "RIGHT";
    isMoving = isEating = false;
    initFrame = 0;
    energy = 0f;
    setInputPort(port);
    tintColor = color(random(128) + 128, random(128) + 128, random(128) + 128);
    gaugeImage = icons.get("GAUSE")[0];
    gaugeVisibleTime = 0f;
  }
  
  void setInputPort(String port) {
    inputPort = port;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg, r);
      PVector i = new PVector(velocity / frameRate * cos(playRate() * TAU), 0f);
      if(isMoving && !isEating) i.rotate(getAngle());
      else i.set(0f, 0f);
      
      pg.tint(tintColor);
      pg.image(getImage(), i.x, i.y);
      pg.noTint();
      
    pgClose(pg);
    DrawGauge(pg);
  }
  
  void DrawGauge(PGraphics pg) {
    if(gaugeVisibleTime <= 0f) return;
    pgOpen(pg, r);
      float w = gaugeImage.width * 4, h = gaugeImage.height;
      pg.tint(64);
      for(int n = 0; n < 4; n++) {
        pg.image(gaugeImage, (w - h) * (-.5f + float(n) / 3f), size * -.5f);
      }
      pg.noTint();
      pg.imageMode(CORNERS);
      pg.clip(w * -.5f, size * -.5f - h, w * (-.5f + energy / maxEnergy), 0f);
      for(int n = 0; n < 4; n++) {
        pg.imageMode(CENTER);
        pg.image(gaugeImage, (w - h) * (-.5f + float(n) / 3f), size * -.5f);
      }
      //pg.noClip();
      //pg.imageMode(CENTER);
    pgClose(pg);
  }
  
  void Update() {
    super.Update();
    
    playTimeForAnime();
    Move();
    setDirection();
    ResistLocate();
    if(gaugeVisibleTime > 0f) gaugeVisibleTime -= 1f / frameRate;
  }
  
  void setEating() {
    isEating = true;
    setNowFrame(initFrame + 1);
    gaugeVisibleTime = gaugeMaxTime;
  }
  
  void addEnergy(float num) {
    energy += num;
    nomalizeEnergy();
  }
  
  private void nomalizeEnergy() {
    energy = constrain(energy, 0f, maxEnergy);
  }
  
  protected void Move() {

    isMoving = isInput(inputPort, "ARROW");
    
    v = new PVector();
    if(isEating == false) {
      for(int n = 0; n < 4; n++) {
        if(isInput(inputPort, getDirection(n))) {
          v.add(unitVector(n).mult(velocity));
        }
      }
    }
  }
  
  private void ResistLocate() {
    if(isEating) v.x = v.y = 0f;
    r.x = constrain(r.x, 0, WIDTH);
    r.y = constrain(r.y, 0, HEIGHT);
  }
  
  private void setDirection() {
    if(v.mag() < velocity) return;
    
    for(int n = 0; n < 4; n++) {
      if(PVector.angleBetween(v, unitVector(n)) <= PI / 4f) {
        direction = getDirection(n);
      }
    }
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
  
  private int getNowFrame() {
    return getFrame(getImages().length);
  }
  
  private void setNowFrame(int frame) {
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