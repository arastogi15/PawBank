//
//  AddPetViewController.swift
//  PawBank
//
//  Created by Natalie Mackraz on 2/18/17.
//  Copyright © 2017 Natalie Mackraz. All rights reserved.
//

import UIKit

class AddPetViewController: UIViewController {
    let petIndex = 0;

    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var breedTF: UITextField!
    @IBOutlet weak var bioTV: UITextView!
    @IBOutlet weak var goalTF: UITextField!
    @IBOutlet weak var currentFundsTF: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func allFieldsFilled() -> Bool {
        if (nameTF.text == "" || breedTF.text == "" ||
            bioTV.text == "" || goalTF.text == "" || currentFundsTF.text == "") {
            return false;
        }
        return true;
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        
        // TODO: GET DATA FROM TEXTFIELDS 
        
        if (allFieldsFilled()) {
            // TODO: also add pet to array
            let pet = Pet()
            pet.bio = bioTV.text;
            pet.breed = breedTF.text!;
            pet.fundingDone = Double(currentFundsTF.text!)!;
            pet.fundingGoal = Double(goalTF.text!)!;
            pet.name = nameTF.text!;
            // TODO: add shelter_id
            pet.shelterId = 1;
            PetData.pets.append(pet)
            
            let json: [String : Any] =
                ["biography" : pet.bio,
                 "breed" : pet.breed,
                 "fundingDone" : pet.fundingDone,
                 "fundingGoal" : pet.fundingGoal,
                 "name" : pet.name,
                 "shelter_id" : pet.shelterId];
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            let todoEndpoint: String = "http://5803e025.ngrok.io/pet"
            //        let todoEndpoint: String = "http://requestb.in/13hhtyr1"
            
            guard let url = URL(string: todoEndpoint) else {
                print("Error: cannot create URL")
                return
            }
            var urlRequest = URLRequest(url: url)
            urlRequest.httpMethod = "POST"
            urlRequest.httpBody = jsonData
            urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    print(responseJSON)
                }
            }
            task.resume()
            
            navigationController?.popViewController(animated: true)
            
            dismiss(animated: true, completion: nil)
            
            // TODO: hide add pet page or do pop up and clear fields
        } else {
            print("oop gotta fill out all fields")
            let alert = UIAlertController(title: "Save Error", message: "You must fill out all fields before saving.", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
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
