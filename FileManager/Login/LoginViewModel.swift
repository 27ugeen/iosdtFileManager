//
//  LoginViewModel.swift
//  FileManager
//
//  Created by GiN Eugene on 20/3/2022.
//

import Foundation
import UIKit
import KeychainAccess

enum AuthorizationStrategy {
    case passwordEnter
    case paswordCreate
    case passwordChange
}

protocol LoginViewInputProtocol: AnyObject {
    func userTryAuthorize(withStrategy: AuthorizationStrategy)
}

protocol LoginViewOutputProtocol: AnyObject {
    func createPassword(userPassword: String, completition: @escaping (Error?) -> Void)
    func checkPasswordsAreEqual(userPassword: String) -> Bool
//    func logOutUser(completition: @escaping (Error?) -> Void)
}

final class LoginViewModel: LoginViewOutputProtocol {
    
    weak var view: LoginViewInputProtocol?
    
    private let keychain = Keychain(service: "com.gin.FileManager")
    private let keychainKey = "GinPassword"
    private var enteredPassword: String?
    
    func checkPasswordExists() -> Bool {
        
        enteredPassword = getPassword()
        guard (enteredPassword ?? "").count > 3 else {
            return false
        }
        return true
    }
    
    func createPassword(userPassword: String, completition: @escaping (Error?) -> Void) {
        do {
            try keychain.set(userPassword, key: keychainKey)
            print("New password has saved!")
        } catch let error {
            completition(error)
            print(error)
        }
    }
    
    private func getPassword() -> String {
        let keychain = Keychain()
        var password: String?
        do {
            password = try keychain.get("GinPassword")
        } catch let error {
            print("error: \(error)")
        }
        return password ?? ""
    }
    
    func checkPasswordsAreEqual(userPassword: String) -> Bool {
        
        enteredPassword = getPassword()
        
        guard userPassword == enteredPassword  else {
            return false
        }
        return true
    }
    
//    func changePassword(newPassword: String, completition: @escaping (Error?) -> Void) {
//        do {
//            try keychain.set(newPassword, key: keychainKey)
//            print("Password has been changed!")
//        } catch let error {
//            completition(error)
//            print(error)
//        }
//    }
    
    func logOutUser(completition: @escaping (Error?) -> Void) {
        do {
            try keychain.remove("GinPassword")
        } catch let error {
            completition(error)
        }
    }
}
