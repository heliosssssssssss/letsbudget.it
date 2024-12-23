//
//  OnboardingStageView.swift
//  lets-budget-it-testing-branch
//
//  Created by user267420 on 11/17/24.
//

import SwiftUI
import UserNotifications
import Contacts
import AuthenticationServices

struct OnboardingStageView: View {
    @State private var loginEmail: String = ""
    @State private var loginPassword: String = ""
    @State private var errorMessage: String?
    @State private var navigateToNext: Bool = false
    @State private var isLoading: Bool = false
    @State private var navigateToRegister: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 24) {
                    Spacer()

                    // Title
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)

                    // Email Input
                    TextField("Email", text: $loginEmail)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .autocapitalization(.none)
                        .keyboardType(.emailAddress)
                        .padding(.horizontal, 32)

                    // Password Input
                    SecureField("Password", text: $loginPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 32)

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Login Button
                    Button(action: {
                        handleLogin()
                    }) {
                        Text("Login")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .padding(.horizontal, 32)

                    // Register Button
                    Button(action: {
                        navigateToRegister = true
                    }) {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.blue)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.blue, lineWidth: 1)
                            )
                    }
                    .padding(.horizontal, 32)


                    // Sign in with Apple Button
                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.email, .fullName]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                print("Successfully signed in with Apple: \(authorization)")
                                navigateToNext = true
                            case .failure(let error):
                                errorMessage = "Apple Sign-In failed: \(error.localizedDescription)"
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)
                    .padding(.top, 10)

                    Spacer()

                    // Footer Text
                    Text("This is a PTB - Private Testing Branch of: letsbudget.it - OAuth keys are validated for testing only - active Xcode build @ 0.1.017 - LoginView is set to input mode.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }
            }
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView()
            }
        }
    }

    private func handleLogin() {
        errorMessage = nil
        isLoading = true // Start loading

        if !isValidEmail(loginEmail) {
            errorMessage = "Please enter a valid email address."
            isLoading = false
            return
        }

        if loginPassword.count < 6 {
            errorMessage = "Password must be at least 6 characters long."
            isLoading = false
            return
        }

        // Simulate delay for login
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isLoading = false // Stop loading
            navigateToNext = true // Navigate to next view
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}


struct OnboardingStageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStageView()
    }
}
