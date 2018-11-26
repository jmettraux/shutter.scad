
$fn=60;

//
// ray()

module ray(angle=0, length=1.4, width=.4, delta=2) {
  rotate(angle)
    translate([ 0, delta, 0 ])
    square([ width, length ], center=true);
}

//
// cloud()

module cloud(height=1) {
  linear_extrude(height=height) {
    translate([ -1, 0, 0 ]) circle(1);
    translate([ 1, 0, 0 ]) circle(1);
    translate([ -1, -1, 0 ]) square(2);
    translate([ 0, 1, 0 ]) circle(1);
  }
}

//
// double_cloud()

module double_cloud(height=1) {
  translate([ .6, -.5, 0 ]) {
    difference() {
      translate([ -1.4, .5, 0 ]) cloud(height);
      cloud(height);
    }
    translate([ .2, -.2, 0 ]) cloud(height);
  }
}

//
// sun()

module sun(height=1, rays=8, length=1.3) {
  linear_extrude(height=height) {
    circle(1);
    inc = 360 / rays;
    for (a = [ 0: inc: 360 ]) ray(a);
  }
}

//
// cloudy()

module cloudy(height=1) {
  difference() {
    translate([ 1, 1, 0 ]) difference() {
      sun(height);
      linear_extrude(height) ray(90);
      linear_extrude(height) ray(180);
    }
    translate([ -.7, -.3, 0 ]) cloud(height);
  }
  translate([ -.9, -.5, 0 ]) cloud(height);
}

//
// bulb()

module bulb(height=1, rays=3) {
  linear_extrude(height=height) {
    hull() {
      translate([ 0, 0, 0 ]) circle(1);
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

//
// streetlamp()

module slice(r=1, angle=30) {
  intersection() {
    circle(r=r);
    square(r);
    rotate(angle - 90) square(r);
  }
}

module streetlamp(height=1, rays=3) {
  linear_extrude(height=height) {
    circle(.3);
    translate([ -.4, 0, 0 ]) square([ 2, .5 ]);
    translate([ 1.5, -3, 0 ]) square([ .5, 3 ]);
    translate([ 1.5, 0, 0 ]) slice(.5, 90);
      for (a = [ 90, 135, 180, 225 ])
        ray(a, length=0.9, width=.3, delta=1.1);
  }
}

//
// penta()

module penta(height=1, base=2, side=2, length=4) {
  b = base / 2;
  linear_extrude(height=height) {
    polygon([ [ -b, 0 ], [ -b, side ], [ 0, length ], [ b, side ], [ b, 0 ] ]);
  }
}

//
// plate()

module plate(height=0.2, length=12, width=7.5, trans=1) {
  tx = -length / 2 * trans;
  ty = -width / 2 * trans;
  translate([ tx, ty, 0 ])
    linear_extrude(height=height) {
      square([ length, width ]);
    }
}


//
// main

// top plate

difference() {

  f = "Menlo:style=Normal";
  fs = .9;

  plate();

  translate([ 0, -1, 0 ]) plate(height=0.3, length=10, width=2);
  translate([ -5, -3.75, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);
  translate([ 3, -3.75, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);
  translate([ -5, 3.25, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);
  translate([ 3, 3.25, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);

  translate([ -5.8, .3, .12 ]) linear_extrude(height=0.1)
    text("EV", size=.4, font=f, spacing=fs);

  translate([ -2, -3.5, .12 ]) linear_extrude(height=0.1)
    text("shutter speed", size=.4, font=f, spacing=fs);
}

// bottom plate

translate([ 0, 10, 0 ]) {
  plate();
  translate([ -6, -3.75, 0 ]) plate(0.5, 12, 0.5, trans=0);
  translate([ -6, 3.25, 0 ]) plate(0.5, 12, 0.5, trans=0);
  translate([ -5, -3.75, 0.5 ]) plate(height=0.2, length=2, width=0.5, trans=0);
  translate([ 3, -3.75, 0.5 ]) plate(height=0.2, length=2, width=0.5, trans=0);
  translate([ -5, 3.25, 0.5 ]) plate(height=0.2, length=2, width=0.5, trans=0);
  translate([ 3, 3.25, 0.5 ]) plate(height=0.2, length=2, width=0.5, trans=0);
}

// inside plate

translate([ 0, -10, 0 ]) {
  color("dodgerblue") plate(width=6.49);
}

