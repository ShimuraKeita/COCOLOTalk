//
//  FirebaseUserListener.swift
//  talk
//
//  Created by 志村　啓太 on 2021/02/23.
//

import Foundation
import Firebase

class FirebaseUserListener {
    
    static let shared = FirebaseUserListener()
    
    private init () {}
    
    //MARK: - Login
    
    //MARK: - Registration
    func registerUserWith(email: String, password: String, completion: @escaping (_ error: Error?) -> Void) {
        
        Auth.auth().createUser(withEmail: email, password: password) { (authDataResult, error) in
            
            completion(error)
            
            if error == nil {
                
                //send verification email
                authDataResult!.user.sendEmailVerification { (error) in
                    print("auth email sent with error: ", error?.localizedDescription)
                }
                
                //create user and save it
                if authDataResult?.user != nil {
                    let user = User(id: authDataResult!.user.uid, username: "", email: email, pushId: "", avatarLink: "", status: "")
                }
            }
        }
    }
}
