//
//  ViewController.swift
//  MVVMUiKit
//
//  Created by Manickam on 01/11/24.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var userNameTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViews()
    }
    
    func configureViews(){
        viewModel.delegate = self
        userNameTF.delegate = self
        passwordTF.delegate = self
        activityIndicator.isHidden = true
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            let keyboardHeight = keyboardSize.height
            // Adjust the view's frame or the bottom constraint
            UIView.animate(withDuration: 0.3) {
                self.view.frame.origin.y = -keyboardHeight / 1.5 // Move the view up by half the keyboard height
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        // Reset the view's position
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
    
    @IBAction func tapLoginButton(_ sender: Any) {
        guard let username = userNameTF.text, !username.isEmpty, let pass = passwordTF.text, !pass.isEmpty else {
                return
            }
        self.view.isUserInteractionEnabled = false
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        viewModel.login(username: username, password: pass)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ProductList" {
//            if let vc = segue.destination as? ProductListViewController {
//                
//            }
//        }
//    }
}

extension ViewController : LoginViewModelProtocol {
    func didReceiveloginResponse(result: Result<User, any Error>) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.activityIndicator.isHidden = true
            self.activityIndicator.stopAnimating()
            self.view.isUserInteractionEnabled = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let vc = storyboard.instantiateViewController(withIdentifier: "ProductListID") as? ProductListViewController {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        print(result)
    }
}

extension ViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
           textField.resignFirstResponder()
           return true
       }
}


