package solution;

/**
 * DoubleNode.java
 * A DoubleNode provides a node for a linked list with
 * double data in each node.
 *
 * @note
 *   Lists of nodes can be made of any length, limited only by the amount of
 *   free memory in the heap. But beyond Integer.MAX_VALUE (2,147,483,647),
 *   the answer from listLength is incorrect because of arithmetic
 *   overflow.
 *
 * @author Michael Main
 *
 * @version   March 6, 2002
 *
 */
public class DoubleNode
{
   /* Invariant of the DoubleNode class:
    * 1. The node's double data is in the instance variable data.
    * 2. For the final node of a list, the link part is null.
    *    Otherwise, the link part is a reference to the
    *    next node of the list. */
    private double data;
    private DoubleNode link;


   /**
    * Initialize a node with a specified initial data and link to the next
    * node. Note that the initialLink may be the null reference,
    * which indicates that the new node has nothing after it.
    * @param initialData
    *   the initial data of this new node
    * @param initialLink
    *   a reference to the node after this new node--this reference may be null
    *   to indicate that there is no node after this new node.
    * @postcondition
    *   This node contains the specified data and link to the next node.
    **/
    public DoubleNode(double initialData, DoubleNode initialLink)
    {
        data = initialData;
        link = initialLink;
    }

    /**
     * Initialize a node with a specified initial data.
     * Make the link be null
     * which indicates that the new node has nothing after it.
     * @param initialData
     *   the initial data of this new node
     * @postcondition
     *   This node contains the specified data and a null link.
     **/
    public DoubleNode(double initialData)
    {
        data = initialData;
        link = null;
    }


    /**
     * Modification method to add a new node after this node.
     * @param item
     *   the data to place in the new node
     * @postcondition
     *   A new node has been created and placed after this node.
     *   The data for the new node is item. Any other nodes
     *   that used to be after this node are now after the new node.
     **/
    public void addNodeAfter(double item)
    {
        link = new DoubleNode(item, link);
    }


    /**
     * Accessor method to get the data from this node.
     * @return
     *   the data from this node
     **/
    public double getData()
    {
        return data;
    }


    /**
     * Accessor method to get a reference to the next node after this node.
     * @return
     *   reference to the node after this node (or null if there
     *   is nothing after this node)
     **/
    public DoubleNode getLink()
    {
        return link;
    }


    /**
     * Copy a list.
     * @param source
     *   the head of a linked list that will be copied (which may be
     *   an empty list in where source is null)
     * @return
     *   The method has made a copy of the linked list starting at
     *   source. The return value is the head reference for the
     *   copy.
     **/
    public static DoubleNode listCopy(DoubleNode source)
    {
        DoubleNode copyHead;
        DoubleNode copyTail;

        // Handle the special case of the empty list.
        if (source == null)
        {
            return null;
        }

        // Make the first node for the newly created list.
        copyHead = new DoubleNode(source.data, null);
        copyTail = copyHead;

        // Make the rest of the nodes for the newly created list.
        while (source.link != null)
        {
            source = source.link;
            copyTail.addNodeAfter(source.data);
            copyTail = copyTail.link;
        }

        // Return the head reference for the new list.
        return copyHead;
    }


    /**
     * Copy a list, returning both a head and tail reference for the copy.
     * @param source
     *   the head of a linked list that will be copied (which may be
     *   an empty list in where source is null)
     * @return
     *   The method has made a copy of the linked list starting at
     *   source.  The return value is an
     *   array where the [0] element is a head reference for the copy 
     *   and the [1] element is a tail reference for the copy.
     **/
    public static DoubleNode[ ] listCopyWithTail(DoubleNode source)
    {
        DoubleNode copyHead;
        DoubleNode copyTail;
        DoubleNode[ ] answer = new DoubleNode[2];

        // Handle the special case of the empty list.
        if (source == null)
        {
            return answer;
        }

        // Make the first node for the newly created list.
        copyHead = new DoubleNode(source.data, null);
        copyTail = copyHead;

        // Make the rest of the nodes for the newly created list.
        while (source.link != null)
        {
            source = source.link;
            copyTail.addNodeAfter(source.data);
            copyTail = copyTail.link;
        }

        // Return the head and tail references.
        answer[0] = copyHead;
        answer[1] = copyTail;
        return answer;
    }


    /**
     * Compute the number of nodes in a linked list.
     * @param head
     *   the head reference for a linked list (which may be an empty list
     *   with a null head)
     * @return
     *   the number of nodes in the list with the given head
     * @note
     *   A wrong answer occurs for lists longer than Int.MAX_VALUE.
     **/
    public static int listLength(DoubleNode head)
    {
        DoubleNode cursor;
        int answer;

        answer = 0;
        for (cursor = head; cursor != null; cursor = cursor.link)
        {
            answer++;
        }

        return answer;
    }


    /**
     * Copy part of a list, providing head and tail reference for the copy.
     * @param start reference to starting node
     * @param end reference to ending node
     * @precondition
     *   start and end are non-null references to nodes
     *   on the same linked list,
     *   with the start node at or before the end node.
     * @return
     *   The method has made a copy of the part of a linked list, from the
     *   specified start node to the specified end node. Return value is an
     *   array where [0] component is a head reference for the copy and the
     *   [1] component is a tail reference for the copy.
     **/
    public static DoubleNode[ ] listPart(DoubleNode start, DoubleNode end)
    {
        DoubleNode copyHead;
        DoubleNode copyTail;
        DoubleNode cursor;
        DoubleNode[ ] answer = new DoubleNode[2];

        // Make first node for the newly created list. Notice that this will
        // cause NullPointerException if start is null.
        copyHead = new DoubleNode(start.data, null);
        copyTail = copyHead;
        cursor = start;

        // Make the rest of the nodes for the newly created list.
        while (cursor != end)
        {
            cursor = cursor.link;
            if (cursor == null)
            {
                throw new IllegalArgumentException(
                    "end node was not found on the list");
            }
            copyTail.addNodeAfter(cursor.data);
            copyTail = copyTail.link;
        }

        // Return the head and tail references
        answer[0] = copyHead;
        answer[1] = copyTail;
        return answer;
    }


    /**
     * Find a node at a specified position in a linked list.
     * @param head
     *   the head reference for a linked list (which may be an empty list in
     *   which case the head is null)
     * @param position
     *   a node number
     * @precondition
     *   position > 0.
     * @return
     *   return value is a reference to the node at the specified position in
     *   the list. (head node is position 1, the next node is position 2, and
     *   so on.) If there is no such position (because the list is too short),
     *   then the null reference is returned.
     **/
    public static DoubleNode listPosition(DoubleNode head, int position)
    {
        DoubleNode cursor;
        int i;

        if (position <= 0)
        {
            throw new IllegalArgumentException("position is not positive");
        }

        cursor = head;
        for (i = 1; (i < position) && (cursor != null); i++)
        {
            cursor = cursor.link;
        }

        return cursor;
    }


    /**
     * Search for a particular piece of data in a linked list.
     * @param head
     *   the head reference for a linked list (which may be an empty list in
     *   which case the head is null)
     * @param target
     *   a piece of data to search for
     * @return
     *   The return value is a reference to the first node that contains the
     *   specified target. If there is no such node, the null reference is
     *   returned.
     **/
    public static DoubleNode listSearch(DoubleNode head, double target)
    {
        DoubleNode cursor;

        for (cursor = head; cursor != null; cursor = cursor.link)
        {
            if (target == cursor.data)
            {
                return cursor;
            }
        }

        return null;
    }


    /**
     * Modification method to remove the node after this node.
     * @precondition
     *   This node must not be the tail node of the list.
     * @postcondition
     *   The node after this node has been removed from the linked list.
     *   If there were further nodes after that one, they are still
     *   present on the list.
     **/
    public void removeNodeAfter()
    {
        link = link.link;
    }


    /**
     * Modification method to set the data in this node.
     * @param newData
     *   the new data to place in this node
     * @postcondition
     *   The data of this node has been set to newData.
     **/
    public void setData(double newData)
    {
        data = newData;
    }


    /**
     * Modification method to set the link to the next node after this node.
     * @param newLink
     *   a reference to the node that should appear after this node 
     *   (or the null reference if there is no node after this node)
     * @postcondition
     *   The link to the node after this node has been set to newLink.
     *   Any other node (that used to be in this link) is no longer connected to
     *   this node.
     **/
    public void setLink(DoubleNode newLink)
    { 
        link = newLink;
    }
}


