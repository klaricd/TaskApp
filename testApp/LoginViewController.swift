//
//  ViewController.swift
//  testApp
//
//  Created by David Klaric on 24.04.2023..
//

import UIKit

class LoginViewController: UIViewController {
    
    let appId = "f5a14a7f-6460-4b28-8e7c-e3b95725689d"
    var iconClick = true
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uiStyle()
    }
    
    //MARK: - Functions
    func loginForm(email: String, password: String, appId: String, completion: @escaping (Bool) -> Void) {
        let url = URL(string: "https://account.zadar.mediaapp.eu/api/User/AdminLogin")!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let params = ["email": email, "password": password, "appId": appId]
        request.httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  let responseData = data,
                  let responseString = String(data: responseData, encoding: .utf8) else {
                print("Error: \(error?.localizedDescription ?? "Unknown error")")
                completion(false)
                return
            }
            
            // extract values from JSON response
            if let jsonData = responseString.data(using: .utf8),
               let jsonDict = try? JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any],
               let accessToken = jsonDict["accessToken"] as? String {
                print("Access token: \(jsonDict["accessToken"] ?? "error")")
                
                UserDefaults.standard.set(accessToken, forKey: "accessToken")
                completion(true)
            } else {
                completion(false)
            }
        }
        task.resume()
    }
    
    func clearTextFields() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    func uiStyle() {
        emailTextField.layer.cornerRadius = 10
        emailTextField.layer.borderColor = UIColor.white.cgColor
        emailTextField.layer.borderWidth = 1.0
        
        passwordTextField.layer.cornerRadius = 10
        passwordTextField.layer.borderColor = UIColor.white.cgColor
        passwordTextField.layer.borderWidth = 1.0
        
        loginButtonOutlet.layer.cornerRadius = 15
    }
    
    func throwAlert(title: String, message: String) {
        let dialogMessage = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        dialogMessage.addAction(ok)
        
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    //MARK: - Buttons
    @IBAction func loginButton(_ sender: Any) {
        let email = emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let password = passwordTextField.text ?? ""
        
        if email.isEmpty || password.isEmpty {
            throwAlert(title: "Error", message: "Email and/or password missing!")
        } else {
            loginForm(email: email, password: password, appId: appId) { success in
                if success {
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "segue", sender: self)
                        self.clearTextFields()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.throwAlert(title: "Error", message: "Invalid email and/or password!")
                    }
                }
            }
        }
    }
    
    @IBAction func passwordStateButton(_ sender: Any) {
        if iconClick {
            passwordTextField.isSecureTextEntry = false
        } else {
            passwordTextField.isSecureTextEntry = true
        }
        iconClick = !iconClick
    }
}
