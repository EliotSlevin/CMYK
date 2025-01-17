public class Field {
 
    public PVector[][] nodes;
    public float[][] mags;
    public float[][] headings;

    public int widthInMm;
    public int heightInMm;
    public int horiztonalSlots;
    public int verticalSlots;

    public Field(int horiztonalSlots, int verticalSlots, int widthInMm, int heightInMm) {
        this.nodes = new PVector[horiztonalSlots][verticalSlots];
        this.mags = new float[horiztonalSlots][verticalSlots];
        this.headings = new float[horiztonalSlots][verticalSlots];
        
        this.widthInMm = widthInMm;
        this.heightInMm = heightInMm;
        this.horiztonalSlots = horiztonalSlots;
        this.verticalSlots = verticalSlots;


        // Generate mags

        float noiseScale = 0.02;
        float largestMag = 0.0;
        float smallestMag = 1.0;

        float largestHead = 0.0;
        float smallestHead = 1.0;

        for (int x = 0; x < horiztonalSlots; x++) {
            for (int y = 0; y < verticalSlots; y++) {
                float newValueMag = noise(x * noiseScale, y * noiseScale, 0.0);

                if( newValueMag > largestMag ){ largestMag = newValueMag; }
                if( newValueMag < smallestMag ){ smallestMag = newValueMag; }

                mags[x][y] = newValueMag;

                float newValueHeading = noise(x * noiseScale, y * noiseScale, 1.0 );

                if( newValueHeading > largestHead ){ largestHead = newValueMag; }
                if( newValueHeading < smallestHead ){ smallestHead = newValueMag; }

                headings[x][y] = newValueHeading;


            }
        }

        // compress
        for (int x = 0; x < horiztonalSlots; x++) {
            for (int y = 0; y < verticalSlots; y++) {
              mags[x][y] = constrain(map(mags[x][y], smallestMag, largestMag, -0.2, 1.2), 0.0, 1.0);
              headings[x][y] = map(headings[x][y], smallestHead, largestHead, 0, 1);
            }
        }

        // done with mags



        for(int x = 0; x < horiztonalSlots; ++x){
          for(int y = 0; y < verticalSlots; ++y){
            //float mag = noise(x * noiseScale, y * noiseScale, 1);
            //float angle = noise(x * noiseScale, y * noiseScale, 1.001);

            PVector v = new PVector(0, 1);
            v.rotate(
              radians(
                map(headings[x][y], 0, 1, 0, 360)
              )
            );

            

            //float calcMag = map(mag, 0.4, 0.6, 0, 1);
            v.setMag(mags[x][y]);
            
            nodes[x][y] = v;
          }
        }
    }
  
    public void draw(PDF pdf) {   
      // pdf.noFill();   
      // pdf.strokeK(0);
      // pdf.strokeWeight(mm(1.2));
      // pdf.strokeCap(PROJECT);

      pdf.fillK(0);
      pdf.noStroke();

      // pdf.noStroke();
      // pdf.fillK(0);

      float distance = ((float)widthInMm / horiztonalSlots) / 2 ;

      for(int x = 0; x < horiztonalSlots; ++x){
        for(int y = 0; y < verticalSlots; ++y){

          float vertDiff = nodes[x][y].y * distance;
          float horiztonalDiff = nodes[x][y].x * distance;

          PVector location = xyToMmCoordinate(x + 0.5, y + 0.5);

          pdf.pushMatrix();
          pdf.translate(mm(location.x), mm(location.y));
          // pdf.rotate(
          //   radians(
          //     map(headings[x][y], 0, 1, 0, 360)
          //   )
          // );
          // pdf.ellipse(
          //   mm(0),
          //   mm(0),
          //   mm(1.2),
          //   mm((mags[x][y] + 1.0) * (1.2))
          // );

          pdf.square(
            mm(0), 
            mm(0), 
            mm((mags[x][y] + 1.0) * distance));

          pdf.popMatrix();

          

          // pdf.line(
          //   mm(location.x - (horiztonalDiff/2) ), 
          //   mm(location.y - (vertDiff/2)), 
          //   mm(location.x + (nodes[x][y].x * distance) - (horiztonalDiff/2)),  
          //   mm(location.y + (nodes[x][y].y) * distance) - (vertDiff/2));

          // pdf.beginShape();
          // pdf.vertex(mm(location.x), mm(location.y));
          // pdf.bezierVertex(
          //   mm(location.x + 1), mm(location.y), 
          //   mm(location.x + (nodes[x][y].x * distance) - 1), mm(location.y + (nodes[x][y].y) * distance), 
          //   mm(location.x + (nodes[x][y].x * distance)),  mm(location.y + (nodes[x][y].y) * distance)
          // );	
          // pdf.endShape();
        }
      }

    }     

    public PVector xyToMmCoordinate(float x, float y){      
      float xMM = ((float)widthInMm / horiztonalSlots) * x;
      float yMM = ((float)heightInMm / verticalSlots) * y;

      return new PVector(xMM, yMM);
    }
}