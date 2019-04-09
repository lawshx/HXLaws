package util;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.Set;

//CHECKSTYLE.OFF: MethodLength

/**
 * Represents an instance of the Robot Game.
 * https://robotgame.net
 * 
 * @author Mitch Parry
 * @version Jun 3, 2015
 */
public class Game
{
    public static final int MAX_TURNS = 100;
    public static final int SPAWN_PER_PLAYER = 5;
    public static final int BOARD_SIZE = 19;
    public static final int ROBOT_HP = 50;
    public static final int SPAWN_EVERY = 10;
    public static final int ATTACK_MIN = 8;
    public static final int ATTACK_MAX = 10;
    public static final int COLLISION_DAMAGE = 5;
    public static final int SUICIDE_DAMAGE = 15;

    public static final int BOARD_CENTER = 9;
    public static final double CLOSED_RADIUS = 8.5;
    public static final double SPAWN_RADIUS = 7.5;
    public static final int NUM_PLAYERS = 2;

    public static final int BOARD_CENTER_ROW = (BOARD_SIZE - 1) / 2;
    public static final int BOARD_CENTER_COL = (BOARD_SIZE - 1) / 2;


    public static final boolean SYMMETRIC = true;
    
    public static final int MS_PER_FRAME = 700;


    // number of turns passed.
    private int turn;
    private boolean verbose;
    private Location[][] board;

    // a dictionary of all robots on the field mapped by {Location: robot}
    private HashMap<Location, Robot> robots;
    private RobotPlayer[] robotPlayers;
    private String[] playerNames = new String[2];

    private Random rand;
    
    /**
     * Create a new game.
     * @param player1 the class for player 1
     * @param player2 the class for player 2
     * @param verbose whether or not to print the board every turn
     */
    public Game(Class<?> player1, Class<?> player2, boolean verbose)
    {
        this.verbose = verbose;
        robots = new HashMap<Location, Robot>();
        rand = new Random();
        playerNames[0] = player1.toString().substring(6);
        playerNames[1] = player2.toString().substring(6);
        initPlayers(player1, player2);
        createBoard();
    }
    
    /**
     * Create a new game.
     * @param player1 the class for player 1
     * @param player2 the class for player 2
     */
    public Game(Class<?> player1, Class<?> player2)
    {
        this(player1, player2, true);
    }
    /**
     * Create new instances of the robot players.
     * @param player1 the first player's RobotPlayer class
     * @param player2 the second player's RobotPlayer class
     */
    public void initPlayers(Class<?> player1, Class<?> player2)
    {
        robotPlayers = new RobotPlayer[2];
        try
        {
            robotPlayers[0] = 
                (RobotPlayer) player1.getConstructor().newInstance();
            robotPlayers[1] = 
                (RobotPlayer) player2.getConstructor().newInstance();
        }
        catch (Exception e)
        {
            e.printStackTrace();
            throw new RuntimeException("One of the RobotPlayer classes does "
                + "not have a no-args constructor.");
        }
    }
    
    /**
     * Create the terrain for the board.
     */
    private void createBoard()
    {
        board = new Location[BOARD_SIZE][BOARD_SIZE];
        for (int i = 0; i < BOARD_SIZE; i++)
        {
            for (int j = 0; j < BOARD_SIZE; j++)
            {
                double d = Math.sqrt((i - BOARD_CENTER) * (i - BOARD_CENTER) 
                    + (j - BOARD_CENTER) * (j - BOARD_CENTER));
                if (d > CLOSED_RADIUS)
                {
                    board[i][j] = new Location(i, j, Terrain.OBSTACLE);
                }
                else if (d > SPAWN_RADIUS)
                {
                    board[i][j] = new Location(i, j, Terrain.SPAWN);
                }
                else
                {
                    board[i][j] = new Location(i, j, Terrain.NORMAL);
                }
            }
        }
    }

    /**
     * @return the score
     */
    private int[] computeScore()
    {
        int numBots[] = new int[2];
        for (Robot r : robots.values())
        {
            numBots[r.getPlayerId()]++;
        }
        return numBots;
    }
    
    /**
     * print the game result.
     */
    private void printWinner()
    {
        int[] numBots = computeScore();
        if (numBots[0] > numBots[1])
        {
            System.out.println(playerNames[0] + " wins " + numBots[0] 
                + " to " + numBots[1]);
        }
        else if (numBots[1] > numBots[0])
        {
            System.out.println(playerNames[1] + " wins " + numBots[1] 
                + " to " + numBots[0]);
        }
        else
        {
            System.out.println("It's a tie with " + numBots[0] + " each.");
        }
    }
    
    /**
     * Print the score.
     */
    private void printScore()
    {
        int[] numBots = computeScore();
        for (int i = 0; i < NUM_PLAYERS; i++)
        {
            System.out.printf("%-20s: %d\n", playerNames[i], numBots[i]);
        }
    }
    
    /**
     * Play the game.
     * @return the score
     */
    public int[] playGame()
    {
        if (verbose)
        {
            System.out.println(this);
            try
            {
                Thread.sleep(MS_PER_FRAME);
            }
            catch (InterruptedException e)
            {
                // TODO Auto-generated catch block
                e.printStackTrace();
            }
        }
        turn = 0;
        while (turn < MAX_TURNS)
        {
            takeTurn(true);
            if (verbose)
            {
                System.out.println(this);
                printScore();
                try
                {
                    Thread.sleep(MS_PER_FRAME);
                }
                catch (InterruptedException e)
                {
                    // TODO Auto-generated catch block
                    e.printStackTrace();
                }
            }
        }
        if (verbose)
        {
            printWinner();
        }
        return computeScore();
    }

    /**
     * Take one turn.
     * @param spawn whether or not to consider spawning
     */
    public void takeTurn(boolean spawn)
    {
        queryProvisionalActions();
        HashMap<Location, Set<Robot>> contenders = getContenders();
        moveRobots(contenders);
        applyCollisions(contenders);
        applyDamage();

        if (spawn && turn % SPAWN_EVERY == 0)
        {
            applySpawn();            
        }
        removeTheDead();
        
        // record history?
        turn++;
    }


    /**
     * Remove dead robots from the board.
     */
    private void removeTheDead()
    {
        Iterator<Map.Entry<Location, Robot>> it = robots.entrySet().iterator();
        while (it.hasNext())
        {
            Map.Entry<Location, Robot> entry = it.next();
            Robot r = entry.getValue();
            if (!r.isAlive())
            {
                it.remove();
            }
        }
    }
    

    /**
     * Set the robot map.
     * @param robotList the list of robots to place
     */
    public void setRobots(List<Robot> robotList)
    {
        robots = new HashMap<Location, Robot>();
        for (Robot r : robotList)
        {
            robots.put(r.getLocation(), r);
        }
    }

    /**
     * collisions = {loc: set(robots collided with robot at loc)}.
     * @param contenders the dictionary of contenders
     * @return the collisions
     */
    private HashMap<Robot, Set<Robot>> 
        applyCollisions(HashMap<Location, Set<Robot>> contenders)
    {
        HashMap<Robot, Set<Robot>> collisions = 
            new HashMap<Robot, Set<Robot>>();
        for (Robot bot1 : robots.values())
        {
            for (Robot bot2 : contenders.get(bot1.dest()))
            {
                if (bot1.getPlayerId() != bot2.getPlayerId())
                {
                    if (bot1.getProvisionalAction().getAct() != Act.GUARD)
                    {
                        bot1.getHit(COLLISION_DAMAGE);
                    }
                    if (bot2.getProvisionalAction().getAct() != Act.GUARD)
                    {
                        bot2.getHit(COLLISION_DAMAGE);
                    }
                }
            }
        }
        return collisions;
    }

    /**
     * Get the damage map.
     * 
     * damage_map = {loc: [actor_id: (actor_loc, damage)]}
     * only counts potential attack and suicide damage
     * self suicide damage is not counted
     * 
     */
    private void applyDamage()
    {
        GameData gd = getGameData(0);
        for (Map.Entry<Location, Robot> pair : robots.entrySet())
        {
            Location loc = pair.getKey();
            Robot robot = pair.getValue();
            int actorId = robot.getPlayerId();
            Action a = robot.getProvisionalAction();
            if (a.getAct() == Act.ATTACK)
            {
                int damage = ATTACK_MIN + rand.nextInt(ATTACK_MAX - ATTACK_MIN);
                Location target = a.getLocation();
                if (robots.containsKey(target))
                {
                    Robot victim = robots.get(target);
                    int victimId = victim.getPlayerId();
                    if (actorId != victimId)
                    {
                        if (victim.getProvisionalAction().getAct() == Act.GUARD)
                        {
                            damage /= 2;
                        }
                        victim.getHit(damage);                    
                    }
                }
            }
            else if (a.getAct() == Act.SUICIDE)
            {
                for (Location target 
                    : gd.locsAround(loc, GameData.VALID_TERRAIN))
                {
                    int damage = SUICIDE_DAMAGE;
                    if (robots.containsKey(target))
                    {
                        Robot victim = robots.get(target);
                        int victimId = victim.getPlayerId();
                        if (actorId != victimId)
                        {
                            if (victim.getProvisionalAction().getAct() 
                                == Act.GUARD)
                            {
                                damage /= 2;
                            }
                            victim.getHit(damage);                    
                        }
                    }
                }
                robot.kill();
            }
        }
    }

    /**
     * Gets the mapping from old to new locations.
     * @param contenders the dictionary of contenders at locations
     */
    private void moveRobots(HashMap<Location, Set<Robot>> contenders)
    {
        HashMap<Location, Robot> newRobots = new HashMap<Location, Robot>();
        for (Location loc : robots.keySet())
        {
            Robot robot = robots.get(loc);
            if (!loc.equals(robot.dest()) 
                && contenders.getOrDefault(loc, 
                    new HashSet<Robot>()).contains(robot))
            {
                robot.setLocation(loc);
                newRobots.put(loc, robot);
            }
            else
            {
                Location dest = robot.dest();
                robot.setLocation(dest);
                newRobots.put(dest, robot);
            }
        }
        robots = newRobots;
    }

    /**
     * Validates the action.
     * @param r the robot
     * @param a the action
     */
    public void validateAction(Robot r, Action a)
    {
        GameData gd = getGameData(0);
        if (a.getAct() == Act.MOVE || a.getAct() == Act.ATTACK)
        {
            // make sure location is on the map and can be occupied.
            ArrayList<Location> validLocations = 
                gd.locsAround(r.getLocation(), GameData.VALID_TERRAIN);
            if (!validLocations.contains(a.getLocation()))
            {
                throw new IllegalArgumentException(
                    "Bot " + r + ": " + a + " is not a valid action.");
            }
        }
    }

    /**
     * Ask robots to make provisional actions.
     */
    private void queryProvisionalActions()
    {
        GameData[] gd = new GameData[NUM_PLAYERS];
        for (int playerId = 0; playerId < NUM_PLAYERS; playerId++)
        {
            gd[playerId] = new GameData(turn, robots, board, rand, playerId);
        }

        for (Map.Entry<Location, Robot> pair : robots.entrySet())
        {
            Robot r = pair.getValue();
            int playerId = r.getPlayerId();
            r.actProvisional(gd[playerId]);
            validateAction(r, r.getProvisionalAction());
        }
    }

    /**
     * Robot at loc is stuck.
     * Other robots trying to move in its old locations
     * should be marked as stuck, too
     * @param loc the location
     * @param contenders the contenders for each location
     */
    private void stuck(Location loc, 
        HashMap<Location, Set<Robot>> contenders)
    {
        Set<Robot> oldContenders = contenders.getOrDefault(loc, 
            new HashSet<Robot>());
        HashSet<Robot> set = new HashSet<Robot>(1);
        set.add(robots.get(loc));
        contenders.put(loc, set);

        for (Robot robot : oldContenders)
        {
            Location contender = robot.getLocation(); 
            if (!contender.equals(loc))
            {
                stuck(contender, contenders);
            }
        }
    }

    /**
     *  Generates a dict of locations, where the values correspond to the
     *  set of bots that wish to move into that square or will be moving
     *  into that square. This is because due to collisions a bot can
     *  'use up' two squares:
     *  1. the first is blocked because he attempted to move into it
     *  2. the second is blocked because that is his current location
     *     where he will be staying due to the collision at 1
     *     
     *  @return dict[destination] = set(locations of bots that either
     *                                  want to move to 'destination' or
     *                                  are moving to 'destination'
     *                                  because of collisions)
     */
    private HashMap<Location, Set<Robot>> getContenders()
    {
        HashMap<Location, Set<Robot>> contenders = 
            new HashMap<Location, Set<Robot>>();

        for (Robot robot : robots.values())
        {
            Location dest = robot.dest();
            Set<Robot> set = 
                contenders.getOrDefault(dest, new HashSet<Robot>());
            set.add(robot);
            contenders.put(dest, set);
        }
        for (Robot robot : robots.values())
        {
            Location loc = robot.getLocation();
            Location dest = robot.dest();
            Robot drobot = robots.get(dest);
            if (contenders.get(dest).size() > 1 
                || (drobot != null && !dest.equals(loc) 
                && drobot.dest().equals(loc)))
            {
                stuck(loc, contenders);
            }
        }
        return contenders;
    }

    /**
     * @return a list of spawn locations.
     */
    private ArrayList<Location> getSpawnLocations()
    {
        ArrayList<Location> spawnLocations = new ArrayList<Location>();
        for (int i = 0; i < BOARD_SIZE; i++)
        {
            for (int j = 0; j < BOARD_SIZE; j++)
            {
                Location loc = board[i][j];
                if (loc.getTerrain() == Terrain.SPAWN)
                {
                    spawnLocations.add(loc);
                }
            }
        }
        return spawnLocations;
    }

    /**
     * Get the location opposite this one.
     * @param loc the location
     * @return the location opposite
     */
    private Location symmetricLoc(Location loc)
    {
        int i = BOARD_SIZE - 1 - loc.getRow();
        int j = BOARD_SIZE - 1 - loc.getColumn();
        return board[i][j];
    }

    /**
     * Spawns new robots.
     */
    private void applySpawn()
    {
        // kill robots on spawn point
        for (Robot r : robots.values())
        {
            Location loc = r.getLocation();
            if (loc.getTerrain() == Terrain.SPAWN)
            {
                r.kill();
            }
        }

        // randomly spawn robots on spawn sites in a symmetric way.
        // shallow copy
        ArrayList<Location> locations = getSpawnLocations();
        if (SYMMETRIC)
        {
            for (int i = 0; i < SPAWN_PER_PLAYER; i++)
            {
                Location loc = 
                    locations.get(rand.nextInt(locations.size()));
                for (int playerId = 0; playerId < NUM_PLAYERS; playerId++)
                {
                    locations.remove(loc);
                    Robot r = new Robot(playerId, loc, robotPlayers[playerId], 
                        rand);
                    robots.put(loc, r);
                    loc = symmetricLoc(loc);
                }
            }
        }
        else
        {
            for (int playerId = 0; playerId < NUM_PLAYERS; playerId++)
            {
                for (int i = 0; i < SPAWN_PER_PLAYER; i++)
                {
                    Location loc = 
                        locations.remove(rand.nextInt(locations.size()));
                    Robot r = new Robot(playerId, loc, robotPlayers[playerId], 
                        rand);
                    robots.put(loc, r);
                }
            }
        }
    }

    /**
     * @return a shallow copy of the robots list.
     */
    public ArrayList<Robot> getRobots()
    {
        return new ArrayList<Robot>(robots.values());
    }

    @Override
    public String toString()
    {
        String s = "";
        for (int i = 0; i < BOARD_SIZE; i++)
        {
            for (int j = 0; j < BOARD_SIZE; j++)
            {
                if (robots.get(board[i][j]) != null)
                {
                    s += robots.get(board[i][j]).displayString();
                }
                else
                {
                    switch (board[i][j].getTerrain())
                    {
                        case OBSTACLE:
                            s += " . ";
                            break;
                        case SPAWN:
                            s += " s ";
                            break;
                        default:
                            s += "   ";
                    }
                }
            }
            s += "\n";
        }
        return s;
    }


    /**
     * @return the board.
     */
    public Location[][] getBoard()
    {
        return board;
    }
    
    /**
     * Get the game data.
     * @param playerId the player id the data is for.
     * @return the game data for this turn.
     */
    public GameData getGameData(int playerId)
    {
        return new GameData(turn, robots, board, rand, playerId);
    }

    /**
     * @return the random number generator.
     */
    public Random getRandom()
    {
        return rand;
    }

    /**
     * Main method to play the game.
     * @param args not used.
     */
    public static void main(String[] args)
    {
        Class<?> class1;
        Class<?> class2;
        try
        {
            class1 = Class.forName(args[0]);
        }
        catch (ClassNotFoundException e)
        {
            System.out.println("RobotPlayer " + args[0] + " not found.");
            return;
        } 
        try
        {
            class2 = Class.forName(args[1]);
        }
        catch (ClassNotFoundException e)
        {
            System.out.println("RobotPlayer " + args[1] + " not found.");
            return;
        } 
        
        Game g = new Game(class1, class2);
        g.playGame();
    }
}
