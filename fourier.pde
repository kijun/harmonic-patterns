int centerX = 300;
int centerY = 300;
void setup() {
  size(600,600);
//  colorMode(HSB,360);
  background(0);
//  noLoop();
  frameRate(20);
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
  stroke(360);
  HashMap coeff = new HashMap();
  float inner_radius = mouseX/2;
  float pen_distance = mouseY/2;

/* whirl
  //background(0);
  int steps = 100;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;
  coeff.put(1, Complex.FromDegrees(frameCount/2.0).multi2(-x));
  coeff.put(2, Complex.FromDegrees(x*360).multi2(x));
  coeff.put(3, Complex.FromDegrees(frameCount*5.0));
  coeff.put(4, Complex.FromDegrees(frameCount*5.0).multi2(1));
  int N = 360;
*/
  //basic shapes;
  background(0);

  int steps = 100;
  float x = steps - abs(frameCount % (2*steps) - steps);
  x = x/steps;

//  coeff.put(1.7, Complex.FromDegrees(-x*360));
  //coeff.put(1.71, Complex.FromDegrees(x*360));
  //coeff.put(3, Complex.FromDegrees(0));
  //coeff.put(4, Complex.FromDegrees(0).multi2(-0.5));
  //coeff.put(5, Complex.FromDegrees(abs(x*3)*360).multi2(x*2));

  //draw2(coeff, 18, 100, 10);

  //coeff.put(x*10, Complex.FromDegrees(360));

  //coeff.put(0, new Complex.FromDegrees(x*360*random()).multi2(x));
  //coeff.put(5, Complex.FromDegrees(x*360));//.multi2(x+random()/20));
  float l = -2+x;
  float m = 5-x*4;
  coeff.put(l, Complex.FromDegrees(0).multi2((1/(l*l))*(-x)));//.multi2(x+random()/20));
  coeff.put(m, Complex.FromDegrees(0).multi2(pow(2, x)));//.multi2(x+random()/20));
  //coeff.put(200000, Complex.FromDegrees(x*36));//.multi2(x+random()/20));
  //coeff.put(3, Complex.FromDegrees(x*360).multi2(x));
  //draw2(coeff, 720, 50, 3);

  HashMap coeff2 = new HashMap();
  //coeff2.put(1000, Complex.FromDegrees(frameCount).multi2(x*3));
  coeff2.put(10, Complex.FromDegrees(frameCount));
  coeff2.put(25, Complex.FromDegrees(-frameCount).multi2(1-x));
  coeff2.put(3, Complex.FromDegrees(frameCount*2.573));

  //stroke(80);
  //draw2(coeff2, 15, 100, 10);
  strokeWeight(10);
  stroke(360);
  line(100, 150, 100+50, 150+50);
}

void draw2(HashMap coeff, int N, float scale, float dot_size) {
  //int N = 360;
  for (int n = 0; n<N; n++) {
    //float angle_in_fraction = n/360.0;
    for (int z = 0; z < 1; z++) {
      Complex c = dft_calc(n, coeff, N);


      float x = centerX + scale*c.real;
      float y = centerY + scale*c.img;
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
