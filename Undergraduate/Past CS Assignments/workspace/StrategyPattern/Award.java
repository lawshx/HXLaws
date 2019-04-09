import java.util.ArrayList;
public class Award
{
    private ArrayList<String> summaCumLaude;
    private ArrayList<String> magnaCumLaude;
    private ArrayList<String> cumLaude;
    private DisplayMethod displayMethod;
    
    public Award(ArrayList<String> s, ArrayList<String> m, ArrayList<String> c)
    {
        this.summaCumLaude = s;
        this.magnaCumLaude = m;
        this.cumLaude = c;
    }
    
    public void setDisplayMethod(DisplayMethod d)
    {
        this.displayMethod = d;
    }

    public DisplayMethod getDisplayMethod()
    {
        return displayMethod;
    }

    public ArrayList<String> getSummaCumLaude()
    {
        return summaCumLaude;
    }

    public ArrayList<String> getMagnaCumLaude()
    {
        return magnaCumLaude;
    }

    public ArrayList<String> getCumLaude()
    {
        return cumLaude;
    }
    
}
