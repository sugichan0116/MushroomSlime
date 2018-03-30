class Manager {
  String scene;
  float timer, resultTime;
  
  Manager() {
    scene = "MENU";
  }
  
  void restart() {
    timer = 0f;
    resultTime = 3f;
    objects = new ArrayList<Article>();
    //objects.add(new Slime(0, "ARROWS"));
    //objects.add(new Slime(0, "KEYBOARD"));
    objects.add(new Slime(1, "CONTROLLER", 0));
    objects.add(new Slime(2, "CONTROLLER", 1));
    objects.add(new Slime(3, "CONTROLLER", 2));
    objects.add(new AutoSlime(4));
    objects.add(new AutoSlime(4));
    objects.add(new AutoSlime(4));
    objects.add(new AutoSlime(4));
    teams = getTeams();
    sounds.play("BGM_WATER");
  }
  
  void Update() {
    if(timer > 4f) scene = "FIGHT";
    
    timer += 1f / frameRate;
    if(winTeam() >= 0 || countSlime() == 0) resultTime -= 1f / frameRate;
    if(isInput("START") || resultTime <= 0f) {
      restart();
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
    
    if(scene == "MENU") {
      pgOpen(pg, new PVector(WIDTH / 2f, HEIGHT * .6f));
        icon = (icons.get("FRAME_MENU"))[0];
        pg.imageMode(CENTER);
        pg.image(icon, 0, 0);
      pgClose(pg);
    }
    
    if(scene == "FIGHT") {
      pgOpen(pg);
        pg.imageMode(CENTER);
        icon = (icons.get("FRAME_TIME"))[0];
        pg.image(icon, WIDTH / 2f, icon.height / 2f);
        pg.textSize(48);
        pg.textAlign(CENTER, CENTER);
        pg.text(String.format("%.0f", timer), WIDTH / 2f, 40);
        pg.text(((winTeam() >= 0) ? "Win " + winSlime().getTeamName() + " ": "")
          , WIDTH / 2f, HEIGHT / 2f);
      pgClose(pg);
      
      PImage slimeImage = icons.get("SLIME")[0];
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
  
  int winTeam() {
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