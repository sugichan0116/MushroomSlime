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
  
  controlState.stateLog();
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
  
  pg = layers.get("UI");
  pgOpen(pg);
    icon = (icons.get("FRAME_FRONT"))[0];
    pg.image(icon, 0, 0);
  pgClose(pg);
  
}