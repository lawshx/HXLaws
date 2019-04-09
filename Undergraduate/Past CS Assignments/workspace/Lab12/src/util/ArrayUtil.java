package util;
import java.util.Random;

/**
   This class contains utility methods for array manipulation.
   
   @author Unknown
   @version 00/00/00
*/  
public class ArrayUtil
{  
   /**
      Creates an array filled with random values.
      @param length the length of the array
      @param n the number of possible random values
      @return an array filled with length numbers between
      1 and n
   */
    public static int[] randomIntArray(int length, int n)
    {  
        int[] a = new int[length];
        Random generator = new Random();
      
        for (int i = 0; i < a.length; i++)
        {
            a[i] = generator.nextInt(n) + 1;
        }
      
        return a;
    }
}
      
