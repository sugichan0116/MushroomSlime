class Item extends Article {
  private boolean isRemove;
  private float removingTime;
  private final float removeDelay = 0.5f;
  private float growthTime, growthSize;
  private float ripeTime;
  private PImage[] tiles;
  
  Item() {
    this("ITEM", 4f, .5f);
  }
  
  Item(String name, float ripe, float food) {
    r = new PVector(random(1f), 0f);
    r.rotate(random(TAU));
    r.x *= WIDTH;
    r.y *= HEIGHT;
    r.div(3f).add(WIDTH * .5f, HEIGHT * .6f);
    
    growthSize = food;
    ripeTime = ripe;
    tiles = icons.get(name);
    size = 32f;
    isRemove = false;
    removingTime = growthTime = 0f;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg,r);
      pg.image(getImage(), 0, 0);
    pgClose(pg);
  }
  
  private PImage getImage() {
    return tiles[getFrame(tiles.length)];
  }
  
  private int getFrame(int frames) {
    return int((frames - 1) * min(1f, growthTime / ripeTime));
  }
  
  private int getGrowth() {
    return getFrame(tiles.length) + 1;
  }
  
  void Update() {
    super.Update();
    if(!isRemove) growthTime += 1f / frameRate;
    if(isRemove) removingTime += 1f / frameRate;
  }
  
  boolean isEat() {
    return getGrowth() > 1;
  }
  
  boolean isCollide(Article temp) {
    if(temp instanceof Slime == false) return false;
    if(!isEat()) return false;
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
          ((Slime)temp).addEnergy(getGrowth() * growthSize);
          v.add(temp.r).sub(r).mult(removeDelay);
      }
    }
    
    isRemove = true;
  }
  
  boolean isRemove() {
    return (removingTime >= removeDelay) && isRemove;
  }
}