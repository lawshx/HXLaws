package solution;

/**
 * BigOh.java
 */
import java.util.Random;
import java.util.Scanner;
import util.Algorithms;

/**
 * Contains methods to analyze time complexity of algorithms.
 * 
 * @author Mitch Parry
 * @version 2014-01-28
 * 
 */
public class BigOh
{
    private static final double MILLISECONDS_PER_SECOND = 1000.0;

    private Random rand;

    /**
     * No-args constructor initializes the random using current time.
     */
    public BigOh()
    {
        rand = new Random();
    }

    /**
     * Constructor takes an Random object to initialize the randomness of the
     * algorithms.
     * 
     * @param rand
     *            the random number generator
     */
    public BigOh(Random rand)
    {
        this.rand = rand;
    }

    /**
     * robustTimeAlgorithm returns the minimum time it takes to run the chosen
     * algorithm over 5 trials.
     * 
     * @param choice
     *            The index of the algorithm to use
     * @param n
     *            The size of the problem
     * @return the time in seconds
     */
    public double robustTimeAlgorithm(int choice, int n)
    {
        // TODO
        double t = 0;
        for (int i = 0; i < 5; i++)
        {
            t = timeAlgorithm(choice, n);
            if (t > timeAlgorithm(choice, n))
            {
                t = timeAlgorithm(choice, n);
            }
        }
        return t;
    }

    /**
     * timeAlgorithm returns the time it takes to run the algorithm once.
     * 
     * @param choice
     *            The index of the algorithm to use
     * @param n
     *            The size of the problem
     * @return the time in seconds
     */
    public double timeAlgorithm(int choice, int n)
    {
        // make sure that the garbage collector doesn't run
        // during timing. (Do this first.)
        System.gc();

        // TODO
        double s = System.currentTimeMillis();
        runAlgorithm(choice, n);
        s = System.currentTimeMillis() - s;
        
        return s / MILLISECONDS_PER_SECOND;
    }

    /**
     * runAlgorithm selects the algorithm to run based on <code>choice</code>.
     * 
     * @param choice
     *            The number representing the algorithm choice
     * @param numElements
     *            The size of the problem
     * @return The result of the algorithm
     */
    public int runAlgorithm(int choice, int numElements)
    {
        // TODO (be sure to change return statement too)
        int result = choice;
        switch (choice)
        {
            case 1:
                result = Algorithms.alg1(numElements, rand);
                break;
            case 2:
                result = Algorithms.alg2(numElements, rand);
                break;
            case 3:
                result = Algorithms.alg3(numElements, rand);
                break;
            case 4:
                result = Algorithms.alg4(numElements, rand);
                break;
            case 5:
                result = Algorithms.alg5(numElements, rand);
                break;
            case 6:
                result = Algorithms.alg6(numElements, rand);
                break;
            default:
                System.out.println("Please input a valid algorithm number.");
                break;

        }

        return result;
    }

    /**
     * bigOhFunc returns the Big-Oh function for algorithm and problem size
     * parameters.
     * 
     * @param choice
     *            The number representing the algorithm choice
     * @param n
     *            The problem size.
     * @return The Big-Oh function for problem size, n.
     */
    public double bigOhFunc(int choice, double n)
    {
        double result = 0;
        switch (choice)
        {
            case 1:
                result = n;
                break;
            case 2:
                result = Math.pow(n, 3);
                break;
            case 3:
                result = Math.pow(n, 2);
                break;
            case 4:
                result = Math.pow(n, 2);
                break;
            case 5:
                result = Math.pow(n, 5);
                break;
            case 6:
                result = Math.pow(n, 5) * (1 / n);
                break;
            default:
                System.out.println("Please input valid algorithm.");
                break;
        }
        System.out.println(result);
        return result;
    }

    /**
     * estimateTiming takes an algorithm choice, problem size and timing, and
     * estimates the timing for a second problem size.
     * 
     * @param choice
     *            The number representing the algorithm choice
     * @param n1
     *            The first problem size
     * @param t1
     *            The first timing
     * @param n2
     *            The second problem size
     * @return The estimated timing for the second problem size
     */
    public double estimateTiming(int choice, int n1, double t1, int n2)
    {
        // TODO
        double time2 = t1 * (bigOhFunc(choice, n2) / bigOhFunc(choice, n1));
        return time2;
    }

    /**
     * percentError returns the percent error in an estimate.
     * 
     * @param correct
     *            the correct value
     * @param estimate
     *            the estimated value
     * @return the percent error
     */
    public double percentError(double correct, double estimate)
    {
        // TODO
        double error = Math.abs((estimate - correct) / correct);
        return error;
    }

    /**
     * computePercentError takes an algorithm choice, and two problem sizes and
     * computes the error in estimating the timing of the second problem using
     * the timing of the first.
     * 
     * @param choice
     *            The number representing the algorithm choice
     * @param n1
     *            The first problem size
     * @param n2
     *            The second problem size
     * @return the percent error in estimating t2 given n1 and n2.
     */
    public double computePercentError(int choice, int n1, int n2)
    {
        // TODO
        double t1 = robustTimeAlgorithm(choice, n1);
        double predicted = estimateTiming(choice, n1, t1, n2);
        double actual = robustTimeAlgorithm(choice, n2);

        return Math.abs((predicted - actual) / actual);
    }

    /**
     * Main method.
     * 
     * @param args
     *            Command line arguments not used.
     */
    public static void main(String[] args)
    {
        int choice;
        int numElements = 0;
        Scanner keyInput = new Scanner(System.in);
        BigOh bo = new BigOh();

        // run the fragments
        choice = menu(keyInput);
        while (choice != 7)
        {
            if (choice >= 1 && choice <= 6)
            {
                System.out.print("How many elements: ");
                numElements = keyInput.nextInt();
                double time = bo.timeAlgorithm(choice, numElements);
                long milliseconds = (long) (time * MILLISECONDS_PER_SECOND);
                System.out.println("The time for alg" + choice + " with n="
                    + numElements + " is " + milliseconds + " ms.\n\n");
            }
            choice = menu(keyInput);
        }
        System.out.println("Quitting");
    }

    /**
     * Prints the menu and prompts for input.
     * 
     * @param keyInput
     *            The scanner to read input
     * @return the number read
     */
    public static int menu(Scanner keyInput)
    {
        int choice = -1;

        System.out.println();
        System.out.println("       1.  Method #1 ");
        System.out.println("       2.  Method #2 ");
        System.out.println("       3.  Method #3 ");
        System.out.println("       4.  Method #4 ");
        System.out.println("       5.  Method #5 ");
        System.out.println("       6.  Method #6 ");
        System.out.println("       7.  Quit \n");
        System.out.print("Enter your choice: ");
        choice = keyInput.nextInt();
        return choice;
    }
}
