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
    if (magnitude < 7) return;
    this.x += xdir / magnitude * speed;
    this.y += ydir / magnitude * speed;
  }
}

float width = screen.width;
float height = screen.height;
float centerX = width/2;
float centerY = height/2;
int defaultFrameRate = 60;
Character mainCharacter = new Character(centerX, centerY, width/defaultFrameRate/2);

void setup() {
  size(width, height);
  //size(width,width);
//  colorMode(HSB,360);
  background(0);
//  noLoop();
  frameRate(defaultFrameRate);

}

void draw() {
  // drawStructure();
  background(0);
  //drawBackground();
  drawSolitaire();
  moveCharacter();
  drawCharacter();
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
  println(framesToMove+framesToPause + " " + index);
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
  stroke(360, 360, 360);
  fill(360, 360, 360);


  int steps = 1000;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;

  /* background */
  HashMap coeff2 = new HashMap();
  float baseSpeed = frameCount/8;
  coeff2.put(1, Complex.FromDegrees(baseSpeed));
  coeff2.put(-2, Complex.FromDegrees(-baseSpeed));
  coeff2.put(3, Complex.FromDegrees(-baseSpeed));

  Complex[] samps = genSamples(coeff2, 200);
  drawEllipses(samps, 1000, 40);
  /* hashmap */
  HashMap c2 = new HashMap();
  baseSpeed /= 2;
  c2.put(1, Complex.FromDegrees(baseSpeed));
  c2.put(3, Complex.FromDegrees(-baseSpeed));
  drawEllipses(genSamples(c2, 100), 1000, 20);
}

void drawEllipses(Complex[] samples, float scale, float diameter) {
  for (int i=0;i<samples.length;i++) {
    Complex c = samples[i];
    ellipse(centerX + scale*c.real, centerY+scale*c.img, diameter, diameter);
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

void moveCharacter() {
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
