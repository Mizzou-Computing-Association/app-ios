//
//  ProfileViewController.swift
//  TigerHacks-App
//
//  Created by Jacob Sokora on 9/6/19.
//  Copyright © 2019 Zukosky, Jonah. All rights reserved.
//

import UIKit
import FirebaseAuth
import GoogleSignIn

class ProfileViewController: UIViewController {

	@IBOutlet weak var loadingSpinner: UIActivityIndicatorView!

	@IBOutlet weak var emailTextField: UITextField!
	@IBOutlet weak var passwordTextField: UITextField!
	@IBOutlet weak var signInButton: UIButton!
	@IBOutlet weak var githubButton: UIButton!
	@IBOutlet weak var googleButton: UIButton!

	@IBOutlet weak var tigerPassImageView: UIImageView!
	@IBOutlet weak var registerButton: UIButton!
	@IBOutlet weak var signOutButton: UIButton!

	var githubProvider: OAuthProvider?

	override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
		Auth.auth().addStateDidChangeListener { _, user in
			self.refresh()
		}
		view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
    }

	@objc func tap() {
		view.endEditing(true)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		refresh()
	}

	func refresh() {
		let signedIn = Auth.auth().currentUser != nil
		emailTextField.isHidden = signedIn
		passwordTextField.isHidden = signedIn
		signInButton.isHidden = signedIn
		githubButton.isHidden = signedIn
		googleButton.isHidden = signedIn

		title = signedIn ? "Profile" : "Sign In"

		if signedIn {
			loadingSpinner.startAnimating()
			Model.sharedInstance.getProfile { profile in
				DispatchQueue.main.async {
					guard let profile = profile else { return }
					self.tigerPassImageView.isHidden = false
					do {
					self.tigerPassImageView.image = try UIImage(data: Data(contentsOf: URL(string: profile.pass)!))
					} catch {}
					self.registerButton.isHidden = profile.registered
					self.signOutButton.isHidden = false
					self.loadingSpinner.stopAnimating()
				}
			}
		} else {
			tigerPassImageView.isHidden = !signedIn
			registerButton.isHidden = !signedIn
			signOutButton.isHidden = !signedIn
		}
	}

	@IBAction func signIn(_ sender: Any) {
		view.endEditing(true)
		guard let email = emailTextField.text, let password = passwordTextField.text, isEmail(email) else {
			return
		}
		Auth.auth().fetchSignInMethods(forEmail: email) { providers, _ in
			if providers == nil {
				Auth.auth().createUser(withEmail: email, password: password) { result, _ in
					self.register()
				}
			} else {
				Auth.auth().signIn(withEmail: email, password: password)
			}
		}
	}

	@IBAction func githubSignIn(_ sender: Any) {
		githubProvider = OAuthProvider(providerID: "github.com")
		githubProvider?.getCredentialWith(nil) { credential, _ in
			if let credential = credential {
				Auth.auth().signIn(with: credential)
			}
		}
	}

	@IBAction func googleSignIn(_ sender: Any) {
		GIDSignIn.sharedInstance()?.presentingViewController = self
		GIDSignIn.sharedInstance()?.signIn()
	}

	@IBAction func signOut(_ sender: Any) {
		do {
			try Auth.auth().signOut()
			refresh()
		} catch let signOutError as NSError {
			print("Error signing out: %@", signOutError)
		}
	}
	
	@IBAction func register() {
		UIApplication.shared.open(URL(string: "https://tigerhacks.com")!)
	}

	/*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

	func isEmail(_ string: String) -> Bool {
		let emailRegex = ".+@([a-zA-Z0-9\\-]+\\.)+[a-zA-Z0-9]{2,63}"
		let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
		let result = emailTest.evaluate(with: string)
		return result
	}

}
