//
//  LoginViewController.swift
//  FileManager
//
//  Created by GiN Eugene on 20/3/2022.
//

import UIKit

class LogInViewController: UIViewController, LoginViewInputProtocol {
    
    let loginViewModel: LoginViewModel
    
    var currentStrategy: AuthorizationStrategy = .loggedIn
    
    var isSignUp: Bool = true {
        willSet {
            if newValue {
                loginButton.setTitle("Enter password", for: .normal)
                switchLoginButton.setTitle("You don't have a password yet? Create", for: .normal)
            } else {
                loginButton.setTitle("Create password", for: .normal)
                switchLoginButton.setTitle("Do you already have a password? Sign In", for: .normal)
            }
        }
    }
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    
    let contentView: UIView = {
        let content = UIView()
        content.translatesAutoresizingMaskIntoConstraints = false
        return content
    }()
    
    let passwordTextField: UITextField = {
        let text = UITextField()
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .systemGray6
        text.layer.borderColor = UIColor.lightGray.cgColor
        text.layer.borderWidth = 0.5
        text.layer.cornerRadius = 10
        text.textColor = .black
        text.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        text.tintColor = UIColor(named: "myAccentColor")
        text.autocapitalizationType = .none
        text.placeholder = " Password"
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: text.frame.height))
        text.leftViewMode = .always
        text.isSecureTextEntry = true
        return text
    }()
    
    lazy var loginButton = MagicButton(title: "Enter password", titleColor: .white) {
        self.goToProfile()
    }
    
    lazy var switchLoginButton = MagicButton(title: "You don't have a password yet? Create", titleColor: .systemBlue) {
        self.isSignUp = !self.isSignUp
    }
    
    init(loginViewModel: LoginViewModel) {
        self.loginViewModel = loginViewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLoginButton()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        loginViewModel.createListener { auth, user in
//            if user != nil {
//                let profileVC = ProfileViewController(userService: CurrentUserService(), userName: (auth.currentUser?.email)!, loginViewModel: self.loginViewModel)
//                if !profileVC.isViewLoaded {
//                    self.navigationController?.pushViewController(profileVC, animated: true)
//                }
//                print("User is signed in")
//                print("Current user: \(String(describing: user?.email))")
//            } else {
//                print("No user is signed in.")
//            }
//        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        loginViewModel.removeListener()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func showAlert(message: String) {
        let alertVC = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func goToProfile() {
        if !isSignUp {
            currentStrategy = .newUser
        } else {
            currentStrategy = .loggedIn
        }
        
        if(!(passwordTextField.text ?? "").isEmpty) {
            userTryAuthorize(withStrategy: currentStrategy)
        } else {
            showAlert(message: "Please fill the password field!")
        }
    }
    
    func userTryAuthorize(withStrategy: AuthorizationStrategy) {
        switch currentStrategy {
        case .loggedIn:
            loginViewModel.signInUser(userPassword: passwordTextField.text ?? "") { error in
                if let unwrappedError = error {
                    print("error is: \(String(describing: unwrappedError.localizedDescription))")
                    self.showAlert(message: String(describing: unwrappedError.localizedDescription))
//                    return
                }
            }
            let docsVC = DocsViewController(docsViewModel: DocsViewModel().self)
            self.navigationController?.pushViewController(docsVC, animated: true)
        case .newUser:
            loginViewModel.createUser(userPassword: passwordTextField.text ?? "") { error in
                if let unwrappedError = error {
                    print("error is: \(String(describing: unwrappedError.localizedDescription))")
                    self.showAlert(message: String(describing: unwrappedError.localizedDescription))
                }
            }
        }
    }
}

extension LogInViewController {
    func setupLoginButton() {
        let backgroundImage = UIImage(named: "blue_pixel")
        let trasparentImage = backgroundImage!.alpha(0.8)
        
        loginButton.setBackgroundImage(backgroundImage, for: .normal)
        loginButton.setBackgroundImage(trasparentImage, for: .selected)
        loginButton.setBackgroundImage(trasparentImage, for: .highlighted)
        loginButton.setBackgroundImage(trasparentImage, for: .disabled)
        loginButton.layer.cornerRadius = 10
        loginButton.clipsToBounds = true
        
        switchLoginButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
    }
}

extension LogInViewController {
    func setupViews() {
        view.backgroundColor = .white
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(passwordTextField)
        contentView.addSubview(loginButton)
        contentView.addSubview(switchLoginButton)
        
        let constraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor),
            
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            passwordTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextField.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            passwordTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            switchLoginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            switchLoginButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 5),
            switchLoginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            switchLoginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            switchLoginButton.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

private extension LogInViewController {
    @objc
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            scrollView.contentInset.bottom = keyboardSize.height
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    @objc
    func keyboardWillHide(notification: NSNotification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets = .zero
    }
}
