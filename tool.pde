
PImage[] sliceImage(String name) {
  return sliceImage()
}

PImage[] sliceImage(String name, int widthSize, int heightSize) {
  PImage image = loadImage(name);
  PImage[] tiles;
  
  if(widthSize <= 0 || heightSize <= 0) {
    tiles = new PImage[1];
    tiles[0] = image;
    return tiles;
  }
  
  int[] size = {(image.width / widthSize), (image.height / heightSize)}; 
  tiles = new PImage[size[0] * size[1]];
  
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

void DrawInit() {
  //init
  background(0);
  for(Map.Entry<String, PGraphics> set: layers.entrySet()) {
    set.getValue().beginDraw();
    set.getValue().clear();
    set.getValue().endDraw();
  }
}

void DrawLayers() {
  //画面サイズに拡大・レイヤーを重ねる
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

boolean isKeyPressed(String code) {
  /*
  println("*" + UP + ", " + DOWN + ", " + RIGHT + ", " + LEFT + " ;" + keyCode);
  if(keyPressed) {
    if(key == CODED) {
      if(keyCode == UP && code == "UP") return true;
      if(keyCode == DOWN && code == "DOWN") return true;
      if(keyCode == RIGHT && code == "RIGHT") return true;
      if(keyCode == LEFT && code == "LEFT") return true;
    }
  }
  */
  if(code == "UP") return keyState.getState(UP);
  if(code == "DOWN") return keyState.getState(DOWN);
  if(code == "RIGHT") return keyState.getState(RIGHT);
  if(code == "LEFT") return keyState.getState(LEFT);
  if(code == "ARROW") return keyState.getState(UP) | keyState.getState(DOWN) | keyState.getState(RIGHT) | keyState.getState(LEFT);
  
  return false;
}