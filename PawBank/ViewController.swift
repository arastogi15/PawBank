//
//  ViewController.swift
//  PawBank
//
//  Created by Natalie Mackraz on 2/18/17.
//  Copyright © 2017 Natalie Mackraz. All rights reserved.
//

import UIKit
import Koloda

extension ViewController : KolodaViewDelegate {
    
    internal func kolodaDidRunOutOfCards(koloda: KolodaView){
     // kodolaView.dataSource.reset()
    }
    
    func koloda(koloda: KolodaView, didSelectCardAt index: Int) {
        UIApplication.shared.openURL(NSURL(string: "https://yalantis.com/")! as URL)
        
    }
}

struct currentIndex {
    static var curr = 0;
}

extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.characters.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}

extension ViewController: KolodaViewDataSource {
    
    func kolodaNumberOfCards(_ koloda:KolodaView) -> Int {
        return PetData.pets.count
    }

    func donationClicked() {
        print("in donation clicked w/ userdata dict size of %d" , UserData.userDictionary.count )
        if (UserData.userDictionary.count != 0) {
            // display an alert
            //1. Create the alert controller.
            let alert = UIAlertController(title: "Donation", message: "Thank you! Please specify how much you would like to donate to your furry friend :)", preferredStyle: .alert)
            
            //2. Add the text field. You can configure it however you need.
            alert.addTextField { (textField) in
                textField.text = "0"
                textField.keyboardType = .numberPad
            }

            // 3. Grab the value from the text field, and print it when the user clicks OK.
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
                let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
                print("Text field: \(textField?.text)")
                
                if (textField?.text != nil) {
                   // print(koloda);
                    print("\n")
                    var petID = currentIndex.curr + 1
                    let json: [String : Any] =
                        ["user_id" : UserData.userDictionary["id"],
                         "pet_id" : petID,
                         "amount" : Int((textField?.text)!),
                         ]
                    let jsonData = try? JSONSerialization.data(withJSONObject: json)
                    let todoEndpoint: String = "http://5803e025.ngrok.io/addDonation"
                    //let todoEndpoint: String = "http://requestb.in/182uvxg1"
                    
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

                }
                
                
            }))
            self.present(alert, animated: true, completion: nil)

                
                
        
            
            
        }
    }

    
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        //petImageView.image = petImages[index];
        let width = self.view.frame.width;
        let height = self.view.frame.height;
        
        // frame
        let myNewView = UIView(frame: CGRect(x: 0, y: 0, width: width, height: self.view.frame.height))
        myNewView.backgroundColor = UIColor.white
        
        // buffer
        let buffer = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30))
        buffer.backgroundColor = UIColor(hexString: "#4CA063");

        // Name
        let titleView = UILabel(frame: CGRect(x: 0, y: 40, width: self.view.frame.width, height: 40))
        titleView.textAlignment = .center
        titleView.text = PetData.pets[index].name;
        titleView.font = UIFont(name: "Avenir Black", size: 30)
        titleView.textColor = UIColor(hexString: "#884D45");

        
        // Paw Icon
        let pawView = UIImageView(frame: CGRect(x: width - 44 - 29, y: 179 - 50, width: 44, height: 44))
        pawView.image = #imageLiteral(resourceName: "BrownPaw")

        // Image
        let imageView = UIImageView(frame: CGRect(x: 29, y: 179, width: self.view.frame.width - (29*2), height: self.view.frame.width - (29*2)))
        imageView.image = #imageLiteral(resourceName: "GermanSheppardPuppy")
        
        // Bio
        let bioView = UILabel(frame: CGRect(x: 29 , y: 0, width: self.view.frame.width - (29*2), height: 29))
        bioView.numberOfLines = 0;
        bioView.text = PetData.pets[index].bio;
        
        // buttons
        let donateButton = UIButton(frame: CGRect(x: 29 , y: height * 0.125, width: 114, height: 29))
        donateButton.setImage(#imageLiteral(resourceName: "unclickedDonateButton"), for: UIControlState.normal)
        currentIndex.curr = koloda.currentCardIndex;
        donateButton.addTarget(self, action:#selector(self.donationClicked), for: .touchUpInside)
        
        
        let adoptionButton = UIButton(frame: CGRect(x:width * 0.75 - width * 0.125 , y: height * 0.125, width: 114, height: 29))
        adoptionButton.setImage(#imageLiteral(resourceName: "adopt button unclicked"), for: UIControlState.normal)

        
        // adding to Label View
        let labelView = UIView(frame: CGRect(x: 0, y:(self.view.frame.height * 0.75), width: self.view.frame.width, height: (self.view.frame.height * 0.25)))
        labelView.backgroundColor = UIColor.white;
        labelView.addSubview(bioView)
        labelView.addSubview(adoptionButton)
        labelView.addSubview(donateButton);
 
        myNewView.addSubview(buffer);
        myNewView.addSubview(titleView);
        myNewView.addSubview(pawView);
        myNewView.addSubview(imageView);

        
        myNewView.addSubview(labelView);
       // myNewView.addSubview(label)
        return myNewView
        
        
//        UIImageView(image: petImages[index])
    }
    
    func koloda(koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("OverlayView",
                                        owner: self, options: nil)?[0] as? OverlayView
    }
}


class ViewController: UIViewController {

    @IBOutlet weak var kolodaView: KolodaView!
    
    @IBOutlet weak var noDogsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        kolodaView.dataSource = self
        kolodaView.delegate = self

        // TODO update
        if (PetData.pets.count == 0) {
            noDogsLabel.text = "No Dogs Available :("
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBOutlet var newWordField: UITextField!
    var deletedString = "";
    func wordEntered(alert: UIAlertAction!){
        // store the new word
        print(deletedString + " " + self.newWordField.text!);
    }
    func addTextField(textField: UITextField!){
        // add the text field and make the result global
        textField.placeholder = "Definition"
        self.newWordField = textField
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    @IBAction func paymentButtonClicked(_ sender: UIButton) {
//        donateButton.setImage(#imageLiteral(resourceName: "unclickedDonateButton"), for: UIControlState.normal)
//
//    }
//    
//    @IBAction func touchDownPay(_ sender: Any) {
//         donateButton.setImage(#imageLiteral(resourceName: "donateClickedButton"), for: UIControlState.normal)
//    }
//    func updateFrames(pet: Pet) {
//        nameLabel.text = pet.name;
//        bioLabel.text = pet.bio;
//        var amountRaised = pet.fundingDone/pet.fundingGoal;
//        amountRaised = 0.75;
//        progressView.setProgress(Float(amountRaised), animated: true)
//        petImageView.image = #imageLiteral(resourceName: "GermanSheppardPuppy");
//    }
}

