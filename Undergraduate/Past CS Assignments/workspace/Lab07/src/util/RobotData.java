package util;
/**
 * Data for each robot passed to a robot's act method.
 * @author Mitch Parry
 * @version Jun 5, 2015
 *
 */
public class RobotData
{
    private Location location;
    private int hp;
    private int playerId;
    private int robotId;
    
    /**
     * Constructs the robot data.
     * @param location the robot's location
     * @param hp the robot's hit points
     * @param playerId the robot's player
     * @param whoseData the player who will use these data
     * @param robotId the robot's id
     */
    public RobotData(Location location, int hp, int playerId, int whoseData, 
        int robotId)
    {
        this.location = location;
        this.hp = hp;
        this.playerId = playerId;
        if (playerId == whoseData)
        {
            this.robotId = robotId;
        }
        else
        {
            this.robotId = -1;
        }
    }

    /**
     * @return location
     */
    public Location getLocation()
    {
        return location;
    }

    /**
     * @return hit points
     */
    public int getHp()
    {
        return hp;
    }

    /**
     * @return player id
     */
    public int getPlayerId()
    {
        return playerId;
    }

    /**
     * @return robot id
     */
    public int getRobotId()
    {
        return robotId;
    }
}
