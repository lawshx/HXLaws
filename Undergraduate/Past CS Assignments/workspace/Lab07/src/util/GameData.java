package util;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

/**
 * Stores the game data for a player.
 * @author Mitch Parry
 * @version Jun 5, 2015
 *
 */
public class GameData
{
    public static final Terrain[] VALID_TERRAIN = 
    {
        Terrain.NORMAL, Terrain.SPAWN
    };
    private final int turn;
    private final RobotData[][] robots;
    private final Location[][] board;
    private final Random rand;

    /**
     * Constructs the game data.
     * @param turn the current turn of the game
     * @param robotMap the map of robots
     * @param board the locations on the board
     * @param rand the random number generator
     * @param playerId the player with which these data will be shared
     */
    public GameData(int turn, HashMap<Location, Robot> robotMap, 
        Location[][] board, Random rand, int playerId)
    {
        this.turn = turn;
        this.rand = rand;
        robots = new RobotData[Game.BOARD_SIZE][Game.BOARD_SIZE];
        for (Map.Entry<Location, Robot> pair : robotMap.entrySet())
        {
            Robot robot = pair.getValue();
            Location loc = pair.getKey();
            RobotData rd = new RobotData(loc, robot.getHp(), 
                robot.getPlayerId(), playerId, robot.getId());
            robots[loc.getRow()][loc.getColumn()] = rd;
        }
        this.board = new Location[Game.BOARD_SIZE][Game.BOARD_SIZE];
        for (int i = 0; i < Game.BOARD_SIZE; i++)
        {
            for (int j = 0; j < Game.BOARD_SIZE; j++)
            {
                this.board[i][j] = new Location(board[i][j]);
            }
        }
    }

    /**
     * @return the turn.
     */
    public int getTurn()
    {
        return turn;
    }

    /**
     * @return the robot grid.
     */
    public RobotData[][] getRobots()
    {
        return robots;
    }

    /**
     * @return the random number generator.
     */
    public Random getRandom()
    {
        return rand;
    }

    /**
     * Get the adjacent location that is one step closer to the destination.
     * @param a the current location
     * @param b the destination location
     * @return a location one step toward the destination
     */
    public Location toward(Location a, Location b)
    {
        if (a.equals(b))
        {
            return a;
        }

        int rDiff = b.getRow() - a.getRow();
        int cDiff = b.getColumn() - a.getColumn();

        Location rMove = 
            board[a.getRow() + (int) Math.signum(rDiff)][a.getColumn()];
        Location cMove = 
            board[a.getRow()][a.getColumn() + (int) Math.signum(cDiff)];


        if (Math.abs(rDiff) > Math.abs(cDiff))
        {
            if (rMove.getTerrain() != Terrain.OBSTACLE)
            {
                return rMove;
            }
            return cMove;
        }
        else
        {
            if (cMove.getTerrain() != Terrain.OBSTACLE)
            {
                return cMove;
            }
            return rMove;
        }
    }


    /**
     * Get neighboring locations that are on the grid and have the provided 
     * terrain type. 
     * @param loc the current locations
     * @param terrain the terrain type to include
     * @return a list of neighboring locations with the specified terrain
     */
    public ArrayList<Location> locsAround(Location loc, Terrain terrain)
    {
        ArrayList<Location> locations = new ArrayList<Location>(4);
        if (loc != null)
        {
            int i = loc.getRow();
            int j = loc.getColumn();
            int[] ii = {i - 1, i, i + 1, i};
            int[] jj = {j, j + 1, j, j - 1};
            for (int k = 0; k < ii.length; k++)
            {
                Location newLoc = board[ii[k]][jj[k]];
                if (newLoc != null && newLoc.getTerrain() == terrain)
                {
                    locations.add(newLoc);
                }
            }
        }
        return locations;
    }

    /**
     * Get neighboring locations that have any of the list of terrain types.
     * @param loc the current location
     * @param terrains the terrains to include
     * @return a list of neighboring locations with without the 
     * specified terrains 
     */
    public ArrayList<Location> locsAround(Location loc, Terrain[] terrains)
    {
        ArrayList<Location> locations = new ArrayList<Location>(4);
        for (Terrain t : terrains)
        {
            locations.addAll(locsAround(loc, t));
        }
        return locations;
    }

    /**
     * @return the center location.
     */
    public Location centerLocation()
    {
        return board[Game.BOARD_CENTER][Game.BOARD_CENTER];
    }
}
