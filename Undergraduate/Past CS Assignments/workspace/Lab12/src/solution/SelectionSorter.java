package solution;

import util.Sorter;

/**
 * This class sorts an array, using the selection sort algorithm.
 * 
 * @author Unknown
 * @version 00/00/00
 */
public class SelectionSorter extends Sorter
{
    /**
     * Constructor that receives the array to sort.
     * 
     * @param anArray
     *            the array to sort
     */
    public SelectionSorter(int[] anArray)
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
        for (int i = 0; i < a.length - 1; i++)
        {
            step(i);
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
        int minPos = minimumPosition(i);
        swap(minPos, i);
        // For animation
        alreadySorted = i;
        pause(2);
    }

    /**
     * 
     * Finds the smallest element in a tail range of the array.
     * 
     * @param from
     *            the first position in a to compare
     * @return the position of the smallest element in the range
     *         a[from]...a[a.length - 1]
     * @throws InterruptedException
     *             if it is interruped.
     */
    private int minimumPosition(int from) throws InterruptedException
    {
        int minPos = from;
        for (int i = from + 1; i < a.length; i++)
        {
            if (a[i] < a[minPos])
            {
                minPos = i;
            }
            // For animation
            markedPosition = i;
            pause(2);
        }
        return minPos;
    }

}
