void setup() {

  PDF pdf = new PDF(this, mm(69), mm(94), sketchPath("exports/" + System.currentTimeMillis() + ".pdf"));  
  pdf.pushMatrix();
  pdf.noStroke();

  // setup border clip
  //pdf.clip(mm(6), mm(6), mm(57), mm(82));

  // background grey
  // pdf.fillCMYK(0, 0, 0, 1);
  // pdf.rect(mm(6), mm(6), mm(57), mm(82));

  pdf.fillCMYK(1, 0, 0.15, 0.5);
  pdf.rect(mm(0), mm(0), mm(69), mm(94));

  // translate to center
  //pdf.translate(mm(34.5), mm(47));  
  

  // translate to corner
  pdf.translate(mm(6), mm(6));  
  Field field = new Field(14,20,57,82);
  field.draw(pdf);

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

// A small helper function to convert CMYK to Processing RGB, for preview purposes
// Formula from http://www.easyrgb.com/index.php?X=MATH
// Convert CMYK > CMY > RGB
// c,m,y,k ranges from 0.0 to 1.0
int CMYKtoRGB(float c, float m, float y, float k) {
  float C = c * (1-k) + k;
  float M = m * (1-k) + k;
  float Y = y * (1-k) + k;
  float r = (1-C) * 255;
  float g = (1-M) * 255;
  float b = (1-Y) * 255;
  return color(r, g, b);
}
