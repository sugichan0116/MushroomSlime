public class KeyState
{
  HashMap<Integer, Boolean> Key;

  //コンストラクタ
  KeyState()
  {
    this.Initialize();
  }

  //入力状態の初期化
  void Initialize()
  {
    this.Key = new HashMap<Integer, Boolean>();

    this.Key.put(RIGHT, false);
    this.Key.put(LEFT, false);
    this.Key.put(UP, false);
    this.Key.put(DOWN, false);
    this.Key.put(ALT, false);
    this.Key.put(CONTROL, false);
    this.Key.put(SHIFT, false);
  }

  //keyCodeとその入力状態を受け取り、更新する
  void putState(int code, boolean state)
  {
    this.Key.put(code, state);
  }

  //keyCodeを受け取り、その入力状態を返す
  boolean getState(int code)
  {
    return this.Key.get(code);
  }
}