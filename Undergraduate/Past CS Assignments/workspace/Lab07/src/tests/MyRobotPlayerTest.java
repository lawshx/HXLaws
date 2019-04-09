package tests;

import static org.junit.Assert.assertNull;

import java.util.ArrayList;
import java.util.Random;

import org.junit.Test;

import util.Game;
import util.GameData;
import util.Location;
import util.Robot;
import util.Terrain;
import solution.MyRobotPlayer;

/**
 * 
 * @author Mitch Parry
 * @version Jun 24, 2015
 *
 */
public class MyRobotPlayerTest
{
    /**
     * Return the excpetion message if there is one, otherwise null if not.
     * @param g the game
     * @param spawn whether or not to consider spawning
     * @return the exception message if there is one
     */
    private String message(Game g, boolean spawn)
    {
        String exceptionMessage = null;
        try 
        {
            g.takeTurn(spawn);
        }
        catch (Exception e)
        {
            exceptionMessage = e.getMessage();
        }
        return exceptionMessage;
    }

    /**
     * Check the location for all combinations of neighbors.
     * @param loc the current location
     * @param g the game
     */
    private void checkLocation(Location loc, Game g)
    {
        Random r = g.getRandom();
        for (int pid = 0; pid < 2; pid++)
        {
            // neighborhood
            ArrayList<Location> nh = g.getGameData(pid).
                locsAround(loc, GameData.VALID_TERRAIN);

            // Friend, Enemy, Empty
            for (int j = 0; j < Math.pow(3, nh.size()); j++)
            {
                ArrayList<Robot> list = new ArrayList<Robot>();
                list.add(new Robot(pid, loc, new MyRobotPlayer(), r));
                int b = j;
                for (int k = 0; k < nh.size(); k++)
                {
                    if (b % 3 > 0)
                    {
                        list.add(new Robot(b % 3 == 1 ? pid : 1 - pid,
                            nh.get(k), new GuardBot(), r));
                    }
                    b /= 3;
                }
                g.setRobots(list);
                // this should throw an exception for bad moves.
                assertNull(message(g, false), message(g, false));
            }
        }        
    }
    
    /**
     * Test for valid actions.
     */
    @Test
    public void test()
    {
        Game g = new Game(GuardBot.class, GuardBot.class);
        for (Location[] row : g.getBoard())
        {
            for (Location loc : row)
            {
                Terrain t = loc.getTerrain();
                if (t == Terrain.NORMAL || t == Terrain.SPAWN)
                {
                    checkLocation(loc, g);
                }
            }
        }
    }
}
