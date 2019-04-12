using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

public class Animal
{
    public string name;
    public int age { get; set; }
    public string species;
    public int legs { get; set; }
    
    
    public virtual void Happy(){
        Console.WriteLine("I'm happy!");
    }
}

public class Dog : Animal {
    public Dog(){
        name = "new guest";
        legs = 4;
    }

    public Dog(string name){
        this.name = name;
    }

    public Dog(int legs,int age,string name)
    {
        this.legs = legs;
        this.age = age;
        this.name = name;
    }

    public override void Happy()
    {
        Console.WriteLine("Wags Tail");
    }
}

public class MainStage
{
    static void Main(string[] args){
        Console.WriteLine("Welcome to the Pet Shop! Would you like to sign up with us today?");
        response = Console.ReadLine();

        if (response.ToLower.StartsWith("y")){
            Console.WriteLine("Alright! Let's start by entering the name of your pet and what animal s/he is:");
            Console.WriteLine("Please tell us the name of your pet:");
            nameof = Console.ReadLine();
            Console.WriteLine("What kind of animal is s/he?");
            an = Console.ReadLine();
            if(an.ToLower() == "dog"){
                Dog client = new Dog(name);
            }
        }
    }
}
