using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SoloLearnTaughtMeThis
{
    class StartingOut
    {
        public double mathmagic(double x, double y)
        {
            return (x + y) * x;
        }
        static void Main(string[] args)
        {
            Console.WriteLine("Let's do an experiment, write down a sentence.");
            string resp = Console.ReadLine();
            Console.WriteLine(resp);
            Console.WriteLine("Now give me two numbers");
            double x = Convert.ToDouble(Console.ReadLine());
            double y = Convert.ToDouble(Console.ReadLine());
            StartingOut p = new StartingOut();
            Console.WriteLine("Here's what happens when we use mathmagic: " + p.mathmagic(x, y));
            //If I don't do this command, I won't be able to see the last printed statement.
            Console.ReadKey(true);

        }
    }    
}