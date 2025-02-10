//
//  UserDefaultsManager.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//

import Foundation

class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private let userKey = "loggedInUser"

    private init() {}

    func saveUser(_ user: User) {
        if let encoded = try? JSONEncoder().encode(user) {
            UserDefaults.standard.set(encoded, forKey: userKey)
        }
    }

    func getUser() -> User? {
        guard let data = UserDefaults.standard.data(forKey: userKey),
              let user = try? JSONDecoder().decode(User.self, from: data) else {
            return nil
        }
        return user
    }

    func clearUser() {
        UserDefaults.standard.removeObject(forKey: userKey)
    }
}
