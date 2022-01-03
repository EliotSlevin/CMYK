public class Stone {
 
    public PVector[] points;

    private int n_points = 12;
    private int radius = 20;
    private float angle = radians(360) / n_points;
    private float factor = 0.2;

    public Stone() {
        //
    }
  
    public void draw(PDF pdf) {  

       // pdf.beginShape();
       pdf.fillCMYK(0.5, 0, 0, 0);

        for (int e = 0; e < n_points; e++) {
            float x = cos(angle * e) * radius;
            float y = sin(angle * e) * radius;
            PVector p = new PVector(x, y).normalize();
            float n = map(noise(p.x * factor, p.y * factor), 0, 1, 10, 200);
            p.mult(n);
            // p.mult(50);
           // pdf.curveVertex(p.x, p.y);

            println(e);
            println(angle * e);
            println(p.x, p.y);
            pdf.circle(p.x,p.y,mm(2));
        }


       // pdf.endShape(CLOSE);
    }     
}
