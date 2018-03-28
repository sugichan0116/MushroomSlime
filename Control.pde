import org.gamecontrolplus.*;

public class ControlState
{
  
  private ControlIO control;
  private ControlDevice device;
  private final String[] deviceName = 
  { "ELECOM JC-PS202U series", "4Axes 16Key GamePad"};
  
  private ControlButton[] buttons;
  private ControlSlider[] sliders;

  private final float sensitivity = 0.5f;

  ControlState(PApplet p) {
    control = ControlIO.getInstance(p);
    List<ControlDevice> devices = control.getDevices();
    println(devices);
    
    for(ControlDevice c: devices) {
      for(String n: deviceName) {
        if(c.getName().equals(n)) device = control.getDevice(n);
      }
    }
    if(device == null) return;
    //device = control.getDevice(deviceName[1]);
    device.open();
    
    buttons = new ControlButton[device.getNumberOfButtons()];
    sliders = new ControlSlider[device.getNumberOfSliders()];
    
    for(int n = 0; n < buttons.length; n++) {
      buttons[n] = device.getButton(n);
    }
    
    for(int n = 0; n < sliders.length; n++) {
      sliders[n] = device.getSlider(n);
    }
    
  }
  
  void stateLog() {
    print(device.getName() + ", ");
    
    for(int n = 0; n < buttons.length; n++) {
      print("[" + n + "]" +  buttons[n].pressed() + (buttons[n].pressed() ? " " : "") + ", ");
    }
    
    for(int n = 0; n < sliders.length; n++) {
      print(sliders[n].getValue() + ", ");
    }
    
    println();
  }
  
  boolean isButton(int id) {
    if(id < 0 || buttons.length <= id) return false;
    return buttons[id].pressed();
  }
  
  float getSlider(int id) {
    if(id < 0 || sliders.length <= id) return 0f;
    return sliders[id].getValue();
  }
  
  boolean isArrow(String direction) { 
    return isButton(direction) || isSlider(0, direction) || isSlider(1, direction);
  }
  
  boolean isButton(String name) {
    if(device.getName().equals("ELECOM JC-PS202U series")) {
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
    if(device.getName().equals("4Axes 16Key GamePad")) {
      if(name == "A") return isButton(2);
      if(name == "B") return isButton(1);
      if(name == "X") return isButton(4);
      if(name == "Y") return isButton(3);
      if(name == "R1") return isButton(7);
      if(name == "R2") return isButton(8);
      if(name == "L1") return isButton(5);
      if(name == "L2") return isButton(6);
      if(name == "UP") return isButton(13);
      if(name == "RIGHT") return isButton(14);
      if(name == "DOWN") return isButton(15);
      if(name == "LEFT") return isButton(16);
      if(name == "SELECT") return isButton(9);
      if(name == "START") return isButton(10);
    }
    return false;
  }
  
  float getSlider(String name, String direction) {
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