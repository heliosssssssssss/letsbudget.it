//
//  OnboardingStage2.swift
//  lets-budget-it-testing-branch
//
//  Created by user267420 on 11/18/24.
//

import SwiftUI

struct OnboardingStage2View: View {
    @State private var currentScreenIndex: Int = 0 // Tracks the current slide (0 = onboarding, 1-5 = questions)
    @State private var selectedOption: String? = nil // Tracks the selected option for questions
    @State private var showErrorMessage: Bool = false // Tracks if the user tries to proceed without selecting
    @State private var navigateToPermissions: Bool = false // Tracks if we move to OnboardingStage3View

    // Placeholder Questions and Options
    let questions = [
        "How confident are you in managing your budget?",
        "Q/2",
        "Q/3",
        "Q/4",
        "Q/5"
    ]
    
    // Onboarding Answers (linked with each q/number
    // multi opton (4) choice - only 1 choice per option
    
    let options = [
        ["I have no experience with budgeting.", "I have some experience and want to learn more.", "I have good budgeting habits but can improve.", "I have excellent budgeting skills."],
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
                            Text("Let's personalize your experience.")
                                .font(.title)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 32)

                            Text("Answer a few quick questions to help us set up your account for success.")
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
    var body: some View {
        VStack(spacing: 20) {
            // Permission Title
            Text("Enable Notifications")
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            // Permission Description
            Text("Stay updated with alerts and reminders. Please enable notifications to get the most out of this app.")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .lineSpacing(4) // Adjust for tighter text spacing
                .padding()

            // Allow Button
            Button("Allow Notifications") {
                requestNotificationPermission()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
        .background(Color.white.ignoresSafeArea())
    }

    // Request notification permissions
    private func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Error requesting notifications permission: \(error.localizedDescription)")
            } else {
                print(granted ? "Notifications permission granted." : "Notifications permission denied.")
                // Navigate to the next view or handle logic here
            }
        }
    }
}
