class Character {
  float x;
  float y;
  float speed;

  public Character(float x, float y, float speed) {
    this.x = x;
    this.y = y;
    this.speed = speed;
  }

  public void MoveToward(float xdir, float ydir) {
    float magnitude = sqrt(xdir*xdir+ydir*ydir);
    //if (magnitude < 7) return;
    this.x += xdir / magnitude * speed;
    this.y += ydir / magnitude * speed;
  }
}

float width = screen.width/2;
float height = screen.height;
//float width = 1000;
//float height = 500;
float centerX = width/2;
float centerY = height/2;
int defaultFrameRate = 60;
Character mainCharacter = new Character(centerX, centerY, width/defaultFrameRate/2);

void setup() {
  size(width, height);
  //size(width,width);
//  colorMode(HSB,360);
  background(255);
//  noLoop();
  frameRate(defaultFrameRate);

}

void draw() {
  // drawStructure();
  //background(255);
  background(0);
  //drawBackground();
  //drawBackground2();
  drawSolitaire();
  moveCharacter();
  drawCharacter();
}

void drawBackground2() {
  stroke(255);
  fill(0,0);
  int steps = 500;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;
  //ellipse(centerX+300*(x-0.5), centerY, 200*(2-x), 200*(2-x));
  ellipse(centerX+300*(x-0.5), centerY, 200, 200);

  //ellipse(centerX+400, centerY-300, 100*(2-x), 100*(2-x));
  //ellipse(centerX-500, centerY+100, 100, 100);

  //ellipse(centerX+100*(1-x), centerY-100*(1-x), 100*(2-x), 100*(2-x));
  //ellipse(centerX-100*(1-x), centerY-100*(1-x), 200*(2-x), 200*(2-x));
  //ellipse(centerX+100*(1-x), centerY+100*(1-x), 200*(2-x), 200*(2-x));
  //ellipse(centerX-100*(1-x), centerY+100*(1-x), 200*(2-x), 200*(2-x));
  //ellipse(centerX+100, centerY-100, 400, 400);
}

void drawBackground() {
  int color = 20;
  stroke(color, color, color);
  fill(color, color, color);

  // [params]
  int dotCount = 8;
  float moveForSec = 0.8;
  float pauseForSec = 0.2;

  // [calc]
  float framesToMove = defaultFrameRate * moveForSec;
  float framesToPause = defaultFrameRate * pauseForSec;

  float xdisp = 0;
  float ydisp = 0;

  float dispPerFrame = (width/(int)dotCount)/framesToMove;
  bool sign = true;

  int index = frameCount % (framesToMove+framesToPause);
  //println(framesToMove+framesToPause + " " + index);
  if (index < framesToMove) {
    if ((int)(frameCount / (framesToMove+framesToPause)) % 2 == 0) {
      xdisp = dispPerFrame * index;
      //ydisp = dispPerFrame * index;
    } else {
      //xdisp = dispPerFrame * index;
      //ydisp = dispPerFrame * index;
      xdisp = dispPerFrame * index * -1;
    }
  }

  for (int i=-1; i<dotCount+1; i++) {
    for (int j=-1; j<dotCount+1; j++) {
      float xpos = xdisp + i*width/(float)dotCount;
      float ypos = ydisp + j*width/(float)dotCount;
      ellipse(xpos, ypos, 10, 10);
    }
  }
}

void drawSolitaire() {
  stroke(255);
  fill(255);

  int steps = 250;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;
  //x = (frameCount % steps)/steps;

  /* background */
  // from 1s to 10s
  HashMap coeff2 = new HashMap();
  float baseSpeed = frameCount/8;
  float sec = millis()/1000;

  float s1 = 0;
  float s2 = 70;
  float p1 = (sec - s1)/(s2-s1);
  float minFactor = 0.3;
  float maxFactor = 0.6;
  float currFactor = ((maxFactor-minFactor)/(s2-s1)) * (millis()/1000.0-1)+minFactor;

  // 0s = 0.1
  // 5s = 0.6
  // 10s = 0.1
  coeff2.put(1, Complex.FromDegrees(baseSpeed*currFactor));
  coeff2.put(-2, Complex.FromDegrees(-baseSpeed*currFactor));
  coeff2.put(3, Complex.FromDegrees(-baseSpeed*currFactor));
  //coeff2.put(3, Complex.FromDegrees(-baseSpeed*0.5));

  if (sec > s1 && sec < s2) {
  Complex[] samps = genSamples(coeff2, 200);
  drawEllipses(samps, 1000, 40, 0, height*3*p1-height/2);
  }

  /* hashmap */
  float ss1 = 5;
  float ss2 = 40;
  float progress = (sec - ss1)/(ss2-ss1);

  if (sec < ss1 || sec > ss2) return;

  HashMap c2 = new HashMap();
  baseSpeed /= 2;
  c2.put(2, Complex.FromDegrees(-baseSpeed*1));
  c2.put(3, Complex.FromDegrees(baseSpeed*1.5).multi2(1+progress));
  stroke(255*progress);
  fill(255*progress);
  drawEllipses(genSamples(c2, 130), 300*(progress+0.3), 5, 0, height * 2.5* progress - height);

  //drawEllipses(genSamples(c2, 70), 1000, 5);
  return;

/*
  HashMap c3 = new HashMap();
  c3.put(3, Complex.FromDegrees(baseSpeed).multi2(2-x));
  //stroke(255*x);
  drawEllipses(genSamples(c3, 60), 400, 5);
  */

  HashMap c4 = new HashMap();
  c4.put(3, Complex.FromDegrees(baseSpeed).multi2(1-x));
  stroke(255*(1-x));
  drawEllipses(genSamples(c4, 60), 400, 5*(1-x));
  stroke(255);

  HashMap c5 = new HashMap();
  c5.put(1, Complex.FromDegrees(1*baseSpeed));
  c5.put(-1, Complex.FromDegrees(-0.5*baseSpeed));
  drawEllipses(genSamples(c5, 40), 500, 5);

  HashMap c6 = new HashMap();
  c6.put(1, Complex.FromDegrees(1*baseSpeed+90));
  c6.put(-1, Complex.FromDegrees(-0.5*baseSpeed+90));
  drawEllipses(genSamples(c6, 40), 500, 5);
}

void drawEllipses(Complex[] samples, float scale, float diameter, float dx, float dy) {
  for (int i=0;i<samples.length;i++) {
    Complex c = samples[i];
    ellipse(centerX + scale*c.real + dx, centerY+scale*c.img + dy, diameter, diameter);
  }
}

void moveCharacter() {
  if (!keyPressed) return;
  float xdir = 0;
  float ydir = 0;
  if (key == CODED) {
    if (keyCode == UP) {
      ydir = -1;
    }
    if (keyCode == DOWN) {
      ydir = 1;
    }
    if (keyCode == RIGHT) {
      xdir = 1;
    }
    if (keyCode == LEFT) {
      xdir = -1;
    }
  }
  if (xdir != 0 || ydir != 0) {
    mainCharacter.MoveToward(xdir, ydir);
  }
}

void moveCharacterr() {
  xpos = mouseX;
  ypos = mouseY;
  mainCharacter.MoveToward(xpos-mainCharacter.x, ypos - mainCharacter.y);
}

void drawCharacter() {
  stroke(213, 85, 47);
  fill(213, 85, 47);
  ellipse(mainCharacter.x, mainCharacter.y, 10, 10);
}

Complex[] genSamples(HashMap coeff, int N) {
  Complex[] data = new Complex[N];

  for (int n = 0; n<N; n++) {
    data[n] = dft_calc(n, coeff, N);
  }

  return data;
}

void drawPattern(HashMap coeff, int N, float scale, float dot_size) {
  //int N = 360;
  for (int n = 0; n<N; n++) {
    //float angle_in_fraction = n/360.0;
    for (int z = 0; z < 1; z++) {
      Complex c = dft_calc(n, coeff, N);

      float x = centerX + scale*c.real*(z+1);
      float y = centerY + scale*c.img*(z+1);
      ellipse(x, y, dot_size, dot_size);
    }
  }
}

Complex dft_calc(int n, HashMap coeff, int N) {
  float real = 0;
  float comp = 0;
  Complex i = new Complex(0, 1);

  Complex sum = new Complex(0, 0);

  Iterator iter = coeff.entrySet().iterator();

  while (iter.hasNext()) {
    Map.Entry me = (Map.Entry)iter.next();
    float k = me.getKey();
    Complex Xk = me.getValue();
    float arg = TWO_PI * k * n / N;

    sum.add(Xk.multi(new Complex(cos(arg),0)));
    sum.add(Xk.multi(new Complex(0, sin(arg))));
  }
  return sum;
}

class Complex {
    double real;   // the real part
    double img;   // the imaginary part

    public Complex(double real, double img) {
        this.real = real;
        this.img = img;
    }

    public static Complex FromDegrees(float angleInDeg) {
      return Complex.FromRadian(TWO_PI * angleInDeg / 360);
    }

    public static Complex FromRadian(float radian) {
      return new Complex(cos(radian), sin(radian));
    }

    public Complex multi(Complex b) {
        double real = this.real * b.real - this.img * b.img;
        double img = this.real * b.img + this.img * b.real;
        return new Complex(real, img);
    }

    public float magnitude() {
      return sqrt(real*real+img*img);
    }

    public void add(Complex b) {
        this.real += b.real;
        this.img += b.img;
    }

    public void addReal(double real) {
        this.real += real;
    }

    public Complex normalize() {
      float mag = magnitude();
      return new Complex(real/mag, img/mag);
    }

    public Complex multi2(float scale) {
      return new Complex(scale*real, scale*img);
    }
}
