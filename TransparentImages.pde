void setup()
{ 
  PImage pic1 = loadImage("1.png");
  PImage pic2 = loadImage("2.png");
  int w = max(pic1.width, pic2.width);
  int h = max(pic1.height, pic2.height);

  surface.setSize(w, h);

  PImage out = createImage(w, h, ARGB);
  out.loadPixels();

  for (int i = 0; i < out.pixels.length; i++)
  {
    out.pixels[i] = mergeColor(pic1.pixels[i], pic2.pixels[i], color(34), color(255));
    println(i);
  }

  out.updatePixels();
  out.save("out.png");
  exit();
}

color mergeColor(color c1, color c2, color bg1, color bg2) {
  float A1 = getLum(c1, true, false);
  float A2 = getLum(c2, false, true);
  float R = weightedAverage(red(bg1), A1, red(bg2), A2);
  float G = weightedAverage(green(bg1), A1, green(bg2), A2);
  float B = weightedAverage(blue(bg1), A1, blue(bg2), A2);
  float A = (A1 + A2)/2;
  return color(R, G, B, A);
}

float getLum(color c, boolean isInverted, boolean isBGInverted)
{
  float lum = (red(c) + green(c) + blue(c)) / 3;
  float bgLum = 255;
  if (isBGInverted != isInverted) {
    bgLum = 0;
  }
  if (isInverted) { 
    lum = 255 - lum;
  }
  return weightedAverage(lum, alpha(c), bgLum, 255 - alpha(c));
}

color weightedAverage(color c1, float weight1, color c2, float weight2)
{
  if (weight1 + weight2 == 0)
  {
    return weightedAverage(c1, 255/2, c2, 255/2);
  }

  int A = 255; 
  float R = weightedAverage(red(c1), weight1, red(c2), weight2);
  float G = weightedAverage(green(c1), weight1, green(c2), weight2);
  float B = weightedAverage(blue(c1), weight1, blue(c2), weight2);
  return color(R, G, B, A);
}

float weightedAverage(float val1, float weight1, float val2, float weight2)
{
  if (weight1 + weight2 == 0)
  {
    return ((val1 + val2)/2);
  }
  
  return ((val1 * weight1 + val2 * weight2) / (weight1 + weight2));
}
