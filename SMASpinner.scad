use <knurledFinishLib_v2.scad>
/*
  SMASpinner.scad
 
  Author: radiogeek381@gmail.com

  A simple knurled widget that slides onto an SMA (5/16") male connector
  that allows a user to "finger tighten" the connector. 
 
  This scad definition is optimized to print on the Monoprice 3D printer, 
  so it allows a bit of extra clearance (about 2.5 mils) for the hex 
  cutout surrounding the SMA body.
  
*/ 
/*
Copyright (c) 2016, Matthew H. Reilly (kb1vc)
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

    Redistributions of source code must retain the above copyright
    notice, this list of conditions and the following disclaimer.
    Redistributions in binary form must reproduce the above copyright
    notice, this list of conditions and the following disclaimer in
    the documentation and/or other materials provided with the
    distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
"AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

SpinnerThickness = 0.250; // This is about right. 
SpinnerDiameter = 0.65;
//HexWidth = 0.315; // nominal size is 0.3125 -- add slight clearance
HexWidth = 0.325;  // Fit for Monoprice Select Mini

DoCut = true; // Change "true" to "false" to get a whole nut. 
CutWidth = 0.16; // big enough for UT140?
$fn=64;

module hexagon(w) {
    side = w / sqrt(3);
    hside = side / 2;
    r = side;
    h = w / 2; 
    polygon( points = [ [-hside, -h], [hside, -h], 
                        [r, 0], 
                        [hside, h], [-hside, h], 
                        [-r, 0], [-hside, -h] ] );
}

module hex_body(w,l) {
   // make a hex block with width w and length l
   linear_extrude(l) hexagon(w); 
}

module cut_body(wx, wy, l) {
    translate([0, -wy/2, 0]) cube([wx, wy, l]);
}
module spinner_body(w, l) {
    union() {
       knurl(k_cyl_hg = l, k_cyl_od = w, 
             knurl_wd = 0.08, knurl_hg = 0.08, knurl_dp = 0.02,
	         e_smooth = 0.02, s_smooth = 0);
    }
}

module spinner_nut() {
    difference() {
        spinner_body(SpinnerDiameter, SpinnerThickness);
        translate([0, 0, -1]) hex_body(HexWidth, SpinnerThickness * 2 + 1);
    }
}

module SMASpinner() {
    if (DoCut) {
        difference() {
            spinner_nut();
            translate([0, 0, -1]) cut_body(SpinnerDiameter, CutWidth, SpinnerThickness * 2 + 1);
        }   
    }
    else {
        spinner_nut();
    }
}

scale([25.4,25.4,25.4]) SMASpinner();
