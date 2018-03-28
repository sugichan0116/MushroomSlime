void draw() {
  //call in every frame
  Update();
  Draw();
}

void Draw() {
  //init -> draw -> flip
  DrawInit();
  
  for(Article a : objects) {
    if(a.isDraw()) a.Draw();
  }
  
  DrawSystem();
  
  DrawLayers();
}

void Update() {
  //remove
  for(int n = objects.size() - 1; n >= 0; n-- ) {
    if((objects.get(n)).isRemove()) objects.remove(n);
    else (objects.get(n)).Update();
  }
  
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
  
  if(isInput("START") || winTeam() >= 0) {
    restart();
  }
}

void buildObjects() {
  buildItem();
}

void buildItem() {
  if(random(100) < countSlime() * 2f)
  objects.add(new Item());
  if(random(1000) < 1f)
  objects.add(new Item("ITEM_BIG", 16f, 1.4f));
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
    pg.textSize(72);
    pg.textAlign(CENTER, CENTER);
    pg.text(((winTeam() >= 0) ? "Win " + winTeam() : ""), WIDTH / 2f, HEIGHT / 2f);
  pgClose(pg);
  
}

int countSlime() {
  int count = 0;
  for(Article a: objects) {
    if(a instanceof Slime) {
      count++;
    }
  }
  return count;
}

int winTeam() {
  int winteam = -1;
  for(Article a: objects) {
    if(a instanceof Slime) {
      Slime s = (Slime)a;
      if(winteam == -1) winteam = s.getTeam();
      else winteam = -2;
    }
  }
  return winteam;
}