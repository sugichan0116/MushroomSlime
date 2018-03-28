void draw() {
  //call in every frame
  Update();
  Draw();
}

void Draw() {
  //init -> draw -> flip
  DrawInit();
  
  for(Article a : objects) {
    if(a.isDraw()) a.Draw();
  }
  
  DrawSystem();
  
  DrawLayers();
}

void Update() {
  //remove
  for(int n = objects.size() - 1; n >= 0; n-- ) {
    Article a = objects.get(n);
    if(a.isRemove()) {
      objects.remove(n);
    }
    else a.Update();
  }
  
  //collide
  for(int m = 0; m < objects.size() - 1; m++) {
    for(int n = m + 1; n < objects.size(); n++) {
      Article a = (objects.get(m)), b = (objects.get(n));
      if(a.isCollide(b) && b.isCollide(a)) {
        a.collide(b);
        b.collide(a);
      }
    }
  }
  
  //build
  buildObjects();
  
  controlState.stateLog();
  keyState.Update();
  
  timer += 1f / frameRate;
  if(winTeam() >= 0 || countSlime() == 0) resultTime -= 1f / frameRate;
  if(isInput("START") || resultTime <= 0f) {
    restart();
  }
}

void buildObjects() {
  buildItem();
}

void buildItem() {
  if(random(frameRate * 4) < countSlime() * 1.5f)
  objects.add(new Item());
  if(random(frameRate * 40) < 1f)
  objects.add(new Item("ITEM_BIG", 16f, 1.4f));
}

void DrawSystem() {
  PGraphics pg;
  
  pg = layers.get("BACK");
  pg.beginDraw();
    PImage icon = (icons.get("FRAME_BACK"))[0];
    pg.image(icon, 0, 0);
  pg.endDraw();
  
  pg = layers.get("UI");
  pgOpen(pg);
    icon = (icons.get("FRAME_FRONT"))[0];
    pg.image(icon, 0, 0);
    pg.textSize(72);
    pg.textAlign(CENTER, CENTER);
    pg.text(String.format("%.0f", timer), WIDTH / 2f, HEIGHT / 16f);
    //Slime s = winSlime();
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