//
//  LoginTableViewController.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/29/21.
//

import UIKit

class LoginTableViewController: UITableViewController {
    
    // MARK: IBOutlets
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordConfirmationTextField: UITextField!
    
    // MARK: View Life Cycle
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
//        if Auth().token != nil {
//            self.view.isHidden = true
//            
//            performSegue(withIdentifier: "ShowUserProfileSegue", sender: nil)
////            self.navigationController?.pushViewController(ProfileTableViewController(), animated: false)
//        }
        
    }
    
    // MARK: IBActions
    @IBAction func loginTapped(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            ErrorPresenter.showError(message: "Username cannot be empty.", on: self)
            return
        }
        
        guard let password = passwordTextField.text, !password.isEmpty else {
            ErrorPresenter.showError(message: "Password cannot be empty.", on: self)
            return
        }
        
        guard let passwordConfirmation = passwordConfirmationTextField.text, passwordConfirmation == password else {
            ErrorPresenter.showError(message: "Password Confirmation does not match Password.", on: self)
            return
        }
        
        
        Auth().login(username: username, password: password) { result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "ShowUserProfileSegue", sender: nil)
                    
                    // Change tab bar title
                    self.tabBarController?.tabBar.items?[2].title = "Profile"
                    
                }
            case .failure:
                let message = "Could not login. Check your credentials and try again."
                ErrorPresenter.showError(message: message, on: self)
            }
        }
        
    }

}
