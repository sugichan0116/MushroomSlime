class Slime extends Article{
  private String inputPort;
  private color tintColor;
  protected int team;
  private int controlID;
  
  private boolean isDead, isShield;
  private float playTime, cycleTime;
  protected float velocity;
  private final float speed = 240f;
  private String direction;
  protected boolean isMoving, isEating;
  private int initFrame;
  protected float energy;
  private final float maxEnergy = 8.0f; 
  private PImage gaugeImage;
  private float gaugeVisibleTime;
  private final float gaugeMaxTime = 8.0f;
  private float shootCoolTime;
  private final float shootMaxTime = 0.2f;
  private float shieldPlayTime;
  private final float shieldCycleTime = 0.3f;
  private float ineffectiveTime;
  private final float ineffectiveCycleTime = .1f;
  private float awakeningTime;
  private final float awakeningRate = 2.0f;
  
  Slime() {
    this(-1, new color[]{}, "");
  }
  
  Slime(int team, color[] colors, String port) {
    this(team, colors, port, -1);
  }
  
  Slime(int team, color[] colors, String port, int controlID) {
    r = new PVector(WIDTH / 2f, HEIGHT / 2f);
    PVector locate = (new PVector(1f, 1f).rotate(PI * (1f + .5f * team)));
    locate.x *= WIDTH;
    locate.y *= HEIGHT;
    r.add(locate.div(4f));
    
    size = 64f;
    playTime = 0f; cycleTime = 0.9f;
    velocity = speed;
    direction = "RIGHT";
    isMoving = isEating = false;
    initFrame = 0;
    energy = 0f;
    setInputPort(port);
    gaugeImage = icons.get("GAUGE")[3];
    gaugeVisibleTime = 0f;
    isDead = isShield = false;
    this.team = team;
    shootCoolTime = 0f;
    ineffectiveTime = 0f;
    this.controlID = controlID;
    setColor(colors);
  }
  
  Slime setColor(color[] colors) {
    tintColor = lerpColor(lerpColor(colors[team % colors.length], color(255), random(.5f)), color(128), random(.5f));
    return this;
  }
  
  protected color getRandomColor() {
    return color(random(128) + 128, random(128) + 128, random(128) + 128);
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
      
      pg.tint((isAwakening()) ? getRandomColor() : tintColor);
      pg.image(getImage(), i.x, i.y);
      pg.noTint();
      
      pg.textAlign(CENTER, BOTTOM);
      pg.text((this.getClass() == Slime.class) ? getTeamName() : "", 0f, size * -.5f);
      
    pgClose(pg);
    DrawShield(pg, i);
    DrawGauge(pg);
  }
  
  void DrawShield(PGraphics pg, PVector i) {
    pgOpen(pg, r);
    PImage[] tiles = icons.get("SHIELD");
    pg.tint(tintColor);
    if(isShield) pg.image(tiles[int((tiles.length - 1) * shieldPlayTime / shieldCycleTime)], i.x, i.y);
    pgClose(pg);
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
    pgClose(pg);
  }
  
  void Update() {
    super.Update();
    
    controlState.setControlID(controlID);
    playTimeForAnime();
    Move();
    selectCommand();
    setDirection();
    ResistLocate();
    if(gaugeVisibleTime > 0f) gaugeVisibleTime -= 1f / frameRate;
    if(shootCoolTime > 0f) shootCoolTime -= 1f / frameRate;
    if(ineffectiveTime > 0f) ineffectiveTime -= 1f / frameRate;
    if(isAwakening()) awakeningTime -= 1f / frameRate;
    shieldPlayTime += 1f / frameRate;
    shieldPlayTime %= shieldCycleTime;
    
  }
  
  void collide(Article temp) {
    if(temp instanceof Bullet) {
      if(ineffectiveTime > 0f) return;
      if(isShield) {
        isShield = false;
        sounds.play("SHIELD_CLOSE");
        ineffectiveTime = ineffectiveCycleTime;
      }
      else {
        for(Team team: teams) {
          if(team.getID() == ((Bullet)temp).getTeam()) {
            team.killed();
          }
        }
        isDead = true;
      }
    }
  }
  
  boolean isRemove() {
    return isDead;
  }
  
  protected boolean isAwakening() {
    return awakeningTime > 0f;
  }
  
  int getTeam() {
    return team;
  }
  
  color getColor() {
    return tintColor;
  }
  
  String getTeamName() {
    return ((controlID >= 0) ? (controlID + 1) + " P" : inputPort);
  }
  
  void setEating() {
    isEating = true;
    setNowFrame(initFrame + 1);
    gaugeVisibleTime = gaugeMaxTime;
    sounds.play("EAT");
  }
  
  void setAwakening(int level) {
    if(!isAwakening()) awakeningTime = 0f;
    awakeningTime += level * awakeningRate;
  }
  
  boolean addEnergy(float num) {
    energy += num;
    return nomalizeEnergy();
  }
  
  boolean subEnergy(float num) {
    if(energy < num) return false;
    energy -= num;
    return nomalizeEnergy();
  }
  
  private boolean nomalizeEnergy() {
    float buf = energy;
    energy = constrain(energy, 0f, maxEnergy);
    return buf == energy;
  }
  
  void selectCommand() {
    velocity = speed; //後で治す
    
    if(isInput(inputPort, "A")) {
      command("A");
    }
    if(isInput(inputPort, "B")) {
      command("B");
    }
    if(isInput(inputPort, "X")) {
      command("X");
    }
    if(isInput(inputPort, "Y")) {
      command("Y");
    }
  }
  
  void command(String button) {
    if(isEating) return;
    float demandEnergy = 0f;
    PVector[] bullets = new PVector[0];
    if(button == "A") {
      demandEnergy = 0.2f;
      bullets = new PVector[1];
      bullets[0] = (v.mag() < velocity) ? (new PVector(velocity, 0f)).rotate(getAngle()) : (new PVector(v.x, v.y).mult(2f));
    }
    if(button == "Y") {
      demandEnergy = 1.0f;
      if(isShield == false && subEnergy(demandEnergy)) {
        isShield = true;
        gaugeVisibleTime = gaugeMaxTime;
        sounds.play("SHIELD_OPEN");
      }
      return;
    }
    if(button == "X") {
      demandEnergy = 4.0f;
      bullets = new PVector[8];
      for(int n = 0; n < 8; n++) {
        bullets[n] = (new PVector(velocity * 2f, 0f)).rotate(TAU * float(n) / 8f);
      }
    }
    if(button == "B") {
      demandEnergy = 1f / frameRate;
      if(subEnergy(demandEnergy)) {
        velocity = speed * 2f;
        gaugeVisibleTime = gaugeMaxTime;
      }
      return;
    }
    
    if(isAwakening()) {
      int split = 3;
      PVector[] newBullets = new PVector[split * bullets.length];
      int i = 0;
      for(PVector b: bullets) {
        for(int n = 0; n < split; n++) {
          newBullets[i] = b.copy().rotate(radians(10) * (n - floor(split / 2f)));
          i++;
        }
      }
      bullets = newBullets;
    }
    
    if(shootCoolTime <= 0f && subEnergy(demandEnergy)) {
      sounds.play("SHOOT");
      shootCoolTime = shootMaxTime;
      gaugeVisibleTime = gaugeMaxTime;
      for(int n = 0; n < bullets.length; n++) {
        objects.add(
          new Bullet(
            team,
            tintColor,
            new PVector(r.x, r.y),
            bullets[n]
          )
        );
      }
    }
  }
  
  protected void Move() {

    isMoving = isInput(inputPort, "ARROW");
    
    v = new PVector();
    if(isEating == false) {
      for(int n = 0; n < 4; n++) {
        if(isInput(inputPort, getDirection(n))) {
          v.add(unitVector(n));
        }
      }
      v.add(getInputDirection(inputPort));
      if(v.mag() < 1f) v.mult(0f);
      v.normalize().mult(velocity);
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