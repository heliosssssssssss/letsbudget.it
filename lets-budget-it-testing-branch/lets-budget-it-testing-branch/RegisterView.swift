import SwiftUI
import AuthenticationServices


struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var phoneNumber: String = ""
    @State private var errorMessage: String?
    @State private var isRegistering: Bool = false
    @State private var navigateToOnboarding: Bool = false // Tracks navigation to OnboardingStage2

    var body: some View {
        NavigationStack {
            ZStack {
                Color.white
                    .ignoresSafeArea()

                VStack(spacing: 20) {
                    // Title
                    Text("Register")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    // Email Input
                    TextField("Email", text: $email)
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
                    SecureField("Password", text: $password)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 32)

                    // Confirm Password Input
                    SecureField("Confirm Password", text: $confirmPassword)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .padding(.horizontal, 32)

                    // Phone Number Input
                    TextField("Phone Number", text: $phoneNumber)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                        )
                        .keyboardType(.phonePad)
                        .padding(.horizontal, 32)

                    // Error Message
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.footnote)
                            .foregroundColor(.red)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }

                    // Loading Indicator
                    if isRegistering {
                        ProgressView("Registering...")
                            .padding()
                    }

                    // Register Button
                    Button(action: handleRegistration) {
                        Text("Register")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .padding(.horizontal, 32)
                    .padding(.top, 10)

                    // Sign in with Apple Button
                    SignInWithAppleButton(
                        .signUp,
                        onRequest: { request in
                            request.requestedScopes = [.email, .fullName]
                        },
                        onCompletion: { result in
                            switch result {
                            case .success(let authorization):
                                print("Successfully signed in with Apple: \(authorization)")
                                navigateToOnboarding = true
                            case .failure(let error):
                                errorMessage = "Apple Sign-Up failed: \(error.localizedDescription)"
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(height: 50)
                    .cornerRadius(10)
                    .padding(.horizontal, 32)

                    Spacer()

                    // PTB Footer Text
                    Text("This is a PTB - Private Testing Branch of: letsbudget.it - OAuth keys are validated for testing only - active Xcode build @ 0.1.017 - RegisterView is set to input mode.")
                        .font(.footnote)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 10)
                }
                .padding(.top, 50)
            }
            // Navigation Destination
            .navigationDestination(isPresented: $navigateToOnboarding) {
                OnboardingStage2View() // Replace with your actual OnboardingStage2 implementation
            }
        }
    }

    private func handleRegistration() {
        // Clear any existing error messages
        errorMessage = nil
        isRegistering = true

        // Input validations
        guard isValidEmail(email) else {
            errorMessage = "Please enter a valid email address."
            isRegistering = false
            return
        }

        guard password.count >= 6 else {
            errorMessage = "Password must be at least 6 characters long."
            isRegistering = false
            return
        }

        guard password == confirmPassword else {
            errorMessage = "Passwords do not match."
            isRegistering = false
            return
        }

        guard !phoneNumber.isEmpty else {
            errorMessage = "Please enter your phone number."
            isRegistering = false
            return
        }

        // Simulate registration process
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isRegistering = false
            navigateToOnboarding = true // Navigate to OnboardingStage2
            print("User registered with email: \(email), phone: \(phoneNumber)")
        }
    }

    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
