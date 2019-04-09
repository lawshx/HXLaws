package solution;

import java.util.Scanner;
import java.io.FileNotFoundException;
import java.io.FileReader;

/**
 * A maze game.
 * 
 * @author Hannah Xiao Si Laws
 * @version 1.0
 *
 */
public class MazeGame
{
    /**
     * The size of each side of the game map.
     */
    private final static int HEIGHT = 19;
    private final static int WIDTH = 39;

    /**
     * The game map, as a 2D array of ints.
     */
    private boolean[][] blocked;

    /**
     * Keeps track of movement.
     */
    private boolean[][] breadc; 

    /**
     * The current location of the player vertically.
     */
    // TODO: add field here.
    private int userRow;

    /**
     * The current location of the player horizontally.
     */
    // TODO: add field here.
    private int userCol;

    /**
     * The scanner from which each move is read.
     */
    // TODO: add field here.
    private Scanner moveScanner = new Scanner(System.in);

    /**
     * The row and column of the goal.
     */
    // TODO: add fields here.
    private int gx;
    private int gy;

    /**
     * The row and column of the start.
     */
    // TODO: add fields here.
    private int sx = 0;
    private int sy = 0;


    /**
     * Getter for userCol.
     * @return returns the current column position.
     */
    public int getUserCol()
    {
        return userCol;
    }

    /**
     * Getter for userRow.
     * @return returns the current row position.
     */
    public int getUserRow()
    {
        return userRow;
    }


    /**
     * Getter for moveScanner.
     * @return returns the moveScanner.
     */
    public Scanner getMoveScanner()
    {
        return moveScanner;
    }

    /**
     * Sets the column position.
     * @param col the column position.
     */
    public void setUserCol(int col)
    {
        userCol = col;
    }

    /**
     * Sets the row position.
     * @param row the row position.
     */
    public void setUserRow(int row)
    {
        userRow = row;
    }

    /**
     * Sets the scanner.
     * @param move the scanner.
     */
    public void setMoveScanner(Scanner move)
    {
        moveScanner = move;
    }






    /**
     * Constructor initializes the maze with the data in 'mazeFile'.
     * @param mazeFile the input file for the maze
     */
    public MazeGame(String mazeFile)
    {
        moveScanner = new Scanner(System.in);
        loadMaze(mazeFile);

    }


    /**
     * Constructor initializes the maze with the 'mazeFile' and the move 
     * scanner with 'moveScanner'.
     * @param mazeFile the input file for the maze
     * @param moveScanner the scanner object from which to read user moves
     */
    public MazeGame(String mazeFile, Scanner moveScanner)
    {
        this.moveScanner = moveScanner;
        loadMaze(mazeFile);
    }


    /**
     * getMaze returns a copy of the current maze for testing purposes.
     * 
     * @return the grid
     */
    public boolean[][] getMaze()
    {
        if (blocked == null)
        {
            return null;
        }
        boolean[][] copy = new boolean[HEIGHT][WIDTH];
        for (int i = 0; i < HEIGHT; i++)
        {
            for (int j = 0; j < WIDTH; j++)
            {
                copy[i][j] = blocked[i][j];
            }
        }
        return copy;
    }

    /**
     * setMaze sets the current map for testing purposes.
     * 
     * @param maze
     *            another maze.
     */
    public void setMaze(boolean[][] maze)
    {
        this.blocked = maze;
    }

    /**
     * Function loads the data from the maze file and creates the 'blocked' 
     * 2D array.
     *  
     * @param mazeFile the input maze file.
     */
    // TODO: private void loadMaze(String mazeFile)
    private void loadMaze(String mazeFile)
    {
        blocked = new boolean[HEIGHT][WIDTH]; 
        breadc = new boolean[HEIGHT][WIDTH]; 
        Scanner myScanner = null; 
        String m = " ";
        try
        {
            myScanner = new Scanner(new FileReader(mazeFile));
        }
        catch (FileNotFoundException e)
        {
            System.out.print("Can't find."); System.exit(0);
        }
        for (int i = 0; i < HEIGHT; i++)
        {
            for (int j = 0; j < WIDTH; j++)
            {
                blocked[i][j] = false; m = myScanner.next();
                if ((m.equals("G")))
                {
                    blocked[i][j] = false; gx = i; gy = j;
                }
                else if (m.equals("S"))
                {
                    blocked[i][j] = false; sx = userRow = i; sy = userCol = j;
                }
                else if (m.equals("1"))
                {
                    blocked[i][j] = true;
                }
            }
        }
        myScanner.close();
    }

    /**
     * Actually plays the game.
     */
    public void playGame()
    {
        int c = 0;
        printMaze();
        System.out.println("Next move: ");
        String a = moveScanner.nextLine();
        makeMove(a);
        c++;

        while (!(a.equals("quit")) && !playerAtGoal())
        //do
        {
            printMaze();
            System.out.println("Next move: ");
            a = moveScanner.nextLine();
            makeMove(a);
            c++;
        } //while((a.equals("quit") == true));
        if (playerAtGoal())
        {
            printMaze();
            System.out.println("It took " + (c - 1) + " moves to win!");
            //System.exit(0);
        }
    }

    
    /**
     * Checks to see if the player has won the game.
     * @return true if the player has won.
     */
    // TODO: public boolean playerAtGoal()
    public boolean playerAtGoal()
    {
        if (userRow == gx && userCol == gy)
        {
            return true;
        }
        return false;
    }

    /**
     * Makes a move based on the String.
     * 
     * @param move
     *            the direction to make a move in.
     * @return whether the move was valid.
     */
    public boolean makeMove(String move)
    {
        String mm = move.toLowerCase();

        if (mm.equals("left") && (userCol > 0) && (userCol <= WIDTH - 1) 
            && (blocked[userRow][userCol - 1] == false))
        {
            breadc[userRow][userCol] = true; userCol = userCol - 1; return true;
        }
        else if (mm.equals("right") && (userCol >= 0) && (userCol < WIDTH - 1) 
            && (blocked[userRow][userCol + 1] == false))
        {
            breadc[userRow][userCol] = true; userCol = userCol + 1; return true;
        }
        else if (mm.equals("up") && (userRow <= HEIGHT - 1) && (userRow > 0) 
            && (blocked[userRow - 1][userCol] == false))
        {
            breadc[userRow][userCol] = true; userRow = userRow - 1; return true;
        }
        else if (mm.equals("down") && (userRow >= 0) && (userRow < HEIGHT - 1) 
            && (blocked[userRow + 1][userCol] == false))
        {
            breadc[userRow][userCol] = true; userRow = userRow + 1; return true;
        }
        else if (mm.equals("quit"))
        {
            return true;
        }
        return false;
    }

    /**
     * Prints the map of the maze.
     */
    public void printMaze()
    {
        System.out.println("*---------------------------------------*");
        for (int i = 0; i < HEIGHT; i++)
        {
            System.out.print("|");
            for (int j = 0; j < WIDTH; j++)
            {
                if (i == userRow && j == userCol)
                {
                    System.out.print("@");
                }
                else if (i == sx && j == sy)
                {
                    System.out.print("S");
                }
                else if (breadc[i][j] == true)
                {
                    System.out.print(".");
                }
                else if (i == gx && j == gy)
                {
                    System.out.print("G");
                }
                else if (blocked[i][j] == true)
                {
                    System.out.print("X");
                }
                else if (blocked[i][j] == false)
                {
                    System.out.print(" ");
                }
            }
            System.out.println("|");
        }
        System.out.println("*---------------------------------------*");
    }

    /**
     * Creates a new game, using a command line argument file name, if one is
     * provided.
     * 
     * @param args the command line arguments
     */

    public static void main(String[] args)
    {
        String mapFile = "data/easy.txt";
        Scanner scan = new Scanner(System.in);
        MazeGame game = new MazeGame(mapFile, scan);
        //game.setUserCol(38);
        //game.setUserRow(9);
        game.playGame();
        //game.getUserRow();
        //game.getUserCol();
    }
}
