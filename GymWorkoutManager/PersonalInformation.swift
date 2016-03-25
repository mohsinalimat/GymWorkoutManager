//
//  PersonalInformation.swift
//  GymWorkoutManager
//
//  Created by Liguo Jiao on 16/3/19.
//  Copyright © 2016年 McKay. All rights reserved.
//

import UIKit
import ChameleonFramework
import JVFloatLabeledTextField

class PersonalInformation: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var name: JVFloatLabeledTextField!
    @IBOutlet var gender: UISegmentedControl!
    @IBOutlet var age: JVFloatLabeledTextField!
    @IBOutlet var bodyFat: JVFloatLabeledTextField!
    @IBOutlet var weight: JVFloatLabeledTextField!
    @IBOutlet var height: JVFloatLabeledTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        name.delegate = self
        age.delegate = self
        bodyFat.delegate = self
        weight.delegate = self
        height.delegate = self
        print(gender.selectedSegmentIndex)
    }
    
    @IBAction func selectGender(sender: AnyObject) {
        if gender.selectedSegmentIndex == 0 {
            print("M")
        } else if gender.selectedSegmentIndex == 1 {
            print("F")
        }
    }
    
    @IBAction func BMRCalculation(sender: AnyObject) {
    }
    
    @IBAction func BMICalculation(sender: AnyObject) {
        let result = BMICalculator(Float(weight.text ?? "") ?? 0.0, heights: Float(height.text ?? "") ?? 0.0)
        let alert = UIAlertController(title: "BMI Index", message: "\(result)%", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Got it", style: UIAlertActionStyle.Cancel, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    private func BMRCalculation1(a:Int, w:Float, h:Float, gender:Int) -> Float{
        //Harris Benedict Method
        /*BMR Men: BMR = 66.5 + ( 13.75 x weight in kg ) + ( 5.003 x height in cm ) – ( 6.755 x age in years )
        
        BMR Women: BMR = 655.1 + ( 9.563 x weight in kg ) + ( 1.850 x height in cm ) – ( 4.676 x age in years )
        */
        var result : Float = 0.0
        if gender == 0 { // 0 For male
            result = 66+(13.75*w)+(5.003*h)-(6.755 * Float(a))
        } else if gender == 1 { // 1 For female
            result = 655.1+(9.563*w)+(1.85*h)-(4.676 * Float(a))
        }
        return result
    }
    private func BMRCalculation2(age:Int, weights:Float, bodyFat:Float) -> Float {
        //Katch & McArdle Method
        /*
        BMR (Men + Women) = 370 + (21.6 * Lean Mass in kg)
        
        Lean Mass = weight in kg – (weight in kg * body fat %)
        1 kg = 2.2 pounds, so divide your weight by 2.2 to get your weight in kg
        */
        var result : Float = 0.0
        var leanMass : Float = 0.0
        leanMass = weights - (weights * bodyFat)
        result = 370 + (21.6 * leanMass)
        return result
    }
    private func BMICalculator(weights:Float, heights:Float) -> Float {
        // Metric Units: BMI = Weight (kg) / (Height (m) x Height (m))
        let result = 10000*(weights / (heights * heights))
        return result
    }
}
