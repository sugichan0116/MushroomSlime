class AutoSlime extends Slime {
  private float movingTime, targetTime;
  
  AutoSlime() {
    movingTime = 0f;
    targetTime = random(2f) + 1f;
  }
  
  void Move() {
    movingTime += 1f / frameRate;
    isMoving = true;
    
    if(targetTime <= movingTime || v.mag() <= 0f) {
      movingTime = 0f;
      v = (new PVector(WIDTH / 2f, HEIGHT / 2f)).sub(r).normalize().mult(velocity).rotate(TAU * (-.3f + random(.6f)));
      if(v.mag() <= 0f) v = new PVector(velocity, 0); 
    }
  }
  
  void selectCommand() {
    if(isMoving && !isEating) command("A");
  }
}