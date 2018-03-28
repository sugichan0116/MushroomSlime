class Team {
  List<Slime> list;
  private int kill;
  
  Team() {
    list = new ArrayList<Slime>();
    kill = 0;
  }
  
  int size() {
    return list.size();
  }
  
  void add(Slime s) {
    list.add(s);
  }
  
  Slime get(int i) {
    return list.get(i);
  }
  
  String getTeamName() {
    return (size() != 0) ? get(0).getTeamName() : "none";
  }
  
  int getID() {
    return (size() != 0) ? get(0).getTeam() : -1;
  }
  
  void killed() {
    kill++;
  }
  
  int getKill() {
    return kill;
  }
}