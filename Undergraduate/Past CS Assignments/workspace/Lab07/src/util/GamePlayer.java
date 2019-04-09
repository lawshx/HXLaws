package util;

import solution.MyRobotPlayer;

/**
 * 
 * @author Mitch Parry
 * @version Jun 25, 2015
 *
 */
public class GamePlayer
{
    /**
     * Play one game.
     * @param args not used
     */
    public static void main(String[] args)
    {
        Game game = new Game(MyRobotPlayer.class, MyRobotPlayer.class);
        game.playGame();
    }
}
