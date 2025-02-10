//
//  ProfileView.swift
//  SignupSigninApp
//
//  Created by jaiprakash sharma on 10/02/25.
//

import SwiftUI

struct ProfileView: View {
    let user: User?

    var body: some View {
        VStack(spacing: 20) {
            Text("Profile")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            if let user = user {
                Text("Name: \(user.fullName)")
                    .font(.headline)

                Text("Email: \(user.email)")
                    .font(.subheadline)

            } else {
                Text("User data not available.")
                    .foregroundColor(.red)
            }

            Spacer()
        }
        .padding()
    }
}

#Preview {
    ProfileView(user: User(fullName: "John Doe", email: "john.doe@example.com"))
}
