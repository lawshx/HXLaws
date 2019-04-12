package tests;
import util.Act;
import util.Action;
import util.GameData;
import util.RobotData;
import util.RobotPlayer;

/**
 * This robot implements specific behavior. 
 * @author Mitch Parry
 * @version Jun 3, 2015
 *
 */
public class GuardBot implements RobotPlayer
{
    @Override
    public Action act(RobotData self, GameData game)
    {
        return new Action(Act.GUARD);
    }
}
