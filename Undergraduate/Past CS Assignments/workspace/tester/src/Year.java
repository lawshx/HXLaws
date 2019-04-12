public class Year
{
       public enum Month
       {
           JAN, FEB, MAR, APRIL, MAY, JUN, JUL, AUG, SEPT, OCT, NOV, DEC
       }
       
       private static Month[] monthArray = Month.values();
       
       public static void main(String[] args)
       {
           if (monthArray[3].equals(APRIL))
           {
               System.out.println("yes");
           }
           else
           {
               System.out.println("no");
           }
           System.exit(0);
           
           
       }
    
}