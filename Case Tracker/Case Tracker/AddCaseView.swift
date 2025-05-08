import SwiftUI

struct AddCaseView: View {
    @EnvironmentObject var caseStore: CaseManager
    @Environment(\.dismiss) var dismiss
    
    @State private var caseNumber: String = ""
    @State private var caseName: String = ""
    @State private var isLoading: Bool = false
    @State private var errorMessage: String? = nil
    var service = Services()
    
    var body: some View {
        ZStack {
            Color.cyan.ignoresSafeArea()
            
            VStack(spacing: 16) {
                // Case Number Field
                TextField("Your case number...", text: $caseNumber)
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Case Name Field
                TextField("Case Name", text: $caseName)
                    .multilineTextAlignment(.center)
                    .frame(width: 300, height: 40)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                // Add Case Button
                Button(action: {
                    Task {
                        await addCase()
                    }
                }) {
                    Text("Add Case")
                        .font(.headline)
                        .frame(width: 120, height: 40)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(20)
                }
                .disabled(isLoading || caseNumber.isEmpty || caseName.isEmpty)
                
                // Loading Indicator
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                }
                
                // Error Message
                if let errorMessage = errorMessage {
                   Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
                }
            }
        }
//        .alert(isPresented: .constant(errorMessage != nil)) {
//            Alert(
//                title: Text("Error"),
//                message: Text(errorMessage ?? "An unexpected error occurred."),
//                dismissButton: .default(Text("OK"), action: {
//                    errorMessage = nil // Reset error message after dismissing the alert
//                })
//            )
//        }
    }
    
    private func addCase() async {
        isLoading = true
        do {
            let fetched = try await service.fetchData(caseNumber: caseNumber, caseName: caseName)
            caseStore.addCase(fetched)
            dismiss()
        } catch {
            print("Error fetching data: \(error)")
            errorMessage = "Invalid case number or network issue. Please try again."  // Custom error message
        }
        isLoading = false
    }
}

