import org.gamecontrolplus.*;

public class ControlState
{
  
  private ControlIO control;
  private ControlDevice device;
  private final String deviceName = "ELECOM JC-PS202U series";
  
  private final int buttonsLength = 16;
  private final int slidersLength = 4;
  private ControlButton[] buttons;
  private ControlSlider[] sliders;

  private final float sensitivity = 0.5f;

  ControlState(PApplet p) {
    control = ControlIO.getInstance(p);
    println(control.getDevices());
    
    device = control.getDevice(deviceName);
    device.open();
    
    buttons = new ControlButton[buttonsLength];
    sliders = new ControlSlider[slidersLength];
    
    for(int n = 0; n < buttons.length; n++) {
      buttons[n] = device.getButton(n);
    }
    
    for(int n = 0; n < sliders.length; n++) {
      sliders[n] = device.getSlider(n);
    }

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
    return isArrow(0, direction) || isArrow(1, direction) || isArrow(2, direction);
  }
  
  boolean isArrow(int id, String direction) {
    switch(id) {
      case 0:
        if(direction == "UP") return isButton(12);
        if(direction == "RIGHT") return isButton(13);
        if(direction == "DOWN") return isButton(14);
        if(direction == "LEFT") return isButton(15);
        
        break;
      case 1:
        if(direction == "DOWN") return getSlider(0) >= sensitivity;
        if(direction == "RIGHT") return getSlider(1) >= sensitivity;
        if(direction == "UP") return getSlider(0) <= -sensitivity;
        if(direction == "LEFT") return getSlider(1) <= -sensitivity;
        
        break;
      case 2:
        if(direction == "DOWN") return getSlider(2) >= sensitivity;
        if(direction == "RIGHT") return getSlider(3) >= sensitivity;
        if(direction == "UP") return getSlider(2) <= -sensitivity;
        if(direction == "LEFT") return getSlider(3) <= -sensitivity;
        
        break;
    }
    
    return false;
  }
}