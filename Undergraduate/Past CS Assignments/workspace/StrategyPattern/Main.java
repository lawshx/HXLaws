import java.util.ArrayList;
public class Main
{
    public static void main(String[] args)
    {
        ArrayList<String> ss = new ArrayList<String>();
        ArrayList<String> mm = new ArrayList<String>();
        ArrayList<String> cc = new ArrayList<String>();
        ss.add("Adam Smith");
        ss.add("Sue Jones");
        ss.add("Bruce Wayne");
        ss.add("Clark Kent");
        mm.add("Jane Doe");
        mm.add("Jewel Pearl");
        mm.add("Peter Parker");
        cc.add("Harold Harmon");
        cc.add("Bill Crouch");
        cc.add("Jim Jam");
        cc.add("Zack Attack");
        cc.add("Aaron Rodgers");
        Award a = new Award(ss, mm, cc);

        DisplayMethod t = new DisplayTabular();
        DisplayMethod o = new DisplayOriented();

        a.setDisplayMethod(t);
        String s = a.getDisplayMethod().display(a.getSummaCumLaude(), a.getMagnaCumLaude(), a.getCumLaude());
        System.out.println("****Tabular Display****");
        System.out.println(s);

        a.setDisplayMethod(o);
        s = a.getDisplayMethod().display(a.getSummaCumLaude(), a.getMagnaCumLaude(), a.getCumLaude());
        System.out.println("****Oriented Display****");
        System.out.println(s);
    }
}

