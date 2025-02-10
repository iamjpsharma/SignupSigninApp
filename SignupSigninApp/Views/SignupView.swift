//
//  SignupView.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//
import SwiftUI

struct SignupView: View {
    @StateObject private var viewModel = SignupViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Create an Account")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)

                    // Full Name Field
                    TextField("Full Name", text: $viewModel.fullName)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .overlay(
                            Text(viewModel.fullName.isEmpty && viewModel.showValidationErrors ? "Full name is required." : "")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5),
                            alignment: .bottomLeading
                        )

                    // Email Field
                    TextField("Email", text: $viewModel.email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)
                        .overlay(
                            Text(!ValidationHelper.isValidEmail(viewModel.email) && viewModel.showValidationErrors ? "Enter a valid email." : "")
                                .foregroundColor(.red)
                                .font(.footnote)
                                .padding(.top, 5),
                            alignment: .bottomLeading
                        )

                    // Password Field
                    VStack(alignment: .leading, spacing: 5) {
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

                        if viewModel.showValidationErrors {
                            Text(viewModel.password.isEmpty ? "Password is required." : "")
                                .foregroundColor(.red)
                                .font(.footnote)

                            Text(viewModel.password.isEmpty || ValidationHelper.isValidPassword(viewModel.password) ? "" : "Password must contain at least 6 characters, 1 uppercase letter, 1 number, and 1 special character.")
                                .foregroundColor(.red)
                                .font(.footnote)
                        }
                    }

                    // Confirm Password Field
                    HStack {
                        if viewModel.showConfirmPassword {
                            TextField("Confirm Password", text: $viewModel.confirmPassword)
                        } else {
                            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                        }
                        Button(action: { viewModel.showConfirmPassword.toggle() }) {
                            Image(systemName: viewModel.showConfirmPassword ? "eye.slash" : "eye")
                                .foregroundColor(.gray)
                        }
                    }
                    .padding()
                    .background(Color(.secondarySystemBackground))
                    .cornerRadius(8)
                    .overlay(
                        Text(viewModel.confirmPassword != viewModel.password && viewModel.showValidationErrors ? "Passwords do not match." : "")
                            .foregroundColor(.red)
                            .font(.footnote)
                            .padding(.top, 5),
                        alignment: .bottomLeading
                    )

                    // Date of Birth Field
                    DatePicker("Date of Birth", selection: $viewModel.dateOfBirth, in: ...Calendar.current.date(byAdding: .year, value: -18, to: Date())!, displayedComponents: .date)
                        .padding()
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(8)

                    // Gender Picker
                    Picker("Gender", selection: $viewModel.gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                        Text("Others").tag("Others")
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()

                    // Sign Up Button
                    Button(action: viewModel.handleSignup) {
                        Text("Sign Up")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(8)
                    }
                    .alert(isPresented: $viewModel.showSignupError) {
                        Alert(
                            title: Text("Signup Error"),
                            message: Text(viewModel.errorMessage ?? "Something went wrong."),
                            dismissButton: .default(Text("OK"))
                        )
                    }

                    // Navigation to Sign In
                    NavigationLink(destination: SignInView().navigationBarBackButtonHidden(true)) {
                        Text("Already registered? Sign in")
                            .font(.footnote)
                            .foregroundColor(.blue)
                            .padding(.top, 10)
                    }
                    
                    // NavigationLink for dashboard
                    NavigationLink(destination: DashboardView().navigationBarBackButtonHidden(true), isActive: $viewModel.navigateToDashboard) {
                        EmptyView()
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    SignupView()
}

