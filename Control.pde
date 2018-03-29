import org.gamecontrolplus.*;

public class ControlState
{
  
  private ControlIO control;
  private List<ControlDevice> devices;
  private final String[] deviceName = 
  { "ELECOM JC-PS202U series", "4Axes 16Key GamePad"};
  
  private ControlButton[][] buttons;
  private ControlSlider[][] sliders;
  
  int controlID = 0;
  
  private final float sensitivity = 0.5f;

  ControlState(PApplet p) {
    control = ControlIO.getInstance(p);
    List<ControlDevice> deviceList = control.getDevices();
    println(deviceList);
    
    devices = new ArrayList<ControlDevice>();
    for(ControlDevice c: deviceList) {
      for(String n: deviceName) {
        if(c.getName().equals(n)) devices.add(c);
      }
    }
    
    buttons = new ControlButton[devices.size()][];
    sliders = new ControlSlider[devices.size()][];
    
    for(int i = 0; i < devices.size(); i++) {
      ControlDevice c = devices.get(i);
      c.open();
      
      buttons[i] = new ControlButton[c.getNumberOfButtons()];
      sliders[i] = new ControlSlider[c.getNumberOfSliders()];
      
      for(int n = 0; n < buttons[i].length; n++) {
        buttons[i][n] = c.getButton(n);
      }
      
      for(int n = 0; n < sliders[i].length; n++) {
        sliders[i][n] = c.getSlider(n);
      }
    }
  }
  
  void stateLog() {
    println("* " + devices.size() + "(now" + controlID + ")");
    for(int i = 0; i < devices.size(); i++) {
      print((devices.get(i)).getName() + ", " + buttons[i].length + ", ");
      
      for(int n = 0; n < buttons[i].length; n++) {
        print("[" + n + "]" + (buttons[i][n].pressed() ? "true " : "false") + ", ");
      }
      
      for(int n = 0; n < sliders[i].length; n++) {
        print(sliders[i][n].getValue() + ", ");
      }
      
      println();
    }
  }
  
  boolean setControlID(int ID) {
    controlID = ID;
    
    return isValidID(ID);
  }
  
  boolean isValidID(int ID) {
    return 0 <= ID && ID < devices.size();
  }
  
  private boolean isButton(int id) {
    if(id < 0 || buttons[controlID].length <= id) return false;
    return buttons[controlID][id].pressed();
  }
  
  private float getSlider(int id) {
    if(id < 0 || sliders[controlID].length <= id) return 0f;
    return sliders[controlID][id].getValue();
  }
  
  boolean isDirection(String direction) { 
    if(!isValidID(controlID)) return false;
    return isButton(direction) || isSlider(0, direction) || isSlider(1, direction);
  }
  
  private ControlDevice getDevice() {
    return devices.get(controlID);
  }
  
  boolean isButton(String name) {
    if(!isValidID(controlID)) return false;
    if(getDevice().getName().equals("ELECOM JC-PS202U series")) {
      if(name == "A") return isButton(1);
      if(name == "B") return isButton(2);
      if(name == "X") return isButton(0);
      if(name == "Y") return isButton(3);
      if(name == "R1") return isButton(7);
      if(name == "R2") return isButton(5);
      if(name == "R3") return isButton(11);
      if(name == "L1") return isButton(6);
      if(name == "L2") return isButton(4);
      if(name == "L3") return isButton(10);
      if(name == "UP") return isButton(12);
      if(name == "RIGHT") return isButton(13);
      if(name == "DOWN") return isButton(14);
      if(name == "LEFT") return isButton(15);
      if(name == "HAT") return isButton(16);
      if(name == "SELECT") return isButton(9);
      if(name == "START") return isButton(8);
    }
    if(getDevice().getName().equals("4Axes 16Key GamePad")) {
      if(name == "A") return isButton(2);
      if(name == "B") return isButton(1);
      if(name == "X") return isButton(4);
      if(name == "Y") return isButton(3);
      if(name == "R1") return isButton(7);
      if(name == "R2") return isButton(8);
      if(name == "R3") return isButton(12);
      if(name == "L1") return isButton(5);
      if(name == "L2") return isButton(6);
      if(name == "L3") return isButton(11);
      if(name == "UP") return isButton(13);
      if(name == "RIGHT") return isButton(14);
      if(name == "DOWN") return isButton(15);
      if(name == "LEFT") return isButton(16);
      if(name == "HAT") return isButton(0);
      if(name == "SELECT") return isButton(9);
      if(name == "START") return isButton(10);
    }
    return false;
  }
  
  float getSlider(String name, String direction) {
    if(!isValidID(controlID)) return 0f;
    if(name == "LEFT") {
      if(direction == "X") return getSlider(1);
      if(direction == "Y") return getSlider(0);
    }
    if(name == "RIGHT") {
      if(direction == "X") return getSlider(3);
      if(direction == "Y") return getSlider(2);
    }
    return 0f;
  }
  
  boolean isSlider(int id, String direction) {
    if(!isValidID(controlID)) return false;
    switch(id) {
      case 0:
        if(direction == "DOWN") return getSlider(0) >= sensitivity;
        if(direction == "RIGHT") return getSlider(1) >= sensitivity;
        if(direction == "UP") return getSlider(0) <= -sensitivity;
        if(direction == "LEFT") return getSlider(1) <= -sensitivity;
        
        break;
      case 1:
        if(direction == "DOWN") return getSlider(2) >= sensitivity;
        if(direction == "RIGHT") return getSlider(3) >= sensitivity;
        if(direction == "UP") return getSlider(2) <= -sensitivity;
        if(direction == "LEFT") return getSlider(3) <= -sensitivity;
        
        break;
    }
    
    return false;
  }
}