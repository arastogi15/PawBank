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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addButtonPressed(_ sender: Any) {
        
        // TODO: also add pet to array
        
        // TODO: GET DATA FROM TEXTFIELDS 
        
        let json: [String : Any] =
            ["biography" : "BIO hazard! ha ha",
                "breed" : "Collie",
                "fundingDone" : 0,
                "fundingGoal" : 10000,
                "name" : "Mr Stinky",
                "shelter_id" : 1];
        
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
        //TODO: make sure all fields
        
        // swipe right
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
