void setup() {

  PDF pdf = new PDF(this, mm(69), mm(94), sketchPath("exports/" + System.currentTimeMillis() + ".pdf"));  
  pdf.pushMatrix();
  pdf.noStroke();

  // setup border clip
  pdf.clip(mm(6), mm(6), mm(57), mm(82));

  // background grey
  pdf.fillCMYK(0, 0, 0, 0.1);
  pdf.rect(mm(6), mm(6), mm(57), mm(82));


  // translate to corner
  pdf.translate(mm(6), mm(6));  

  Grid grid = new Grid(16,23);

  //8/12 (checkerboards)  1.04 aspect ratio
  //16/24
  //6/9
  //12/18

  //9/13 1.004
  grid.dither();
  grid.draw(pdf);


  // -----------------------------------------------------------------------------------
  // Save and close
  pdf.dispose();
  //exit();
}

// Converts mm to PostScript points
// This function should be called “pt” but I like how it looks when used:
// mm(29) will be converted to 29mm
public float mm(float pt) {
  return pt * 2.83464567f;
}
