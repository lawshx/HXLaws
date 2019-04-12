package tests;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Arrays;

/**
 * Helper methods for all the tests.
 * 
 * @author Mitch Parry
 * @version 2013-09-17
 * 
 */
public class MyTesting
{
    /**
     * Get the parameter types for this array in a String.
     * 
     * @param method
     *            The method.
     * @return The string of parameter types.
     */
    public static String getParameterTypes(Method method)
    {
        Class<?>[] pClasses = method.getParameterTypes();
        String[] pStrings = new String[pClasses.length];
        for (int i = 0; i < pClasses.length; i++)
        {
            pStrings[i] = pClasses[i].getName();
        }
        String pTypes = Arrays.toString(pStrings);
        return pTypes;
    }

    /**
     * Get the parameter types for this constructor in a String.
     * 
     * @param constructor
     *            The constructor.
     * @return The string of parameter types.
     */
    public static String getParameterTypes(Constructor<?> constructor)
    {
        Class<?>[] pClasses = constructor.getParameterTypes();
        String[] pStrings = new String[pClasses.length];
        for (int i = 0; i < pClasses.length; i++)
        {
            pStrings[i] = pClasses[i].getName();
        }
        String pTypes = Arrays.toString(pStrings);
        return pTypes;
    }

    /**
     * Converts a method into a string (somewhat like a signature).
     * 
     * @param method
     *            The method
     * @return The string representation
     */
    public static String methodAsString(Method method)
    {
        String name = method.getName();
        String mod =
                Modifier.toString(method.getModifiers());
        String ret =
                method.getReturnType().toString();
        String pTypes =
                MyTesting.getParameterTypes(method);
        return mod + ";" + ret + ";" + name + ";" + pTypes;
    }

    /**
     * Converts a constructor into a string (somewhat like a signature).
     * 
     * @param constructor
     *            The constructor
     * @return The string representation
     */
    public static String constructorAsString(Constructor<?> constructor)
    {
        String name = constructor.getName();
        String mod =
                Modifier.toString(constructor.getModifiers());
        String pTypes =
                MyTesting.getParameterTypes(constructor);
        return mod + ";" + name + ";" + pTypes;
    }

    /**
     * Converts a field into a string (like a declaration).
     * 
     * @param field
     *            The field
     * @return The string representation
     */
    public static String fieldAsString(Field field)
    {
        String name = field.getName();
        String mod =
                Modifier.toString(field.getModifiers());
        String type = field.getType().getName();
        return mod + ";" + type + ";" + name;
    }

    /**
     * Converts an array of methods into an array of their string
     * representations.
     * 
     * @param methods
     *            The array of methods
     * @return The array of string representations of methods.
     */
    public static String[] methodsAsStrings(Method[] methods)
    {
        String[] methodStrings = new String[methods.length];
        for (int i = 0; i < methods.length; i++)
        {
            methodStrings[i] = methodAsString(methods[i]);
        }
        return methodStrings;
    }

    /**
     * Converts an array of constructors into an array of their string
     * representations.
     * 
     * @param constructors
     *            The array of constructors
     * @return The array of string representations of constructors.
     */
    public static String[] constructorsAsStrings(Constructor<?>[] constructors)
    {
        String[] constructorStrings = new String[constructors.length];
        for (int i = 0; i < constructors.length; i++)
        {
            constructorStrings[i] = constructorAsString(constructors[i]);
        }
        return constructorStrings;
    }

    /**
     * Converts an array of fields into an array of their string
     * representations.
     * 
     * @param fields
     *            The array of fields
     * @return The array of string representations of fields.
     */
    public static String[] fieldsAsStrings(Field[] fields)
    {
        ArrayList<String> fieldStrings = new ArrayList<String>();
        int k = 0;
        for (int i = 0; i < fields.length; i++)
        {
            if (!fields[i].isSynthetic())
            {
                fieldStrings.add(fieldAsString(fields[i]));
                k++;
            }
        }
        return fieldStrings.toArray(new String[k]);
    }

    /**
     * Converts an array of classes into an array of their string
     * representations.
     * 
     * @param classes
     *            The array of classes.
     * @return The array of string representations of classes.
     */
    public static String[] classesAsStrings(Class<?>[] classes)
    {
        String[] classStrings = new String[classes.length];
        for (int i = 0; i < classes.length; i++)
        {
            classStrings[i] = classes[i].getName();
        }
        return classStrings;
    }

    /**
     * Compares the string to an array of regular expressions, returning the
     * first index that matches.
     * 
     * @param s
     *            The string
     * @param regexes
     *            The regular expressions.
     * @return The index of the first regex that matches or -1 if none match.
     */
    public static int indexOfRegex(String s, String[] regexes)
    {
        for (int i = 0; i < regexes.length; i++)
        {
            String regex = regexes[i];
            if (s.matches(regex))
            {
                return i;
            }
        }
        return -1;
    }

    /**
     * Checks that the class contains the methods represented in stringMethods.
     * 
     * @param c
     *            The class
     * @param methodRegexes
     *            An array of regular expressions for each required method.
     */
    public static void checkMethods(Class<?> c, String[] methodRegexes)
    {
        Method[] m = c.getDeclaredMethods();
        if (methodRegexes.length == 0)
        {
            assertEquals(c.getName() + ": should not contain methods.", 0,
                    m.length);
        }
        String[] methods = methodsAsStrings(m);
        String message = c.getName() + ": One or more required methods are "
                + "missing or have the incorrect modifier, return type, name, "
                + "or parameter types.";
        checkStringsExact(methods, methodRegexes, message);
    }

    /**
     * Checks that the class contains the constructors represented in
     * stringMethods.
     * 
     * @param c
     *            The class
     * @param regexes
     *            An array of regular expressions for each required constructor.
     */
    public static void checkConstructors(Class<?> c, String[] regexes)
    {
        Constructor<?>[] m = c.getConstructors();
        String[] constructors = constructorsAsStrings(m);
        String message = c.getName()
                + ": One or more required constructors are "
                + "missing or have the incorrect modifier, name, "
                + "or parameter types.";
        checkStringsExact(constructors, regexes, message);
    }

    /**
     * Checks that the class contains the fields represented in stringFields.
     * 
     * @param c
     *            The class
     * @param fieldRegexes
     *            An array of regular expressions for each required field.
     */
    public static void checkFields(Class<?> c, String[] fieldRegexes)
    {
        Field[] f = c.getDeclaredFields();
        if (fieldRegexes.length == 0)
        {
            assertEquals(c.getName() + ": should not contain fields.", 0,
                    f.length);
        }
        String[] fields = fieldsAsStrings(f);
        String message = c.getName() + ": One or more fields are missing or "
                + "have the incorrect modifier, type, or name.";
        checkStringsExact(fields, fieldRegexes, message);
    }

    /**
     * Checks that the class implements the interfaces represented in
     * interfaceRegexes.
     * 
     * @param c
     *            The class
     * @param interfaceRegexes
     *            An array of regular expressions for each required interface.
     */
    public static void checkInterfaces(Class<?> c, String[] interfaceRegexes)
    {
        Class<?>[] t = c.getInterfaces();
        if (interfaceRegexes.length == 0)
        {
            assertEquals(c.getName() + ": should not contain fields.", 0,
                    t.length);
        }
        String[] interfaces = classesAsStrings(t);
        String message = c.getName()
                + ": One or more interfaces are missing or "
                + "have the incorrect modifier, type, or name.";
        checkStringsExact(interfaces, interfaceRegexes, message);
    }

    /**
     * Checks that the class has the modifiers.
     * 
     * @param c
     *            The class
     * @param modifierRegex
     *            The modifier regular expression.
     */
    public static void checkModifiers(Class<?> c, String modifierRegex)
    {
        String modifier = Modifier.toString(c.getModifiers());
        String message = c.getName()
                + ": Modifiers are incorrect: "
                + modifier;
        String[] modifiers = {modifier};
        String[] regexes = {modifierRegex};
        checkStringsExact(modifiers, regexes, message);
    }

    /**
     * Checks that the class contains the fields represented in stringFields.
     * 
     * @param strings
     *            The strings representing fields or methods for example.
     * @param regexes
     *            The regular expressions to compare against.
     * @param message
     *            A message to print if there is an error.
     */
    /*
    public static void checkStrings(String[] strings, String[] regexes,
            String message)
    {
        boolean[] exists = new boolean[regexes.length];
        for (String s : strings)
        {
            int index = indexOfRegex(s, regexes);
            if (index >= 0)
            {
                exists[index] = true;
            }
            // System.err.println(s);
        }
        for (int i = 0; i < exists.length; i++)
        {
            assertTrue(message + ": " + i, exists[i]);
        }
    }
    */
    /**
     * Checks that the class contains exactly the strings in regexes.
     * 
     * @param strings
     *            The strings representing fields or methods for example.
     * @param regexes
     *            The regular expressions to compare against.
     * @param message
     *            A message to print if there is an error.
     */
    public static void checkStringsExact(String[] strings, String[] regexes,
            String message)
    {
        boolean[] exists = new boolean[regexes.length];
        for (String s : strings)
        {
            // System.err.println(s);
            int index = indexOfRegex(s, regexes);
            if (index >= 0)
            {
                exists[index] = true;
            }
            else
            {
                fail(message + "\n" + s);
            }
        }
        for (int i = 0; i < exists.length; i++)
        {
            assertTrue(message + ": " + regexes[i], exists[i]);
        }
    }
}
