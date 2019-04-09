import java.awt.Color;


/**
 * The MyNewCanvas must be used now.
 * 
 * @author Dr. Ray Russell, Brycon Carpenter
 * @version 0.2
 */
public class MyNewCanvas
{
    
    private CanvasDisplay canvas;

    public MyNewCanvas() {
        System.out.println ("Constructing a MyNewCanvas.");
        canvas = new CanvasDisplay("MyNewCanvas Display");
    }

    public void clear() {
        System.out.println ("Clearing the Canvas.");
        canvas.clear();
    }

    public void drawShape(int[] xPosition, int[] yPosition, int sides, int lineColor, int fillColor) {
        System.out.println ("Drawing a " + sides + "-sided shape at");
        for (int i = 0; i < sides; i++) {
            System.out.println (" Side: " + i + " x: " + xPosition[i] + " y: " + yPosition[i]);
        }
        System.out.println (" lineColor: " + lineColor + " fillColor: " + fillColor);
        
        Integer[] x = new Integer[sides], y = new Integer[sides];
        
        for (int j = 0; j < sides; j++) {
            x[j] = xPosition[j];
            y[j] = yPosition[j];
        }
        
        Color[] colors = {new Color(fillColor), new Color(lineColor)};
        
        canvas.addShape(new Integer[][]{x, y}, colors);

    }
}
