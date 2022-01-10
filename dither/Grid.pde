public class Grid {
 
    public float[][] points;
    public int width;
    public int height;
    private float noiseScale = 0.02;
    
    private float C;
    private float Y;
    private float M;
    private float K;

    public Grid(int width, int height, float C, float Y, float M, float K) {
        noiseSeed(int(random(1000)));

        this.points = new float[width][height];
        this.width = width;
        this.height = height;

        this.C = C;
        this.Y = Y;
        this.M = M;
        this.K = K;

        float largest = 0.0;
        float smallest = 1.0;

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                float newValue = noise(x * noiseScale, y * noiseScale);

                if( newValue > largest ){
                    largest = newValue;
                }

                if( newValue < smallest ){
                    smallest = newValue;
                }

                points[x][y] = newValue;
            }
        }

        // compress
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                points[x][y] = constrain(map(points[x][y], smallest, largest, -0.2, 1.2), 0.0, 1.0);
            }
        }

    }

    public void dither(){
        for (int y = 0; y < height; y++) {
            for (int x = 0; x < width; x++) {
                float oldValue = points[x][y];
                float newValue = round(oldValue);
                points[x][y] = newValue;

                float error = (oldValue - newValue);

                if(!(x+1 > this.width-1)){
                    points[x+1][y] = points[x+1][y] + error * 7/16.0;
                }

                if(!(x-1 < 0 || y+1 > this.height-1)){
                    points[x-1][y+1] = points[x-1][y+1] + error * 3/16.0;
                }

                if(!(y+1 > this.height-1)){
                    points[x][y+1] = points[x][y+1] + error * 5/16.0;
                }

                if(!(x+1 > this.width-1 || y+1 > this.height-1)){
                    points[x+1][y+1] = points[x+1][y+1] + error * 1/16.0;
                }
            }
        }
    }

    private float getPoint(int x, int y){
        if(!(x > this.width-1 || x < 0)){
            if(!(y > this.height-1 || y < 0)){
                return points[x][y];
            }
        }

        return 0.0;
    }
  
    public void draw(PDF pdf) {  
        // always draws at 57 x 82mm

        float horiztonalMM = 57.0 / this.width;
        float verticalMM = 82.0 / this.height;        

        pdf.ellipseMode(CORNER);

        pdf.strokeCMYK(this.C, this.Y, this.M, this.K);
        pdf.strokeWeight(0.05);
        
        for (int x = 0; x < this.width; x++) {
            for (int y = 0; y < this.height; y++) {
                pdf.pushMatrix();
                    pdf.translate(mm(x * horiztonalMM), mm(y * verticalMM));  
                    pdf.fillCMYK(this.C, this.Y, this.M, this.K);

                    if(points[x][y] == 1.0){
                        // main circle
                        pdf.ellipse(mm(0),mm(0),mm(horiztonalMM), mm(verticalMM));
                    }

                    // if(isSurrounded(x, y)){
                    //     pdf.pushStyle();
                    //         pdf.fillCMYK(0, 0, 1, 0);
                    //         pdf.ellipse(mm(horiztonalMM/4),mm(verticalMM/4),mm(horiztonalMM/2), mm(verticalMM/2));
                    //     pdf.popStyle();
                    // }

                    // Time to draw corners oh yay

                    // Top left corner
                    if( getPoint(x, y) == 1.0){
                        // filled logic
                        if(
                            getPoint(x-1, y) == 1.0 || 
                            getPoint(x, y-1) == 1.0 ||
                            getPoint(x-1, y-1) == 1.0
                        ){
                            // that's the basic check surrounded logic
                            if(!(isSurrounded(x-1,y) && isSurrounded(x, y-1))){
                                drawCorner(
                                    mm(0), mm(0),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 0
                                );
                            }
                        }
                    } else{
                        // empty logic
                        if( getPoint(x-1, y) == 1.0 && getPoint(x, y-1) == 1.0){
                            // lets check surrounded logic
                            if(!(isSurrounded(x, y) && isSurrounded(x-1, y-1))){
                                drawCorner(
                                    mm(0), mm(0),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 0
                                );
                            }
                        }
                    }

                    // Top right corner
                    if( getPoint(x, y) == 1.0){
                        // filled logic
                        if(
                            getPoint(x+1, y) == 1.0 || 
                            getPoint(x, y-1) == 1.0 ||
                            getPoint(x+1, y-1) == 1.0
                        ){
                            // that's the basic check surrounded logic
                            if(!(isSurrounded(x,y-1) && isSurrounded(x + 1, y))){
                                drawCorner(
                                    mm(horiztonalMM/2), mm(0),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 90
                                );
                            }
                        }
                    } else{
                        // empty logic
                        if( getPoint(x, y-1) == 1.0 && getPoint(x + 1, y) == 1.0){
                            // lets check surrounded logic
                            if(!(isSurrounded(x, y) && isSurrounded(x + 1, y-1))){
                                drawCorner(
                                    mm(horiztonalMM/2), mm(0),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 90
                                );
                            }
                        }
                    }

                    // Bottom left corner
                    if( getPoint(x, y) == 1.0){
                        // filled logic
                        if(
                            getPoint(x-1, y) == 1.0 || 
                            getPoint(x, y+1) == 1.0 ||
                            getPoint(x-1, y+1) == 1.0
                        ){
                            // that's the basic check surrounded logic
                            if(!(isSurrounded(x-1,y) && isSurrounded(x, y + 1))){
                                drawCorner(
                                    mm(0), mm(verticalMM/2),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 270
                                );
                            }
                        }
                    } else{
                        // empty logic
                        if( getPoint(x-1, y) == 1.0 && getPoint(x, y+1) == 1.0){
                            // lets check surrounded logic
                            if(!(isSurrounded(x, y) && isSurrounded(x - 1, y + 1))){
                                drawCorner(
                                    mm(0), mm(verticalMM/2),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 270
                                );
                            }
                        }
                    }

                    // Bottom right corner
                    if( getPoint(x, y) == 1.0){
                        // filled logic
                        if(
                            getPoint(x + 1, y) == 1.0 || 
                            getPoint(x, y + 1) == 1.0 ||
                            getPoint(x + 1, y + 1) == 1.0
                        ){
                            // that's the basic check surrounded logic
                            if(!(isSurrounded(x + 1,y) && isSurrounded(x, y + 1))){
                                drawCorner(
                                    mm(horiztonalMM/2), mm(verticalMM/2),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 180
                                );
                            }
                        }
                    } else{
                        // empty logic
                        if( getPoint(x + 1, y) == 1.0 && getPoint(x, y+1) == 1.0){
                            // lets check surrounded logic
                            if(!(isSurrounded(x, y) && isSurrounded(x + 1, y + 1))){
                                drawCorner(
                                    mm(horiztonalMM/2), mm(verticalMM/2),
                                    mm(horiztonalMM/2), mm(verticalMM/2), 
                                    pdf, 180
                                );
                            }
                        }
                    }

                pdf.popMatrix();
            }
        }

    }  
    
    private void drawCorner(float x, float y, float width, float height, PDF pdf, float rotation){
        pdf.pushMatrix();

            //pdf.fillCMYK(0, 1, 0, 0);

            float blessedLength = 0.552284749831;
            //https://stackoverflow.com/questions/1734745/how-to-create-circle-with-b%C3%A9zier-curves
           
            pdf.translate(x+width/2, y+width/2); 
            pdf.pushMatrix();
                pdf.rotate(radians(rotation));

                pdf.beginShape();
                    pdf.vertex(-width/2, -height/2); // first point
                    pdf.vertex(width/2, -height/2); // second point
                    pdf.bezierVertex(
                        width/2 - (blessedLength * width), -height/2, // first control
                        -width/2, height/2 - (blessedLength * height), // second control
                        -width/2, height/2 // final anchor
                    );
                pdf.endShape(CLOSE);

            pdf.popMatrix();
        pdf.popMatrix();
    }

    private boolean isSurrounded(int x, int y){
        // checks how surrounded by other full squares this square is
        // only empty squares are allowed to be surrounded

        if(getPoint(x, y) == 1.0){
            return false;
        }

        float fullness = 
            getPoint(x-1, y-1) + 
            getPoint(x, y-1) + 
            getPoint(x+1, y-1) + 
            getPoint(x-1, y) + 
            getPoint(x+1, y) + 
            getPoint(x-1, y+1) + 
            getPoint(x, y+1) + 
            getPoint(x+1, y+1);
        
        if(fullness > 4.0){
            return true;
        }

        return false;
    }
}
