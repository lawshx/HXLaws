
public class test
{
    public static void selectionsort(int[] data, int first, int n)
    {
        int i, j;
        int big;
        int temp;
        
        for (i = n-1; i>0; i--)
        {
            big = first;
            for (j = first + 1; j <= first + i; j++)
            {
                if (data[big] < data[j])
                {
                    big = j;
                }
            }
            
            temp = data[first + i];
            data[first + i] = data[big];
            data[big] = temp;
            for (int k = 0; k<data.length; k++)
            {
                System.out.print(data[k] + " ");
            }
            System.out.println();
        }
    }
    
    public static void main(String[] args)
    {
        int[] data = {32, 72, 17, 86, 29, 80, 5, 11, 20, 74, 80, 86};
        
        System.out.println("Original array");
        for (int i = 0; i < data.length; i++)
        {
            System.out.print(data[i] + " ");
        }
        System.out.println();
        
        selectionsort(data, 0, data.length);
    }
}
