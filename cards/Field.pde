public class Field {
 
    public PVector[][] nodes;
    public int widthInMm;
    public int heightInMm;
    public int horiztonalSlots;
    public int verticalSlots;

    public Field(int horiztonalSlots, int verticalSlots, int widthInMm, int heightInMm) {
        this.nodes = new PVector[horiztonalSlots][verticalSlots];
        this.widthInMm = widthInMm;
        this.heightInMm = heightInMm;
        this.horiztonalSlots = horiztonalSlots;
        this.verticalSlots = verticalSlots;

        for(int x = 0; x < horiztonalSlots; ++x){
          for(int y = 0; y < verticalSlots; ++y){
            nodes[x][y] = nodes[x][y].random2D();
          }
        }
    }
  
    public void draw(PDF pdf) {      
      pdf.fillCMYK(0, 0.5, 0, 0);
      pdf.strokeK(1.0);
      pdf.strokeWeight(0.1);
      pdf.circle(mm(0),mm(0),mm(1));
      pdf.circle(mm(widthInMm),mm(heightInMm),mm(1));


      for(int x = 0; x < horiztonalSlots; ++x){
        for(int y = 0; y < verticalSlots; ++y){
          PVector location = xyToMmCoordinate(x + 0.5, y + 0.5);
          //pdf.circle(mm(location.x), mm(location.y), mm(0.2));
          pdf.line(mm(location.x), mm(location.y), mm(location.x + nodes[x][y].x),  mm(location.y + nodes[x][y].y));

          println(nodes[x][y].x);
        }
      }

    }     

    public PVector xyToMmCoordinate(float x, float y){      
      float xMM = ((float)widthInMm / horiztonalSlots) * x;
      float yMM = ((float)heightInMm / verticalSlots) * y;

      return new PVector(xMM, yMM);
    }
}
