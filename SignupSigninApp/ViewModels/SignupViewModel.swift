//
//  SignupViewModel.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//

import SwiftUI

struct SignupResponse: Codable {
    let success: Bool
    let message: String
}

class SignupViewModel: ObservableObject {
    @Published var fullName: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    @Published var dateOfBirth: Date = Calendar.current.date(byAdding: .year, value: -18, to: Date())!
    @Published var gender: String = "Male"
    @Published var showPassword: Bool = false
    @Published var showConfirmPassword: Bool = false
    @Published var errorMessage: String? = nil
    @Published var isLoading: Bool = false
    @Published var showValidationErrors: Bool = false
    @Published var showSignupError: Bool = false
    @Published var navigateToDashboard: Bool = false

    private let keyChainHelper = KeyChainHelper()

    var isFormValid: Bool {
        return !fullName.isEmpty &&
            ValidationHelper.isValidEmail(email) &&
            ValidationHelper.isValidPassword(password) &&
            password == confirmPassword
    }

    func handleSignup() {
        showValidationErrors = true

        guard isFormValid else {
            errorMessage = "Please fix the errors and try again."
            showSignupError = true
            return
        }

        isLoading = true
        errorMessage = nil

        let parameters: [String: Any] = [
            "name": fullName,
            "email": email,
            "password": password,
            "date_of_birth": dateOfBirth.timeIntervalSince1970,
            "gender": gender,
        ]

        NetworkManager.shared.postRequest(
            urlString: "https://yfguy.free.beeceptor.com/signup",
            parameters: parameters,
            responseType: SignupResponse.self
        ) { result in
            DispatchQueue.main.async {
                self.isLoading = false
                switch result {
                case .success(let signupResponse):
                    if signupResponse.success {
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaultsManager.shared.saveUser(User(fullName: self.fullName, email: self.email))
                        self.navigateToDashboard = true
                        if self.saveDataToKeychain(data: self.email, forKey: "email") {
                            print("Email saved to Keychain!")
                        } else {
                            print("Failed to save email to Keychain.")
                        }
                    } else {
                        self.errorMessage = signupResponse.message
                        self.showSignupError = true
                    }
                case .failure(let error):
                    self.errorMessage = "Error: \(error.localizedDescription)"
                    self.showSignupError = true
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
