//
//  LoginViewController.swift
//  PawBank
//
//  Created by Natalie Mackraz on 2/18/17.
//  Copyright © 2017 Natalie Mackraz. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Set up the URL request
        let todoEndpoint: String = "http://387490ae.ngrok.io/pets"
        guard let url = URL(string: todoEndpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        // set up the session
//        let config = URLSessionConfiguration.defaultSessionConfiguration()
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        // make the request
//        let task = session.dataTaskWithRequest(urlRequest, completionHandler: { (data, response, error) in
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
        // do stuff with response, data & error here
//            print(error)
//            print(response)
            print("got data")
            print(data)
//            let dataString = NSString(data: data!, encoding: UTF8StringEncoding)
//            let dataString = NSString(data) //string.data(using: .utf8)
//            var datastring = NSString(data data: NSData!, NSCoding encoding: UInt)

//            let resultOfURL = String(contentsOf:data!, usedEncoding: String.Encoding.utf8)
           // let aldksjf = String(data: data!, encoding: .utf8)
            
            let json = try? JSONSerialization.jsonObject(with: data!) as! [NSDictionary]
            
            print(json);
            
            
            // TODO: add Optional nil guards
            print((json?[0]["biography"])!);
            
            //print(aldksjf)
//            print(dataString)
//            NSLog(@"%@", data)
        })
        task.resume()
        
        
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
