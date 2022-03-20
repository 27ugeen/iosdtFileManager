//
//  LoginViewModel.swift
//  FileManager
//
//  Created by GiN Eugene on 20/3/2022.
//

import Foundation
import UIKit

enum AuthorizationStrategy {
    case loggedIn
    case newUser
}

protocol LoginViewInputProtocol: AnyObject {
    func userTryAuthorize(withStrategy: AuthorizationStrategy)
}

protocol LoginViewOutputProtocol: AnyObject {
    func signInUser(userPassword: String, completition: @escaping (Error?) -> Void)
    func createUser(userPassword: String, completition: @escaping (Error?) -> Void)
    func logOutUser(completition: @escaping (Error?) -> Void)
}

final class LoginViewModel: LoginViewOutputProtocol {
    
    weak var view: LoginViewInputProtocol?
    
//    var handle: AuthStateDidChangeListenerHandle?
    
    func createUser(userPassword: String, completition: @escaping (Error?) -> Void) {
//        Auth.auth().createUser(withEmail: userLogin, password: userPassword) { authResult, error in
//            if let result = authResult {
//                print("Result: \(result)")
//                print("Create result: \(String(describing: result.user.email))")
//                let ref = Database.database(url: "https://ginnavigation-default-rtdb.europe-west1.firebasedatabase.app").reference().child("users")
//                ref.child(result.user.uid).updateChildValues(["name" : result.user.email!])
//            } else if let error = error as NSError? {
//                completition(error)
//                return
//            }
//        }
    }
    
    func signInUser(userPassword: String, completition: @escaping (Error?) -> Void) {
//        Auth.auth().signIn(withEmail: userLogin, password: userPassword) { authResult, error in
//            if let result = authResult {
//                print("Result: \(result)")
//                print("Sign in result: \(String(describing: result.user.email))")
//            } else if let error = error as NSError? {
//                completition(error)
//                return
//            }
//        }
    }
    
    func logOutUser(completition: @escaping (Error?) -> Void) {
//        do {
//            try Auth.auth().signOut()
//            completition(nil)
//        }
//        catch let error as NSError {
//            completition(error)
//        }
    }
    
//    func createListener(completition: @escaping (FirebaseAuth.Auth, FirebaseAuth.User?) -> Void) {
//        handle = Auth.auth().addStateDidChangeListener { auth, user in
//                completition(auth, user)
//        }
//    }
    
    func removeListener() {
//        Auth.auth().removeStateDidChangeListener(handle!)
    }
}
