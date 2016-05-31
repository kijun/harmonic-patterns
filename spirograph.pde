//float a,b,h,xpos,ypos,oxpos,oypos,t,ot,d,od;
int centerX,centerY;

float outer_radius = 200;
float inner_radius = 30;
float pen_distance = 20;

float rand_mag = 10;
int frame_rate = 5;

void setup() {
  size(600,600);
  colorMode(HSB,360);
  background(0);
  centerX = width/2;
  centerY = height/2;
//  frameRate(frame_rate);
}

void draw() {
  background(0);

  inner_radius = mouseX/2;
  pen_distance = mouseY/2;
  //h = mouseY;

/*
  outer_radius += random(-1 * rand_mag, rand_mag);
  inner_radius += random(-1 * rand_mag, rand_mag);
  pen_distance += random(-1 * rand_mag, rand_mag);
  */

  for(int i=1; i<361*10; i+=1) {
    float t = radians(i);
    float inner_x0 = (outer_radius-inner_radius) * cos(t);
    float inner_y0 = (outer_radius-inner_radius) * sin(t);

    float outer_circ = outer_radius * TWO_PI;
    float inner_circ = inner_radius * TWO_PI;

    float outer_rot_dist = outer_circ * i / 360;
    float inner_rot_angle = -1 * outer_rot_dist / inner_circ * TWO_PI; // radians, goes opposite direction
    float inner_dx = pen_distance * cos(inner_rot_angle);
    float inner_dy = pen_distance * sin(inner_rot_angle);

    float x = centerX + inner_x0 + inner_dx;
    float y = centerY + inner_y0 + inner_dy;
    stroke(i-1%360,360,360);
    point(x,y);
    //ellipse(x, y, 50, 50);

/*
    oxpos = (a-b)*cos(ot)+h*cos(od);
    oypos = (a-b)*sin(ot)+h*sin(od);

    xpos = (a-b)*cos(t)+h*cos(d);
    ypos = (a-b)*sin(t)+h*sin(d);
    */

//    stroke(i-1,360,360);
    //line(centerX+oxpos, centerY+oypos, centerX+xpos, centerY+ypos);
    //line(centerX, centerY, a, h);
  }
}

/*
void mousePressed() {
  save("spiro_big_"+a+"_"+b+"_"+h+".tif");
}
*/
