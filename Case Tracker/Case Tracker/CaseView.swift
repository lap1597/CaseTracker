import SwiftUI

struct CaseView: View {
    let caseData: RootResponse

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Text(caseData.caseOwner ?? "Null").font(.title)
                Text("Case Number: \(caseData.getCaseNumber())")
                    .font(.title2)

                Text("Form Type: \(caseData.caseStatus.getFormType())").font(.caption)

        

                Text("Current Status")
                    .font(.title2)
                    .bold()
                Text(caseData.caseStatus.getCurrentCaseStatusText())
                    .font(.headline)
                Text(caseData.caseStatus.getCurrentCaseStatusDesc())
                    .font(.subheadline)
                    .foregroundColor(.gray)

//                if let days = daysSince(caseData.caseStatus.getModifiedDate()) {
//                                   Text("Last Updated: \(days) day\(days == 1 ? "" : "s") ago")
//                                       .font(.caption)
//                                       .foregroundColor(.secondary)
//                               } else {
//                                   Text("Last Updated: Unknown")
//                                       .font(.caption)
//                                       .foregroundColor(.red)
//                               }

                Divider()

                Text("Case History")
                    .font(.title2)
                    .bold()

                // Simplify the Case History Section
                VStack(alignment: .leading, spacing: 20) {
                    if let history = caseData.caseStatus.hist_case_status {
                        ForEach(history.indices, id: \.self) { index in
                            HStack(alignment: .top, spacing: 10) {
                                VStack {
                                    Circle()
                                        .fill(Color.blue)
                                        .frame(width: 12, height: 12)

                                    if index != history.count - 1 {
                                        Rectangle()
                                            .fill(Color.blue)
                                            .frame(width: 2, height: 40)
                                    }
                                }

                                VStack(alignment: .leading, spacing: 4) {
                                    Text(history[index].date ?? "Unknown date")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text(history[index].completedTextEN ?? "No description available")
                                        .font(.body)
                                }
                            }
                        }
                    } else {
                        Text("No case history available.")
                            .foregroundColor(.gray)
                            .italic()
                    }
                }
            }
            .padding()
            .padding(.bottom, 50)
        }
        .navigationTitle("Case Details")
    }
}
