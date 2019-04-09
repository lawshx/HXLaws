package tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.lang.management.ManagementFactory;
import java.lang.management.ThreadMXBean;
import java.util.Arrays;
import java.util.Iterator;
import java.util.NoSuchElementException;

import org.junit.Test;

import solution.SortedLinkedList;

/**
 * To test SortedLinkedList's iterator.
 * 
 * @author Mitch Parry
 * @version 2013-09-26
 */
public class IteratorTest
{
    private final static String[] DESCRIPTION = {
        "tests for sequence class with a sorted linked list",
        "Testing general iteration, iterator, hasNext, next",
        "Testing to see if next() throws NoSuchElement exception when null",
        "Testing to see if remove is working",
        "Testing to see if remove throws IllegalStateException when no "
                + "preceding next"
    };
    private final static int N = 10000;

    /**
     * Task: A return value of true indicates: a. tests that test.getLength() ==
     * expectedSize, and Otherwise the return value is false. In either case, a
     * description of the test result is printed.
     * 
     * @param test
     *            The list to test.
     * @param expectedSize
     *            the correct size.
     * @param <T>
     *            The type of element in the list.
     * @return whether it passes the test.
     */
    private <T extends Comparable<? super T>> boolean testLength(
            SortedLinkedList<T> test, int expectedSize)
    {
        return test.getLength() == expectedSize;
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
        String message = "\nTEST 1a:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding 'Cat', 'Dog', 'Pig', 'Goat', 'Aardvark' "
                + "to an empty sequence.";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        message += "Calling the interator() method: \n";
        Iterator<String> itr = seq.iterator();
        assertNotNull(
                message + "Failed: Test program did not get an iterator.", itr);
        System.out.println(message + "Passed: Test program got an iterator.");
    }

    /**
     * Test 1a copy.
     */
    @Test
    public void test1a2()
    {
        test1a();
    }

    /**
     * Test 1a copy.
     */
    @Test
    public void test1a3()
    {
        test1a();
    }

    /**
     * Test 1a copy.
     */
    @Test
    public void test1a4()
    {
        test1a();
    }

    /**
     * Test 1a copy.
     */
    @Test
    public void test1a5()
    {
        test1a();
    }

    /**
     * Test 1a copy.
     */
    @Test
    public void test1a6()
    {
        test1a();
    }

    /**
     * Test 1b.
     */
    @Test
    public void test1b()
    {
        String message = "\nTEST 1b:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding 'Cat', 'Dog', 'Pig', 'Goat', 'Aardvark' "
                + "to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertNotNull(
                message + "Failed: Test program did not get an iterator.", itr);
        message += "Passed: Test program got an iterator.\n";

        message += "Calling the hasNext() method at the start: \n";
        assertTrue(message + "Failed. hasNext() false", itr.hasNext());
        System.out.println(message + "Passed. hasNext() true");
    }

    /**
     * Test 1b copy.
     */
    @Test
    public void test1b2()
    {
        test1b();
    }

    /**
     * Test 1c.
     */
    @Test
    public void test1c()
    {
        String message = "\nTEST 1c:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding 'Cat', 'Dog', 'Pig', 'Goat', 'Aardvark' "
                + "to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertNotNull(
                message + "Failed: Test program did not get an iterator.", itr);
        message += "Passed: Test program got an iterator.\n";

        message += "Calling the hasNext() method at the start: \n";
        assertTrue(message + "Failed. hasNext() false", itr.hasNext());
        message += "Passed. hasNext() true\n";

        message += "Calling the next() method to get first element: \n";
        String str = itr.next();
        message += "next() should return Aardvark. It returned :" + str + "\n";
        assertEquals(message + "next() Failed.", "Aardvark", str);
        System.out.println(message + "   Passed.");
    }

    /**
     * Test 1c copy.
     */
    @Test
    public void test1c2()
    {
        test1c();
    }

    /**
     * Test 1d1.
     */
    @Test
    public void test1d1()
    {
        String str;
        String message = "\nTEST 1d:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding Cat Dog Pig Goat Aardvark to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertEquals("Aardvark", itr.next());

        String[] arr = {
            "Aardvark", "Cat", "Dog", "Goat", "Pig"
        };

        for (int i = 1; i <= 1; i++)
        {
            message += "next() expected " + arr[i];
            assertTrue(message + "... got nothing but null. Failed.",
                    itr.hasNext());
            str = itr.next();
            assertEquals(message + "... got " + str + ". Failed.", arr[i], str);
        }
        System.out.println(message + "   Passed.");

    }

    /**
     * Test 1d1.
     */
    @Test
    public void test1d12()
    {
        test1d1();
    }

    /**
     * Test 1d2.
     */
    @Test
    public void test1d2()
    {
        String str;
        String message = "\nTEST 1d:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding Cat Dog Pig Goat Aardvark to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertEquals("Aardvark", itr.next());

        String[] arr = {
            "Aardvark", "Cat", "Dog", "Goat", "Pig"
        };

        for (int i = 1; i <= 2; i++)
        {
            message += "next() expected " + arr[i];
            assertTrue(message + "... got nothing but null. Failed.",
                    itr.hasNext());
            str = itr.next();
            assertEquals(message + "... got " + str + ". Failed.", arr[i], str);
        }
        System.out.println(message + "   Passed.");

    }

    /**
     * Test 1d2.
     */
    @Test
    public void test1d22()
    {
        test1d2();
    }

    /**
     * Test 1d3.
     */
    @Test
    public void test1d3()
    {
        String str;
        String message = "\nTEST 1d:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding Cat Dog Pig Goat Aardvark to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertEquals("Aardvark", itr.next());

        String[] arr = {
            "Aardvark", "Cat", "Dog", "Goat", "Pig"
        };

        for (int i = 1; i <= 3; i++)
        {
            message += "next() expected " + arr[i];
            assertTrue(message + "... got nothing but null. Failed.",
                    itr.hasNext());
            str = itr.next();
            assertEquals(message + "... got " + str + ". Failed.", arr[i], str);
        }
        System.out.println(message + "   Passed.");

    }

    /**
     * Test 1d3.
     */
    @Test
    public void test1d32()
    {
        test1d3();
    }

    /**
     * Test 1d4.
     */
    @Test
    public void test1d4()
    {
        String str;
        String message = "\nTEST 1d:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding Cat Dog Pig Goat Aardvark to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertEquals("Aardvark", itr.next());

        String[] arr = {
            "Aardvark", "Cat", "Dog", "Goat", "Pig"
        };

        for (int i = 1; i <= 4; i++)
        {
            message += "next() expected " + arr[i];
            assertTrue(message + "... got nothing but null. Failed.",
                    itr.hasNext());
            str = itr.next();
            assertEquals(message + "... got " + str + ". Failed.", arr[i], str);
        }
        System.out.println(message + "   Passed.");

    }

    /**
     * Test 1d4.
     */
    @Test
    public void test1d42()
    {
        test1d4();
    }

    /**
     * Test 1e.
     */
    @Test
    public void test1e()
    {
        String str;
        String message = "\nTEST 1e:" + DESCRIPTION[1] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Adding Cat Dog Pig Goat Aardvark to an empty sequence.\n";
        seq.add("Cat");
        seq.add("Dog");
        seq.add("Pig");
        seq.add("Goat");
        seq.add("Aardvark");
        Iterator<String> itr = seq.iterator();
        assertEquals("Aardvark", itr.next());

        String[] arr = {
            "Aardvark", "Cat", "Dog", "Goat", "Pig"
        };

        for (int i = 1; i <= 4; i++)
        {
            message += "next() expected " + arr[i];
            assertTrue(message + "... got nothing but null. Failed.",
                    itr.hasNext());
            str = itr.next();
            assertEquals(message + "... got " + str + ". Failed.", arr[i], str);
        }
        message += "   Passed.";

        message += "Making sure hasNext() returns null at the end.";
        assertFalse(message + " Failed", itr.hasNext());
        System.out.println(message + "   Passed.");
    }

    /**
     * Test 1e.
     */
    @Test
    public void test1e2()
    {
        test1e();
    }

    /**
     * Test 2.
     */
    @Test
    public void test2()
    {
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        String message = "\nTEST 2:" + DESCRIPTION[2] + "\n";
        message += "Adding: 22, 100, 52, 12, 30 to a new sequence\n";
        message += "Calling next() ten times!\n";
        Iterator<Integer> it = seq.iterator();
        boolean answer;
        try
        {
            answer = false;
            for (int i = 0; i < 10; i++)
            {
                it.next();
            }
        }
        catch (NoSuchElementException e)
        {
            answer = true;
        }
        assertTrue(message + "... No exception thrown. Failed.", answer);
        System.out.println(message + "... Exception thrown.  Passed.");
    }

    /**
     * Test 2.
     */
    @Test
    public void test22()
    {
        test2();
    }

    /**
     * Test 2.
     */
    @Test
    public void test23()
    {
        test2();
    }

    /**
     * Test 2.
     */
    @Test
    public void test24()
    {
        test2();
    }

    /**
     * Test 2.
     */
    @Test
    public void test25()
    {
        test2();
    }

    /**
     * Test 3a.
     */
    @Test
    public void test3a()
    {
        String message = "\nTEST 3a:" + DESCRIPTION[3] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        message += "Making a sequence of One, Two, Three, Four, Five\n";
        seq.add("One");
        seq.add("Two");
        seq.add("Three");
        seq.add("Four");
        seq.add("Five");
        message += "Try to remove first element with iterator...\n";
        Iterator<String> itr = seq.iterator();
        itr.next();
        try
        {
            itr.remove();
            assertTrue(message + "length should be four but is "
                    + seq.getLength(), testLength(seq, 4));
        }
        catch (UnsupportedOperationException e)
        {
            message += "Student chose not to implement the remove";
        }
        catch (Exception e)
        {
            fail(message + "Student chose not to implement remove but threw "
                    + "the wrong exception.");
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3b.
     */
    @Test
    public void test3b()
    {
        test3a();
        String message = "\nTEST 3b:" + DESCRIPTION[3] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("One");
        seq.add("Two");
        seq.add("Three");
        seq.add("Four");
        seq.add("Five");
        Iterator<String> itr = seq.iterator();
        itr.next();
        try
        {
            itr.remove();
            String[] arr = {"Four", "One", "Three", "Two"};
            assertTrue(message + "not " + arr, matchesExpectedList(seq, arr));
        }
        catch (UnsupportedOperationException e)
        {
            message += "Student chose not to implement the remove";
        }
        catch (Exception e)
        {
            fail(message + "Student threw the wrong exception.");
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3c.
     */
    @Test
    public void test3c()
    {
        test3b();
        String message = "\nTEST 3c:" + DESCRIPTION[3] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        seq.add("One");
        seq.add("Two");
        seq.add("Three");
        seq.add("Four");
        seq.add("Five");
        Iterator<String> itr = seq.iterator();
        itr.next();
        try
        {
            itr.remove();
            message += "Getting next: should be 'Four'.\n";
            assertTrue(message, itr.hasNext() && itr.next().equals("Four"));
            System.out.println(message + " correct!");
        }
        catch (UnsupportedOperationException e)
        {
            message += "Student chose not to implement the remove";
        }
        catch (Exception e)
        {
            fail(message + "Student threw the wrong exception.");
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3d.
     */
    @Test
    public void test3d()
    {
        test3c();
    }

    /**
     * Test 3e.
     */
    @Test
    public void test3e()
    {
        test3c();
        String message = "\nTEST 3e:" + DESCRIPTION[3] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        Iterator<String> itr = seq.iterator();
        itr.next();
        try
        {
            itr.remove();
            message += "Called next again and got " + itr.next() + "\n";
            message += "Called next again and got " + itr.next() + "\n";
            message += "Removing that last one, hopefully Three.\n";
            itr.remove();
            assertTrue(message + " Failed.", testLength(seq, 3));
            System.out.println(message + " Passed!");
        }
        catch (UnsupportedOperationException e)
        {
            message += "Student chose not to implement the remove";
        }
        catch (Exception e)
        {
            fail(message + "Student threw the wrong exception.");
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3e.
     */
    @Test
    public void test3f()
    {
        test3e();
    }

    /**
     * Test 3e.
     */
    @Test
    public void test3g()
    {
        test3e();
        testConstantTimeRemove();
        String message = "\nTEST 3g:" + DESCRIPTION[3] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        Iterator<String> itr = seq.iterator();
        itr.next();
        try
        {
            itr.remove();
            assertTrue(itr.next() != null && itr.next() != null
                    && itr.next() != null);
            itr.remove();
            String[] arr2 = {"Four", "One", "Two"};
            message += "comparing seq to " + Arrays.toString(arr2);
            assertTrue(message + " Failed.", matchesExpectedList(seq, arr2));
            System.out.println(message + " Passed!");
        }
        catch (UnsupportedOperationException e)
        {
            fail(message + "Student chose not to implement the remove");
        }
        catch (Exception e)
        {
            fail(message + "Student threw the wrong exception.");
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3h.
     */
    @Test
    public void test3h()
    {
        test3g();
    }

    /**
     * Test 3i.
     */
    @Test
    public void test3i()
    {
        test3g();
    }

    /**
     * Test 3i2.
     */
    @Test
    public void test3i2()
    {
        test3g();
    }

    /**
     * Test 3i3.
     */
    @Test
    public void test3i3()
    {
        test3g();
    }

    /**
     * Test 3j.
     */
    @Test
    public void test3j()
    {
        test3g();
        String message = "\nTEST 3j:" + DESCRIPTION[3] + "\n";
        SortedLinkedList<String> seq = new SortedLinkedList<String>();
        assertTrue(seq.add("One") && seq.add("Two") && seq.add("Three")
                && seq.add("Four") && seq.add("Five"));
        Iterator<String> itr = seq.iterator();
        itr.next();
        try
        {
            itr.remove();
            assertTrue((itr.next() + itr.next() + itr.next()) != null);
            itr.remove();
            assertTrue(itr.hasNext() && itr.next() != null);
            itr.remove();
            message += "Linked list should be 'Four', 'One'.\n";
            assertTrue(testLength(seq, 2) && seq.getEntry(0).equals("Four")
                    && seq.getEntry(1).equals("One"));
            System.out.println(message + " Passed!");
        }
        catch (UnsupportedOperationException e)
        {
            fail(message + "Student chose not to implement the remove");
        }
        catch (Exception e)
        {
            fail(message + "Student threw the wrong exception.");
        }
        System.out.println(message + " Passed.");
    }

    /**
     * Test 3k.
     */
    @Test
    public void test3k()
    {
        test3j();
    }

    /**
     * Test 3l.
     */
    @Test
    public void test3l()
    {
        test3j();
    }

    /**
     * Test 3l.
     */
    @Test
    public void test3m()
    {
        test3j();
    }

    /**
     * Test 3n.
     */
    @Test
    public void test3n()
    {
        test3j();
    }

    /**
     * Test 4.
     */
    @Test
    public void test4()
    {
        boolean answer = false;
        testConstantTimeRemove();
        String message = "\nTEST 4:" + DESCRIPTION[4] + "\nFor students trying"
                + " the extra credit\nAdded 14, 3, -1, 7 to a sequence\n"
                + "Calling next, then remove, then remove again";
        SortedLinkedList<Integer> seq = new SortedLinkedList<Integer>();
        assertTrue(seq.add(14) && seq.add(3) && seq.add(-1) && seq.add(7));
        try
        {
            Iterator<Integer> itr = seq.iterator();
            itr.next();
            itr.remove();
            itr.remove();
        }
        catch (IllegalStateException e)
        {
            answer = true;
        }
        catch (UnsupportedOperationException e)
        {
            fail(message + "Student chose not to implement the remove");
        }
        catch (Exception e)
        {
            fail(message + "Student threw the wrong exception.");
        }

        assertTrue(message + "IllegalStateException not thrown.", answer);
        System.out.println(message + "Passed: IllegalStateException thrown.");
    }

    /**
     * Test 4.
     */
    @Test
    public void test42()
    {
        test4();
    }

    /**
     * Test 4.
     */
    @Test
    public void test43()
    {
        test4();
    }

    /**
     * Test 4.
     */
    @Test
    public void test44()
    {
        test4();
    }

    /**
     * Test 4.
     */
    @Test
    public void test45()
    {
        test4();
    }

    /**
     * Test 4.
     */
    @Test
    public void test46()
    {
        test4();
    }

    /**
     * Get user time in nanoseconds.
     * 
     * @return User time in nanoseconds
     */
    private long getUserTime()
    {
        ThreadMXBean bean = ManagementFactory.getThreadMXBean();
        return bean.isCurrentThreadCpuTimeSupported()
                ? bean.getCurrentThreadUserTime() : 0L;
    }

    /**
     * Check that remove is implemented and runs in constant time.
     */
    @Test
    public void testConstantTimeRemove()
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
        assertTrue("Remove takes too long.\nRemoving from the front: " + t2
                + "ns.\nRemoving from the end takes: " + t1 + " ns.",
                t1 < 2.0 * t2 || t1 < 100 * 100 * 100 * 50);
    }
}
