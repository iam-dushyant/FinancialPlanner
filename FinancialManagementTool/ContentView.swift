import SwiftUI

struct ContentView: View {
    @State private var currentStep: Int = 0 // Tracks the current step
    @State private var name = ""
    @State private var email = ""
    @State private var selectedBanks: [String] = []
    @State private var thresholds = [
        "Rent": "",
        "Bills": "",
        "Groceries": "",
        "Travel": "",
        "Subscriptions": "",
        "Savings": ""
    ]

    let bankOptions = ["Lloyds", "Bank of Scotland", "Barclays", "Monzo", "HSBC", "Santander"]
    let totalSteps = 3 // Total number of steps for navigation

    var body: some View {
        VStack {
            // Step Content
            GeometryReader { geometry in
                HStack(spacing: 0) {
                    // Step 1: Name and Email
                    VStack {
                        Text("Enter Your Details")
                            .font(.title)
                            .bold()

                        TextField("Enter your name", text: $name)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()

                        TextField("Enter your email", text: $email)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .padding()
                    }
                    .frame(width: geometry.size.width) // Set width for step 1

                    // Step 2: Bank Selection
                    VStack {
                        Text("Select Your Bank Provider(s)")
                            .font(.title)
                            .bold()

                        ForEach(bankOptions, id: \.self) { bank in
                            Button(action: {
                                toggleBankSelection(bank: bank)
                            }) {
                                Text(bank)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedBanks.contains(bank) ? Color.blue : Color.gray.opacity(0.2))
                                    .foregroundColor(selectedBanks.contains(bank) ? Color.white : Color.black)
                                    .cornerRadius(8)
                            }
                        }
                    }
                    .frame(width: geometry.size.width) // Set width for step 2

                    // Step 3: Threshold Input
                    VStack {
                        Text("Set Thresholds")
                            .font(.title)
                            .bold()

                        ForEach(thresholds.keys.sorted(), id: \.self) { category in
                            HStack {
                                Text(category)
                                Spacer()
                                TextField("Enter amount", text: Binding(
                                    get: { thresholds[category] ?? "" },
                                    set: { thresholds[category] = $0 }
                                ))
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                                .frame(width: 100)
                            }
                        }
                    }
                    .frame(width: geometry.size.width) // Set width for step 3
                }
                .frame(width: geometry.size.width * CGFloat(totalSteps), alignment: .leading)
                .offset(x: -CGFloat(currentStep) * geometry.size.width) // Slide based on current step
                .animation(.easeInOut, value: currentStep)
            }

            // Navigation Buttons
            HStack {
                // Back Button (visible if not on the first step)
                if currentStep > 0 {
                    Button(action: {
                        withAnimation {
                            currentStep -= 1 // Navigate back
                        }
                    }) {
                        Text("Back")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.gray)
                            .foregroundColor(Color.white)
                            .cornerRadius(8)
                    }
                }

                Spacer() // Adds space between buttons

                // Next or Submit Button
                Button(action: {
                    withAnimation {
                        if currentStep < totalSteps - 1 {
                            currentStep += 1 // Navigate forward
                        } else {
                            submitData() // Submit data on the last step
                        }
                    }
                }) {
                    Text(currentStep < totalSteps - 1 ? "Next" : "Submit")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.green)
                        .foregroundColor(Color.white)
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }

    // Helper Functions
    private func toggleBankSelection(bank: String) {
        if selectedBanks.contains(bank) {
            selectedBanks.removeAll { $0 == bank }
        } else {
            selectedBanks.append(bank)
        }
    }

    private func submitData() {
        // Submission logic
        print("Name: \(name), Email: \(email)")
        print("Selected Banks: \(selectedBanks)")
        print("Thresholds: \(thresholds)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
