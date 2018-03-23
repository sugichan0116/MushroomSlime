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
  
  void collide(Article temp) {
    //to aproach mouse
    if(dist(r, (new PVector(0f, size / 3f)).add(temp.r)) < size) {
      //one time
      if(isRemove == false) {
        if(temp.getClass() == Slime.class) {
          ((Slime)temp).setEating();
          v.add(temp.r).sub(r).div(removeDelay);
        }
      }
      
      isRemove = true;
    }
  }
  
  boolean isRemove() {
    return (removingTime >= removeDelay) && isRemove;
  }
}