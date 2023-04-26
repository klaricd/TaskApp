//
//  UserViewController.swift
//  testApp
//
//  Created by David Klaric on 25.04.2023..
//

import UIKit

class UserViewController: UIViewController {
    
    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surnameLabel: UILabel!
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var roleIdLabel: UILabel!
    @IBOutlet weak var imageIdLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var oibLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var statusIdLabel: UILabel!
    @IBOutlet weak var accessLiburnijaLabel: UILabel!
    @IBOutlet weak var accessParkingLabel: UILabel!
    @IBOutlet weak var accessZadarLabel: UILabel!
    @IBOutlet weak var checkedLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var cardsLabel: UILabel!
    @IBOutlet weak var logoutButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        logoutButtonOutlet.layer.cornerRadius = 10
        
        getData()
    }
    
    func getData() {
        let accessToken = UserDefaults.standard.string(forKey: "accessToken")
        
        if accessToken != nil {
            let url = URL(string: "https://account.zadar.mediaapp.eu/api/User/User")
            
            var request = URLRequest(url: url!)
            request.httpMethod = "GET"
            
            request.setValue("Bearer \(accessToken!)", forHTTPHeaderField: "Authorization")
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error in get data: \(error)")
                    return
                }
                
                guard let data = data else {
                    print("No data received")
                    return
                }
                
                do {
                    if let jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        DispatchQueue.main.async {
                            let id = jsonDict["id"] as? Int ?? 0
                            let firstName = jsonDict["name"] as? String ?? ""
                            let lastName = jsonDict["surname"] as? String ?? ""
                            let fullName = jsonDict["fullName"] as? String ?? ""
                            let roleId = jsonDict["roleId"] as? Int ?? 0
                            let imageId = jsonDict["imageId"] as? Int ?? 0
                            let address = jsonDict["address"] as? String ?? ""
                            let phoneNumber = jsonDict["phoneNumber"] as? String ?? ""
                            let oib = jsonDict["oib"] as? String ?? ""
                            let email = jsonDict["email"] as? String ?? ""
                            let statusId = jsonDict["statusId"] as? Int ?? 0
                            let accessLiburnija = jsonDict["accessLiburnija"] as? Bool ?? false
                            let accessParking = jsonDict["accessParking"] as? Bool ?? false
                            let accessZadar = jsonDict["accessZadar"] as? Bool ?? false
                            let checked = jsonDict["checked"] as? Bool ?? false
                            let status = jsonDict["status"] as Any // ostavit Any ?
                            let cards = jsonDict["cards"] as? [Any] ?? []
                            
                            // update labels with values
                            self.idLabel.text = "ID: \(String(id))"
                            self.nameLabel.text = "Name: \(firstName)"
                            self.surnameLabel.text = "Surname: \(lastName)"
                            self.fullNameLabel.text = "Full name: \(fullName)"
                            self.roleIdLabel.text = "Role ID: \(String(roleId))"
                            self.imageIdLabel.text = "Image ID: \(String(imageId))"
                            self.addressLabel.text = "Address: \(address)"
                            self.phoneNumberLabel.text = "Phone number: \(phoneNumber)"
                            self.oibLabel.text = "Oib: \(oib)"
                            self.emailLabel.text = "Email: \(email)"
                            self.statusIdLabel.text = "Status ID: \(String(statusId))"
                            self.accessLiburnijaLabel.text = "Access Liburnija: \(String(accessLiburnija))"
                            self.accessParkingLabel.text = "Access Parking: \(String(accessParking))"
                            self.accessZadarLabel.text = "Access Zadar: \(String(accessZadar))"
                            self.checkedLabel.text = "Checked: \(String(checked))"
                            self.statusLabel.text = "Status: \(status)"
                            self.cardsLabel.text = "Cards: \(String(cards.count))"
                        }
                    } else {
                        print("Unable to deserialize JSON data")
                    }
                } catch {
                    print("Error deserializing JSON data: \(error.localizedDescription)")
                }
            }
            task.resume()
        } else {
            print("Access token not found in UserDefaults")
        }
    }
    
    @IBAction func logoutButton(_ sender: Any) {
        if let navigationController = navigationController {
            UserDefaults.standard.removeObject(forKey: "accessToken")
            navigationController.popViewController(animated: true)
        }
    }
}
