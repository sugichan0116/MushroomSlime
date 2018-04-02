import processing.sound.*;

class SoundData {
  SoundFile s;
  float volume;
  float cue;
  float rate;
  boolean isLoop;
  
  SoundData(PApplet p, String path) {
    s = new SoundFile(p, path);
    volume = 1f;
    cue = 0f;
    rate = 1f;
    isLoop = false;
  }
  
  SoundData play(float master) {
    if(isLoop) {s.loop(); println("@@@");}
    else s.play();
    s.amp(volume * master);
    s.rate(rate);
    s.cue(cue);
    return this;
  }
  
  SoundData stop() {
    s.stop();
    return this;
  }
  
  SoundData volume(float amp) {
    volume = amp;
    return this;
  }
  
  SoundData cue(float cue) {
    this.cue = cue;
    return this;
  }
  
  SoundData rate(float rate) {
    this.rate = rate;
    return this;
  }
  
  SoundData isLoop(boolean loop) {
    isLoop = loop;
    return this;
  }
}

class Sound {
  private float masterVolume;
  private HashMap<String, SoundData> list;
  private PApplet applet;
  
  Sound(PApplet p) {
    Init(p);
  }
  
  Sound Init(PApplet p) {
    applet = p;
    list = new HashMap<String, SoundData>();
    masterVolume = 1.f;
    return this;
  }
  
  SoundData create(String path) {
    return new SoundData(applet, path);
  }
  
  void put(String Key, SoundData s) {
    list.put(Key, s);
  }
  
  void play(String Key) {
    SoundData s = list.get(Key);
    if(s != null) {
      s.play(masterVolume);
    }
  }
  
  void stop(String Key) {
    SoundData s = list.get(Key);
    if(s != null) {
      s.stop();
    }
  }
  
}