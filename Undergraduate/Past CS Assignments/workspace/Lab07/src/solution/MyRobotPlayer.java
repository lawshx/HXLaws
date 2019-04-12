package solution;

import util.Act;
import util.Action;
import util.GameData;
import util.RobotData;
import util.RobotPlayer;
import util.Terrain;
/**
 * 
 * @author Hannah Xiao Si Laws
 * @version 08.10.2017
 *
 */
public class MyRobotPlayer implements RobotPlayer
{
    @Override
    public Action act(RobotData self, GameData game)
    {
        if (Location.getTerrain() == Terrain.SPAWN)
        {
            
        }
        return new Action(Act.GUARD);
    }

}
