package solution;

import util.Sorter;

public class BubbleSorter extends Sorter
{
    /**
     * Constructor that receives the array to sort.
     * 
     * @param anArray
     *            the array to sort
     */
    public BubbleSorter(int[] anArray)
    {
        super(anArray);
    }

    /**
     * Sorts the array managed by this selection sorter.
     * 
     * @throws InterruptedException
     *             if it is interrupted.
     */
    public void sort() throws InterruptedException
    {
        for (int i = 0; i < a.length - 1; i ++)
        {
            
            for (int j = a.length - 1; j > i; j--)
            {
                step(j);
            }
        }

    }

    /**
     * Helper method 'step' with an index must be supplied for unit testing.
     * 
     * @param i
     *            the index to apply this step of the sort
     * @throws InterruptedException
     *             if it is interrupted.
     */
    public void step(int i) throws InterruptedException
    {        
        if (a[i] < a[i - 1])
        {
            int temp = a[i];
            a[i] = a[i - 1];
            a[i - 1] = temp;
        }
        // For animation
        alreadySorted = i;
        pause(2);
    }
}

