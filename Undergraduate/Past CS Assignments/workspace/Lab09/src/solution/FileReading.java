package solution;

import java.io.FileReader;
import java.io.IOException;
import java.util.Iterator;
import java.util.Scanner;

/**
 * Sample program to show how to read the comma delimited text file pets.txt and
 * break the lines up into a name, age, and weight.
 * 
 * @author Hannah Xiao Si Laws
 * @version 26.10.2017
 * 
 */
public class FileReading 
{

    private int m = 300;
    private Scanner fileIn = null;
    private SortedLinkedList<Book> bookss = new SortedLinkedList<Book>();

    /**
     * Constructor reads from filename.
     * 
     * @param filename
     *            The name of the file.
     */
    public FileReading(String filename)
    {
        // open the input file
        try
        {
            setFileIn(new Scanner(new FileReader(filename)));

        }
        catch (IOException ioe)
        {
            System.out.println("Could not open the input file." + filename);
            System.exit(0);
        }

        readLines();
        getBooks();
        removeLessThan200();
        // close the input file
        fileIn.close();
    }

    /**
     * Sets the input scanner.
     * 
     * @param input
     *            The input scanner.
     */
    public void setFileIn(Scanner input)
    {
        fileIn = input;
    }

    /**
     * Read lines of the file.
     */
    public void readLines()
    {
        String[] line;
        String author;
        String title;
        int numberOfPages;

        bookss = new SortedLinkedList<Book>();

        // as long as there are lines to read
        while (fileIn.hasNextLine())
        {
            // read a line from the file and split it
            // into an array of Strings around the commas
            line = fileIn.nextLine().split(",");
            // put the data before the first comma in petName
            author = line[0];
            // put the data before the second comma in petAge
            // after converting the String to an integer
            title = line[1];
            // put the data before the third comma in petWeight
            // after converting the String to a Double
            numberOfPages = Integer.parseInt(line[2]);
            // print out the data for testing to make sure it worked
            System.out.print("Author: " + author + " ");
            System.out.print("Title: " + title + " ");
            System.out.println("Number of Pages: " + numberOfPages);

            bookss.add(new Book(author, title, numberOfPages));
        }
    }

    /**
     * The get method for Book.
     * @return gives back the SortedLinkedList of Books objects.
     */
    public SortedLinkedList<Book> getBooks()
    {
        return bookss;
    }


    /**
     * Prints if there are more than 300 pages.
     */
    public void printMoreThan300()
    {
        for (Iterator<Book> i = bookss.iterator(); i.hasNext();)
        {
            Book b = (Book) i.next();
            if (b.getNumberOfPages() > m && i.next() != null)
            {
                System.out.print(b.toString() + ", ");
            }
            else if (b.getNumberOfPages() > m && i.next() == null)
            {
                System.out.print(b.toString());
            }
        }
    }


    /**
     * Average Page method.
     * @return gives back the average page count of the books in the list.
     */
    public double averagePages()
    {
        double sum = 0.0;
        for (Iterator<Book> i = bookss.iterator(); i.hasNext();)
        {
            sum += i.next().getNumberOfPages();
        }
        return sum / bookss.getLength();
    }

    /**
     * 
     * 
     */
    public void removeLessThan200()
    {
        
    }


    /**
     * The main program to read from pets.txt.
     * 
     * @param args unused.
     */
    public static void main(String[] args)
    {
        FileReading fr = new FileReading("bookdata.txt");

        for (Book b : fr.getBooks())
        {
            System.out.println(b.toString());
            System.out.println(fr.toString());
        }
    }

}
