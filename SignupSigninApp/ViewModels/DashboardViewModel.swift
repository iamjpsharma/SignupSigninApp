//
//  DashboardViewModel.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//

import Foundation
import SwiftUI

class DashboardViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var showProfileView: Bool = false

    func loadUserData() {
        user = UserDefaultsManager.shared.getUser()
    }

    func logout() {
        UserDefaultsManager.shared.clearUser()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        print("User logged out.")
    }

    func showProfile() {
        showProfileView = true
    }


}
