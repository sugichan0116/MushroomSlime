
class Article {
  private float size, angle;
  private PVector r, v;
  Article (){
    r.x = r.y = angle = 0f;
    size = 16f;
  }
    
  void Draw() {
    /*
    pushMatrix();
      translate(x - camera.x, y - camera.y);
      rotate(angle);
      rectMode(CENTER);
      rect(0, 0, size, size);
    popMatrix();
    */
  }
  
  boolean isDraw() {
    //return (0 <= x + size && x - size <= camera.x + width) &&
    //  (camera.y <= y + size && y - size <= camera.y + height);
    return true;
  }
  
  PVector getVertex(int id) {
    PVector temp = new PVector(size / 2f, size / 2f);
    
    temp.rotate(angle + id * HALF_PI);
    temp.add(r);
    
    return temp;
  }
  
  PVector[] getVertexs() {
    PVector[] temp = new PVector[4];
    
    for(int n = 0; n < temp.length; n++ ) {
      temp[n] = getVertex(n);
    }
    
    return temp;
  }
  
  boolean isCollision(Article temp) {
    return isOverlap(temp);
  }
  
  boolean isOverlapRotate(Article temp) {
    if(dist(r, temp.r) > size + temp.size) return false;
    
    final PVector[][] vertexs = new PVector[2][] ;
    vertexs[0] = getVertexs();
    vertexs[1] = temp.getVertexs();
    
    for(int m = 0, n = 1; m < 2; m++, n--) {
      for(int k = 0; k < 4; k++) {
        boolean isInside = true;
        for(int i = 0, j = 3; i < 4; j = ((++i) - 1) % 4) {
          if(vertexs[m][k].copy().sub(vertexs[n][j]).
            cross(vertexs[n][i].copy().sub(vertexs[n][j])).z > 0f)
            isInside = false;
        }
        if(isInside) return true;
      }
    }
    
    return false;
  }
  
  boolean isOverlap(Article temp) {
    //精密回転判定
    return isOverlapRotate(temp);
  }
  
  void collision(Article temp) {
    
  }
  
  void Update() {
    
  }
  
  boolean isDestroyed() {
    return false;
  }
}