//
//  SettingsViewController.swift
//  BubbleSmash
//
//  Created by Zach Clare on 26/4/2022.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeSliderLabel: UILabel!
    @IBOutlet weak var bubbleSlider: UISlider!
    @IBOutlet weak var bubbleSliderLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add an event handler to ensure the player puts in a name
        nameTextField.addTarget(self, action: #selector(nameFieldChanged(_:)), for: .editingChanged)
        
        // add tap handling to leave the keyboard when entering a name on phone
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    // function to track the name field
    @objc func nameFieldChanged(_ textField: UITextField) {
        // disable the start button
        startButton.isEnabled = false
        
        // check that the field isn't empty - if it is, return
        guard let text = textField.text, text != "" else { return }
        
        // since it's not empty, we can enable the start button
        startButton.isEnabled = true
    }
    
    // function to dismiss the keyboard when on phone
    @objc func handleTap() {
        nameTextField.resignFirstResponder()
    }
    
    // simple function to update the label text under the game time slider
    @IBAction func timeSliderValueChanged(_ sender: UISlider) {
        let num = Int(sender.value);
        timeSliderLabel.text = "\(num)";
    }
    // simple function to update the label text under the bubble amount slider
    @IBAction func bubbleSliderValueChanged(_ sender: UISlider) {
        let num = Int(sender.value);
        bubbleSliderLabel.text = "\(num)";
    }
    
    // change the screen to the game screen, bringing across the settings
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToGame" {
            let VC = segue.destination as! GameViewController;
            VC.name = nameTextField.text!
            VC.remainingTime = Int(timeSlider.value)
            VC.amountOfBubbles = Int(bubbleSlider.value)
        }
    }
}
