int centerX = 300;
int centerY = 300;
void setup() {
  size(600,600);
//  colorMode(HSB,360);
  background(0);
//  noLoop();
  frameRate(20);
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
  stroke(360);
  background(0);
  HashMap coeff = new HashMap();

  int steps = 100;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;

  HashMap coeff2 = new HashMap();
  coeff2.put(10, Complex.FromDegrees(frameCount));
  coeff2.put(25, Complex.FromDegrees(-frameCount).multi2(1-x));
  coeff2.put(3, Complex.FromDegrees(frameCount*2.573));

  draw2(coeff2, 30, 50, 5);
}

void draw2(HashMap coeff, int N, float scale, float dot_size) {
  //int N = 360;
  for (int n = 0; n<N; n++) {
    //float angle_in_fraction = n/360.0;
    for (int z = 3; z < 4; z++) {
      Complex c = dft_calc(n, coeff, N);


      float x = centerX + scale*c.real*(z+1);
      float y = centerY + scale*c.img*(z+1);
      ellipse(x, y, dot_size, dot_size);
      //stroke(360);

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
