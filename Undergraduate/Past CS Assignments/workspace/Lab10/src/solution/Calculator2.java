package solution;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.util.Stack;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;


/**
 * 
 * @author Hannah Xiao Si Laws
 * @version 31.10.2017
 *
 */
public class Calculator2
{
    private JFrame calcF;
    private JTextField infixExpression;
    private JTextField rightOperand;
    private JLabel resultLabel;

    public JFrame getFrame()
    {
        return calcF;
    }


    public Calculator2()
    {

        calcF = new JFrame();
        calcF.setLocation(100,100);
        calcF.setSize(400, 400);
        calcF.setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        calcF.setTitle("My Simple Calculator");

        initializeComponents();
        calcF.pack();
        calcF.setVisible(true);
    }

    public void initializeComponents()
    {
        infixExpression = new JTextField(10);
        infixExpression.setName("infixExpression");


        resultLabel = new JLabel("Result = ");
        resultLabel.setName("resultLabel");

        JButton calculateButton = new JButton("Calculate"); 
        calculateButton.setName("calculateButton");

        JButton clearButton = new JButton("Clear"); 
        clearButton.setName("clearButton");


        JPanel buttonPanel = new JPanel();
        buttonPanel.add(calculateButton);
        buttonPanel.add(clearButton);


        JPanel top = new JPanel();
        top.add(infixExpression);
        calcF.add(top, BorderLayout.PAGE_START);

        JPanel middle = new JPanel();
        middle.add(resultLabel);
        calcF.add(middle, BorderLayout.CENTER);

        JPanel bottom = new JPanel();
        bottom.add(calculateButton);
        bottom.add(clearButton);
        calcF.add(bottom, BorderLayout.PAGE_END);

        calculateButton.addActionListener(new calcAct());
        clearButton.addActionListener(new clearAct());

    }

    public class calcAct implements ActionListener
    {
        public void actionPerformed(ActionEvent e) {

            try
            {
                ExpressionEvaluator eval = new ExpressionEvaluator();
                String postval = eval.toPostfix(e);
                eval.evaluate(postval);
                resultLabel.setText("" + eval.evaluate(postval));

            }
            catch(NumberFormatException io){
                resultLabel.setText("Result = error");
            }


        }
    }
    
    public class clearAct implements ActionListener
    {
        public void actionPerformed(ActionEvent e) {
            resultLabel.setText("Result = ");
            infixExpression.setText("");
        }
    }


    public void main(String[] args)
    {
        Calculator2 c = new Calculator2();
    }
}
