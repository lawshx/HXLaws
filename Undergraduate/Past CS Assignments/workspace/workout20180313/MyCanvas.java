
public interface MyCanvas{
   
   public void clear();
   
   public void setLineColor(int rgb);
   
   public void setFillColor(int rgb);
   
   public void drawSquare(int xPosition, int yPosition, int length);
   
   public void drawRectangle(int xPosition, int yPosition, int topLength, int sideLength);
   
   public void drawRightTriangle(int xPosition, int yPosition, int verticalLeg, int horizontalLeg);
   
   public void drawTriangle(int[] xPosition, int[] yPosition);

   public void drawLine(int xStart, int yStart, int xEnd, int yEnd);

}
