
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
    else if (rays == 5) {
      for (a = [ 110, 60, 0, -60, -110 ]) ray(a);
    }
    else if (rays == 7) {
      for (a = [ 135, 90, 45, 0, -45, -90, -135 ]) ray(a);
    }
    //else if (rays == 9) {
    else {
      for (a = [ 135, 100, 65, 35, 0, -35, -65, -100, -135 ]) ray(a);
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
    if (rays == 4) {
      for (a = [ 90, 135, 180, 225 ]) ray(a, length=0.9, width=.3, delta=1.1);
    }
    else if (rays == 3) {
      for (a = [ 90, 145, 215 ]) ray(a, length=0.9, width=.3, delta=1.1);
    }
    else {
      for (a = [ 135, 180 ]) ray(a, length=0.9, width=.3, delta=1.1);
    }
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

f = "Menlo:style=Normal";
fs = .9;

evs = [
  [ 16, "bright sun", "on sand or snow", "2000" ],
  [ 15, "bright sunny day", "(hard shadows)", "1000" ],
  [ 14, "hazy sunshine", "(soft shadows)", "500" ],
  [ 13, "bright cloudy day", "(no shadows)", "250" ],
  [ 12, "heavily overcast", "day", "125" ],
  [ 11, "open shade", "sunsets", "60" ],
  [ 10, "immediately after", "sunset", "30" ],
  [ 9, "neon lights", "spot-lit subjects", "15" ],
  [ 8, "floodlit stadium", "bright day interior", "8" ],
  [ 7, "indoor sports", "stage shows", "4" ],
  [ 6, "bright night interior", "shady day interior", "2" ],
  [ 5, "average home", "night interior", "1" ],
  [ 4, "floodlit buildings", "bright streetlights", "2\"" ],
  [ 3, "streetlights", "fireworks", "4\"" ] ];

difference() {

  plate();

  translate([ 0, -1.5, 0 ]) plate(height=0.3, length=10, width=1.5);
  translate([ -5, -3.75, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);
  translate([ 3, -3.75, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);
  translate([ -5, 3.25, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);
  translate([ 3, 3.25, -.1 ]) plate(height=0.4, length=2, width=0.5, trans=0);

  translate([ -5.8, -.1, .12 ]) linear_extrude(height=0.1)
    text("EV", size=.4, font=f, spacing=fs);

  translate([ -2, -3.5, .12 ]) linear_extrude(height=0.1)
    text("shutter speed", size=.4, font=f, spacing=fs);

  dx = .73;

  for (ev = evs) {

    x = -4.7 + (16 - ev[0]) * dx;
    tx = dx / 2 - .1;
    ty = dx / 2;

    translate([ x, -.7, .12 ]) linear_extrude(height=.1)
      polygon([ [ 0, 0 ], [ tx, ty ], [ -tx, ty ] ]); // triangle
    translate([ x + tx - 0.03, -ty + 0.03, .12 ]) linear_extrude(height=.1)
      square([ .04, 3.5 ]); // line
    translate([ x - dx / 2.8, -.3, .12 ]) linear_extrude(height=.1)
      text(str(ev[0]), size=.3, font=f, spacing=fs); // EV number
    translate([ x - 0.03, .7, .12 ]) rotate(90) linear_extrude(height=.1)
      text(ev[1], size=.2, font=f, spacing=fs - .1);
    translate([ x - 0.03 + dx / 2 - .15, .7, .12 ]) rotate(90) linear_extrude(height=.1)
      text(ev[2], size=.2, font=f, spacing=fs - .1);

    translate([ x, -2.3, .12 ]) linear_extrude(height=.1) rotate(180)
      polygon([ [ 0, 0 ], [ tx, ty ], [ -tx, ty ] ]); // triangle
    translate([ x - dx / 2.8, -2.9, .12 ]) linear_extrude(height=.1)
      text(ev[3], size=.2, font=f, spacing=fs); // EV number
  }

  translate([ -4.8, .39, .12 ]) scale([ .1, .1, .1 ])
    sun(rays=11);
  translate([ -4.8 + 1 * dx, .39, .12 ]) scale([ .1, .1, .1 ])
    sun(rays=9);
  translate([ -4.8 + 2 * dx - 0.05, .29, .12 ]) scale([ .1, .1, .1 ])
    cloudy();
  translate([ -4.8 + 3 * dx + 0.05, .29, .12 ]) scale([ .1, .1, .1 ])
    cloud();
  translate([ -4.8 + 4 * dx + 0.05, .29, .12 ]) scale([ .1, .1, .1 ])
    cloud();
  translate([ -4.8 + 5 * dx + 0.0, .29, .12 ]) scale([ .1, .1, .1 ])
    double_cloud();
  //
  translate([ -4.8 + 8 * dx + 0.0, .33, .12 ]) scale([ .1, .1, .1 ])
    bulb(rays=9);
  translate([ -4.8 + 9 * dx + 0.0, .33, .12 ]) scale([ .1, .1, .1 ])
    bulb(rays=7);
  translate([ -4.8 + 10 * dx + 0.0, .33, .12 ]) scale([ .1, .1, .1 ])
    bulb(rays=5);
  translate([ -4.8 + 11 * dx + 0.0, .33, .12 ]) scale([ .1, .1, .1 ])
    bulb(rays=3);
  translate([ -4.8 + 12 * dx + 0.0, .40, .12 ]) scale([ .1, .1, .1 ])
    streetlamp(rays=4);
  translate([ -4.8 + 13 * dx + 0.0, .40, .12 ]) scale([ .1, .1, .1 ])
    streetlamp(rays=2);
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

  difference() {
    translate([ -6, 2.75, 0 ]) plate(0.5, 12, 0.5, trans=0);
    translate([ -5.5, 2.75, 0 ]) plate(0.5, 11, 0.5, trans=0);
  }
}

// inside plate

translate([ 0, -10, 0 ]) {
  color("dodgerblue") union() {
    plate(width=5.99);
    translate([ 0, 3.10, 0 ]) plate(.1, .5, .5, .5);
  }
}

