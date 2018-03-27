class Bullet extends Article{
  private boolean isHit;
  private int team;
  private color tintColor;
  private float playTime;
  private final float cycleTime = .2f;
  
  Bullet(int team, color Color,PVector r, PVector v) {
    this.team = team;
    tintColor = Color;
    this.r = r;
    this.v = v;
    playTime = 0f;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg,r);
      pg.tint(lerpColor(tintColor, color(0), 0.5f));
      pg.image(getImage(), 0, 0);
    pgClose(pg);
  }
  
  private PImage getImage() {
    PImage[] tiles = icons.get("BULLET");
    return tiles[getFrame(tiles.length)];
  }
  
  private int getFrame(int frames) {
    return int(--frames * playTime / cycleTime);
  }
  
  void Update() {
    super.Update();
    playTime += 1f / frameRate;
    playTime %= cycleTime;
  }
  
  boolean isCollide(Article temp) {
    if(temp instanceof Slime){
      //println("* " + (((Slime)temp).getTeam() != team) + " | " + team + ", " + ((Slime)temp).getTeam());
      if(((Slime)temp).getTeam() != team) {
        if(dist(temp.r, r) <= temp.size) {
          return super.isCollide(temp);
        }
      }
    }
    
    return false;
  }
  
  void collide(Article temp) {
    if(temp instanceof Slime) {
      isHit = true;
    }
  }
  
  boolean isRemove() {
    return (r.x + size <= 0 || WIDTH <= r.x - size || r.y + size <= 0 || HEIGHT <= r.y - size) || isHit;
  }
}