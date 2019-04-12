package tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.assertTrue;

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.util.Arrays;

import org.junit.Test;

import solution.SortedLinkedList;

/**
 * Old test cases converted to JUnit.
 * 
 * @author Mitch Parry
 * @version 2013-09-26
 * 
 */
public class SortedLinkedListTest
{
    private static final String[] DESCRIPTION = {
        "tests for a generic sorted linked list",
        "Testing add, and the getEntry, getLength, isEmpty and isFull methods",
        "Testing the remove and clear methods",
        "Testing the contains and getIndex methods",
        "Testing the getEntry methods",
        "Testing series of adds and removes with somewhat larger sequence",
        "Testing the display() method"
    };

    /**
     * A basic test of length.
     * 
     * @param <T>
     *            the type of container for the SortedLinkedList
     * @param test
     *            the sequence to test its length.
     * @param expectedSize
     *            The correct length.
     * @return A return value of true indicates: a. tests that all tests held;
     *         test.getLength() == expectedSize, and Otherwise the return value
     *         is false. In either case, a description of the test result is
     *         printed
     * 
     */
    private <T extends Comparable<? super T>> boolean testBasic(
            SortedLinkedList<T> test, int expectedSize)
    {
        String message =
                "Testing that getLength() returns " + expectedSize + " ... ";
        assertTrue(message + " Failed.", test.getLength() == expectedSize);
        message += " Passed.\n";

        message += "Testing that isEmpty() returns " + (expectedSize == 0);
        assertEquals(message + " Failed.", expectedSize == 0, test.isEmpty());
        message += " Passed.\n";

        message = "Testing that isFull() returns false. ";
        assertTrue(message + " Failed.", !test.isFull());
        message += " Passed.\n";
        System.out.println(message);

        return true;
    }

    /**
     * Task: Compares a sequence with a given array.
     * 
     * @param test
     *            The list to test.
     * @param values
     *            The expected values in the list.
     * @param <T>
     *            The type of element in the list.
     * @return whether or not the test passes.
     */
    private <T extends Comparable<? super T>> boolean matchesExpectedList(
            SortedLinkedList<T> test, T[] values)
    {
        boolean ok = true;
        for (int i = 0; i < values.length; i++)
        {
            T val = test.getEntry(i);
            if (values[i].compareTo(val) != 0)
            {
                ok = false;
            }
        }
        return ok;
    }

    /**
     * Test 1a.
     */
    @Test
    public void test1a()
    {
        String message = "\nTEST 1a: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Testing adding 'Cat' to an empty linked list.\n";
        message += "Add method should return true; it ";
        assertTrue(message + " Failed.", seq.add("Cat"));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 1b.
     */
    @Test
    public void test1b()
    {
        test1a();
        String message = "\nTEST 1b: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Testing adding 'Cat' to an empty linked list.\n";
        seq.add("Cat");

        assertTrue(message + " Failed.", testBasic(seq, 1));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 1c.
     */
    @Test
    public void test1c()
    {
        test1b();
        String message = "\nTEST 1c: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Testing adding 'Cat' to an empty linked list.\n";
        seq.add("Cat");

        assertTrue(message + " Failed.", seq.getEntry(0).equals("Cat"));
        System.out.println(message + " Passed.");

    }

    /**
     * Test 1d.
     */
    @Test
    public void test1d()
    {
        test1c();
        String message = "\nTEST 1d: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("Cat");

        message += "Testing adding 'Horse' to the sequence.\nAdd method "
                + "should return true;\n";
        assertTrue(message + " Failed.", seq.add("Horse"));
        message += " Passed.\n";

        String[] arr = {"Cat", "Horse"};
        message += "Testing sequence is " + Arrays.toString(arr) + "\n";
        assertTrue(message + " Failed.", testBasic(seq, 2)
                && matchesExpectedList(seq, arr));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 1e.
     */
    @Test
    public void test1e()
    {
        test1d();
        String message = "\nTEST 1e: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("Cat");
        seq.add("Horse");
        message += "Testing adding 'Aardvark' to the sequence.\n";
        message += "Length matches?...";
        assertTrue(message + " Failed.",
                seq.add("Aardvark") && testBasic(seq, 3));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 1f.
     */
    @Test
    public void test1f()
    {
        test1e();
        String message = "\nTEST 1f: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("Cat");
        seq.add("Horse");
        message += "Testing adding 'Aardvark' to the sequence.\n";
        message += "List matches?...";
        seq.add("Aardvark");
        String[] arr = {"Aardvark", "Cat", "Horse"};
        assertTrue(message + " Failed.", matchesExpectedList(seq, arr));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 1g.
     */
    @Test
    public void test1g()
    {
        String message = "\nTEST 1g: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("Cat");
        seq.add("Horse");
        seq.add("Aardvark");
        message += "Testing adding 'Cow' to the sequence.\n";
        message += "Length matches?...";
        assertTrue(message += " Failed.", seq.add("Cow") && testBasic(seq, 4));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 1h.
     */
    @Test
    public void test1h()
    {
        test1g();
        String message = "\nTEST 1h: " + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("Cat");
        seq.add("Horse");
        seq.add("Aardvark");
        message += "Testing adding 'Cow' to the sequence.\n";
        message += "List matches?...";
        seq.add("Cow");
        String[] arr = {
            "Aardvark", "Cat", "Cow", "Horse"
        };
        assertTrue(message + " Failed.", matchesExpectedList(seq, arr));
    }

    /**
     * Test 2a.
     */
    @Test
    public void test2a()
    {
        String message = "\nTEST 2a: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));

        message += "Try to remove at position 6...\n";
        assertNull(message + " Failed.", seq.remove(6));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 2b.
     */
    @Test
    public void test2b()
    {
        test2a();
        String message = "\nTEST 2b: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));

        message += "Try to remove at position 6, 1...\n";
        seq.remove(6);
        String str = seq.remove(1);
        message += str + " removed...";
        assertEquals(message + " Failed.", "Four", str);
        System.out.println(message + " Passed.");
    }

    /**
     * Test 2c.
     */
    @Test
    public void test2c()
    {
        test2b();
        String message = "\nTEST 2c: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        message += "Try to remove at position 6, 1...\n";
        seq.remove(6);
        seq.remove(1);

        message += "Length should be 4...";
        assertTrue(message + " Failed.", testBasic(seq, 4));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 2d.
     */
    @Test
    public void test2d()
    {
        test2c();
        String message = "\nTEST 2d: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        message += "Try to remove at position 6, 1...\n";
        seq.remove(6);
        seq.remove(1);

        message += "Try to remove at index 0: \n";
        String str = seq.remove(0);
        message += str + " removed.\n";
        assertEquals(message + " Failed.", "Five", str);
        System.out.println(message + " Passed.");
    }

    /**
     * Test 2e.
     */
    @Test
    public void test2e()
    {
        test2d();
        String message = "\nTEST 2e: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        message += "Try to remove at position 6, 1, 0...\n";
        seq.remove(6);
        seq.remove(1);
        seq.remove(0);

        message += "Length should be 3.";

        assertTrue(message + " Failed.", testBasic(seq, 3));
    }

    /**
     * Test 2f.
     */
    @Test
    public void test2f()
    {
        test2e();
        String message = "\nTEST 2f: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        message += "Try to remove at position 6, 1, 0...\n";
        seq.remove(6);
        seq.remove(1);
        seq.remove(0);

        message += "Try to remove at index 2\n";
        String str = seq.remove(2);
        message += str + " removed.\n";
        assertEquals(message + " Failed.", "Two", str);
        System.out.println(message + " Passed.");
    }

    /**
     * Test 2g.
     */
    @Test
    public void test2g()
    {
        test2f();
        String message = "\nTEST 2g: " + DESCRIPTION[2] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        message += "Try to remove at position 6, 1, 0, 2...\n";
        seq.remove(6);
        seq.remove(1);
        seq.remove(0);
        seq.remove(2);

        message += "Clearing the list: \n";
        seq.clear();
        message += "Length should be zero: \n";
        assertTrue(message + " Failed.", testBasic(seq, 0));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3a.
     */
    @Test
    public void test3a()
    {
        String message = "\nTEST 3a: " + DESCRIPTION[3] + "\n";
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        message += "Added 14, 3, -1, 7 to a sequence\n";
        assertTrue(seq.add(14) && seq.add(3) && seq.add(-1) && seq.add(7));

        message += "Testing if 12 is in the sequence\n";
        assertFalse(message + " Failed.", seq.contains(12));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3b.
     */
    @Test
    public void test3b()
    {
        String message = "\nTEST 3b: " + DESCRIPTION[3] + "\n";
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        message += "Added 14, 3, -1, 7 to a sequence\n";
        assertTrue(seq.add(14) && seq.add(3) && seq.add(-1) && seq.add(7));

        message += "Testing if -1 is in the sequence\n";
        assertTrue(message + " Failed.", seq.contains(-1));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3d.
     */
    @Test
    public void test3c()
    {
        boolean answer = false;
        String message = "\nTEST 3c: " + DESCRIPTION[3] + "\n";
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        message += "Added 14, 3, -1, 7 to a sequence\n";
        assertTrue(seq.add(14) && seq.add(3) && seq.add(-1) && seq.add(7));

        message += "Testing if 7 is in the sequence\n";
        assertTrue(message + " Failed.", seq.contains(7));
        System.out.println(message + " Passed.");

        message += "Testing getting index of 12\n";
        try
        {
            seq.getPosition(12);
            message += " does not throw exception.\n";
        }
        catch (IllegalArgumentException e)
        {
            message += " 12 not in the list. \n";
            answer = true;
        }
        assertTrue(message + " Failed.", answer);
        System.out.println(message + " Passed.");

    }

    /**
     * Test 3e.
     */
    @Test
    public void test3d()
    {
        String message = "\nTEST 3d: " + DESCRIPTION[3] + "\n";
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        message += "Added 14, 3, -1, 7 to a sequence\n";
        assertTrue(seq.add(14) && seq.add(3) && seq.add(-1) && seq.add(7));

        message += "Testing getting index of 14\n";
        assertEquals(message + " Failed.", 3, seq.getPosition(14));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3f.
     */
    @Test
    public void test3e()
    {
        String message = "\nTEST 3e: " + DESCRIPTION[3] + "\n";
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        message += "Added 14, 3, -1, 7 to a sequence\n";
        assertTrue(seq.add(14) && seq.add(3) && seq.add(-1) && seq.add(7));

        message += "Testing getting index of -1\n";
        assertEquals(message + " Failed.", 0, seq.getPosition(-1));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 4.
     */
    @Test
    public void test4()
    {
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        String message = "\nTEST 4a: " + DESCRIPTION[4] + "\n";
        assertTrue(seq.add("The") && seq.add("Last") && seq.add("Shall")
                && seq.add("Be") && seq.add("First"));
        String[] testArray = {"Be", "First", "Last", "Shall", "The"};
        message += "Get 'The Last Shall Be First' in reverse sorted order\n";
        for (int i = 4; i >= 0; i--)
        {
            String entry = seq.getEntry(i);
            message += entry + " ";
            assertEquals(message + "<-- Failed.", testArray[i], entry);
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 4b.
     */
    @Test
    public void test4b()
    {
        test4();
    }

    /**
     * Test 4c.
     */
    @Test
    public void test4c()
    {
        test4();
    }

    /**
     * Test 5.
     */
    @Test
    public void test5()
    {
        String message = "\nTEST 5a: " + DESCRIPTION[5] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        assertTrue(seq.add("Four") && seq.add("Score") && seq.add("And")
                && seq.add("Seven"));
        seq.remove(2);
        assertTrue(seq.add("Years") && seq.add("Ago"));
        seq.remove(1);
        seq.add("Our");
        seq.remove(2);
        seq.add("Fathers");
        seq.remove(2);
        String[] arr = {"Ago", "Fathers", "Seven", "Years"};
        message += "Correct Answer = 0. Ago, 1. Fathers, 2. Seven, 3. Years\n";

        assertTrue(message + " Failed.", matchesExpectedList(seq, arr));
        System.out.println(message + " Passed.");
    }

    /**
     * Test 5 copy 1 (Test 5 counts 3x).
     */
    @Test
    public void test5a()
    {
        test5();
    }

    /**
     * Test 5 copy 2 (Test 5 counts 3x).
     */
    @Test
    public void test5b()
    {
        test5();
    }

    /**
     * Test 6.
     */
    @Test
    public void test6()
    {
        String message = "\nTEST 6: " + DESCRIPTION[6] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        assertTrue(seq.add("January") && seq.add("February")
                && seq.add("March") && seq.add("April") && seq.add("May")
                && seq.add("July") && seq.add("June") && seq.add("August")
                && seq.add("September"));
        message += "This test is worth 4 points\nCheck to see data matches.\n";
        String correct = "April August February January July June March May "
                + "September \n";

        PrintStream stdout = System.out;
        ByteArrayOutputStream outContent = new ByteArrayOutputStream();
        System.setOut(new PrintStream(outContent));
        seq.display();
        System.setOut(stdout);

        String output = outContent.toString();
        assertEquals(message + " Failed.", correct, output);
        System.out.println(message + " Passed.");
    }

    /**
     * Test 6 Copy 1 (Test 6 is 4 points).
     */
    @Test
    public void test6b()
    {
        test6();
    }

    /**
     * Test 6 Copy 1 (Test 6 is 4 points).
     */
    @Test
    public void test6c()
    {
        test6();
    }

    /**
     * Test 6 Copy 1 (Test 6 is 4 points).
     */
    @Test
    public void test6d()
    {
        test6();
    }
}
