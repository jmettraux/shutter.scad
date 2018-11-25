
module cloud(height=1) {
  linear_extrude(height=height) {
    translate([ -1, 0, 0 ]) circle(1, $fn=20);
    translate([ 1, 0, 0 ]) circle(1, $fn=20);
    translate([ -1, -1, 0 ]) square(2);
    translate([ 0, 1, 0 ]) circle(1, $fn=20);
  }
}

translate([ 0, -7, 0 ]) cloud(.5);

module ray(angle=0, length=1.4, width=.4) {
  rotate(angle)
    translate([ 0, 2, 0 ])
    square([ width, length ], center=true);
}
module sun(height=1, rays=8, length=1.3) {
  linear_extrude(height=height) {
    circle(1, $fn=90);
    inc = 360 / rays;
    for (a = [ 0: inc: 360 ]) ray(a);
  }
}

translate ([ 7, -7, 0 ]) sun(.5, rays=6);

module bulb(height=1, rays=3) {
  linear_extrude(height=height) {
    hull() {
      translate([ 0, 0, 0 ]) circle(1, $fn=90);
      translate([ -.5, -1.3, 0 ]) square([ 1, 1 ]);
    }
    translate([ -.5, -2, 0 ]) square([ 1, 1 ]);
    if (rays == 3) {
      for (a = [ 90, 0, -90 ]) ray(a);
    }
    else {
      for (a = [ 45, 90, 135, 0, -45, -90, -135 ]) ray(a);
    }
  }
}

translate ([ -7, -7, 0 ]) bulb(.5, rays=7);

