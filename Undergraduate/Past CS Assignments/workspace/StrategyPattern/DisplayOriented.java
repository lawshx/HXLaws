import java.util.ArrayList;
public class DisplayOriented implements DisplayMethod
{
    public String display(ArrayList<String> s, 
        ArrayList<String> m, ArrayList<String> c)
    {
        String displayedString = "";
        
        displayedString += "Summa Cum Laude: ";
        for (int i = 0; i < s.size();  i++)
        {
            if (i == s.size() - 1)
            {
                displayedString += s.get(i);
            }
            else
            {
                displayedString += s.get(i) + ", ";
            }
        }
        
        displayedString += "\n";
        
        displayedString += "Magna Cum Laude: ";
        for (int i = 0; i < m.size(); i++)
        {
            if (i == m.size() - 1)
            {
                displayedString += m.get(i);
            }
            else
            {
                displayedString += m.get(i) + ", ";
            }
        }
            displayedString += "\n";

        displayedString += "Cum Laude: ";
        for (int i = 0; i < c.size(); i++)
        {
            if (i == c.size() - 1)
            {
                displayedString += c.get(i);
            }
            else
            {
                displayedString += c.get(i) + ", ";
            }
        }

        return displayedString;
    }
}

