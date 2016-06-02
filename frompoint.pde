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
    this.x += xdir / magnitude * speed;
    this.y += ydir / magnitude * speed;
  }
}

int centerX = 300;
int centerY = 300;
Character mainCharacter = new Character(centerX, centerY, 3);

void setup() {
  size(600,600);
//  colorMode(HSB,360);
  background(0);
//  noLoop();
  frameRate(60);

}

/*
void setup() {
  size(200, 200);
  background(100);
  stroke(255);
  ellipse(50, 50, 25, 25);
  println("hello web!");
}
*/

void draw() {
  background(0);
  stroke(360, 360, 360);
  fill(360, 360, 360);

  HashMap coeff = new HashMap();

  int steps = 1000;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;

  HashMap coeff2 = new HashMap();
  coeff2.put(1, Complex.FromDegrees(frameCount/2));
  //coeff2.put(-1, Complex.FromDegrees(frameCount/120).multi(1/sq(x)));
  coeff2.put(2, Complex.FromDegrees(frameCount/4));
  //coeff2.put(4, Complex.FromDegrees(x*360));
  //coeff2.put(6, Complex.FromDegrees(frameCount/120).multi2(0.5+x));
  //coeff2.put(7, Complex.FromDegrees(-frameCount/8));

  Complex[] samps = genSamples(coeff2, 150);
  float scale = 200;
  for (int i=0;i<150;i++) {
    Complex c = samps[i];
    ellipse(c.magnitude()*scale+100, i*4, c.img*40, 1);
  }

  drawPattern(coeff2, 100, 150, 5);

  moveCharacter();
  drawCharacter();
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

void drawCharacter() {
  stroke(213, 85, 47);
  fill(213, 85, 47);
  ellipse(mainCharacter.x, mainCharacter.y, 4, 4);
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
