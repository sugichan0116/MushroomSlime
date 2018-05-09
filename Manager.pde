class Manager {
  String scene;
  float timer, intervalTime;
  color[] colors;
  ArrayList<Slime> preset;
  boolean preMousePressed;
  
  Manager() {
    scene = "SETUP";
    colors = new color[]{#FF6262, #79F0ED, #FBFF1A, #52FF65};
    intervalTime = 5f;
    resetController();
  }
  
  void restart() {
    timer = 0f;
    objects = new ArrayList<Article>();
    for(Slime s: preset) {
      objects.add(s.copy().setColor(colors));
    }
    teams = getTeams();
    sounds.play("BGM_WATER");
    sounds.play("BGM_NIGHT");
  }
  
  boolean is(String sceneKey) {
    return scene.indexOf(sceneKey) != -1;
  }
  
  void resetController() {
    preset = new ArrayList<Slime>();
  }
  
  boolean isCheckEqualController(String _port, int _id) {
    for(Slime s: preset) {
      if(s.isEqualController(_port, _id)) return true;
    }
    return false;
  }
  
  void connectCPU() {
    if(mousePressed && !preMousePressed && keyState.getCode(CONTROL) && (mouseButton == LEFT)) {
          println("~");
      for(int team = 0; team < 4; team++) {
        if(abs(width * .5 - mouseX) <= width * .4 && abs(height * (.1 * team + .35) - mouseY) <= HEIGHT * .05) {
          println("~");
          preset.add(new AutoSlime(team, colors));
        }
      }
    }
  }
  
  void connectController() {
    final String code = "START";
    int team = (objects.size()) % 4; //TODO
    String[] ports = {"ARROWS", "KEYBOARD", "CONTROLLER"};
    
    for(String port : ports) {
      if(port == "CONTROLLER") {
        int id = 0;
        while(controlState.isValidID(id)) {
          controlState.setControlID(id);
          if(isInput(port, code) && isCheckEqualController(port, id) == false) {
            preset.add(new Slime(team, colors, port, id));
          }
          id++;
        }
      } else if(isInput(port, code) && isCheckEqualController(port, -1) == false) {
        preset.add(new Slime(team, colors, port));
      }
    }
  }
  
  void selectTeamController() {
    for(Slime s: preset) {
      if(s.isPressed("A")) {
        s.shiftTeam(0);
      } else if(s.isPressed("B")) {
        s.shiftTeam(1);
      } else if(s.isPressed("X")) {
        s.shiftTeam(2);
      } else if(s.isPressed("Y")) {
        s.shiftTeam(3);
      }
      //s.validateTeam(4);
    }
  }
  
  void Update() {
    if(scene.startsWith("SETUP")) {
      scene = "MENU";
      sounds.play("TITLE");
    }
    if(scene.startsWith("MENU")) {
      intervalTime -= 1f / frameRate;
      if(intervalTime <= 0f) scene = "FIGHT_RESTART";
      if(mousePressed && (mouseButton == LEFT)) scene = "META_CONFIG";
    }
    
    if(is("META")) {
      String pre, next;
      pre = next = "META";
      if(is("CONFIG")) {
        pre += "_CREDIT";
        next += "_HELP_CON";
        if(is("CONFIG") && !is("RESET")) {
          scene += "_RESET";
          //resetController();
        }
        connectController();
        connectCPU();
        selectTeamController();
      }
      if(is("HELP")) {
        if(is("CON")) {
          pre += "_CONFIG";
          next += "_HELP_KEY";
        }
        if(is("KEY")) {
          pre += "_HELP_CON";
          next += "_CREDIT";
        }
      }
      if(is("CREDIT")) {
        pre += "_HELP_KEY";
        next += "_CONFIG";
      }
      if(mousePressed && !preMousePressed && (mouseButton == LEFT)) {
        if(mouseX < width * .1) scene = pre;
        if(mouseX > width * .9) scene = next;
      }
      if(mousePressed && (mouseButton == RIGHT)) scene = "FIGHT_RESTART";
    }
    
    if(is("FIGHT")) {
      if(is("START")) {
        intervalTime -= 1f / frameRate;
        if(intervalTime <= 0f) scene = "FIGHT_MAIN";
        if(mousePressed && (mouseButton == LEFT)) scene = "META_CONFIG";
      }
      if(is("MAIN")) {
        if(winTeamID() >= 0) scene = "FIGHT_END_WIN";
        if(countSlime() == 0) scene = "FIGHT_END_DRAW";
        if(is("END")) intervalTime = 3f;
        if(isInput("START")) scene = "FIGHT_RESTART";
        timer += 1f / frameRate;
      }
      if(is("END")) {
        intervalTime -= 1f / frameRate;
        if(intervalTime <= 0f) {
          scene = "FIGHT_RESTART";
        }
      }
      if(is("RESTART")) {
        restart();
        intervalTime = 1f;
        scene = "FIGHT_START";
      }
    }
    
    preMousePressed = mousePressed;
  }
  
  void DrawSystem() {
    PGraphics pg;
    PImage icon;
    
    pg = layers.get("BACK");
    pg.beginDraw();
      icon = (icons.get("FRAME_BACK"))[0];
      pg.image(icon, 0, 0);
    pg.endDraw();
    
    pg = layers.get("UI");
    pgOpen(pg);
      icon = (icons.get("FRAME_FRONT"))[0];
      pg.image(icon, 0, 0);
    pgClose(pg);
    
    if(scene.startsWith("MENU")) {
      pgOpen(pg, new PVector(WIDTH / 2f, HEIGHT * .5f));
        icon = (icons.get("FRAME_MENU"))[0];
        pg.image(icon, 0, 0);
      pgClose(pg);
    }
    
    if(is("META")) {
      pgOpen(pg, new PVector(WIDTH / 2f, 0f));
        icon = (icons.get("FRAME_SHIFT"))[0];
        pg.image(icon, 0f, HEIGHT * .5f);
      pgClose(pg);
      
      if(is("CONFIG")) {
        pgOpen(pg, new PVector(WIDTH / 2f, 0f));
          icon = (icons.get("FRAME_CONFIG"))[0];
          pg.image(icon, 0, HEIGHT * .15f);
          icon = (icons.get("FRAME_CONFIG_JOIN"))[0];
          pg.image(icon, 0, HEIGHT * .7f + icon.height);
          for(int i = 0; i < 4; i++) {
            pg.fill(colors[i], 64);
            pg.rect(WIDTH * -.4, HEIGHT * (.1 * i + .3), WIDTH * .8, HEIGHT * .1);
          }
          for(int i = 0, n = preset.size(); i < n; i++) {
            int team = (preset.get(i)).team;
            float rate = (n == 1) ? 0 : map(i, 0, n - 1, -1, 1) * constrain(n * .08, 0f, .3f);
            //pg.text("" + team + "," + rate, WIDTH * rate, 100 + HEIGHT * 0.2 * team);
            icon = (icons.get("SLIME_RIGHT"))[0];
            pg.tint(colors[team]);
            pg.image(icon, WIDTH * rate, HEIGHT * (.1 * team + .3) + icon.height / 2f);
            //(preset.get(i)).Draw();
          }
        pgClose(pg);
      }
      
      if(is("HELP")) {
        if(is("CON")) {
          icon = (icons.get("FRAME_HELP_CON"))[0];
        }
        if(is("KEY")) {
          icon = (icons.get("FRAME_HELP_KEY"))[0];
        }
        pgOpen(pg);
          pg.image(icon, 0f, 0f);
        pgClose(pg);
      }
      
      if(is("CREDIT")) {
        pgOpen(pg);
          icon = (icons.get("FRAME_CREDIT"))[0];
          pg.image(icon, 0f, 0f);
        pgClose(pg);
      }
    }
    
    if(scene.startsWith("FIGHT")) {
      pgOpen(pg, new PVector(WIDTH / 2f, 0f));
        pg.imageMode(CENTER);
        if(scene.endsWith("START")) {
          PImage[] tiles = icons.get("FRAME_WAITING");
          for(int i = 0; i < 3; i++) {
            pg.image(tiles[mod(int((1f - intervalTime) * 8f) + i, (tiles.length - 1))], WIDTH * .1f * (i - 1), HEIGHT * .7f);
          }
          if(intervalTime < .5f) {
            icon = (icons.get("FRAME_START"))[0];
            pg.image(icon, 0f, HEIGHT * .5f);
          }
        } else {
          icon = (icons.get("FRAME_TIME"))[0];
          pg.image(icon, 0f, icon.height / 2f);
          pg.textSize(48);
          pg.textAlign(CENTER, CENTER);
          pg.fill(#715012);
          pg.text(String.format("%.0f", timer), -1, 40 - 1);
          pg.fill(#FFE2AD);
          pg.text(String.format("%.0f", timer), 0, 40);
          
          if(scene.endsWith("WIN")) {
            icon = (icons.get("JUDGE_WIN"))[0];
            PVector v;
            v = new PVector(0f, HEIGHT * .4f);
            pg.tint(64);
            pg.image(icon, v.x + 4, v.y + 4);
            pg.noTint();
            pg.image(icon, v.x, v.y);
            Team t = getWinTeam();
            icon = (icons.get("SLIME_BIG"))[0];
            for(int n = 0; n < t.size(); n++) {
              v = new PVector(icon.width * (float(n) - t.size() / 2f + .5f), HEIGHT * .6f);
              pg.tint(color(32));
              pg.image(icon, v.x + 2, v.y + 2);
              pg.tint(t.get(n).getColor());
              pg.image(icon, v.x, v.y);
            }
          } else if(scene.endsWith("DRAW")) {
            icon = (icons.get("JUDGE_DRAW"))[0];
            PVector v;
            v = new PVector(0f, HEIGHT * .5f);
            pg.tint(64);
            pg.image(icon, v.x + 4, v.y + 4);
            pg.noTint();
            pg.image(icon, v.x, v.y);
          }
        }
      pgClose(pg);
      
      PImage slimeImage = icons.get("SLIME")[0];
      if(teams != null)
      for(int n = 0; n < teams.size(); n++) {
        Team team = teams.get(n);
        if(n * 2 - 1 <= teams.size() * 2) {
          pgOpen(pg, new PVector(0, 64 * n));
            pg.textAlign(LEFT, TOP);
            pg.textSize(12);
            pg.text(team.getTeamName(), 0, 0);
            pg.textSize(10);
            pg.text("kill " + team.getKill(), 0, 12);
            pg.imageMode(CORNER);
            for(int i = 0; i < team.size(); i++) {
              Slime slime = team.get(i);
              pg.tint((slime.isRemove()) ? color(32) : slime.getColor());
              pg.image(slimeImage, slimeImage.width * i, 24);
            }
          pgClose(pg);
        } else {
          
        }
      }
    }
  }

  List<Team> getTeams() {
    List<Team> teams = new ArrayList<Team>();
    
    for(Article a: objects) {
      if(a instanceof Slime) {
        Slime s = (Slime)a;
        boolean isExist = false;
        for(Team team: teams) {
          if(team.size() != 0 && s.team == (team.get(0)).team) {
            team.add(s);
            isExist = true;
            break;
          }
        }
        if(isExist == false) {
          Team newteam = new Team();
          newteam.add(s);
          teams.add(newteam);
        }
      }
    }
    
    return teams;
  }
  
  int countSlime() {
    int count = 0;
    for(Article a: objects) {
      if(a instanceof Slime) {
        count++;
      }
    }
    return count;
  }
  
  Team getWinTeam() {
    for(Team t: teams) {
      if(t.getID() == winTeamID()) {
        return t;
      }
    }
    return null;
  }
  
  int winTeamID() {
    int winteam = -1;
    for(Article a: objects) {
      if(a instanceof Slime) {
        Slime s = (Slime)a;
        if(winteam == -1) winteam = s.getTeam();
        else if(winteam != s.getTeam()) winteam = -2;
      }
    }
    return winteam;
  }
  
  Slime winSlime() {
    for(Article a: objects) {
      if(a instanceof Slime) {
        return (Slime)a;
      }
    }
    
    return null;
  }
}