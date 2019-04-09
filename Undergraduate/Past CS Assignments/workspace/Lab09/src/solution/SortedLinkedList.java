package solution;

import java.util.Iterator;
import java.util.NoSuchElementException;

/**
 * SortedLinkedList.
 * 
 * @author Hannah Xiao Si Laws
 * @version 26.10.2017
 * @param <T> I don't know what to put here.
 * 
 */
public class SortedLinkedList<T extends Comparable<? super T>>
    implements Iterable<T>
{
    // reference to the first item in the list
    private Node<T> head;
    // number of elements in the list
    private int manyNodes;

    /**
     * Task: Default constructor for the SortedLinkedList.
     */
    public SortedLinkedList()
    {
        head = null;
        manyNodes = 0;
    }


    /**
     * The iterator.
     * @return gives back an iterator.
     */
    public Iterator<T> iterator()
    {
        return new MyIterator();
    }


    /**
     * MyIterator class.
     */
    private class MyIterator implements Iterator<T>
    {
        private int currentIndex;
        private int lastReturnedIndex = -1;
        
        /**
         * My version of the iterator.
         */
        public MyIterator()
        {
            currentIndex = 0;
        }

        /**
         * Iterator next method.
         * @return gives back the next item on the list.
         * @throws NoSuchElementException not trying for the extra credit.
         */
        public T next() throws NoSuchElementException
        {
            T answer;
            if (!hasNext())
            {
                throw new NoSuchElementException("empty.");
            }
            answer = head.getData();
            head = head.getLink();
            lastReturnedIndex = currentIndex;
            currentIndex++;
            return answer;
        }
        
        /**
         * the iterator's hasNext method.
         * @return tells you whether there is another element or not.
         */
        public boolean hasNext()
        {
            //return currentIndex < manyNodes;
            if (head.getLink() == null)
            {
                return true;
            }
            return false;
        }
        
        /**
         * the remove method.
         * 
         */
        public void remove()
        {
            //throw new UnsupportedOperationException("No remove method.");
            if (lastReturnedIndex == -1)
            {
                throw new IllegalStateException("Remove called before next");
            }
            for (int i = lastReturnedIndex; i < manyNodes - 1; i++)
            {
                
            }
        }

    }


    /**
     * Task: Helper method to get the node before the entry.
     * 
     * @param entry
     *            an entry in the sequence
     * @return a reference to the node before where the entry would fit in the
     *         sequence or null if the entry would be first
     */
    private Node<T> getPrevious(T entry)
    {
        Node<T> previous = null;
        Node<T> traverse = head;
        while (traverse != null)
        {
            if (entry.compareTo(traverse.getData()) > 0)
            {
                previous = traverse;
                traverse = traverse.getLink();
            }
            else
            {
                return previous;
            }
        }
        return previous;
    }

    /**
     * Task: Adds a new entry in its sorted position in the list. Entries
     * currently in the list are unaffected. The lists size is increased by 1.
     * 
     * @param newEntry
     *            the object to be added as a new entry
     * @return true if the addition is successful, or false if the list is full
     */
    public boolean add(T newEntry)
    {
        Node<T> newNode = new Node<T>(newEntry);
        Node<T> addHere = getPrevious(newEntry);
        if (addHere == null)
        {
            newNode.setLink(head);
            head = newNode;
        }
        else
        {
            newNode.setLink(addHere.getLink());
            addHere.setLink(newNode);
        }
        manyNodes++;
        return true;
    }

    /**
     * Task: Removes the entry at the given index in the list. Entries
     * originally at positions higher than the given position are at the next
     * lower position within the list, and the lists size is decreased by 1.
     * 
     * @param givenPosition
     *            an integer that indicates the position of the entry to be
     *            removed
     * @return a reference to the removed entry or -1, if either the list was
     *         empty, givenPosition < 0, or givenPosition > getLength()-1
     */
    public T remove(int givenPosition)
    {
        T dataToReturn;
        if (givenPosition < 0 || givenPosition >= manyNodes)
        {
            return null;
        }
        if (givenPosition == 0)
        {
            dataToReturn = head.getData();
            head = head.getLink();
        }
        else
        {
            Node<T> previous = head;
            for (int i = 0; i < givenPosition - 1; i++)
            {
                previous = previous.getLink();
            }
            Node<T> oneToDelete = previous.getLink();
            dataToReturn = oneToDelete.getData();
            previous.setLink(oneToDelete.getLink());
            oneToDelete.setLink(null);
        }
        manyNodes--;
        return dataToReturn;
    }

    /**
     * Task: Removes all entries from the list. The length of the sequence
     * should be zero, and there will be no currentItem
     */
    public void clear()
    {
        head = null;
        manyNodes = 0;
    }

    /**
     * Task: Retrieves the entry at a given position in the list.
     * 
     * @param givenPosition
     *            an integer that indicates the position of the desired entry
     * @return a reference to the indicated entry or -1, if either the list is
     *         empty, givenPosition < 0, or givenPosition > getLength()-1
     */
    @SuppressWarnings("unchecked")
    public T getEntry(int givenPosition)
    {
        if (givenPosition < 0 || givenPosition >= manyNodes)
        {
            Integer a = new Integer(-1);
            return (T) a;
        }
        Node<T> traverse = head;
        for (int i = 0; i < givenPosition; i++)
        {
            traverse = traverse.getLink();
        }
        return traverse.getData();
    }

    /**
     * Task: Finds the index of the first occurrence of the entry in the list.
     * 
     * @param anEntry
     *            The object to find in the list.
     * @return the index of the first occurrence of this element, throws
     *         IllegalArgumentException if the element is not in the list
     */
    public int getPosition(T anEntry)
    {
        Node<T> traverse = head;
        for (int i = 0; i < manyNodes; i++, traverse = traverse.getLink())
        {
            if (anEntry == traverse.getData())
            {
                return i;
            }
        }
        throw new IllegalArgumentException("Element not in list");
    }

    /**
     * Task: Sees whether the list contains a given entry.
     * 
     * @param anEntry
     *            the object that is the desired entry
     * @return true if the list contains anEntry, or false if not
     */

    public boolean contains(T anEntry)
    {
        Node<T> traverse = head;
        for (int i = 0; i < manyNodes; i++, traverse = traverse.getLink())
        {
            if (anEntry == traverse.getData())
            {
                return true;
            }
        }
        return false;
    }

    /**
     * Task: Gets the length of the list.
     * 
     * @return the integer number of entries currently in the list
     */
    public int getLength()
    {
        return manyNodes;
    }

    /**
     * Task: Sees whether the list is empty.
     * 
     * @return true if the list is empty, or false if not
     */
    public boolean isEmpty()
    {
        return manyNodes == 0;
    }

    /**
     * Task: Sees whether the list is full.
     * 
     * @return true if the list is full, or false if not
     */
    public boolean isFull()
    {
        return false;
    }

    /**
     * Task: Displays all entries that are in the list, one per line, in the
     * order in which they occur in the list.
     */
    public void display()
    {
        for (Node<T> traverse = head; 
            traverse != null; traverse = traverse.getLink())
        {
            System.out.print(traverse.getData() + " ");
        }
        System.out.print("\n");
    }

} // end SortedSequence

