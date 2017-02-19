//
//  EditPetViewController.swift
//  PawBank
//
//  Created by Natalie Mackraz on 2/19/17.
//  Copyright © 2017 Natalie Mackraz. All rights reserved.
//

import UIKit

class EditPetViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var breedTF: UITextField!
    @IBOutlet weak var bioTF: UITextView!
    @IBOutlet weak var goalTF: UITextField!
    @IBOutlet weak var raisedTF: UITextField!
    
    
    @IBAction func saveChangesClicked(_ sender: Any) {
        if (allFieldsFilled()) {
            // TODO: remove/add to database
            let pet = PetData.pets[PetIndex.value];
            pet.name = nameTF.text!
            pet.breed = breedTF.text!
            pet.bio = bioTF.text
            pet.fundingGoal = Double(goalTF.text!)!
            pet.fundingDone = Double(raisedTF.text!)!
            PetData.pets[PetIndex.value] = pet;
            
            let alert = UIAlertController(title: "Pet Information Updated!", message: "", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Thanks!", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        } else {
            print("oop gotta fill out all fields")
            let alert = UIAlertController(title: "Save Error", message: "You must fill out all fields before saving.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)

        }
        
    }
    
    func allFieldsFilled() -> Bool {
        if (nameTF.text == "" || breedTF.text == "" ||
            bioTF.text == "" || goalTF.text == "" || raisedTF.text == "") {
            return false;
        }
        return true;
    }

    
    @IBAction func uploadNewImage(_ sender: Any) {
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let pet = PetData.pets[PetIndex.value];
        
        imageView.image = #imageLiteral(resourceName: "GermanSheppardPuppy")
        nameTF.text = pet.name;
        breedTF.text = pet.breed;
        bioTF.text = pet.bio;
        goalTF.text = String(pet.fundingGoal);
        raisedTF.text = String(pet.fundingDone);
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
