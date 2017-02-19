//
//  LoginViewController.swift
//  PawBank
//
//  Created by Natalie Mackraz on 2/18/17.
//  Copyright © 2017 Natalie Mackraz. All rights reserved.
//

import UIKit
struct PetData {
    static var pets: [Pet] = []
}
struct UserData {
    static var userDictionary = [String : Any]()
}

class LoginViewController: UIViewController {

    @IBOutlet weak var imgView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        
//        tstView.dataSource = self
//        tstView.delegate = self
        
        // Set up the URL request
        let todoEndpoint: String = "http://5803e025.ngrok.io/pets"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        // make request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
 
            print("got data")
            print(data)

            let json = try? JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
            if json != nil {
            // Adding JSON info to Pets array
            // TODO: clean up code/make less repetitive
            // TODO: make strings constants in Pet.swift maybe?
            for petsInfoDict in json! {
                let pet = Pet()
                print(petsInfoDict["name"]);
                if let nameStr = petsInfoDict["name"] as? String {
                    pet.name = nameStr;
                }
                if let bioStr = petsInfoDict["biography"] as? String {
                    pet.bio = bioStr;
                }
                if let breedStr = petsInfoDict["breed"] as? String {
                    pet.breed = breedStr;
                }
                if let fundingDoneStr = petsInfoDict["fundingDone"] as? NSNumber {
                    pet.fundingDone = Double(fundingDoneStr);
                }
                if let fundingGoalStr = petsInfoDict["fundingGoal"] as? NSNumber {
                    pet.fundingGoal = Double(fundingGoalStr);
                }
                if let idStr = petsInfoDict["id"] as? NSNumber {
                    pet.id = Int(idStr);
                }
                if let shelterIdStr = petsInfoDict["shelter_id"] as? NSNumber {
                    pet.shelterId = Int(shelterIdStr);
                }
                PetData.pets.append(pet);
            }
                print((json?[0]["biography"])!);

            }
            
            print(json);
            
            
            // TODO: add Optional nil guards
            print("printing out pets: \n");
            for pet in PetData.pets {
                
                print(pet.name);
                print("\n");
            }

        })
        task.resume()
        
        
        // Do any additional setup after loading the view.
        
        // Getting Users
        let urlString: String = "http://5803e025.ngrok.io/users"
        guard let userUrl = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        let userUrlRequest = URLRequest(url: userUrl)
        
        // set up the session
        let userConfig = URLSessionConfiguration.default
        let userSession = URLSession(configuration: userConfig)
        // make request
        let userTask = userSession.dataTask(with: userUrlRequest, completionHandler: { (data, response, error) in
            
            print("got data")
            print(data)
            
            let json = try? JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
            if json != nil {
                let userDict = json?[0];
                if (userDict != nil) {
                    UserData.userDictionary = userDict as! [String : Any];
                }
            }
        })
        userTask.resume()
        
        
        // Do any additional setup after loading the view.


    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userButtonClicked(_ sender: Any) {
    }

    @IBAction func adoptionCenterClicked(_ sender: Any) {
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
