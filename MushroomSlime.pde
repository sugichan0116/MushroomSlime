
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
//test
//オブジェクト管理
ArrayList<Article> objects;

/* system */
int WIDTH;
int HEIGHT;
float timer, resultTime;
List<Team> teams;
KeyState keyState;
ControlState controlState;

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
  println("* start up...");
  
  println("* system setting...");
  size(960, 540, P2D);
  WIDTH = width;
  HEIGHT = height;
  keyState = new KeyState();
  controlState = new ControlState(this);
  
  println("* image loading...");
  icons = new HashMap<String, PImage[]>();
  icons.put("SLIME", sliceImage("slime2.png", 32, 32));
  icons.put("SLIME_RIGHT", sliceImage("slime2.png", 32, 32, 2, 2));
  icons.put("SLIME_LEFT", sliceImage("slime2.png", 32, 32, -2, 2));
  icons.put("SLIME_DOWN", sliceImage("slime_b.png", 32, 32, 2, 2));
  icons.put("SLIME_UP", sliceImage("slime_a.png", 32, 32, 2, 2));
  icons.put("SLIME_EAT", sliceImage("slime_e.png", 32, 32, 2, 2));
  icons.put("BULLET", sliceImage("acidbullet.png", 16, 16, 1, 1));
  icons.put("SHIELD", sliceImage("shield.png", 32, 32, 3, 3));
  icons.put("ITEM", sliceImage("mushroom.png", 16, 16, 2, 2));
  icons.put("ITEM_BIG", sliceImage("bigmushroom.png", 32, 32, 2, 2));
  icons.put("GAUSE", sliceImage("mushroom.png", 16, 16));
  icons.put("FRAME_FRONT", sliceImage("grassland_d.png", WIDTH / 4, HEIGHT / 4, 4, 4));
  icons.put("FRAME_BACK", sliceImage("grassland_c.png", WIDTH / 4, HEIGHT / 4, 4, 4));
  
  println("* layer setting...");
  layers = new HashMap<String, PGraphics>();
  layerDepth = new HashMap<String, Float>();
  layers.put("UI", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("UI", -2.);
  layers.put("BACK", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("BACK", 1.);
  layers.put("MAIN", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("MAIN", .0);
  
  restart();
}

void restart() {
  timer = 0f;
  resultTime = 3f;
  objects = new ArrayList<Article>();
  objects.add(new Slime(0, "ARROWS"));
  objects.add(new Slime(2, "CONTROLLER", 0));
  objects.add(new Slime(3, "CONTROLLER", 1));
  objects.add(new Slime(1, "KEYBOARD"));
  objects.add(new AutoSlime(4));
  objects.add(new AutoSlime(4));
  objects.add(new AutoSlime(4));
  objects.add(new AutoSlime(5));
  objects.add(new AutoSlime(5));
  objects.add(new AutoSlime(5));
  teams = getTeams();
}