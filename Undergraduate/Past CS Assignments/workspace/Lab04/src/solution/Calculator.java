package solution;
import java.awt.BorderLayout;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

import javax.swing.JButton;
import javax.swing.JFrame;
import javax.swing.JLabel;
import javax.swing.JPanel;
import javax.swing.JTextField;


public class Calculator
{
    private JFrame calcF;
    private JTextField leftOperand;
    private JTextField rightOperand;
    private JLabel resultLabel;

    public JFrame getFrame()
    {
        return calcF;
    }


    public Calculator()
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
        leftOperand = new JTextField(10);
        leftOperand.setName("leftOperand");
        
        rightOperand = new JTextField(10);
        rightOperand.setName("rightOperand");
        
        resultLabel = new JLabel("Result = ");
        resultLabel.setName("resultLabel");

        JButton addButton = new JButton("ADD"); 
        addButton.setName("addButton");

        JButton subButton = new JButton("SUB");
        subButton.setName("subButton");

        JButton multButton = new JButton("MULT");
        multButton.setName("multButton");

        JButton divButton = new JButton("DIV");
        divButton.setName("divButton");

        JPanel buttonPanel = new JPanel();
        buttonPanel.add(addButton);
        buttonPanel.add(subButton);
        buttonPanel.add(multButton);
        buttonPanel.add(divButton);

        JPanel top = new JPanel();
        top.add(leftOperand);
        top.add(rightOperand);
        calcF.add(top, BorderLayout.PAGE_START);

        JPanel middle = new JPanel();
        middle.add(resultLabel);
        calcF.add(middle, BorderLayout.CENTER);

        JPanel bottom = new JPanel();
        bottom.add(addButton);
        bottom.add(subButton);
        bottom.add(multButton);
        bottom.add(divButton);
        calcF.add(bottom, BorderLayout.PAGE_END);

        addButton.addActionListener(new addAct());

        subButton.addActionListener(new subAct());

        multButton.addActionListener(new multAct());

        divButton.addActionListener(new divAct());
    }



    public class addAct implements ActionListener
    {


        public void actionPerformed(ActionEvent e){

            try{
                double one = Double.parseDouble(leftOperand.getText());
                double two = Double.parseDouble(rightOperand.getText());

                if (leftOperand.getText().trim().equals("") || rightOperand.getText().trim().equals(""))
                {
                    resultLabel.setText("Result = error");
                }
                else
                {
                    resultLabel.setText("Result = " + (int)(one + two));
                }
            }catch(NumberFormatException io){
                resultLabel.setText("Result = error");
            }



        }
    }



    public class subAct implements ActionListener
    {
        public void actionPerformed(ActionEvent e) {
            try{
                double one = Double.parseDouble(leftOperand.getText());
                double two = Double.parseDouble(rightOperand.getText());

                if (leftOperand.getText().trim().equals("") || rightOperand.getText().trim().equals(""))
                {
                    resultLabel.setText("Result = error");
                }
                else
                {
                    resultLabel.setText("Result = " + (int)(one - two));
                }
            }catch(NumberFormatException io){
                resultLabel.setText("Result = error");
            }

        }
    }


    public class multAct implements ActionListener
    {
        public void actionPerformed(ActionEvent e) {
            try{
                double one = Double.parseDouble(leftOperand.getText());
                double two = Double.parseDouble(rightOperand.getText());

                if (leftOperand.getText().trim().equals("") || rightOperand.getText().trim().equals(""))
                {
                    resultLabel.setText("Result = error");
                }
                else
                {
                    resultLabel.setText("Result = " + (int)(one * two));
                }
            }catch(NumberFormatException io){
                resultLabel.setText("Result = error");
            }


        }
    }


    public class divAct implements ActionListener
    {
        public void actionPerformed(ActionEvent e) {

            try{
                double one = Double.parseDouble(leftOperand.getText());
                double two = Double.parseDouble(rightOperand.getText());

                if (leftOperand.getText().trim().equals("") || rightOperand.getText().trim().equals(""))
                {
                    resultLabel.setText("Result = error");
                }
                else if (two == 0.0)
                {
                    resultLabel.setText("Result = error");
                }
                else
                {
                    resultLabel.setText("Result = " + (int)(one / two));
                }
            }catch(NumberFormatException io){
                resultLabel.setText("Result = error");
            }


        }
    }


    public static void main(String[] args)
    {
        Calculator calc = new Calculator();
    }

}
