class AutoSlime extends Slime {
  private float movingTime, targetTime;
  private PVector target;
  
  AutoSlime(int team) {
    super(team, "");
    movingTime = 0f;
    targetTime = random(2f) + 1f;
  }
  
  void Move() {
    movingTime += 1f / frameRate;
    isMoving = true;
    
    if(targetTime <= movingTime || v.mag() <= 0f) {
      movingTime = 0f;
      float accuracy;
      if(energy > 2f || target != null) {
        v = target.copy().sub(r);
        accuracy = .1f;
      } else {
        v = (new PVector(WIDTH / 2f, HEIGHT / 2f)).sub(r);
        accuracy = .4f;
      }
      v.normalize().mult(velocity).rotate(TAU * (accuracy * -.5f + random(accuracy)));
      if(v.mag() <= 0f) v = new PVector(velocity, 0); 
    }
  }
  
  boolean isCollide(Article temp) {
    if(temp instanceof Slime) {
      Slime s = (Slime)temp;
      if(s.team != team) {
        if(target == null || dist(r, target) > dist(r, s.r)) {
          target = s.r;
        }
      }
    }
    
    return super.isCollide(temp);
  }
  
  void selectCommand() {
    if(isMoving && !isEating) command("A");
    command("X");
    command("Y");
  }
}