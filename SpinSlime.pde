
/* library */
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import ddf.minim.*;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;


/* game arrays */
//オブジェクト管理

/* system */
int WIDTH;
int HEIGHT;

/* materials */
//icon配列
Map<String, PImage[]> icons;
//layer
Map<String, PGraphics> layers;
Map<String, Float> layerDepth;

//sound
Minim minim;
Map<String, AudioPlayer> sounds;

void setup() {
  size(960, 540, P2D);
  WIDTH = width;
  HEIGHT = height;
  
  icons = new HashMap<String, PImage[]>();
  icons.put("SLIME", sliceImage("slime.png", 32, 32));
  
  layers = new HashMap<String, PGraphics>();
  layerDepth = new HashMap<String, Float>();
  layers.put("UI", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("UI", -1.);
  layers.put("BACK", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("BACK", 1.);
  layers.put("MAIN", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("MAIN", .0);
}

PImage[] sliceImage(String name, int widthSize, int heightSize) {
  PImage image = loadImage(name);
  int[] size = {(image.width / widthSize), (image.height / heightSize)}; 
  PImage[] tiles = new PImage[size[0] * size[1]];
  
  for(int n = 0; n < size[0]; n++) {
    for(int m = 0; m < size[1]; m++) {
      tiles[n + m * size[0]] = image.get(n * widthSize, m * heightSize, widthSize, widthSize);
    }
  }
  
  return tiles;
}

List<Entry<String, Float>> sortLayers(Map<String, Float> layerDepth) {
    List<Entry<String, Float>> list = new ArrayList<Entry<String, Float>>(layerDepth.entrySet());
    Collections.sort(list, new Comparator<Entry<String, Float>>() {
      public int compare(Entry<String, Float> obj1, Entry<String, Float> obj2) {
        return obj2.getValue().compareTo(obj1.getValue());
      }
    });
    return list;
}

void draw() {
  //init
  background(0);
  for(Map.Entry<String, PGraphics> set: layers.entrySet()) {
    set.getValue().beginDraw();
    set.getValue().clear();
    set.getValue().endDraw();
  }
  
  PGraphics pg = layers.get("MAIN");
  pg.beginDraw();
  pg.background(200);
  pg.image((icons.get("SLIME"))[(frameCount / 4) % 9], 100, 100);
  int n = 0;
  for(PImage i : (icons.get("SLIME"))) {
    pg.image(i, 200, 100 + i.height * n);
    n++;
  }
  pg.endDraw();
  
  
  pg = layers.get("UI");
  pg.beginDraw();
  pg.fill(128);
  pg.rect(50, 50, 100, 50 * sin(frameRate));
  pg.fill(255);
  pg.stroke(255);
  pg.textSize(72);
  pg.textAlign(LEFT, TOP);
  pg.text("FPS" + min(float(width) / float(WIDTH), float(height) / float(HEIGHT)), 0, 0);
  pg.endDraw();
  
  Draw();
  Update();
}

void Draw() {
  float screenRate = min(float(width) / float(WIDTH), float(height) / float(HEIGHT));
  
  pushMatrix();
  translate(width / 2f, height / 2f);
  scale(screenRate);
  imageMode(CENTER);
  for(Entry<String, Float> entry : sortLayers(layerDepth)) {
    image(layers.get(entry.getKey()), 0, 0);
  }
  popMatrix();
}

void Update() {
  
}