class Bullet extends Article{
  boolean isHit;
  int team;
  color tintColor;
  
  Bullet(int team, color Color,PVector r, PVector v) {
    this.team = team;
    tintColor = Color;
    this.r = r;
    this.v = v;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg,r);
      pg.tint(tintColor);
      pg.image(icons.get("BULLET")[0], 0, 0);
    pgClose(pg);
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