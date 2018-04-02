class Manager {
  String scene;
  float timer, intervalTime;
  color[] colors;
  
  Manager() {
    scene = "SETUP";
    colors = new color[]{#FF6262, #79F0ED, #FBFF1A, #52FF65};
    intervalTime = 5f;
  }
  
  void restart() {
    timer = 0f;
    objects = new ArrayList<Article>();
    objects.add(new Slime(0, colors, "ARROWS"));
    objects.add(new Slime(0, colors, "CONTROLLER", 0));
    objects.add(new Slime(0, colors, "CONTROLLER", 1));
    objects.add(new Slime(1, colors, "CONTROLLER", 2));
    objects.add(new Slime(2, colors, "CONTROLLER", 3));
    objects.add(new AutoSlime(3, colors));
    teams = getTeams();
    sounds.play("BGM_WATER");
    sounds.play("BGM_NIGHT");
  }
  
  boolean is(String sceneKey) {
    return scene.indexOf(sceneKey) != -1;
  }
  
  void Update() {
    if(scene.startsWith("SETUP")) {
      scene = "MENU";
      sounds.play("TITLE");
    }
    if(scene.startsWith("MENU")) {
      intervalTime -= 1f / frameRate;
      if(intervalTime <= 0f) scene = "FIGHT_RESTART";
      if(mousePressed && (mouseButton == LEFT)) scene = "CONFIG";
    }
    if(is("CONFIG")) {
      if(mousePressed && (mouseButton == RIGHT)) scene = "MENU";
      
    }
    
    if(scene.startsWith("FIGHT_START")) {
      intervalTime -= 1f / frameRate;
      if(intervalTime <= 0f) scene = "FIGHT_MAIN";
    }
    if(scene.startsWith("FIGHT_MAIN")) {
      if(winTeamID() >= 0) scene = "FIGHT_END_WIN";
      if(countSlime() == 0) scene = "FIGHT_END_DRAW";
      if(scene.indexOf("FIGHT_END") != -1) intervalTime = 3f;
      if(isInput("START")) scene = "FIGHT_RESTART";
      timer += 1f / frameRate;
    }
    if(scene.startsWith("FIGHT_END")) {
      intervalTime -= 1f / frameRate;
      if(intervalTime <= 0f) {
        scene = "FIGHT_RESTART";
      }
    }
    if(is("FIGHT_RESTART")) {
      restart();
      intervalTime = 1f;
      scene = "FIGHT_START";
    }
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
      pgOpen(pg, new PVector(WIDTH / 2f, HEIGHT * .6f));
        icon = (icons.get("FRAME_MENU"))[0];
        pg.imageMode(CENTER);
        pg.image(icon, 0, 0);
      pgClose(pg);
    }
    
    if(is("CONFIG")) {
      pgOpen(pg);
        icon = (icons.get("FRAME_CREDIT"))[0];
        pg.image(icon, 0f, 0f);
      pgClose(pg);
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
            pg.image(icon, 0f, HEIGHT * .7f);
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
            v = new PVector(0f, HEIGHT / 2f);
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
            v = new PVector(0f, HEIGHT * .7f);
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