package util;
import java.awt.Color;
import java.awt.Graphics2D;
import java.awt.geom.Line2D;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

import javax.swing.JComponent;

/**
 * This class sorts an array, using the selection sort algorithm.
 * 
 * @author Unknown
 * @version 00/00/00
 */
public abstract class Sorter
{
    private static final int DELAY = 20;

    protected int[] a;
    protected Lock sortStateLock;

    // The component is repainted when the animation is paused
    protected JComponent component;

    // These instance variables are needed for drawing
    protected int markedPosition = -1;
    protected int alreadySorted = -1;

    /**
     * Constructs a selection sorter.
     * 
     * @param anArray
     *            the array to sort
     */
    public Sorter(int[] anArray)
    {
        a = anArray.clone();
        sortStateLock = new ReentrantLock();
    }

    /**
     * Setter for component.
     * 
     * @param component
     *            the value to set it to
     */
    public void setComponent(JComponent component)
    {
        this.component = component;
    }

    /**
     * @return a copy of the array.
     */
    public int[] getArray()
    {
        return a.clone();
    }

    /**
     * Method that does the sorting. Needs to be implemented in subclasses.
     * 
     * @throws InterruptedException
     *             if it is interrupted.
     */
    public abstract void sort() throws InterruptedException;

    /**
     * Helper method for the JUnit tests.
     * 
     * @param i
     *            the current step index
     * @throws InterruptedException
     *             if it is interrupted.
     */
    public abstract void step(int i) throws InterruptedException;

    /**
     * Draws the current state of the sorting algorithm.
     * 
     * @param g2
     *            the graphics context
     */
    public void draw(Graphics2D g2)
    {
        sortStateLock.lock();
        try
        {
            int deltaX = component.getWidth() / a.length;
            for (int i = 0; i < a.length; i++)
            {
                if (i == markedPosition)
                {
                    g2.setColor(Color.RED);
                }
                else if (i <= alreadySorted)
                {
                    g2.setColor(Color.BLUE);
                }
                else
                {
                    g2.setColor(Color.BLACK);
                }
                g2.draw(new Line2D.Double(i * deltaX, 0, i * deltaX, a[i]));
            }
        }
        finally
        {
            sortStateLock.unlock();
        }
    }

    /**
     * Pauses the animation.
     * 
     * @param steps
     *            the number of steps to pause
     * @throws InterruptedException
     *             if it is interrupted.
     */
    public void pause(int steps) throws InterruptedException
    {
        if (component != null)
        {
            component.repaint();
            Thread.sleep(steps * DELAY);
        }
    }

    /**
     * Swaps two entries of the array.
     * 
     * @param i
     *            the first position to swap
     * @param j
     *            the second position to swap
     */
    protected void swap(int i, int j)
    {
        int temp = a[i];
        a[i] = a[j];
        a[j] = temp;
    }
}
