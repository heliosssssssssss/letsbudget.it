import SwiftUI

struct LaunchScreenView: View {
    @State private var progress: CGFloat = 0.0
    @State private var isActive = false

    var body: some View {
        ZStack {
            if isActive {
                OnboardingStageView()
            } else {
                LoadingView(progress: $progress)
                    .onAppear {
                        startLoadingProcess()
                    }
            }
        }
    }

    private func startLoadingProcess() {
        // Animate the progress bar
        withAnimation(.easeInOut(duration: 5.0)) {
            progress = 1.0
        }

        // Switch to OnboardingStageView after 5 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            print("Switching to OnboardingStageView...")
            isActive = true
        }
    }
}

struct LoadingView: View {
    @Binding var progress: CGFloat

    var body: some View {
        ZStack {
            Color(hex: "006EFF")
                .ignoresSafeArea()

            VStack {
                Spacer()

                // Logo
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300, height: 300)

                Spacer()

                // Progress bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(height: 10)
                        .foregroundColor(.white.opacity(0.3))
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: progress * UIScreen.main.bounds.width * 0.8, height: 10)
                        .foregroundColor(.white)
                }
                .frame(width: UIScreen.main.bounds.width * 0.8)
                .padding(.bottom, 40)
            }
        }
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
