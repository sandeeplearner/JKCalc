//
//  ViewController.swift
//  JKCalc
//
//  Created by Sandeep Bhandari on 6/8/16.
//  Copyright © 2016 Sandeep Bhandari. All rights reserved.
//

import UIKit
import Contacts

class ViewController: UIViewController {
    
    @IBOutlet var answerLabel: UILabel!
    var operationInExecution : Operators!
    var operand1 : Double!
    var isNewOperationStarted : Bool = false
    var shouldClearWholeOperation : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func keyPadTapped(sender: AnyObject) {
        //each buttons in storyboard is assigned a tag value.
        //for number's it is their value it self
        //for each operators a special value has been assigned
        switch sender.tag! {
            
        case 0 ... 9 :
            
            if self.answerLabel.text != nil && self.answerLabel.text!.containsString(".") {
                self.answerLabel.text! += String(sender.tag)
            }
            
            // if the value of the label is 0 adding any number behind it will not make any differrence hence lets trim out 0
            else if (Double(self.answerLabel.text!) == 0 || self.isNewOperationStarted == true) {
                self.answerLabel.text! = String(sender.tag)
            }
                
                //if the opertaor had been enterred in proevious operation lets clear it of from screen
            else if Double(self.answerLabel.text!) == nil {
                self.answerLabel.text! = String(sender.tag)
            }
                //if number was already present in self.answerLabel we should append the user tapped number to it
            else{
                self.answerLabel.text! += String(sender.tag)
            }
            
            if self.operationInExecution == nil {
                self.operand1 = nil
            }
            self.isNewOperationStarted = false
            self.shouldClearWholeOperation = false
            break
            
        case Operators.clear.rawValue ... Operators.dot.rawValue :
            self.handleOperations(sender.tag)
            break
            
        default :
            print("Sorry I din get that")
        }
    }
    
    //as most of the code in operation handler will be same for most of the operators rather then copy pasting the methods again and again lets have a method.
    func handleOperations(selectedOperator : Int) {
        
        switch selectedOperator {
        case Operators.addition.rawValue:
            if (self.operationInExecution != nil) {
                self.operand1 = self.performMathmaticalOperation()
            }
            self.operationInExecution = Operators.addition
            if self.operand1 == nil {
                self.operand1 = Double(self.answerLabel.text!)!
            }
            self.answerLabel.text! = "+"
            
        case Operators.subtraction.rawValue:
            if (self.operationInExecution != nil) {
                self.operand1 = self.performMathmaticalOperation()
            }
            self.operationInExecution = Operators.subtraction
            if self.operand1 == nil {
                self.operand1 = Double(self.answerLabel.text!)!
            }
            self.answerLabel.text! = "-"
            
        case Operators.multiplication.rawValue:
            if (self.operationInExecution != nil) {
                self.operand1 = self.performMathmaticalOperation()
            }
            self.operationInExecution = Operators.multiplication
            if self.operand1 == nil {
                self.operand1 = Double(self.answerLabel.text!)!
            }
            self.answerLabel.text! = "x"
            
        case Operators.division.rawValue:
            if (self.operationInExecution != nil) {
                self.operand1 = self.performMathmaticalOperation()
            }
            self.operationInExecution = Operators.division
            if self.operand1 == nil {
                self.operand1 = Double(self.answerLabel.text!)!
            }
            self.answerLabel.text! = "/"
            
        case Operators.equals.rawValue:
            let result = self.performMathmaticalOperation()
            if result != nil {
                if result % 1 == 0 {
                    self.answerLabel.text! = String(Int(result))
                }
                else{
                    self.answerLabel.text! = String(result)
                }
                self.operationInExecution = nil
                self.operand1 = result
                self.isNewOperationStarted = true
            }
        case Operators.clear.rawValue:
            self.clearOperation()
            
        case Operators.dot.rawValue:
            
            if self.isNewOperationStarted {
                self.answerLabel.text! = "0."
            }
            else{
                if Double(self.answerLabel.text!) == nil{
                    self.answerLabel.text! = "0."
                }
                else{
                    if Double(self.answerLabel.text!)! % 1 == 0{
                        self.answerLabel.text! += "."
                    }
                }
            }
        default:
            print("Could not recognize the operator sorry")
        }
        
    }
    
    //lets keept the method that performs the calculation seperate in differrent method
    func performMathmaticalOperation() -> Double! {
        if self.operationInExecution != nil && Double(self.answerLabel.text!) != nil && self.operand1 != nil {
            switch self.operationInExecution! {
            case Operators.addition:
                return self.operand1 + Double(self.answerLabel.text!)!
                
            case Operators.subtraction :
                return self.operand1 - Double(self.answerLabel.text!)!
                
            case Operators.multiplication :
                return self.operand1 * Double(self.answerLabel.text!)!
                
            case Operators.division :
                if Double(self.answerLabel.text!)! == 0 {
                    return nan(nil)
                }
                else{
                    return self.operand1 / Double(self.answerLabel.text!)!
                }
            default:
                return 0
            }
        }
        else{
            return nil
        }
    }
    
    func clearOperation() {
        if self.shouldClearWholeOperation != nil && self.shouldClearWholeOperation == true{
            self.operationInExecution = nil
            self.operand1 = nil
            self.answerLabel.text! = "0"
        }
        else{
            self.answerLabel.text! = "0"
            self.shouldClearWholeOperation = true
        }
    }
}

