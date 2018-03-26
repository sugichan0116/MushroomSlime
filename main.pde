void draw() {
  //call in every frame
  Update();
  Draw();
}

void Draw() {
  //init -> draw -> flip
  DrawInit();
  
  for(Article a : objects) {
    a.Draw();
  }
  
  DrawSystem();
  
  DrawLayers();
}

void Update() {
  //remove
  for(int n = objects.size() - 1; n >= 0; n-- ) {
    if((objects.get(n)).isRemove()) objects.remove(n);
  }
  
  //Update
  for(Article a : objects) {
    a.Update();
  }
  
  if(keyState.getKeyOnce('z')) println("* "  + frameRate + ", " + keyState.getKeyOnce('z'));
  //collide
  for(int m = 0; m < objects.size() - 1; m++) {
    for(int n = m + 1; n < objects.size(); n++) {
      Article a = (objects.get(m)), b = (objects.get(n));
      if(a.isCollide(b) && b.isCollide(a)) {
        a.collide(b);
        b.collide(a);
      }
    }
  }
  
  //build
  buildObjects();
  
  keyState.Update();
}

void buildObjects() {
  buildItem();
}

void buildItem() {
  if(random(100) < 1f)
  objects.add(new Item());
}

void DrawSystem() {
  PGraphics pg;
  
  pg = layers.get("BACK");
  pg.beginDraw();
    PImage icon = (icons.get("FRAME_BACK"))[0];
    pg.image(icon, 0, 0);
  pg.endDraw();
  
  
  pg = layers.get("MAIN");
  pg.beginDraw();
  pg.imageMode(CENTER);
  color[] colors = {#FEFF0A, #6AE349, #4DFBFF, #FF924D};
  for(int n = 0; n < 4; n++) {
    //pg.tint(42 + 255 / 4 * n, 168, 255);
    PImage[] tiles = (icons.get("SLIME_LEFT"));
    float velo = 2.0, size = tiles[0].width, frame = tiles.length;
    pg.tint(colors[n]);
    int x = int((frameCount * size / frame / velo
      + size / 8.0 * sin(frameCount / frame / velo * TAU))
      * (float(n) / 4.0 + 1.0));
    pg.image(tiles[(3 + frameCount / int(velo)) % tiles.length],
      mod(-x, WIDTH),
      160 + size * n);
  }
  pg.noTint();
  pg.endDraw();
  
  pg = layers.get("UI");
  pgOpen(pg);
    icon = (icons.get("FRAME_FRONT"))[0];
    pg.image(icon, 0, 0);
  pgClose(pg);
  
}