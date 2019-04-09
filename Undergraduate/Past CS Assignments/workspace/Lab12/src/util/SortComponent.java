package util;
import java.awt.Graphics;
import java.awt.Graphics2D;

import javax.swing.JComponent;

/**
 * A component that displays the current state of the selection sort algorithm.
 * 
 * @author Unknown
 * @version 00/00/00
 */
public class SortComponent extends JComponent
{
    /**
     * Serial version UID.
     */
    private static final long serialVersionUID = 1912486866180510674L;
    private Sorter sorter;

    /**
     * Constructs the component.
     * 
     * @param sorter
     *            the sorter to use
     */
    public SortComponent(Sorter sorter)
    {
        this.sorter = sorter;
        sorter.setComponent(this);
    }

    /**
     * Receives the Graphics argumnet.
     * 
     * @param g
     *            the Graphics argument
     */
    public void paintComponent(Graphics g)
    {
        Graphics2D g2 = (Graphics2D) g;
        sorter.draw(g2);
    }

    /**
     * Starts a new animation thread.
     */
    public void startAnimation()
    {
        /**
         * This makes the animation runnable.
         * 
         * @author Unknown.
         * @version 00/00/00
         */
        class AnimationRunnable implements Runnable
        {
            /**
             * The run method.
             */
            public void run()
            {
                try
                {
                    sorter.sort();
                }
                catch (InterruptedException exception)
                {
                    // This catch was empty. I added the exit to
                    // satisfy checkstyle. It might not work now.
                    // System.exit(0);
                    return;
                }
            }
        }

        Runnable r = new AnimationRunnable();
        Thread t = new Thread(r);
        t.start();
    }

    /**
     * @return the sorter.
     */
    public Sorter getSorter()
    {
        return sorter;
    }
}
