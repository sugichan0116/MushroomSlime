
void draw() {
  Update();
  Draw();
}

void Draw() {
  DrawInit();
  
  gray.Draw();
  
  
  /* --------test--------------- */
  PGraphics pg = layers.get("BACK");
  pg.beginDraw();
  pg.background(4 * 56);
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
  int n = 0;
  for(PImage i : (icons.get("SLIME_EAT"))) {
    pg.image(i, 200, 100 + i.height * n);
    n++;
  }
  pg.endDraw();
  
  
  pg = layers.get("UI");
  pgOpen(pg);
  {
    PImage icon = (icons.get("FOREST"))[0];
    pg.image(icon, 0, 0);
    pg.image(icon, icon.width, 0);
  }
  pgClose(pg);
  
  pg = layers.get("UI");
  pg.beginDraw();
  pg.fill(128);
  pg.rect(50, 50, 100, 50 * sin(frameRate));
  pg.fill(255);
  pg.stroke(255);
  pg.textSize(24);
  pg.textAlign(LEFT, TOP);
  pg.text("FPS" + frameRate + "\n" +
    "ScreenRate" + min(float(width) / float(WIDTH), float(height) / float(HEIGHT)) + "\n" +
    "mouseX" + mouseX
    , 0, 0);
  pg.endDraw();
  
  /* ----------------------- */
  
  
  
  DrawLayers();
}

void Update() {
  gray.Update();
}


void keyPressed()
{
  keyState.putState(keyCode, true);
}

void keyReleased()
{
  keyState.putState(keyCode, false);
}