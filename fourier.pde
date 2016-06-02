int centerX = 300;
int centerY = 300;
void setup() {
  size(600,600);
//  colorMode(HSB,360);
  background(0);
//  noLoop();
//  frameRate(300);
  println("YO MAN");
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
  //background(0);
  stroke(360);
  HashMap coeff = new HashMap();

  int steps = 100;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;
  coeff.put(1, Complex.FromDegrees(frameCount/2.0).multi2(-x));
  coeff.put(2, Complex.FromDegrees(x*360).multi2(x));
  coeff.put(3, Complex.FromDegrees(frameCount*5.0));
  coeff.put(4, Complex.FromDegrees(frameCount*5.0).multi2(1));

  int N = 720;

  for (int n = 0; n<N; n++) {
    //float angle_in_fraction = n/360.0;
    for (int z = 0; z < 1; z++) {
    Complex c = dft_calc(n, coeff, N);
    //println("angle = "+n+" real = "+c.real+ " img = "+c.img);

    //stroke(0,0,360);
    /*
    ellipse(centerX+300*cos((c.real+frameCount/7200.0)*TWO_PI),
            centerY+300*sin((c.img+frameCount/360.0)*TWO_PI),
            3,3
            );
            */

    ellipse(centerX+500*c.real,
          centerY+500*c.img, 3, 3);
          /*
    150*cos(TWO_PI*angle_in_fraction) * (abs(c.real+c.img)),
          centerY+150*sin(TWO_PI*angle_in_fraction) * (abs(c.real+c.img)));
          */
          /*
    point(centerX + 150*cos(TWO_PI*(angle_in_fraction+z*0.25)) * (abs(c.real*c.img)),
          centerY+150*sin(TWO_PI*(angle_in_fraction+z*0.25)) * (abs(c.real*c.img)));
          }
          */
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
    //if (Xk == 0) continue;
    float arg = TWO_PI * k * n / N;

    sum.add(Xk.multi(new Complex(cos(arg),0)));
    sum.add(Xk.multi(new Complex(0, sin(arg))));
    //println("@"+sum.real);
    //sum.add(i.multi(new Complex(Xk * sin(arg),0)));
  }
  //println(sum.real);
  //println(sum.img);
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
