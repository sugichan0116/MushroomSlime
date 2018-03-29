import processing.sound.*;

class Sound {
  float masterVolume;
  HashMap<String, SoundFile> list;
  HashMap<String, Float> volumes;
  HashMap<String, Integer> cues;
  HashMap<String, Boolean> isLoops;
  
  Sound(PApplet p) {
    Init(p);
  }
  
  Sound Init(PApplet p) {
    minim = new Minim(p);
    list = new HashMap<String, AudioPlayer>();
    volumes = new HashMap<String, Float>();
    cues = new HashMap<String, Integer>();
    isLoops = new HashMap<String, Boolean>();
    masterVolume = .1f;
    return this;
  }
  
  private Sound put(String Key, AudioPlayer a, float volume, int millis, boolean isLoop) {
    if(a != null) {
      list.put(Key, a);
      volumes.put(Key, volume);
      cues.put(Key, millis);
      isLoops.put(Key, isLoop);
    }
    return this;
  }
  
  Sound put(String Key, String path) {
    put(Key, minim.loadFile(path), 1f, 0, false);
    return this;
  }
  
  Sound put(String Key, String path, float volume, int millis, boolean isLoop) {
    put(Key, minim.loadFile(path), volume, millis, isLoop);
    return this;
  }
  
  void Stop() {
    for(AudioPlayer a: list.values()) {
      a.close();
    }
    minim.stop();
  }
  
  boolean isPlaying(String Key) {
    AudioPlayer a = list.get(Key);
    if(a != null) {
      return a.isPlaying();
    }
    return false;
  }
  
  Sound play(String Key) {
    AudioPlayer a = list.get(Key);
    if(a != null) {
      if(isPlaying(Key) && isLoops.get(Key)) return this;
      println("* " + volumes.get(Key) * masterVolume + ", " + a.getVolume());
      a.setVolume(volumes.get(Key) * masterVolume);
      a.play(cues.get(Key));
    }
    return this;
  }
}