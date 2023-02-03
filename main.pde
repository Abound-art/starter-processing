void setup() {
  if (args == null || args.length == 0) {
    println("no args were provided");
    exit();
  }
  size(0,0);
  Config cfg = new Config(args[0]);
  PImage img = run(cfg);
  img.save(args[1]);
  exit();
}
