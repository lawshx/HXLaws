package solution;

import java.util.Random;

/**
 * This program tests the DoubleSortedLinkedList class.
 *
 * @author Dee Parks
 * @version 3/8/2014
 *
 */
public class DoubleSortedLinkedListMain
{
    /**
     * Generates 100 random doubles and adds them to the sorted linked list.
     * Then calls the display method to print them out.
     *
     * @param args are command line arguments -- not used
     *
     */
    public static void main(String[] args)
    {
        DoubleSortedLinkedList list = new DoubleSortedLinkedList();
        Random rnd = new Random();
        for (int i = 0; i < 100; i++)
        {
            list.add(rnd.nextDouble() * 100);
            System.out.println(list.getLength());
        }
        list.display();
    }
}

