package util;
/**
 * Represents the actions that can be taken by a robot.
 * Based on https://robotgame.net
 * ['move', (x, y)]
 * ['attack', (x, y)]
 * ['guard']
 * ['suicide']
 * 
 * @author Mitch Parry
 * @version 2015-06-03
 *
 */
public class Action
{
    private Location location;
    private Act act;

    /**
     * Create an action without a location.
     * @param a the act
     */
    public Action(Act a)
    {
        // to move or attack a location is needed.
        if (a == Act.MOVE || a == Act.ATTACK)
        {
            throw new IllegalArgumentException(
                "Action " + a + " must include a location."
            );
        }
        act = a;
        location = null;
    }
    
    /**
     * Create an action with a location.
     * @param a the act
     * @param loc the location
     */
    public Action(Act a, Location loc)
    {
        // guard and suicide cannot take a location.
        if ((a == Act.GUARD || a == Act.SUICIDE) && loc != null)
        {
            throw new IllegalArgumentException(
                "Action " + a + " must not include a location."
            );
        }
        if ((a == Act.MOVE || a == Act.ATTACK) && loc == null)
        {
            throw new IllegalArgumentException(
                "Action " + a + " must include a location."
            );
        }
        act = a;
        location = loc;
    }
    
    /**
     * @return the act.
     */
    public Act getAct()
    {
        return act;
    }
    
    /**
     * @return the location
     */
    public Location getLocation()
    {
        return location;
    }

    @Override
    public String toString()
    {
        return "[" + location + "," + act + "]";
    }

}
