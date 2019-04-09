package util;

/**
 * 
 * @author Mitch Parry
 * @version Jun 12, 2015
 *
 */
public interface RobotPlayer
{
    /**
     * Decide what to do based on the state of the game.
     * @param robot the robot taking the action.
     * @param game the state of the game.
     * @return the action
     */
    public abstract Action act(RobotData robot, GameData game);
}
