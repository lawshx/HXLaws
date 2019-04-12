package solution;

import util.Sorter;

public class InsertionSorter extends Sorter
{
    /**
     * Constructor that receives the array to sort.
     * 
     * @param anArray
     *            the array to sort
     */
    public InsertionSorter(int[] anArray)
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
            if (a[i + 1] < a[i])
            {
                int temp = a[i+1];
                a[i+1] = a[i];
                a[i] = temp;
                step(i);
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
        
        int j = i;
        while (j > 0 && a[j] < a[j - 1])
        {
            int temp1 = a[j-1];
            a[j-1] = a[j];
            a[j] = temp1;
            j--;
        }

        // For animation
        alreadySorted = j;
        pause(2);
    }
}
