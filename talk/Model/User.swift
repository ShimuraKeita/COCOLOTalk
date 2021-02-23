//
//  User.swift
//  talk
//
//  Created by 志村　啓太 on 2021/02/23.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct User: Codable, Equatable {
    
    var id = ""
    var username: String
    var email: String
    var pushId = ""
    var avatarLink = ""
    var status: String

    static var currentId: String {
        return Auth.auth().currentUser!.uid
    }
    
    static var curretnUser: User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.data(forKey: kCURRENTUSER) {
                
                let decoder = JSONDecoder()
                
                do {
                    let userObject = try decoder.decode(User.self, from: dictionary)
                    return userObject
                } catch {
                    print("Error decoding user from user defaults ", error.localizedDescription)
                }
            }
        }
        
        return nil
    }
    
    static func == (1hs: User, rhs: User) -> Bool {
        1hs.id == rhs.id
    }
}
