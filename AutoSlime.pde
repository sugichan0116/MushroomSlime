class AutoSlime extends Slime {
  private float movingTime, targetTime;
  
  AutoSlime() {
    movingTime = 0f;
    targetTime = random(2f) + 1f;
  }
  
  void Move() {
    movingTime += 1f / frameRate;
    isMoving = true;
    
    if(targetTime <= movingTime) {
      movingTime = 0f;
      v = (new PVector(velocity, 0f)).rotate(random(TAU));
    }
  }
  
  
}