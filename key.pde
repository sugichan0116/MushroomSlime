public class KeyState
{
  HashMap<Integer, Boolean> KeyCode;
  HashMap<Character, Boolean> Key;

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
    
    for(int n = 0; n < 256; n++) {
      this.Key.put(char(n), false);
      this.KeyCode.put(n, false);
    }
  }

  //keyCodeとその入力状態を受け取り、更新する
  void putState(char keys, int codes, boolean state)
  {
    if(keys == CODED) this.KeyCode.put(codes, state);
    else this.Key.put(keys, state);
  }
  
  boolean getCode(int codes) {
    return this.KeyCode.get(codes);
  }
  
  boolean getKey(char keys) {
    return this.Key.get(keys);
  }
  
  
}