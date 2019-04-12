package util;
import java.awt.GridBagConstraints;
import java.awt.GridBagLayout;
import java.awt.Label;

import javax.swing.JFrame;
import javax.swing.JPanel;

import solution.BubbleSorter;
import solution.InsertionSorter;
import solution.SelectionSorter;

/**
 * This sets up the GUI to show the sorting algorithm.
 * 
 * @author Unknown
 * @version 00/00/00
 * 
 */
public class SortViewer
{
    final static int FRAME_WIDTH = 700;
    final static int FRAME_HEIGHT = 400;
    final static int NUM_VALUES = 30;
    final static int MAX_HEIGHT = 300;
    final static int X = 200;
    final static int Y = 350;
    private JFrame frame;

    /**
     * No-args constructor.
     */
    public SortViewer()
    {
        frame = new JFrame();
        JPanel panel = new JPanel();
        panel.setLayout(new GridBagLayout());
        GridBagConstraints c = new GridBagConstraints();
        panel.setSize(FRAME_WIDTH, FRAME_HEIGHT);
        frame.setSize(FRAME_WIDTH, FRAME_HEIGHT);
        frame.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);

        c.ipadx = X;
        c.ipady = Y;
        c.gridy = 1;

        int[] values = ArrayUtil.randomIntArray(NUM_VALUES, MAX_HEIGHT);

        SortComponent selComponent = addSelectionSort(c, panel, values);
        SortComponent bubComponent = addBubbleSort(c, panel, values);
        SortComponent insComponent = addInsertionSort(c, panel, values);

        frame.add(panel);
        frame.setVisible(true);
        selComponent.startAnimation();
        bubComponent.startAnimation();
        insComponent.startAnimation();
    }
    
    /**
     * Helper method to initialize selection sort.
     * @param c the grid bag constraints
     * @param panel the panel
     * @param values the random values
     * @return the selection sorter
     */
    private SortComponent addSelectionSort(GridBagConstraints c, 
        JPanel panel, int[] values)
    {
        Label lbl1 = new Label("Selection Sort");
        panel.add(lbl1, c);
        SelectionSorter selSorter = new SelectionSorter(values);
        SortComponent selComponent = new SortComponent(selSorter);
        selComponent.setName("selectionSortComponent");
        panel.add(selComponent, c);
        return selComponent;
    }

    /**
     * Helper method to initialize bubble sort.
     * @param c the grid bag constraints
     * @param panel the panel
     * @param values the random values
     * @return the bubble sorter
     */
    private SortComponent addBubbleSort(GridBagConstraints c, JPanel panel, 
        int[] values)
    {
        Label lbl2 = new Label("Bubble Sort");
        panel.add(lbl2, c);
        BubbleSorter bubSorter = new BubbleSorter(values);
        SortComponent bubComponent = new SortComponent(bubSorter);
        bubComponent.setName("bubbleSortComponent");
        panel.add(bubComponent, c);
        return bubComponent;
    }
    
    /**
     * Helper method to initialize insertion sort.
     * @param c the grid bag constraints
     * @param panel the panel
     * @param values the random values
     * @return the bubble sorter
     */
    private SortComponent addInsertionSort(GridBagConstraints c, JPanel panel, 
        int[] values)
    {
        Label lbl3 = new Label("Insertion Sort");
        panel.add(lbl3, c);
        InsertionSorter insSorter = new InsertionSorter(values);
        SortComponent insComponent = new SortComponent(insSorter);
        insComponent.setName("insertionSortComponent");
        panel.add(insComponent, c);
        return insComponent;
    }

    
    /**
     * @return the frame.
     */
    public JFrame getFrame()
    {
        return frame;
    }

    /**
     * This is the main that sets up the GUI.
     * 
     * @param args
     *            command line arguments
     */
    public static void main(String[] args)
    {
        @SuppressWarnings("unused")
        SortViewer view = new SortViewer();
    }
}
