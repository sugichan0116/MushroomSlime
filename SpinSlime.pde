
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
  
  frameRate(30f);
  
  icons = new HashMap<String, PImage[]>();
  icons.put("SLIME", sliceImage("slime2.png", 32, 32, 1, 1));
  icons.put("SLIME_YELLOW", sliceImage("slime.png", 32, 32));
  
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

PImage[] sliceImage(String name, int widthSize, int heightSize, int widthRate, int heightRate) {
  return resizeImages(sliceImage(name, widthSize, heightSize), widthRate, heightRate);
}

PImage[] resizeImages(PImage[] images, int widthRate, int heightRate) {
  for(int n = 0; n < images.length; n++) {
    //* choose rendering type
    //images[n].resize(int(images[n].width * widthRate), int(images[n].height * heightRate));
    images[n] = resizeImage(images[n], widthRate, heightRate);
  }
  return images;
}

PImage resizeImage(PImage image, int widthRate, int heightRate) {
  if(widthRate * heightRate == 0) return image;
  PImage tile = createImage(image.width * abs(widthRate), image.height * abs(heightRate), ARGB);
  for(int x = 0; x < image.width; x++) {
    for(int y = 0; y < image.height; y++) {
      for(int w = 0; w < abs(widthRate); w++) {
        for(int h = 0; h < abs(heightRate); h++) {
          tile.pixels[mod(x * widthRate + w, tile.width) + mod(y * heightRate + h, tile.height) * tile.width] =
            image.pixels[x + y * image.width];
        }
      }
    }
  }
  return tile;
}

int mod(int a, int b) {
  return (a % b < 0) ? (a % b + b) : (a % b);
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
  //pg.colorMode(HSB);
  pg.imageMode(CENTER);
  color[] colors = {#FEFF0A, #6AE349, #4DFBFF, #FF924D};
  for(int n = 0; n < 4; n++) {
    //pg.tint(42 + 255 / 4 * n, 168, 255);
    pg.tint(colors[n]);
    int x = int((frameCount * 32.0 / 18.0 + 4.0 * sin(frameCount / 18.0 * TAU)) * (float(n) / 4.0 + 1.0));
    pg.image((icons.get("SLIME"))[(3 + frameCount / 2) % 9],
      mod(x, WIDTH),
      160 + (icons.get("SLIME"))[0].height * n);
  }
  pg.noTint();
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
  pg.textSize(24);
  pg.textAlign(LEFT, TOP);
  pg.text("FPS" + frameRate + "\n" +
    "ScreenRate" + min(float(width) / float(WIDTH), float(height) / float(HEIGHT)) + "\n" +
    "mouseX" + mouseX
    , 0, 0);
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