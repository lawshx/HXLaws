package tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Test;

import solution.Book;

/**
 * JUnit tests for the Book class.
 * 
 * @author Mitch Parry
 * @version 2013-10-01
 */
public class BookTest
{
    /**
     * Check the fields.
     */
    @Test
    public void testFields()
    {
        String[] regexes = {
            "private;java.lang.String;title",
            "private;java.lang.String;author",
            "private;int;numberOfPages"
        };
        MyTesting.checkFields(Book.class, regexes);
    }

    /**
     * Check the constructors.
     */
    @Test
    public void testConstructors()
    {
        String[] regexes = {
            "public;solution\\.Book;\\[java.lang.String, "
                + "java.lang.String, int\\]"
        };
        MyTesting.checkConstructors(Book.class, regexes);
    }

    /**
     * Test constructor.
     */
    @Test
    public void testConstructor()
    {
        final int NUM_PAGES = 320;
        Book book = new Book("Michael Lewis", "Moneyball", NUM_PAGES);
        assertEquals("Constructor or getAuthor() doesn't work.",
                "Michael Lewis", book.getAuthor());
        assertEquals("Constructor or getTitle() doesn't work.", "Moneyball",
                book.getTitle());
        assertEquals("Constructor or getNumberOfPages() doesn't work.",
                NUM_PAGES,
                book.getNumberOfPages());
    }

    /**
     * Test constructor.
     */
    @Test
    public void testConstuctor2()
    {
        testConstructor();
    }

    /**
     * Test constructor.
     */
    @Test
    public void testConstuctor3()
    {
        testConstructor();
    }

    /**
     * Test constructor.
     */
    @Test
    public void testConstuctor4()
    {
        testConstructor();
    }

    /**
     * Test constructor.
     */
    @Test
    public void testConstuctor5()
    {
        testConstructor();
    }

    /**
     * Test compareTo.
     */
    @Test
    public void testCompareTo1()
    {
        final int NUM_PAGES = 100;
        Book a = new Book("author1", "title1", NUM_PAGES);
        Book b = new Book("author2", "title2", NUM_PAGES);
        assertTrue("author1, title1 should be less than author2, title2.",
                a.compareTo(b) < 0);
    }

    /**
     * Test compareTo.
     */
    @Test
    public void testCompareTo2()
    {
        final int NUM_PAGES = 100;
        Book a = new Book("author1", "title1", NUM_PAGES);
        Book b = new Book("author1", "title2", NUM_PAGES);
        assertTrue("author1, title1 should be less than author1, title2.",
                a.compareTo(b) < 0);
    }

    /**
     * Test compareTo.
     */
    @Test
    public void testCompareTo3()
    {
        final int NUM_PAGES = 100;
        Book a = new Book("author1", "title1", NUM_PAGES);
        Book b = new Book("author1", "title1", NUM_PAGES);
        assertTrue("author1, title1 should equal author1, title1.",
                a.compareTo(b) == 0);
    }

    /**
     * Test compareTo.
     */
    @Test
    public void testCompareTo4()
    {
        final int NUM_PAGES = 100;
        Book a = new Book("author1", "title1", NUM_PAGES);
        Book b = new Book("author2", "title1", NUM_PAGES);
        assertTrue("author1, title1 should be less than author2, title1.",
                a.compareTo(b) < 0);
    }

    /**
     * Test equals.
     */
    @Test
    public void testEquals1()
    {
        Book a = new Book("author1", "title1", 100);
        Book b = new Book("author1", "title1", 20);
        assertTrue("author1, title1 should equal author1, title1.",
                a.equals(b));
    }

    /**
     * Test equals.
     */
    @Test
    public void testEquals2()
    {
        final int NUM_PAGES = 100;
        Book a = new Book("author1", "title1", NUM_PAGES);
        Book b = new Book("author1", "title2", NUM_PAGES);
        assertFalse("author1, title1 should not equal author1, title2.",
                a.equals(b));
    }

    /**
     * Test equals.
     */
    @Test
    public void testEquals3()
    {
        final int NUM_PAGES = 100;
        Book a = new Book("author1", "title1", NUM_PAGES);
        Book b = new Book("author2", "title1", NUM_PAGES);
        assertFalse("author1, title1 should not equal author1, title2.",
                a.equals(b));
    }

    /**
     * Test equals.
     */
    @Test
    public void testEquals4()
    {
        testEquals1();
    }

    /**
     * Test toString.
     */
    @Test
    public void testToString1()
    {
        final String CORRECT = "author1, title1, 100";
        Book a = new Book("author1", "title1", 100);
        assertEquals("toString() should return \"" + CORRECT + "\"", CORRECT,
                a.toString());
    }

    /**
     * Test toString.
     */
    @Test
    public void testToString2()
    {
        testToString1();
    }

    /**
     * Test toString.
     */
    @Test
    public void testToString3()
    {
        testToString1();
    }

    /**
     * Test toString.
     */
    @Test
    public void testToString4()
    {
        testToString1();
    }

    /**
     * Test toString.
     */
    @Test
    public void testToString5()
    {
        testToString1();
    }

}
