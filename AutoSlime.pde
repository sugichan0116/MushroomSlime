class AutoSlime extends Slime {
  private float movingTime, targetTime;
  
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
      v = (new PVector(WIDTH / 2f, HEIGHT / 2f)).sub(r).normalize().mult(velocity).rotate(TAU * (-.2f + random(.4f)));
      if(v.mag() <= 0f) v = new PVector(velocity, 0); 
    }
  }
  
  void selectCommand() {
    if(isMoving && !isEating) command("A");
    command("X");
    command("Y");
  }
}