class Limit<T> {
  private T min, max;
  
  Limit() {
    min = max = null;
  }
  
  Limit(T Min, T Max) {
    min = Min;
    max = Max;
  }
  
  
}

class Volume<T> {
  private T value;
  
  
}

Limit<Integer> limit = new Limit<Integer>(0, 255);