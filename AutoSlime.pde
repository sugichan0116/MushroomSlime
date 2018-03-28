class AutoSlime extends Slime {
  private float movingTime, targetTime;
  private PVector target;
  private float aggressiveEnergy;
  private String mode;
  
  AutoSlime(int team) {
    super(team, "");
    movingTime = 0f;
    targetTime = random(2.0f) + .8f;
    aggressiveEnergy = random(8.0f);
    String mode = "";
  }
  
  void Move() {
    movingTime += 1f / frameRate;
    isMoving = true;
    if(isEating) target = null; 
    
    if(targetTime <= movingTime || v.mag() <= 0f) {
      movingTime = 0f;
      float accuracy = 0f;
      if(target != null && mode != "EAT") {
        v = target.copy().sub(r);
        if(energy >= aggressiveEnergy) {
          accuracy = .0f;
          mode = "ATTACK";
        } else {
          mode = "EAT";
        }
      } else {
        mode = "";
        v = (new PVector(WIDTH / 2f, HEIGHT / 2f)).sub(r);
        accuracy = .8f;
      }
      v.normalize().mult(velocity).rotate(TAU * (accuracy * -.5f + random(accuracy)));
      if(v.mag() <= 0f) v = new PVector(velocity, 0); 
    }
  }
  
  String getNature() {
    return mode + String.format("%.1f[s]",targetTime) + ", " + String.format("E:%.1f",aggressiveEnergy);
  }
  
  boolean isCollide(Article temp) {
    if(energy >= aggressiveEnergy) {
      if(temp instanceof Slime) {
        Slime s = (Slime)temp;
        if(s.team != team) {
          if(target == null || dist(r, target) > dist(r, s.r)) {
            target = s.r;
          }
        }
      }
    } else {
      if(temp instanceof Item) {
        Item i = (Item)temp;
        //if(i.isEat()) {
          if(target == null || dist(r, target) > dist(r, i.r)) {
            target = i.r.copy();
          }
        //}
      }
    }
    
    return super.isCollide(temp);
  }
  
  void selectCommand() {
    if(isMoving && !isEating && mode == "ATTACK") command("A");
    command("X");
    command("Y");
  }
}