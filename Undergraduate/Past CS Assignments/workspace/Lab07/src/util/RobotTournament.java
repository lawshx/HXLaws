package util;

import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Scanner;
import java.util.Comparator;
//CHECKSTYLE.OFF: MethodLength

/**
 * 
 * @author Mitch Parry
 * @version Jun 16, 2015
 *
 */
public class RobotTournament
{
    public static final String PLAYER_FILE = "data/players.txt";
    public static final double NANO_TO_SEC = 1000000000.0;

    private static ArrayList<String> playerNames;
    private static ArrayList<String> playerClassNames;

    /**
     * get the classes for the players.
     * @param list the list of class strings.
     * @return the list of classes.
     */
    private static ArrayList<Class<?>> getClasses(ArrayList<String> list)
    {
        ArrayList<Class<?>> classes = new ArrayList<Class<?>>();
        for (String className : list)
        {
            try
            {
                classes.add(Class.forName(className));
            }
            catch (ClassNotFoundException e)
            {
                throw new RuntimeException("RobotPlayer " + className + " not "
                    + "found.");
            }
        }
        return classes;
    }

    /**
     * Load the players (names and classes).
     * @param playerFile the input file name
     */
    public static void loadPlayers(String playerFile)
    {
        playerNames = new ArrayList<String>();
        playerClassNames = new ArrayList<String>();
        // read players from file
        Scanner scan;
        try
        {
            scan = new Scanner(new FileReader(playerFile));
            scan.useDelimiter("\\s*[,\\n\\r]+\\s*");
        }
        catch (FileNotFoundException e)
        {
            throw new RuntimeException("Player file not found.");
        }
        while (scan.hasNext())
        {
            playerNames.add(scan.next());
            playerClassNames.add(scan.next());
        }
        scan.close();
    }

    /**
     * Main program.
     * @param args not used.
     */
    public static void main(String[] args)
    {
        if (args.length != 3)
        {
            System.out.println("Usage: java RobotTournament <players.txt> "
                + "<num_games> [verbose|quiet]");
        }
        String playerFile = args[0];
        int numGames = Integer.valueOf(args[1]);
        boolean verbose = false;
        if (args.length > 2 && args[2].equals("verbose"))
        {
            verbose = true;
        }
        long t0 = System.nanoTime();
        loadPlayers(playerFile);
        ArrayList<Class<?>> playerClasses = getClasses(playerClassNames);
        int[] wins = new int[playerClasses.size()]; 
        int[] loss = new int[playerClasses.size()]; 
        int[] tie = new int[playerClasses.size()]; 
        int[][] table = new int[playerClasses.size()][4];
        int advance = (int) Math.pow(2.0, 
            Math.floor(
                Math.log((double) playerNames.size() - 1) / Math.log(2.0)
            ));
        // round robin
        final double TIE = 0.5;
        for (int k = 0; k < numGames; k++)
        {
            for (int i = 0; i < playerClasses.size(); i++)
            {
                Class<?> class1 = playerClasses.get(i);
                for (int j = i + 1; j < playerClasses.size(); j++)
                {
                    Class<?> class2 = playerClasses.get(j);
                    Game g = new Game(class1, class2, verbose);
                    int[] score = g.playGame();
                    if (score[0] > score[1])
                    {
                        wins[i]++;
                        loss[j]++;
                    }
                    else if (score[1] > score[0])
                    {
                        wins[j]++;
                        loss[i]++;
                    }
                    else
                    {
                        tie[i]++;
                        tie[j]++;
                    }
                }
            }
            for (int n = 0; n < playerClasses.size(); n++)
            {
                table[n][0] = wins[n];
                table[n][1] = loss[n];
                table[n][2] = tie[n];
                table[n][3] = n;
            }
            // sort table
            Arrays.sort(table, new Comparator<int[]>() {
                @Override
                public int compare(int[] d1, int[] d2) 
                {
                    double t1 = (d1[0] + TIE * d1[2]) / (d1[0] + d1[1] + d1[2]);
                    double t2 = (d2[0] + TIE * d2[2]) / (d2[0] + d2[1] + d2[2]);
                    if (t1 > t2)
                    {
                        return -1;
                    } 
                    else if (t1 < t2)
                    {
                        return 1;
                    }
                    else
                    {
                        return 0;
                    }
                }
            });
            // clear the console
            System.out.print(String.format("\033[2J"));
            System.out.printf("%3s-%3s-%3s\n", "W", "L", "T");
            for (int n = 0; n < playerClasses.size(); n++)
            {
                int w = table[n][0];
                int l = table[n][1];
                int t = table[n][2];
                String p = playerNames.get(table[n][3]);
                System.out.printf("%3d-%3d-%3d (%5.1f%%: %s\n", 
                    w, l, t, 100.0 * (w + TIE * t) / (w + l + t), p);
            }
            long t1 = System.nanoTime();
            System.out.printf("%.1f seconds\n", (t1 - t0) / NANO_TO_SEC);

        }
        // clear the console
        System.out.print(String.format("\033[2J"));
        // write results
        String winnersFile = playerFile + "_winners";
        String formattedWinnersFile = playerFile + "_formatted_winners";
        PrintWriter writer;
        try
        {
            writer = new PrintWriter(winnersFile);
            for (int i = 0; i < advance; i++)
            {
                writer.printf("%s,%s\n", playerNames.get((int) table[i][3]), 
                    playerClassNames.get((int) table[i][3]));
            }
            writer.close();
            writer = new PrintWriter(formattedWinnersFile);
            for (int i = 0; i < playerNames.size(); i++)
            {
                int w = table[i][0];
                int l = table[i][1];
                int t = table[i][2];
                String p = playerNames.get(table[i][3]);
                char a = (i < advance) ? '*' : ' ';
                double f = 100.0 * (w + TIE * t) / (w + l + t);
                writer.printf("%-20s%c: %3d-%3d-%3d (%5.1f%%)%c\n", 
                    p, a, w, l, t, f, a);
                System.out.printf("%-20s%c: %3d-%3d-%3d (%5.1f%%)%c\n", 
                    p, a, w, l, t, f, a);
            }
            if (playerNames.size() == 2)
            {
                writer.println("\t* = WINS !!!");
                System.out.println("\t* = WINS !!!");
            }
            else
            {
                writer.println("\t* = advances to next round.");
                System.out.println("\t* = advances to next round.");
            }
            writer.close();
        }
        catch (FileNotFoundException e)
        {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
    }
}
