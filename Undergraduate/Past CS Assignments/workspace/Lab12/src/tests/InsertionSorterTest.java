package tests;
import static org.junit.Assert.assertArrayEquals;

import java.util.Arrays;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import solution.InsertionSorter;

/**
 * JUnit test class for SelectionSorter.
 * 
 * @author Mitch Parry
 * @version 2013-03-14
 * 
 */
public class InsertionSorterTest
{
    private static final String ALGORITHM = "Insertion Sort";
    private static final int[] INPUT1 = {
        9, 3, 4, 5, 6, 10, 1, 8, 2, 7
    };
    private static final int[][] CORRECT1 = {
        {
            3, 9, 4, 5, 6, 10, 1, 8, 2, 7
        }, {
            3, 4, 9, 5, 6, 10, 1, 8, 2, 7
        }, {
            3, 4, 5, 9, 6, 10, 1, 8, 2, 7
        }, {
            3, 4, 5, 6, 9, 10, 1, 8, 2, 7
        }, {
            3, 4, 5, 6, 9, 10, 1, 8, 2, 7
        }, {
            1, 3, 4, 5, 6, 9, 10, 8, 2, 7
        }, {
            1, 3, 4, 5, 6, 8, 9, 10, 2, 7
        }, {
            1, 2, 3, 4, 5, 6, 8, 9, 10, 7
        }, {
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        }
    };
    private static final int[] INPUT2 = {
        7, 10, 9, 5, 2, 6, 1, 4, 3, 8
    };
    private static final int[][] CORRECT2 = {
        {
            7, 10, 9, 5, 2, 6, 1, 4, 3, 8
        }, {
            7, 9, 10, 5, 2, 6, 1, 4, 3, 8
        }, {
            5, 7, 9, 10, 2, 6, 1, 4, 3, 8
        }, {
            2, 5, 7, 9, 10, 6, 1, 4, 3, 8
        }, {
            2, 5, 6, 7, 9, 10, 1, 4, 3, 8
        }, {
            1, 2, 5, 6, 7, 9, 10, 4, 3, 8
        }, {
            1, 2, 4, 5, 6, 7, 9, 10, 3, 8
        }, {
            1, 2, 3, 4, 5, 6, 7, 9, 10, 8
        }, {
            1, 2, 3, 4, 5, 6, 7, 8, 9, 10
        }
    };

    /**
     * Stuff to do before each test method.
     * 
     * @throws Exception
     *             certainly is possible.
     */
    @Before
    public void setUp() throws Exception
    {
    }

    /**
     * Stuff to do after each test method.
     * 
     * @throws Exception
     *             certainly is possible.
     */
    @After
    public void tearDown() throws Exception
    {
    }

    /**
     * Test selection sort.
     * 
     * @throws InterruptedException
     *             if it is interrupted.
     */
    @Test
    public void testSort1() throws InterruptedException
    {
        InsertionSorter sorter = new InsertionSorter(INPUT1);
        sorter.sort();
        int[] answer = sorter.getArray();
        assertArrayEquals(CORRECT1[8], answer);
    }

    /**
     * Test selection sort.
     * 
     * @throws InterruptedException
     *             if it is interrupted.
     */
    @Test
    public void testSort2() throws InterruptedException
    {
        InsertionSorter sorter = new InsertionSorter(INPUT2);
        sorter.sort();
        int[] answer = sorter.getArray();
        assertArrayEquals(CORRECT2[8], answer);
    }

    /**
     * Helper method to construct a message.
     * 
     * @param input
     *            the original array input.
     * @param step
     *            the step of the algorithm.
     * @param correct
     *            the correct array after this step.
     * @param answer
     *            the student's answer
     * @return the message
     */
    private String message(int[] input, int step, int[] correct, int[] answer)
    {
        return "For the input array:\n" + Arrays.toString(input) + "\nthe "
            + step + "-th step of the " + ALGORITHM + " should produce:\n"
            + Arrays.toString(correct) + "\nYour code produced:\n"
            + Arrays.toString(answer);
    }

    /**
     * Tests each step of the sort.
     * 
     * @throws InterruptedException
     *             if it is interrupted.
     */
    @Test
    public void testStep1() throws InterruptedException
    {
        InsertionSorter sorter = new InsertionSorter(INPUT1);
        for (int i = 1; i < INPUT1.length; i++)
        {
            sorter.step(i);
            int[] answer = sorter.getArray();
            assertArrayEquals(message(INPUT1, i, CORRECT1[i - 1], answer),
                CORRECT1[i - 1], answer);
        }
    }

    /**
     * Tests each step of the sort.
     * 
     * @throws InterruptedException
     *             if it is interrupted.
     */
    @Test
    public void testStep2() throws InterruptedException
    {
        InsertionSorter sorter = new InsertionSorter(INPUT2);
        for (int i = 1; i < INPUT2.length; i++)
        {
            sorter.step(i);
            int[] answer = sorter.getArray();
            assertArrayEquals(message(INPUT2, i, CORRECT2[i - 1], answer),
                CORRECT2[i - 1], answer);
        }
    }
}
