public class KeyState
{
  private HashMap<Integer, Boolean> KeyCode;
  private HashMap<Character, Boolean> Key;
  private HashMap<Integer, Boolean> KeyCode_Pressed;
  private HashMap<Character, Boolean> Key_Pressed;

  //コンストラクタ
  KeyState()
  {
    this.Initialize();
  }

  //入力状態の初期化
  void Initialize()
  {
    this.KeyCode = new HashMap<Integer, Boolean>();
    this.Key = new HashMap<Character, Boolean>();
    this.KeyCode_Pressed = new HashMap<Integer, Boolean>();
    this.Key_Pressed = new HashMap<Character, Boolean>();
    
    for(int n = 0; n < 256; n++) {
      this.Key.put(char(n), false);
      this.KeyCode.put(n, false);
    }
    
    Update();
  }
  
  void Update() {
    for(int n = 0; n < 256; n++) {
      this.Key_Pressed.put(char(n), false);
      this.KeyCode_Pressed.put(n, false);
    }
  }
  
  //keyCodeとその入力状態を受け取り、更新する
  void putState(char keys, int codes, boolean state)
  {
    if(keys == CODED) {
      this.KeyCode.put(codes, state);
      this.KeyCode_Pressed.put(codes, state);
    }
    else {
      this.Key.put(keys, state);
      this.Key_Pressed.put(keys, state);
    }
    
  }
  
  boolean getCode(int codes) {
    return this.KeyCode.get(codes);
  }
  
  boolean getCodeOnce(int codes) {
    return this.KeyCode_Pressed.get(codes);
  }
  
  boolean getKey(char keys) {
    return this.Key.get(keys);
  }
  
  boolean getKeyOnce(char keys) {
    return this.Key_Pressed.get(keys);
  }
  
}