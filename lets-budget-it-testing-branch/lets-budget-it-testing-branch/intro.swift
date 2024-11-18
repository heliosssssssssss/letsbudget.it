import SwiftUI

struct IntroView: View {
    @State private var currentIndex = 0 // Tracks the current slide index
    @State private var dragOffset: CGFloat = 0 // Tracks the horizontal drag offset
    @State private var navigateToRegister: Bool = false // Tracks navigation to RegisterView

    // Slide content table: Customize slide-specific text here
    let slideContents = [
        "Slide - 1": "Welcome to the first slide!",
        "Slide - 2": "This is the second slide.",
        "Slide - 3": "Here's the third slide.",
        "Slide - 4": "Finally, the fourth slide."
    ]

    // Sorted slide keys for guaranteed order
    var sortedSlides: [(String, String)] {
        slideContents.sorted { $0.key < $1.key }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Slide Section (70% of the height)
                ZStack {
                    ForEach(Array(sortedSlides.enumerated()), id: \.offset) { index, slide in
                        ZStack(alignment: .topLeading) {
                            Color.blue
                                .ignoresSafeArea(edges: .top)

                            // Top-left corner text
                            VStack(alignment: .leading, spacing: 8) {
                                Text(slide.0) // Slide title
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)

                                Text(slide.1) // Slide content
                                    .font(.system(size: 16))
                                    .foregroundColor(.white)
                            }
                            .padding([.top, .leading], 16) // Add padding for spacing
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .offset(x: CGFloat(index - currentIndex) * UIScreen.main.bounds.width + dragOffset) // Slide positioning
                        .animation(.easeInOut(duration: 0.4), value: currentIndex) // Smooth animation
                    }
                }
                .frame(height: UIScreen.main.bounds.height * 0.7) // Covers 70% of the height
                .gesture(
                    DragGesture()
                        .onChanged { gesture in
                            dragOffset = gesture.translation.width // Track horizontal drag offset
                        }
                        .onEnded { gesture in
                            if gesture.translation.width < -100 && currentIndex < sortedSlides.count - 1 {
                                // Swipe left to go forward
                                currentIndex += 1
                            } else if gesture.translation.width > 100 && currentIndex > 0 {
                                // Swipe right to go backward
                                currentIndex -= 1
                            }
                            dragOffset = 0 // Reset drag offset
                        }
                )

                // Rectangular Position Indicators
                HStack(spacing: 8) {
                    ForEach(0..<sortedSlides.count, id: \.self) { index in
                        Rectangle()
                            .fill(index == currentIndex ? Color.blue : Color.gray.opacity(0.4))
                            .frame(width: 20, height: 6)
                            .cornerRadius(3)
                    }
                }
                .padding(.vertical, 16)

                // Next Button
                Button(action: {
                    if currentIndex < sortedSlides.count - 1 {
                        currentIndex += 1 // Move to the next slide
                    } else {
                        navigateToRegister = true // Navigate to RegisterView
                    }
                }) {
                    Text(currentIndex == sortedSlides.count - 1 ? "Let's Start" : "Next")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 200) // Slightly reduce the button width
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.bottom, 8)

                // Already a member? Text
                NavigationLink(destination: OnboardingStageView()) {
                    Text("Already a member?")
                        .font(.footnote) // Slightly bigger font size
                        .foregroundColor(.gray.opacity(0.7)) // Make it a bit darker gray
                        .padding(.top, 4) // Move it slightly up
                }

                // Bottom White Section
                Spacer()
            }
            .background(Color.white) // Ensures the bottom section is white
            .navigationDestination(isPresented: $navigateToRegister) {
                RegisterView() // Navigate to the RegisterView
            }
        }
    }
}

struct SlideWithIndicators_Previews: PreviewProvider {
    static var previews: some View {
        IntroView()
    }
}
