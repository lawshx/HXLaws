package solution;

/**
 * Book.
 * 
 * @author Hannah Xiao Si Laws
 * @version 26.10.2017
 * 
 */
public class Book implements Comparable<Book>
{
    private String author;
    private String title;
    private int numberOfPages;


    /**
     * Constructor for Book class.
     * @param a the name of the author.
     * @param t name of the book.
     * @param n the number of pages in said book.
     */
    public Book(String a, String t, int n)
    {
        this.author = a;
        this.title = t;
        this.numberOfPages = n;
    }

    
    
    
    /**
     * Getter method for author.
     * @return returns the name of the author.
     */
    public String getAuthor()
    {
        return author;
    }

    /**
     * Getter method for title.
     * @return gives back the name of the book.
     */
    public String getTitle()
    {
        return title;
    }

    /**
     * Getter method for numberOfPages.
     * @return gives back the number of pages in the book.
     */
    public int getNumberOfPages()
    {
        return numberOfPages;
    }

    /**
     * The compareTo method for Book class.
     * @param b the book.
     * @return tells what order two books are in based on author 
     * and then title.
     */
    public int compareTo(Book b)
    {
        if (author.compareTo(b.author) == 0)
        {
            return title.compareTo(b.title);    
        }

        return author.compareTo(b.author);
    }
    
    /**
     * The equals method for the Book class.
     * @param b the other book to compare.
     * @return gives back true if the books are the same, else false if not.
     */
    public boolean equals(Book b)
    {
        if (author.compareTo(b.author) == 0 && title.compareTo(b.title) == 0)
        {
            return true;
        }
        return false;
    }
    
    
    /**
     * The String Method.
     * @return gives back the string.
     */
    public String toString()
    {
        String s = "";
        s += author + ", " + title + ", " + numberOfPages;
        return s;
    }





}
