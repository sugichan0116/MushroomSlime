
class Article {
  protected float size, angle;
  protected PVector r, v;
  
  Article (){
    r = new PVector(0f, 0f);
    v = new PVector(0f, 0f);
    angle = 0f;
    size = 16f;
  }
    
  void Draw() {
    
  }
  
  boolean isDraw() {
    //return (0 <= x + size && x - size <= camera.x + width) &&
    //  (camera.y <= y + size && y - size <= camera.y + height);
    return isRemove() == false;
  }
  
  void Update() {
    r.x += v.x / frameRate;
    r.y += v.y / frameRate;
  }
  
  boolean isRemove() {
    return false;
  }
  
  void collide(Article temp) {
    
  }
  
  boolean isCollide(Article temp) {
    return isOverlap(temp);
  }
  
  
  protected PVector getVertex(int id) {
    PVector temp = new PVector(size / 2f, size / 2f);
    
    temp.rotate(angle + id * HALF_PI);
    temp.add(r);
    
    return temp;
  }
  
  protected PVector[] getVertexs() {
    PVector[] temp = new PVector[4];
    
    for(int n = 0; n < temp.length; n++ ) {
      temp[n] = getVertex(n);
    }
    
    return temp;
  }
  
  protected boolean isOverlap(Article temp) {
    //精密回転判定
    return isOverlapRotate(temp);
  }
  
  protected boolean isOverlapRotate(Article temp) {
    if(dist(r, temp.r) > (size + temp.size) * sqrt(2)) return false;
    
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
  
}