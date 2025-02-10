//
//  DashboardView.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//

import SwiftUI
import LocalAuthentication

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    @State private var isLoggedIn = UserDefaults.standard.bool(forKey: "isLoggedIn")
    @State private var isUnlocked = false // State to track if the app is unlocked

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                if isLoggedIn && isUnlocked {
                    Text("Welcome, \(viewModel.user?.fullName ?? "User")!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    Text("Email: \(viewModel.user?.email ?? "Not available")")
                        .font(.subheadline)
                    
                    VStack(spacing: 10) {
                        Button(action: viewModel.showProfile) {
                            Text("View Profile")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(8)
                        }

                        Button(action: {
                            viewModel.logout()
                            isLoggedIn = false
                            isUnlocked = false
                        }) {
                            Text("Log Out")
                                .font(.headline)
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color(.secondarySystemBackground))
                                .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)

                    NavigationLink(destination: ProfileView(user: viewModel.user), isActive: $viewModel.showProfileView) {
                        EmptyView()
                    }

                    Spacer()
                } else if !isLoggedIn {
                    NavigationLink(destination: SignInView().navigationBarBackButtonHidden(true), isActive: .constant(true)) {
                        EmptyView()
                    }
                } else {
                    Text("Authenticating...")
                        .font(.title)
                        .padding()
                }
            }
            .padding()
            .onAppear {
                if isLoggedIn {
                    authenticateWithFaceID()
                } else {
                    isLoggedIn = false
                }
            }
        }
    }

    private func authenticateWithFaceID() {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports Face ID and if the user has enrolled face
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to access your dashboard"

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // Authentication successful
                        isUnlocked = true
                        viewModel.loadUserData()
                    } else {
                        // Authentication failed
                        isUnlocked = false
                        // Handle the error
                        viewModel.logout()
                        isLoggedIn = false
                    }
                }
            }
        } else {
            // Face ID not available, handle accordingly
            isUnlocked = true // Fallback to normal login if Face ID is not available
            viewModel.loadUserData()
        }
    }
}

#Preview {
    DashboardView()
}

#Preview {
    DashboardView()
}
