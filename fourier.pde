int centerX = 300;
int centerY = 300;
void setup() {
  size(600,600);
//  colorMode(HSB,360);
  background(360);
//  noLoop();
  frameRate(60);
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
  background(360);
  HashMap coeff = new HashMap();
  coeff.put(-1, 1);
  coeff.put(1, 1);
  coeff.put(2, 1*((frameCount%50)/50.0));
  coeff.put(3, 1);
  int N = 3;
  /*
  float[] coeff = new float[3];
  coeff[0] = 1;
  coeff[1] = 1;
  //coeff[1] = 1*((frameCount%150)/250.0);
  coeff[2] = 1*((frameCount)/50.0);
  //coeff[3] = 0.5*((frameCount%134)/134.0);
  //coeff[4] = 0.25*((frameCount%79)/79.0);
  //coeff[5] = 1;
  */
  for (int n = 0; n<360*8; n++) {
    float angle_in_fraction = n/360.0;
    for (int z = 0; z < 1; z++) {
    Complex c = dft_calc(angle_in_fraction, coeff, N);
    //println("angle = "+n+" real = "+c.real+ " img = "+c.img);

    //stroke(0,0,360);
    point(centerX+c.real*150,
          centerY+c.img*150);
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

Complex dft_calc(float angle_in_fraction, float[] coeff, int N) {
  float real = 0;
  float comp = 0;
  Complex i = new Complex(0, 1);

  Complex sum = new Complex(0, 0);

  Iterator iter = coeff.entrySet().iterator();

  while (iter.hasNext()) {
    Map.Entry me = (Map.Entry)iter.next();
    float k = me.getKey();
    float Xk = me.getValue();
    if (Xk == 0) continue;
    float arg = TWO_PI * k * angle_in_fraction / N;
    sum.addReal(Xk * cos(arg));
    //println("@"+sum.real);
    sum.add(i.multi(new Complex(Xk * sin(arg),0)));
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

    public Complex multi(Complex b) {
        double real = this.real * b.real - this.img * b.img;
        double img = this.real * b.img + this.img * b.real;
        return new Complex(real, img);
    }

    public void add(Complex b) {
        this.real += b.real;
        this.img += b.img;
    }

    public void addReal(double real) {
        this.real += real;
    }
}
