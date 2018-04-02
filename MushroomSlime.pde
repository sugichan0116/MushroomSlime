/* library */
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.List;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.awt.event.ComponentAdapter;
import java.awt.event.ComponentEvent;

/* for game */
ArrayList<Article> objects;
Manager manager;
List<Team> teams;

/* system */
//window
int WIDTH;
int HEIGHT;
//input
KeyState keyState;
ControlState controlState;
//icon
Map<String, PImage[]> icons;
//layer
Map<String, PGraphics> layers;
Map<String, Float> layerDepth;
//sound
Sound sounds;


void setup() {
  println("* start up...");
  
  println("* system setting...");
  size(960, 540, P2D);
  WIDTH = width;
  HEIGHT = height;
  keyState = new KeyState();
  controlState = new ControlState(this);
  manager = new Manager();
  objects = new ArrayList<Article>();
  
  println("* sound loading...");
  sounds = new Sound(this);
  sounds.put("BGM_WATER", sounds.create("water_land.mp3").isLoop(true).volume(.6f));
  sounds.put("BGM_NIGHT", sounds.create("summernight.mp3").isLoop(true).volume(.6f));
  sounds.put("BGM_CRY", sounds.create("montanus_cry.mp3").isLoop(true));
  sounds.put("TITLE", sounds.create("title.mp3"));
  sounds.put("EAT", sounds.create("eat.mp3"));
  sounds.put("SHOOT", sounds.create("shoot.mp3"));
  sounds.put("WALK", sounds.create("slime.mp3"));
  sounds.put("SHIELD_OPEN", sounds.create("shield_open.mp3"));
  sounds.put("SHIELD_CLOSE", sounds.create("shield_close.mp3"));
  
  println("* image loading...");
  icons = new HashMap<String, PImage[]>();
  icons.put("SLIME", sliceImage("slime2.png", 32, 32));
  icons.put("SLIME_BIG", sliceImage("slime2.png", 32, 32, 6, 6));
  icons.put("SLIME_RIGHT", sliceImage("slime2.png", 32, 32, 2, 2));
  icons.put("SLIME_LEFT", sliceImage("slime2.png", 32, 32, -2, 2));
  icons.put("SLIME_DOWN", sliceImage("slime_b.png", 32, 32, 2, 2));
  icons.put("SLIME_UP", sliceImage("slime_a.png", 32, 32, 2, 2));
  icons.put("SLIME_EAT", sliceImage("slime_e.png", 32, 32, 2, 2));
  icons.put("BULLET", sliceImage("acidbullet.png", 16, 16, 1, 1));
  icons.put("SHIELD", sliceImage("shield.png", 32, 32, 3, 3));
  icons.put("ITEM", sliceImage("mushroom.png", 16, 16, 2, 2));
  icons.put("ITEM_BIG", sliceImage("bigmushroom.png", 32, 32, 2, 2));
  icons.put("GAUGE", sliceImage("mushroom.png", 16, 16));
  icons.put("JUDGE_WIN", sliceImage("win.png", 72, 32, 3, 3));
  icons.put("JUDGE_DRAW", sliceImage("draw.png", 96, 32, 3, 3));
  icons.put("FRAME_MENU", sliceImage("titlelogo.png", 108, 72, 4, 4));
  icons.put("FRAME_START", sliceImage("start.png", 96, 32, 4, 4));
  icons.put("FRAME_WAITING", sliceImage("waiting.png", 17, 17, 4, 4));
  icons.put("FRAME_FRONT", sliceImage("grassland_d.png", WIDTH / 4, HEIGHT / 4, 4, 4));
  icons.put("FRAME_TIME", sliceImage("signboard.png", 64, 32, 4, 3));
  icons.put("FRAME_BACK", sliceImage("grassland_c.png", WIDTH / 4, HEIGHT / 4, 4, 4));
  icons.put("FRAME_CREDIT", sliceImage("credit.png", WIDTH / 4, HEIGHT / 4, 4, 4));
  
  println("* layer setting...");
  layers = new HashMap<String, PGraphics>();
  layerDepth = new HashMap<String, Float>();
  layers.put("UI", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("UI", -2.);
  layers.put("BACK", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("BACK", 1.);
  layers.put("MAIN", createGraphics(WIDTH, HEIGHT));
  layerDepth.put("MAIN", .0);
}