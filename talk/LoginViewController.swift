//
//  LoginViewController.swift
//  talk
//
//  Created by 志村　啓太 on 2021/02/22.
//

import UIKit

class LoginViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    //textField
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    //Button
    @IBOutlet weak var loginButtonOutlet: UIButton!
    @IBOutlet weak var signUpButtonOutlet: UIButton!
    @IBOutlet weak var resendEmailButtonOutlet: UIButton!
    
    //Label
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    
    //MARK: - Vars
    var isLogin = true
    
    //MARK: View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButtonOutlet.layer.cornerRadius = 5
        updateUIFor(login: true)
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "ログイン")
        isLogin.toggle()
    }
    
    //MARK: - Animations
    private func updateUIFor(login: Bool) {
        
        loginButtonOutlet.setTitle(login ? "ログイン" : "新規作成", for: .normal)
        signUpLabel.text = login ? "新規アカウント作成は" : "既にアカウントをお持ちの方は"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
        }
    }
}
