class Config {
  float beta, rho, sigma, dt;
  int iterations, resultSize;

  Config(String filename) {
    JSONObject json = loadJSONObject(filename);
    rho = json.getFloat("rho");
    sigma = json.getFloat("sigma");
    beta = json.getFloat("beta");
    dt = json.getFloat("dt");
    iterations = json.getInt("iterations");
    resultSize = json.getInt("result_size");
  }
}

PImage run(Config cfg) {
  Point3[] points = new Point3[cfg.iterations];
  points[0] = new Point3(1, 1, 1);
  Bounds bounds = new Bounds(new Point3(1, 1, 1), new Point3(1, 1, 1));
  for (int i = 1; i < cfg.iterations; i++) {
    Point3 point = nextStep(cfg, points[i-1]);
    points[i] = point;
    bounds.expand(point);
  }
  for (int i = 0; i < points.length; i++) {
    points[i] = bounds.translate(points[i], cfg.resultSize);
  }
  int[][] counts = new int[cfg.resultSize][];
  for (int i = 0; i < cfg.resultSize; i++) {
    counts[i] = new int[cfg.resultSize];
  }
  int maxCount = 0;
  for (int i = 0; i < points.length; i++) {
    Point3 point = points[i];
    int x = floor(point.x);
    int y = floor(point.y);
    counts[x][y]++;
    if (counts[x][y] > maxCount) {
      maxCount = counts[x][y];
    }
  }
  PImage img = createImage(cfg.resultSize, cfg.resultSize, RGB);
  for (int i = 0; i < counts.length; i++) {
    for (int j = 0; j < counts[i].length; j++) {
      int count = counts[i][j];
      if (count == 0) {
        img.pixels[j * cfg.resultSize + i] = color(0, 0, 0);
      } else {
        float pos = sqrt(sqrt(float(count) / float(maxCount)));
        int b = int(pos*200) % 256 + 55;
        int g = int((1-pos)*200) % 256 + 55;
        img.pixels[j * cfg.resultSize + i] = color(0, g, b);
      }
    }
  }
  return img;
}

Point3 nextStep(Config cfg, Point3 p) {
  float dxdt = cfg.sigma * (p.y - p.x);
  float dydt = p.x*(cfg.rho-p.z) - p.y;
  float dzdt = p.x*p.y - cfg.beta*p.z;
  return new Point3(p.x + dxdt*cfg.dt, p.y + dydt*cfg.dt, p.z + dzdt*cfg.dt);
}

class Point3 {
  float x, y, z;
  
  Point3(float xx, float yy, float zz) {
    x = xx;
    y = yy;
    z = zz;
  }
}

class Bounds {
  Point3 min, max;
  
  Bounds(Point3 mn, Point3 mx) {
    min = mn;
    max = mx;
  }
  
  void expand(Point3 p) {
    if (p.x < min.x) {
      min.x = p.x;
    }
    if (p.y < min.y) {
      min.y = p.y;
    }
    if (p.z < min.z) {
      min.z = p.z;
    }
    if (p.x > max.x) {
      max.x = p.x;
    }
    if (p.y > max.y) {
      max.y = p.y;
    }
    if (p.z > max.z) {
      max.z = p.z;
    }
  }
  
  Point3 translate(Point3 p, int resultSize)  {
    float relX = (p.x - min.x) / (max.x - min.x);
    float relY = (p.y - min.y) / (max.y - min.y);
    float relZ = (p.z - min.z) / (max.z - min.z);
    float s = resultSize - 1;
    return new Point3(relX * s, relY * s, relZ * s);
  }
}
