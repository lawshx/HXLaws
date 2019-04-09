import java.util.ArrayList;
public class DisplayTabular implements DisplayMethod
{
    public String display(ArrayList<String> s, ArrayList<String> m, ArrayList<String> c)
    {
        String ds = "";

        ds += "+--------------------+--------------------+--------------------+\n";
        ds += "| Summa Cum Laude    | Magna Cum Laude    | Cum Laude          |\n";
        ds += "+--------------------+--------------------+--------------------+\n";
        
        int sSize = s.size();
        int mSize = m.size();
        int cSize = c.size();
        int maxSize = sSize;
        if (maxSize < mSize)
        {
            maxSize = mSize;
        }
        if (maxSize < cSize)
        {
            maxSize = cSize;
        }

        for (int i = 0; i < maxSize; i++)
        {
            //Summa Cum Laude
            if (s.size() > i)
            {
                ds += "| " + s.get(i);
                for (int x = s.get(i).length() + 1; x < 20; x++)
                {
                    ds += " ";
                }
            }
            else
            {
                ds += "|                    ";
            }
            //Magna Cum Laude
            if (m.size() > i)
            {
                ds += "| " + m.get(i);
                for (int y = m.get(i).length() + 1; y < 20; y++)
                {
                    ds += " ";
                }
            }
            else
            {  
                ds += "|                    ";
            }
            //Cum Laude
            if (c.size() > i)
            {
                ds += "| " + c.get(i);
                for (int z = c.get(i).length() + 1; z < 20; z++)
                {
                    ds += " ";
                }
            }
            else
            {
                ds += "|                    ";
            }
            ds += "|\n";
        }
        ds += "+--------------------+--------------------+--------------------+";
        
        return ds;
    }
}

