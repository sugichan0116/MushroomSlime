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
  
  manager.DrawSystem();
  
  DrawLayers();
}

void Update() {
  if(manager.is("FIGHT")) {
    if(manager.is("MAIN")) {
      //remove
      for(int n = objects.size() - 1; n >= 0; n-- ) {
        Article a = objects.get(n);
        if(a.isRemove()) {
          objects.remove(n);
        }
        else a.Update();
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
    }
    
    //build
    buildObjects();
  }
  
  controlState.stateLog();
  keyState.Update();
  
  manager.Update();
}

void buildObjects() {
  buildItem();
}

void buildItem() {
  if(random(frameRate * 4) < manager.countSlime() * 1f)
  objects.add(new Item());
  if(random(frameRate * 40) < 1f)
  objects.add(new Item("ITEM_BIG", 16f, 1.4f, true));
}