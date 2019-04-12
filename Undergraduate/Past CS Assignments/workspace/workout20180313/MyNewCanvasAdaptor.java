public class MyNewCanvasAdaptor implements MyCanvas{
    MyNewCanvas mnc;


    int lineColor;
    int fillColor;

    public MyNewCanvasAdaptor(MyNewCanvas mnc){
        this.mnc = mnc;
    }

    public void clear(){
        mnc.clear();    
    }



    public void setLineColor(int rgb){
        lineColor = rgb;
    }

    public void setFillColor(int rgb){
        fillColor = rgb;
    }

    public void drawSquare(int xPosition, int yPosition, int length){
        int[] xL = new int[4];
        int[] yL = new int[4];
        
        xL[0] = xPosition;
        xL[1] = xPosition + length;
        xL[2] = xPosition + length;
        xL[3] = xPosition;
        
        yL[0] = yPosition;
        yL[1] = yPosition;
        yL[2] = yPosition + length;
        yL[3] = yPosition + length;

        
        mnc.drawShape(xL, yL, 4, lineColor, fillColor);
    }

    public void drawRectangle(int xPosition, int yPosition, int topLength, int sideLength){
        int[] xL = new int[4];
        int[] yL = new int[4];

        xL[0] = xPosition;
        xL[1] = xPosition + topLength;
        xL[2] = xPosition + topLength;
        xL[3] = xPosition;
        
        yL[0] = yPosition;
        yL[1] = yPosition;
        yL[2] = yPosition + sideLength;
        yL[3] = yPosition + sideLength;

        mnc.drawShape(xL, yL , 4,lineColor, fillColor);



    }

    public void drawRightTriangle(int xPosition, int yPosition, int verticalLeg, int horizontalLeg){
        int[] xL = new int[3];
        int[] yL = new int[3];
        
        xL[0] = xPosition;
        xL[1] = xPosition + horizontalLeg;
        xL[2] = xPosition;
        
        yL[0] = yPosition;
        yL[1] = yPosition + verticalLeg;
        yL[2] = yPosition + verticalLeg;
        
        

        mnc.drawShape(xL, yL, 3, lineColor, fillColor);   

    }

    
    
    public void drawTriangle(int[] xPosition, int[] yPosition){
        mnc.drawShape(xPosition, yPosition, 3, lineColor, fillColor);

    }



    public void drawLine(int xStart, int yStart, int xEnd, int yEnd){
        int[] xL = new int[2];
        int[] yL = new int[2];
        
        xL[0] = xStart;
        xL[1] = xEnd;
        
        yL[0] = yStart;
        yL[1] = yEnd;

        mnc.drawShape(xL, yL , 2, lineColor, fillColor);

    }

}
