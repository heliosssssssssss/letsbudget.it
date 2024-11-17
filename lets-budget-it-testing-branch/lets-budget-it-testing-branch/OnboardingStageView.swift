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
    @State private var isLoading: Bool = false // Optional loading state

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("Login")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

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

                    SecureField("Password", text: $loginPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 32)

                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Loading Indicator (Optional)
                    if isLoading {
                        ProgressView("Logging in...")
                            .padding()
                    }

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
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 10)

                    SignInWithAppleButton(
                        .signIn,
                        onRequest: { request in
                            request.requestedScopes = [.email, .fullName]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(_):
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

                    Text("This is a PTB - Private Testing Branch of: letsbudget.it - OAuth keys are validated for testing only - active Xcode build @ 0.1")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }
                .padding(.top, 100)
            }
            .navigationDestination(isPresented: $navigateToNext) {
                OnboardingStage2View()
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

struct OnboardingStage2View: View {
    @State private var currentScreenIndex: Int = 0 // Tracks the current slide (0 = onboarding, 1-5 = questions)
    @State private var selectedOption: String? = nil // Tracks the selected option for questions
    @State private var showErrorMessage: Bool = false // Tracks if the user tries to proceed without selecting
    @State private var navigateToPermissions: Bool = false // Tracks if we move to OnboardingStage3View

    // Placeholder Questions and Options
    let questions = [
        "Q/1",
        "Q/2",
        "Q/3",
        "Q/4",
        "Q/5"
    ]

    let options = [
        ["Opt1", "Opt2", "Opt3", "Opt4"],
        ["Opt1", "Opt2", "Opt3", "Opt4"],
        ["Opt1", "Opt2", "Opt3", "Opt4"],
        ["Opt1", "Opt2", "Opt3", "Opt4"],
        ["Opt1", "Opt2", "Opt3", "Opt4"]
    ]

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Onboarding Slide
                    if currentScreenIndex == 0 {
                        VStack(spacing: 20) {
                            Text("Welcome, we got some onboarding questions")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            Text("We will use this information to smooth your process in setting up your account")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            Button(action: {
                                currentScreenIndex += 1 // Go to first question
                            }) {
                                Text("Start")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal, 32)
                        }
                    } else {
                        // Question Slide
                        Text(questions[currentScreenIndex - 1])
                            .font(.title2)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)

                        // Multi-choice options
                        VStack(spacing: 10) {
                            ForEach(options[currentScreenIndex - 1], id: \.self) { option in
                                Button(action: {
                                    selectedOption = option
                                    showErrorMessage = false // Clear error when an option is selected
                                }) {
                                    Text(option)
                                        .font(.body)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(selectedOption == option ? Color.blue.opacity(0.2) : Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(selectedOption == option ? Color.blue : Color.gray, lineWidth: 1)
                                        )
                                }
                                .padding(.horizontal, 32)
                            }
                        }

                        // Error message
                        if showErrorMessage {
                            Text("Please select an option before proceeding.")
                                .font(.footnote)
                                .foregroundColor(.red)
                                .padding(.horizontal, 32)
                        }

                        // Navigation Buttons
                        HStack(spacing: 20) {
                            // Go Back Button
                            if currentScreenIndex > 0 {
                                Button(action: {
                                    goBack()
                                }) {
                                    Text("Go Back")
                                        .font(.headline)
                                        .foregroundColor(.white)
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.gray)
                                        .cornerRadius(10)
                                        .shadow(radius: 5)
                                }
                            }

                            // Next Button
                            Button(action: {
                                handleNext()
                            }) {
                                Text(currentScreenIndex == questions.count ? "Finish" : "Next")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.blue)
                                    .cornerRadius(10)
                                    .shadow(radius: 5)
                            }
                        }
                        .padding(.horizontal, 32)

                        // Progress Bar
                        HStack(spacing: 4) {
                            ForEach(0..<5) { index in
                                Rectangle()
                                    .foregroundColor(index < currentScreenIndex ? Color.blue : Color.gray.opacity(0.3))
                                    .frame(height: 8)
                                    .cornerRadius(4)
                            }
                        }
                        .padding(.horizontal, 32)
                        .padding(.top, 10)
                    }
                }
                .padding()
            }
            .navigationDestination(isPresented: $navigateToPermissions) {
                OnboardingStage3View()
            }
        }
    }

    private func handleNext() {
        if currentScreenIndex == 0 || selectedOption != nil {
            showErrorMessage = false
            if currentScreenIndex < questions.count {
                currentScreenIndex += 1
                selectedOption = nil // Reset selection for the next question
            } else {
                navigateToPermissions = true // Navigate to OnboardingStage3View
            }
        } else {
            showErrorMessage = true // Show error if no option is selected
        }
    }

    private func goBack() {
        if currentScreenIndex > 0 {
            currentScreenIndex -= 1
            selectedOption = nil
            showErrorMessage = false
        }
    }
}

struct OnboardingStage3View: View {
    @State private var notificationGranted: Bool? = nil

    var body: some View {
        VStack(spacing: 20) {
            Text("Enable Notifications")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Text("Stay updated with important alerts and reminders. Please enable notifications to get the most out of this app.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button(action: requestNotificationPermission) {
                Text("Enable Notifications")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal, 32)

            if let granted = notificationGranted {
                Text(granted ? "Notifications Enabled!" : "Notifications Denied!")
                    .foregroundColor(granted ? .green : .red)
                    .padding(.top, 20)
            }
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }

    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async {
                notificationGranted = granted
            }
        }
    }
}





struct OnboardingStageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingStageView()
    }
}
