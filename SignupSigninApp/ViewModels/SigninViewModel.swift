//
//  SigninViewModel.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//


import SwiftUI
import Combine

struct SignInResponse: Codable {
    let type: String
    let user: User
}

class SignInViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var showPassword: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var navigateToDashboard: Bool = false
    @Published var navigateToSignup: Bool = false
    @Published var showValidationErrors: Bool = false

    private let keyChainHelper = KeyChainHelper()

    var isFormValid: Bool {
        return ValidationHelper.isValidEmail(email) && !password.isEmpty
    }
    
    func handleSignIn() {
        guard isFormValid else {
            errorMessage = "Please fill all fields correctly."
            showValidationErrors = true
            return
        }

        isLoading = true
        errorMessage = nil
        showValidationErrors = false

        let parameters: [String: Any] = [
            "email": email,
            "password": password
        ]

        NetworkManager.shared.postRequest(
            urlString: "https://nike4s.free.beeceptor.com/signin",
            parameters: parameters,
            responseType: SignInResponse.self
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let signInResponse):
                    UserDefaultsManager.shared.saveUser(signInResponse.user)
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    if self.saveDataToKeychain(data: self.email, forKey: "email") {
                        print("Email saved to Keychain!")
                    } else {
                        print("Failed to save email to Keychain.")
                    }
                    self.navigateToDashboard = true
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                }
            }
        }
    }
    
    func saveDataToKeychain(data: String, forKey key: String) -> Bool {
        return keyChainHelper.saveToKeychain(stringData: data, forKey: key)
    }
    
    func retrieveDataFromKeychain(forKey key: String) -> String? {
        return keyChainHelper.getFromKeychain(forKey: key)
    }
}
