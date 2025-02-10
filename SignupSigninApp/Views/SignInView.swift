//
//  SignInView.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//

import SwiftUI

struct SignInView: View {
    @ObservedObject var viewModel = SignInViewModel()

    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("Welcome Back")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                if viewModel.showValidationErrors {
                    Text(viewModel.errorMessage ?? "Please fill all fields correctly.")
                        .foregroundColor(.red)
                        .font(.footnote)
                }

                TextField("Email", text: $viewModel.email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)

                HStack {
                    if viewModel.showPassword {
                        TextField("Password", text: $viewModel.password)
                    } else {
                        SecureField("Password", text: $viewModel.password)
                    }
                    Button(action: { viewModel.showPassword.toggle() }) {
                        Image(systemName: viewModel.showPassword ? "eye.slash" : "eye")
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                .background(Color(.secondarySystemBackground))
                .cornerRadius(8)

                Button(action: {
                    viewModel.handleSignIn()
                }) {
                    if viewModel.isLoading {
                        ProgressView()
                    } else {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(viewModel.isFormValid ? Color.blue : Color.gray)
                            .cornerRadius(8)
                    }
                }
                .disabled(!viewModel.isFormValid || viewModel.isLoading)

                NavigationLink(destination: SignupView().navigationBarBackButtonHidden(true), isActive: $viewModel.navigateToSignup) {
                    Button(action: {
                        viewModel.navigateToSignup = true
                    }) {
                        Text("New user? Sign up now")
                            .font(.footnote)
                            .foregroundColor(.blue)
                    }
                }

                // Add NavigationLink for dashboard
                NavigationLink(destination: DashboardView().navigationBarBackButtonHidden(true), isActive: $viewModel.navigateToDashboard) {
                    EmptyView()
                }
            }
            .padding()
        }
    }
}

#Preview {
    SignInView()
}
