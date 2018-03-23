class Item extends Article {
  private boolean isRemove;
  
  Item() {
    r.x = r. y = 200f;
    isRemove = false;
  }
  
  void Draw() {
    PGraphics pg = layers.get("MAIN");
    pgOpen(pg,r);
      pg.image(icons.get("ITEM")[0], 0, 0);
    pgClose(pg);
  }
  
}