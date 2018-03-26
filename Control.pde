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
}