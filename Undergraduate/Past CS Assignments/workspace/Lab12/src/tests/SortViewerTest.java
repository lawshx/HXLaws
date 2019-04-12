package tests;
import static org.junit.Assert.assertNotNull;
import static org.junit.Assert.assertTrue;
import static org.junit.Assert.fail;

import java.awt.Component;

import javax.swing.JComponent;
import javax.swing.JFrame;
import javax.swing.JLayeredPane;
import javax.swing.JPanel;
import javax.swing.JRootPane;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.Test;

import util.SortViewer;
import util.SortComponent;
import solution.BubbleSorter;
import solution.InsertionSorter;
import solution.SelectionSorter;

/**
 * Test cases for the Sort Viewer GUI.
 * 
 * @author Mitch Parry
 * @version 2013-03-15
 * 
 */
public class SortViewerTest
{
    private static SortViewer view;

    /**
     * Creates a new viewer before each all tests.
     * 
     * @throws Exception
     *             if there's a problem.
     */
    @BeforeClass
    public static void setUp() throws Exception
    {
        view = new SortViewer();
    }

    /**
     * Stuff to do after all test methods.
     * 
     * @throws Exception
     *             certainly is possible.
     */
    @AfterClass
    public static void tearDown() throws Exception
    {
    }

    /**
     * Gets the component within a panel of the frame of the calculator with the
     * specified name.
     * 
     * @param <T>
     *            used for the return value.
     * 
     * @param type
     *            The type of component to find.
     * @param name
     *            the name of the component.
     * @return the component or null if it wasn't found.
     */
    @SuppressWarnings("unchecked")
    private <T extends Component> T getPanelComponent(
        Class<T> type, String name
    )
    {
        JPanel contentPane = getContentPane();
        for (Component c : contentPane.getComponents())
        {
            if (c instanceof JPanel)
            {
                for (Component d : ((JPanel) c).getComponents())
                {
                    if (d.getClass() == type && d.getName().equals(name))
                    {
                        return (T) d;
                    }
                }
            }
        }
        return null;
    }

    /**
     * Gets the subcomponent of root with the 'type' and 'name'.
     * 
     * @param <T>
     *            the return type
     * @param root
     *            the root component
     * @param type
     *            the type of the subcomponent
     * @param name
     *            the name of the subcomponent
     * @return the subcomponent or null if it does not exist.
     */
    @SuppressWarnings("unchecked")
    private <T extends Component> T getComponent(JComponent root,
        Class<T> type, String name)
    {
        for (Component c : root.getComponents())
        {
            if (c.getClass() == type)
            {
                if (((T) c).getName().equals(name))
                {
                    return (T) c;
                }
            }
        }
        fail("Could not find " + type + " with name = \"" + name + "\"");
        return null;
    }

    /**
     * @return the content pane for the calculator.
     */
    private JPanel getContentPane()
    {
        JFrame frame = view.getFrame();
        assertNotNull(frame);
        JRootPane root = (JRootPane) frame.getRootPane();
        JLayeredPane layeredPane =
            getComponent(root, JLayeredPane.class, "null.layeredPane");
        JPanel contentPane =
            getComponent(layeredPane, JPanel.class, "null.contentPane");
        return contentPane;
    }

    /**
     * Test whether a frame is visible.
     */
    @Test
    public void testFrameVisible()
    {
        JFrame frame = view.getFrame();
        assertNotNull(frame);
        assertTrue(frame.isVisible());
    }

    /**
     * Test selection sort component.
     */
    @Test
    public void testSelectionComponent()
    {
        testFrameVisible();
        SortComponent comp =
            getPanelComponent(SortComponent.class, "selectionSortComponent");
        assertNotNull(comp);
        assertTrue(comp.getSorter() instanceof SelectionSorter);
    }

    /**
     * Test insertion sort component.
     */
    @Test
    public void testInsertionComponent()
    {
        testFrameVisible();
        SortComponent comp =
            getPanelComponent(SortComponent.class, "insertionSortComponent");
        assertNotNull(comp);
        assertTrue(comp.getSorter() instanceof InsertionSorter);
    }

    /**
     * Test bubble sort component.
     */
    @Test
    public void testBubbleComponent()
    {
        testFrameVisible();
        SortComponent comp =
            getPanelComponent(SortComponent.class, "bubbleSortComponent");
        assertNotNull(comp);
        assertTrue(comp.getSorter() instanceof BubbleSorter);
    }

}
