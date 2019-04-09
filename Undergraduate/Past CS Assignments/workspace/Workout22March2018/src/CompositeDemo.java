import java.util.ArrayList;

interface AbstractFile
{
  public void ls();
}

class File implements AbstractFile
{
    public File(String name)
    {
        m_name = name;
    }
    public void ls()
    {
        System.out.println(CompositeDemo.g_indent + m_name);
    }
    private String m_name;
}

class Directory implements AbstractFile
{
    public Directory(String name)
    {
        m_name = name;
    }
    public void add(Object obj)
    {
        m_files.add(obj);
    }
    public void ls()
    {
        System.out.println(CompositeDemo.g_indent + m_name);
        CompositeDemo.g_indent.append("   ");
        for (int i = 0; i < m_files.size(); ++i)
        {
            // Leverage the "lowest common denominator"
            AbstractFile obj = (AbstractFile)m_files.get(i);
            obj.ls();
        }
        CompositeDemo.g_indent.setLength(CompositeDemo.g_indent.length() - 3);
    }
    private String m_name;
    private ArrayList m_files = new ArrayList();
}

class CompositeDemo
{
    public static StringBuffer g_indent = new StringBuffer();

    public static void main(String[] args)
    {
        Directory Root = new Directory("Root");
        Directory Documents = new Directory("Documents");
        Directory Pictures = new Directory("Pictures");
        Directory Music = new Directory("Music");
        
        
        File a = new File("fileA.txt");
        File b = new File("fileB.txt");
        File c = new File("fileC.jpg");
        File d = new File("fileD.png");
        File da = new File("fileD.txt");
        
        
        Root.add(Documents);
        Root.add(Pictures);
        Root.add(Music);
        Root.add(da);
        
        Documents.add(a);
        Documents.add(b);
        
        Pictures.add(c);
        Pictures.add(d);
        
        Root.ls();
    }
}