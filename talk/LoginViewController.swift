//
//  LoginViewController.swift
//  talk
//
//  Created by 志村　啓太 on 2021/02/22.
//

import UIKit
import ProgressHUD

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
        setupBackgroundTap()
    }
    
    private func setupBackgroundTap() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundTap))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundTap() {
        view.endEditing(false)
    }
    
    //MARK: - IBActions
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            isLogin ? loginUser() : registerUser()
        } else {
            ProgressHUD.showFailed("全ての項目を入力してください。")
        }
    }
    
    @IBAction func forgotPasswordButtonPressed(_ sender: Any) {
        if isDataInputedFor(type: isLogin ? "login" : "register") {
            resetPassword()
        } else {
            ProgressHUD.showFailed("メールアドレスが入力されていません。")
        }
    }
    
    @IBAction func resendEmailButtonPressed(_ sender: Any) {
        if isDataInputedFor(type:"password") {
            resendVerificationEmail()
        } else {
            ProgressHUD.showFailed("メールアドレスが入力されていません。")
        }
    }
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) {
        updateUIFor(login: sender.titleLabel?.text == "ログイン")
        isLogin.toggle()
    }
    
    //MARK: - Animations
    private func updateUIFor(login: Bool) {
        
        loginButtonOutlet.setTitle(login ? "ログイン" : "新規作成", for: .normal)
        signUpLabel.text = login ? "新規アカウント作成は" : "既にアカウントをお持ちの方は"
        titleLabel.text = login ? "ログイン" : "新規登録"
        
        UIView.animate(withDuration: 0.5) {
            self.repeatPasswordTextField.isHidden = login
        }
    }
    
    //MARK: - Helpers
    private func isDataInputedFor(type: String) -> Bool {
        
        switch type {
        case "login":
            return emailTextField.text != "" && passwordTextField.text != ""
        case "registration":
            return emailTextField.text != "" && passwordTextField.text != "" && repeatPasswordTextField.text != ""
        default:
            return emailTextField.text != ""
        }
    }
    
    private func loginUser() {
        FirebaseUserListener.shared.loginUserWithEmail(email: emailTextField.text!, password: passwordTextField.text!) { (error, isEmailVerified) in
            
            if error == nil {
                if isEmailVerified {
                    
                    self.goToApp()
                } else {
                    ProgressHUD.showFailed("メールアドレスの確認が取れていません。")
                    self.resendEmailButtonOutlet.isHidden = false
                }
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func registerUser() {
        
        if passwordTextField.text == repeatPasswordTextField.text! {
            
            FirebaseUserListener.shared.registerUserWith(email: emailTextField.text!, password: passwordTextField.text!) { (error) in
                
                if error == nil {
                    ProgressHUD.showSuccess("確認メールを送信しました。")
                    self.resendEmailButtonOutlet.isHidden = false
                } else {
                    ProgressHUD.showFailed(error!.localizedDescription)
                }
            }
        } else {
            ProgressHUD.showFailed("パスワードが一致しません。")
        }
    }
    
    private func resetPassword() {
        FirebaseUserListener.shared.resetPasswordFor(email: emailTextField.text!) { (error) in
            
            if error == nil {
                ProgressHUD.showSuccess("パスワード変更メールを送信しました。")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
            }
        }
    }
    
    private func resendVerificationEmail() {
        FirebaseUserListener.shared.resendVerificationEmail(email: emailTextField.text!) { (error) in
            
            if error == nil {
                ProgressHUD.showSuccess("確認メールを送信しました。")
            } else {
                ProgressHUD.showFailed(error!.localizedDescription)
                print(error!.localizedDescription)
            }
        }
    }
    
    //MARK: - Navigation
    private func goToApp() {
        
        let mainView = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainView") as! UITabBarController
        
        mainView.modalPresentationStyle = .fullScreen
        self.present(mainView, animated: true, completion: nil)
    }
}
