package util;
/**
 * Represents the different types of terrain.
 * 
 * INVALID: out of bounds
 * NORMAL: on the grid and not an obstacle or spawn point
 * SPAWN: spawn point on the grid
 * OBSTACLE: obstacle on the grid
 * 
 * @author Mitch Parry
 * @version Jun 3, 2015
 *
 */
public enum Terrain
{
    INVALID, NORMAL, SPAWN, OBSTACLE
};
