class Item extends Article {
  private boolean isRemove;
  private float removingTime;
  private final float removeDelay = 0.5f;
  
  Item() {
    r.x = random(WIDTH);
    r.y = random(HEIGHT);
    size = 32f;
    isRemove = false;
    removingTime = 0f;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg,r);
      pg.image(icons.get("ITEM")[0], 0, 0);
    pgClose(pg);
  }
  
  void Update() {
    super.Update();
    if(isRemove) removingTime += 1f / frameRate;
  }
  
  boolean isCollide(Article temp) {
    if(dist(r, (new PVector(0f, size / 3f)).add(temp.r)) < size) {
      return super.isCollide(temp);
    }
    return false;
  }
  
  void collide(Article temp) {
    //one time
    if(temp instanceof Slime) {
      if(isRemove == false) {
          ((Slime)temp).setEating();
          ((Slime)temp).addEnergy(1f);
          v.add(temp.r).sub(r).div(removeDelay);
      }
    }
    
    isRemove = true;
  }
  
  boolean isRemove() {
    return (removingTime >= removeDelay) && isRemove;
  }
}