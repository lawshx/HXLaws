package util;
import java.util.Random;

/**
 * Represents a robot in the Robot Game.
 * Based on https://robotgame.net
 *  
 * @author Mitch Parry
 * @version 2015-06-03
 *
 */
public class Robot
{
    protected static int numRobots = 0;
    protected Location location;
    protected int hp;
    protected int playerId;
    protected int robotId;
    protected Action provisionalAction;
    protected Random rand;
    protected RobotPlayer player;
    
    /**
     * Constructs a robot for a given player.
     * @param playerId the player id for the player
     * @param location the robot location
     * @param player the class that defines the robot's behavior.
     * @param rand the shared random number generator
     */
    public Robot(int playerId, Location location, RobotPlayer player, 
        Random rand)
    {
        this.playerId = playerId;
        this.location = location;
        this.rand = rand;
        hp = Game.ROBOT_HP;
        robotId = numRobots;
        this.player = player;
        numRobots++;
    }
    
    /**
     * @return the location.
     */
    public Location getLocation()
    {
        return location;
    }

    /**
     * Changes the location of the robot.
     * @param location the new location
     */
    public void setLocation(Location location)
    {
        this.location = location;
    }
    
    /**
     * @return the robot's player id
     */
    public int getPlayerId()
    {
        return playerId;
    }
    
    /**
     * @return hit points
     */
    public int getHp()
    {
        return hp;
    }
    
    /**
     * @return the string representation for the printing the board.
     */
    public String displayString()
    {
        String left = "";
        String right = "";
        if (hp < Game.ROBOT_HP / 3)
        {
            left = right = " ";
        }
        else if (hp < 2 * Game.ROBOT_HP / 3)
        {
            left = right = "_";
        }
        else
        {
            left = "[";
            right = "]";
        }
        String s;
        if (playerId == 0)
        {
            s = "X";
        }
        else
        {
            s = "O";
        }
        return String.format("%1s%1s%1s", left, s, right);
    }
    
    @Override
    public String toString()
    {
        return "Robot [" + location + "," + hp + ","
            + playerId + "," + robotId + "]";
    }

    /**
     * Stores the robot's provisionalAction.
     * @param game the state of the game
     */
    public void actProvisional(GameData game)
    {
        RobotData rd = 
            game.getRobots()[location.getRow()][location.getColumn()];
        provisionalAction = player.act(rd, game);
    }
    
    /**
     * @return the provisional action.
     */
    public Action getProvisionalAction()
    {
        return provisionalAction;
    }
    
    /**
     * Kill the robot.
     */
    public void kill()
    {
        hp = 0;
    }
    
    /**
     * Set the HP.
     * @param hp the hp
     */
    public void setHp(int hp)
    {
        this.hp = hp;
    }
    
    /**
     * @return the robot's id.
     */
    public int getId()
    {
        return this.robotId;
    }

    /**
     * Gets hit with damage during this turn.
     * @param damage the damage
     */
    public void getHit(int damage)
    {
        hp -= damage;
    }

    /**
     * @return whether or not the robot is alive after this turn.
     */
    public boolean isAlive()
    {
        return hp > 0;
    }
    
    /**
     * @return the desired destination for this robot after the turn.
     */
    public Location dest()
    {
        if (provisionalAction.getAct() == Act.MOVE)
        {
            return provisionalAction.getLocation();
        }
        else
        {
            return location;
        }
    }

}
