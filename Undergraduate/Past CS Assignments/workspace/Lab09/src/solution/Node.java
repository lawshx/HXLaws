package solution;

/**
 * 
 * @author Hannah Xiao Si Laws
 * @version 26.10.2017
 * 
 * @param <T>
 *            The container for the data in the node.
 */
public class Node<T>
{
    private T data;
    private Node<T> link;

    /**
     * No-args constructor initializes head and link to null.
     */
    public Node()
    {
        data = null;
        link = null;
    }

    /**
     * Constructor takes a data element and initializes link to null.
     * 
     * @param data
     *            The data for this node.
     */
    public Node(T data)
    {
        this.data = data;
        link = null;
    }

    /**
     * Constructor takes a data element and node reference.
     * 
     * @param data
     *            The data for this node.
     * @param link
     *            The next node in the list.
     */
    public Node(T data, Node<T> link)
    {
        this.data = data;
        this.link = link;
    }

    /**
     * Changes the link of this node.
     * 
     * @param newLink
     *            The new link.
     */
    public void setLink(Node<T> newLink)
    {
        link = newLink;
    }

    /**
     * Changes the data for this node.
     * 
     * @param newData
     *            The new data.
     */
    public void setData(T newData)
    {
        data = newData;
    }

    /**
     * @return the link.
     */
    public Node<T> getLink()
    {
        return link;
    }

    /**
     * @return the data.
     */
    public T getData()
    {
        return data;
    }

}
