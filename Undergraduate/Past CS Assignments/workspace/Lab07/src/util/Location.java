package util;
/**
 * Represents the location of a robot in Robot Game.
 * https://robotgame.net
 * 
 * @author Mitch Parry
 * @version Jun 3, 2015
 *
 */
public class Location
{
    private int row;
    private int column;
    private Terrain terrain;
    
    /**
     * Constructs a location.
     * @param r the row
     * @param c the column
     * @param t the terrain
     */
    public Location(int r, int c, Terrain t)
    {
        row = r;
        column = c;
        terrain = t;
    }
    
    /**
     * Copy constructor.
     * @param loc the location to copy
     */
    public Location(Location loc)
    {
        row = loc.row;
        column = loc.column;
        terrain = loc.terrain;
    }
    
    @Override
    public String toString()
    {
        return "[" + row + "," + column + "," + terrain + "]";
    }

    /**
     * @return the row
     */
    public int getRow()
    {
        return row;
    }
    
    /**
     * @return the column
     */
    public int getColumn()
    {
        return column;
    }
    
    /**
     * @return the terrain
     */
    public Terrain getTerrain()
    {
        return terrain;
    }
    
    /**
     * Set the terrain.
     * @param t the new terrain
     */
    public void setTerrain(Terrain t)
    {
        terrain = t;
    }
    
    /**
     * Returns the straight-line distance between 'a' and 'b'.
     * @param a one location
     * @param b the other location
     * @return the distance between them
     */
    public static double dist(Location a, Location b)
    {
        return Math.sqrt(
            (a.row - b.row) * (a.row - b.row) 
            + (a.column - b.column) * (a.column - b.column)
        );
    }

    /**
     * Returns the walking distance (city-block) betteen two locations, since 
     * robots can't move diagonally.
     * @param a one location
     * @param b the other location
     * @return the walking distance between them
     */
    public static int wdist(Location a, Location b)
    {
        return Math.abs(a.row - b.row) + Math.abs(a.column - b.column);
    }

    @Override
    public int hashCode()
    {
        final int PRIME = 31;
        int result = 1;
        result = PRIME * result + column;
        result = PRIME * result + row;
        return result;
    }

    @Override
    public boolean equals(Object obj)
    {
        if (this == obj)
        {
            return true;
        }
        if (obj == null)
        {
            return false;
        }
        if (getClass() != obj.getClass())
        {
            return false;
        }
        Location other = (Location) obj;
        if (column != other.column)
        {
            return false;
        }
        if (row != other.row)
        {
            return false;
        }
        return true;
    }
}
