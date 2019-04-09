package tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;
import java.util.Arrays;
import java.util.Iterator;
import java.util.Scanner;

import org.junit.Test;

import solution.Book;
import solution.FileReading;
import solution.SortedLinkedList;

/**
 * Test cases for the FileReading class.
 * 
 * @author Mitch Parry
 * @version 2013-10-01
 * 
 */
public class FileReadingTest
{
    public static final String[] CORRECT = {
        "Anderson, Documentation Diaries, 179",
        "Anderson, Inheritance Rules, 391",
        "Brooks, Data Structures and You, 335",
        "Brooks, My Favorite Sorts, 131", "Connors, Stacks are Coming, 90",
        "Daley, I'd Rather Be Programming, 133",
        "Daley, More About Lists, 44",
        "Daley, The Controversy over Shallow Cloning, 30",
        "Grant, The Death of a Database, 90",
        "Jacobs, Exceptional Exceptions, 101",
        "Jacobs, The Joy of Computer Science, 1000",
        "Johnson, A World of Interfaces, 133",
        "Longwood, Searching the Internet, 111",
        "Marks, Iterators are Fun, 23",
        "Matthews, The Art of Recursion, 700",
        "Miller, Referring to References, 441",
        "Morris, Murder in the Computer Lab, 313",
        "Raley, GUIS for Geniuses, 122", "Rogers, Big-oh Rocks, 821",
        "Slaughter, How to Write Infinite Loops, 14",
        "Thompson, The Wonders of Linked Lists, 523",
        "Vanderpool, Cool Queues, 192", "Williams, The Perfect Generic, 90"
    };
    public static final String[] CORRECT_300 = {
        "Anderson, Inheritance Rules, 391",
        "Brooks, Data Structures and You, 335",
        "Jacobs, The Joy of Computer Science, 1000",
        "Matthews, The Art of Recursion, 700",
        "Miller, Referring to References, 441",
        "Morris, Murder in the Computer Lab, 313",
        "Rogers, Big-oh Rocks, 821",
        "Thompson, The Wonders of Linked Lists, 523"
    };
    public static final String[] CORRECT_200 = {
        "Anderson, Inheritance Rules, 391",
        "Brooks, Data Structures and You, 335",
        "Jacobs, The Joy of Computer Science, 1000",
        "Matthews, The Art of Recursion, 700",
        "Miller, Referring to References, 441",
        "Morris, Murder in the Computer Lab, 313",
        "Rogers, Big-oh Rocks, 821",
        "Thompson, The Wonders of Linked Lists, 523",
    };
    private static final int N = 10000;
    private static final String BOOK_DATA = "data/bookdata.txt";
    
    /**
     * Get user time in nanoseconds.
     * 
     * @return User time in nanoseconds
     */
    private static long getUserTime()
    {
        ThreadMXBean bean = ManagementFactory.getThreadMXBean();
        return bean.isCurrentThreadCpuTimeSupported()
                ? bean.getCurrentThreadUserTime() : 0L;
    }

    /**
     * Check that remove is implemented and runs in constant time.
     * 
     * @return whether or not the remove takes constant time.
     */
    public static boolean checkConstantTimeRemove()
    {
        // check if remove is implemented and if it runs in constant time.
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        for (int i = 0; i < N; i++)
        {
            seq.add(i + "");
        }
        // use iterator to remove last half of elements.
        Iterator<String> itr = seq.iterator();
        for (int i = 0; i < N / 2; i++)
        {
            itr.next();
        }
        long t1 = getUserTime();
        for (int i = 0; i < N / 2; i++)
        {
            itr.next();
            itr.remove();
        }
        t1 = getUserTime() - t1;

        // use iterator to remove first 1000 elements.
        itr = seq.iterator();
        long t2 = getUserTime();
        for (int i = 0; i < N / 2; i++)
        {
            itr.next();
            itr.remove();
        }
        t2 = getUserTime() - t2;
        return t1 < 2.0 * t2 || t1 < 100 * 100 * 100 * 50;
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     */
    @Test
    public void testConstructor()
    {
        FileReading fr = new FileReading(BOOK_DATA);
        SortedLinkedList<Book> books = fr.getBooks();
        for (int i = 0; i < books.getLength(); i++)
        {
            Book b = books.getEntry(i);
            assertEquals("Book " + i + " does not match\ncorrect: "
                    + CORRECT[i] + "\nreturned: " + b, CORRECT[i],
                    b.toString());

        }
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor2() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor3() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor4() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor5() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor6() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor7() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor8() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor9() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Test that the constructor creates a SortedLinkedSeq\<Book\>.
     * 
     * @throws IllegalAccessException
     *             when attempting to access a field that is not accessible.
     */
    @Test
    public void testConstructor10() throws IllegalAccessException
    {
        testConstructor();
    }

    /**
     * Tests printMoreThan300().
     */
    @Test
    public void testPrintMoreThan300()
    {
        FileReading fr = new FileReading(BOOK_DATA);

        PrintStream stdout = System.out;
        ByteArrayOutputStream outContent = new ByteArrayOutputStream();
        System.setOut(new PrintStream(outContent));

        fr.printMoreThan300();
        String output = outContent.toString();
        Scanner scan = new Scanner(output);
        for (String s : CORRECT_300)
        {
            assertEquals("printMoreThan300 output does not match:\n"
                    + Arrays.toString(CORRECT_300), s, scan.nextLine().trim());
        }
        scan.close();
        System.setOut(stdout);
    }

    /**
     * Tests printMoreThan300().
     */
    @Test
    public void testPrintMoreThan300B()
    {
        testPrintMoreThan300();
    }

    /**
     * Tests printMoreThan300().
     */
    @Test
    public void testPrintMoreThan300C()
    {
        testPrintMoreThan300();
    }

    /**
     * Tests printMoreThan300().
     */
    @Test
    public void testPrintMoreThan300D()
    {
        testPrintMoreThan300();
    }

    /**
     * Tests printMoreThan300().
     */
    @Test
    public void testPrintMoreThan300E()
    {
        testPrintMoreThan300();
    }

    /**
     * Test averagePages.
     */
    @Test
    public void testAveragePages()
    {
        final double CORRECT = 261.173913;
        final double EPS = 1e-6;
        FileReading fr = new FileReading(BOOK_DATA);
        double average = fr.averagePages();
        assertEquals("Average pages for " + BOOK_DATA + " should be " + CORRECT,
                CORRECT, average, EPS);

    }

    /**
     * Test averagePages.
     */
    @Test
    public void testAveragePages2()
    {
        testAveragePages();
    }

    /**
     * Test averagePages.
     */
    @Test
    public void testAveragePages3()
    {
        testAveragePages();
    }

    /**
     * Test averagePages.
     */
    @Test
    public void testAveragePagesB()
    {
        final double CORRECT = 4416.958333;
        final double EPS = 1e-6;
        FileReading fr = new FileReading(BOOK_DATA);
        fr.setFileIn(new Scanner("author,title,100000\n"));
        fr.readLines();

        double average = fr.averagePages();
        assertEquals("Average pages for " + BOOK_DATA + " should be " + CORRECT,
                CORRECT, average, EPS);

    }

    /**
     * Test averagePages.
     */
    @Test
    public void testAveragePagesB2()
    {
        testAveragePagesB();
    }

    /**
     * Tests the remove method in removeLessThan200().
     * 
     * @throws IllegalAccessException
     *             if unable to access the SortedLinkedList of books.
     */
    @Test
    public void testRemoveLessThan200() throws IllegalAccessException
    {
        assertTrue("Remove is not constant time.", checkConstantTimeRemove());
        FileReading fr = new FileReading(BOOK_DATA);
        fr.removeLessThan200();

        SortedLinkedList<Book> books = fr.getBooks();
        for (int i = 0; i < books.getLength(); i++)
        {
            Book b = books.getEntry(i);
            assertEquals("Book " + i + " does not match\ncorrect: "
                    + CORRECT_200[i] + "\nreturned: " + b, CORRECT_200[i],
                    b.toString());

        }
    }

    /**
     * Tests the remove method in removeLessThan200().
     * 
     * @throws IllegalAccessException
     *             if unable to access the SortedLinkedList of books.
     */
    @Test
    public void testRemoveLessThan200B() throws IllegalAccessException
    {
        testRemoveLessThan200();
    }

    /**
     * Tests the remove method in removeLessThan200().
     * 
     * @throws IllegalAccessException
     *             if unable to access the SortedLinkedList of books.
     */
    @Test
    public void testRemoveLessThan200C() throws IllegalAccessException
    {
        testRemoveLessThan200();
    }
}
