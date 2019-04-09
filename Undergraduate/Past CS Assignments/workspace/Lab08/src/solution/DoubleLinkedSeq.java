package solution;

import util.DoubleNode;

/**
 * A DoubleLinkedSeq is a sequence of double numbers. The sequence can have a
 * special &quot;current element&quot;, which is specified and accessed through
 * four methods that are not available in the IntArrayBag class (start,
 * getCurrent, advance, and isCurrent).
 * 
 * Limitations:
 * 
 * Beyond Integer.MAX_VALUE element, the size method does not work.
 * 
 * @author Hannah Xiao Si Laws
 * @version 19.10.2017
 */


public class DoubleLinkedSeq implements Cloneable
{

    // your non-static fields go here.
    private int manyNodes;
    private DoubleNode precursor;
    private DoubleNode cursor;
    private DoubleNode head;
    private DoubleNode tail;

    /**
     * Initializes an empty DoubleLinkedSeq.
     * 
     * @postcondition This sequence is empty.
     */
    public DoubleLinkedSeq()
    {
        head = null;
        tail = null;
        manyNodes = 0;
        precursor = null;
        cursor = null;

    }

    /**
     * Adds a new element to this sequence.
     * 
     * @param element
     *            the new element that is being added to this sequence.
     * 
     * @postcondition a new copy of the element has been added to this sequence.
     *                If there was a current element, then this method places
     *                the new element before the current element. If there was
     *                no current element, then this method places the new
     *                element at the front of this sequence. The newly added
     *                element becomes the new current element of this sequence.
     */
    public void addBefore(double element)
    {
        DoubleNode e = new DoubleNode(element);
        if (manyNodes == 0)
        {
            head = e;
            tail = e;
            cursor = e;
        }
        else if (precursor == null || cursor == null)
        {
            e.setLink(head);
            cursor = e;
            head = e;
        }
        else
        {
            precursor.setLink(e);
            e.setLink(cursor);
            precursor = cursor;
            cursor = e;
        }        
        manyNodes++;
    }

    /**
     * Adds a new element to this sequence.
     * 
     * @param element
     *            the new element that is being added to this sequence.
     * 
     * @postcondition a new copy of the element has been added to this sequence.
     *                If there was a current element, then this method places
     *                the new element after the current element. If there was no
     *                current element, then this method places the new element
     *                at the end of this sequence. The newly added element
     *                becomes the new current element of this sequence.
     */
    public void addAfter(double element)
    {
        DoubleNode e = new DoubleNode(element);
        if (manyNodes == 0)
        {
            head = e;
            tail = e;
            cursor = e;
        }
        else if (cursor == null || manyNodes == 1 || cursor.getLink() == null)
        {
            tail.setLink(e);
            precursor = tail;
            cursor = e;
            tail = e;
        }
        else if (cursor == head)
        {
            e.setLink(cursor.getLink());
            cursor.setLink(e);
            precursor = cursor;
            cursor = e;
        }
        else
        {
            e.setLink(cursor.getLink());
            precursor = cursor;
            cursor.setLink(e);
            cursor = e;
        }        
        manyNodes++;
    }

    /**
     * Places the contents of another sequence at the end of this sequence.
     * 
     * @precondition other must not be null.
     * 
     * @param other
     *            a sequence show contents will be placed at the end of this
     *            sequence.
     * 
     * @postcondition the elements from other have been placed at the end of
     *                this sequence. The current element of this sequence
     *                remains where it was, and other is unchanged.
     * 
     * @throws NullPointerException
     *             if other is null.
     */
    public void addAll(DoubleLinkedSeq other) throws NullPointerException
    {
        DoubleNode[] copyInfo;
        if (other == null)
        {
            throw new NullPointerException("Other Sequence is Null");
        }
        if (other.manyNodes > 0)
        {
            copyInfo = DoubleNode.listCopyWithTail(other.head);
            tail.setLink(copyInfo[0]);
            tail = copyInfo[1];
            manyNodes += other.manyNodes;
        }
    }

    /**
     * Move forward so that the current element is now the next element in the
     * sequence.
     * 
     * @precondition isCurrent() returns true.
     * 
     * @postcondition If the current element was already the end element of this
     *                sequence (with nothing after it), then there is no longer
     *                any current element. Otherwise, the new element is the
     *                element immediately after the original current element.
     * 
     * @throws IllegalStateException
     *             if there is not current element.
     */
    public void advance() throws IllegalStateException
    {
        if (isCurrent())
        {
            precursor = cursor;
            cursor = cursor.getLink();
        }
        else
        {
            throw new IllegalStateException("No current element.");
        }
    }

    /**
     * Creates a copy of this sequence.
     * 
     * @return a copy of this sequence. Subsequent changes to the copy will not
     *         affect the original, nor vice versa.
     * @throws RuntimeException
     *             if this class does not implement Cloneable.
     * 
     */
    public DoubleLinkedSeq clone() throws RuntimeException
    {
        // your code here. see textbook for hints
        // change this return!
        DoubleLinkedSeq answer = new DoubleLinkedSeq();
        try
        {
            answer = (DoubleLinkedSeq) super.clone();


            if (manyNodes == 0)
            {
                return ((DoubleLinkedSeq) super.clone());
            }
            else if (cursor == null || cursor == head)
            {
                DoubleNode[] aa = DoubleNode.listCopyWithTail(head);
                answer.head = aa[0];
                answer.tail = aa[1];

            }
            else
            {
                DoubleNode[] bb = DoubleNode.listPart(head, precursor);
                DoubleNode[] cc = DoubleNode.listPart(cursor, tail);

                answer.head = bb[0];
                answer.tail = cc[1];
                answer.precursor = bb[1];
                answer.cursor = cc[0];
                bb[0].setLink(cc[0]);

            }
        }
        catch (CloneNotSupportedException r)
        {
            throw new RuntimeException("Clone doesn't work.");
        }
        return answer;
    }

    /**
     * Creates a new sequence that contains all the elements from s1 followed by
     * all of the elements from s2.
     * 
     * @precondition neither s1 nor s2 are null.
     * 
     * @param s1
     *            the first of two sequences.
     * @param s2
     *            the second of two sequences.
     * 
     * @return a new sequence that has the elements of s1 followed by the
     *         elements of s2 (with no current element).
     * 
     * @throws NullPointerException
     *             if s1 or s2 are null.
     */
    public static DoubleLinkedSeq concatenation(DoubleLinkedSeq s1,
        DoubleLinkedSeq s2) throws NullPointerException
    {
        if (s1 != null && s2 != null)
        {
            DoubleLinkedSeq seq = new DoubleLinkedSeq();

            DoubleNode[] seq1 = DoubleNode.listCopyWithTail(s1.head);
            DoubleNode[] seq2 = DoubleNode.listCopyWithTail(s2.head);
            seq.head = seq1[0];
            seq1[1].setLink(seq2[0]);
            seq.tail = seq2[1];

            seq.manyNodes = s1.manyNodes + s2.manyNodes;
            return seq;
        }
        else
        {
            throw new NullPointerException("Concatenation didn't work.");
        }
    }

    /**
     * Returns a copy of the current element in this sequence.
     * 
     * @precondition isCurrent() returns true.
     * 
     * @return the current element of this sequence.
     * 
     * @throws IllegalStateException
     *             if there is no current element.
     */
    public double getCurrent() throws IllegalStateException
    {
        if (isCurrent())
        {
            return cursor.getData();
        }
        else
        {
            throw new IllegalStateException("Nope.");    
        }

    }

    /**
     * Determines whether this sequence has specified a current element.
     * 
     * @return true if there is a current element, or false otherwise.
     */
    public boolean isCurrent()
    {
        if (cursor != null)
        {
            return true;
        }
        return false;
    }

    /**
     * Removes the current element from this sequence.
     * 
     * @precondition isCurrent() returns true.
     * 
     * @postcondition The current element has been removed from this sequence,
     *                and the following element (if there is one) is now the new
     *                current element. If there was no following element, then
     *                there is now no current element.
     * 
     * @throws IllegalStateException
     *             if there is no current element.
     */
    public void removeCurrent() throws IllegalStateException
    {
        if (isCurrent())
        {
            if (cursor != tail && cursor != head)
            {
                precursor.setLink(cursor.getLink());
                cursor = cursor.getLink();
            }
            else if (cursor == tail)
            {
                precursor.setLink(null);
                cursor = null;
            }
            else if (cursor == head)
            {
                precursor = cursor;
                cursor = cursor.getLink();
                head = cursor;
                precursor = null;
            }

            manyNodes--;

        }
        else
        {
            throw new IllegalStateException("Could not remove cursor.");
        }
    }

    /**
     * Determines the number of elements in this sequence.
     * 
     * @return the number of elements in this sequence.
     */
    public int size()
    {
        return manyNodes;
    }

    /**
     * Sets the current element at the front of this sequence.
     * 
     * @postcondition If this sequence is not empty, the front element of this
     *                sequence is now the current element; otherwise, there is
     *                no current element.
     */
    public void start()
    {
        if (manyNodes > 0)
        {
            precursor = null;
            cursor = head;
        }

    }

    /**
     * Returns a String representation of this sequence. If the sequence is
     * empty, the method should return &quot;&lt;&gt;&quot;. If the sequence has
     * one item, say 1.1, and that item is not the current item, the method
     * should return &quot;&lt;1.1&gt;&quot;. If the sequence has more than one
     * item, they should be separated by commas, for example: &quot;&lt;1.1,
     * 2.2, 3.3&gt;&quot;. If there exists a current item, then that item should
     * be surrounded by square braces. For example, if the second item is the
     * current item, the method should return: &quot;&lt;1.1, [2.2],
     * 3.3&gt;&quot;.
     * 
     * @return a String representation of this sequence.
     */
    @Override
    public String toString()
    {
        String s = "<";
        for (DoubleNode cur = head; cur != null; cur = cur.getLink())
        {

            if (cur == cursor)
            {
                s += "[" + cur.getData() + "]";
            }
            else
            {
                s += cur.getData();
            }
            if (cur.getLink() != null)
            {
                s += ", ";
            }

        }
        s += ">";

        return s;
    }

    /**
     * Determines if this object is equal to the other object.
     * 
     * @param other
     *            The other object (possibly a DoubleLinkedSequence).
     * @return true if this object is equal to the other object, false
     *         otherwise. Two sequences are equal if they have the same number
     *         of elements, and each corresponding element is equal
     */
    public boolean equals(Object other)
    {
        // your code goes here
        // change this return!
        if (toString().equals(other.toString()))
        {
            return true;
        }
        return false;
    }
}
