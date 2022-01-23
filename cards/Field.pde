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
      pdf.strokeK(0);
      pdf.strokeWeight(mm(0.4));
      pdf.strokeCap(ROUND);

      for(int x = 0; x < horiztonalSlots; ++x){
        for(int y = 0; y < verticalSlots; ++y){
          PVector location = xyToMmCoordinate(x + 0.5, y + 0.5);
          pdf.line(mm(location.x), mm(location.y), mm(location.x + (nodes[x][y].x * 8)),  mm(location.y + (nodes[x][y].y) * 8));
        }
      }

    }     

    public void advance(){
      for(int x = 0; x < horiztonalSlots; ++x){
        for(int y = 0; y < verticalSlots; ++y){
          ArrayList<PVector> neighbours = new ArrayList<PVector>();
         
          neighbours.add(safelyGetNode(x - 1, y)); // north
          neighbours.add(safelyGetNode(x + 1, y)); // south
          neighbours.add(safelyGetNode(x, y - 1)); // west
          neighbours.add(safelyGetNode(x, y + 1)); // east
          neighbours.add(safelyGetNode(x - 1, y - 1));
          neighbours.add(safelyGetNode(x - 1, y + 1));
          neighbours.add(safelyGetNode(x + 1, y - 1));
          neighbours.add(safelyGetNode(x + 1, y + 1));
          
          neighbours.removeAll(Collections.singleton(null));

          float xSum = 0;
          for (PVector n : neighbours){
            xSum += n.x;
          } 
          float xAverage = xSum / neighbours.size();

          float ySum = 0;
          for (PVector n : neighbours){
            ySum += n.y;
          } 
          float yAverage = ySum / neighbours.size();

          nodes[x][y].set(xAverage, yAverage, 0.0);
        }
      }
    }

    public PVector safelyGetNode(int x, int y) {
      if (x < 0 || x > horiztonalSlots - 1 ||y < 0 || y > verticalSlots - 1) return null;

      return nodes[x][y];
    }

    public PVector xyToMmCoordinate(float x, float y){      
      float xMM = ((float)widthInMm / horiztonalSlots) * x;
      float yMM = ((float)heightInMm / verticalSlots) * y;

      return new PVector(xMM, yMM);
    }
}