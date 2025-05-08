// Case.swift
// Final
//
// Created by Lap Pham on 3/9/25.

import SwiftUI

class CaseManager: ObservableObject {
    @Published var cases: [RootResponse] = []
    var services = Services()

    func addCase(_ newCase: RootResponse) {
        // Check if the case already exists by caseNumber
        if let index = cases.firstIndex(where: { $0.caseNumber == newCase.caseNumber }) {
            // If the case exists, update it
            cases[index] = newCase
        } else {
            
            cases.append(newCase)
        }
    }
    func sortCasesByOwner(ascending: Bool) {
        if ascending {
            cases.sort { $0.getCaseOwner().localizedCompare($1.getCaseOwner()) == .orderedAscending }
        } else {
            cases.sort { $0.getCaseOwner().localizedCompare($1.getCaseOwner()) == .orderedDescending }
        }
    }
    func deleteCase(at offsets: IndexSet) {
           cases.remove(atOffsets: offsets)
           print("Case(s) at offsets \(offsets) deleted.")
       }
    // Method to fetch and update all cases
    func refreshCases() async {
        for caseData in cases {
            // For each case, check if it needs to be updated by its caseNumber
            do {
                let updatedCase = try await services.fetchData(caseNumber: caseData.caseNumber ?? "", caseName: caseData.caseOwner ?? "")
                DispatchQueue.main.async {
                    self.addCase(updatedCase) // Add or update the case
                }
            } catch {
                print("Error refreshing case: \(error)")
            }
        }
    }
}

struct RootResponse: Decodable {
let caseStatus: Case
var caseOwner: String?
var caseNumber: String?

enum CodingKeys: String, CodingKey {
    case caseStatus = "case_status"
}

mutating func setCaseOwner(_ caseOwner: String?) {
    self.caseOwner = caseOwner
}

mutating func setCaseNumber(_ caseNumber: String?) {
    self.caseNumber = caseNumber
}

func getCaseOwner() -> String {
    return caseOwner ?? "Unknown" // Return a default value if caseOwner is nil
}

func getCaseNumber() -> String {
    return caseNumber ?? "Unknown" // Return a default value if caseNumber is nil
}

struct CaseHistory: Decodable {
    let date: String?
    let completedTextEN: String?
   

    enum CodingKeys: String, CodingKey {
        case date
        case completedTextEN = "completed_text_en"
       
    }
}

struct Case: Decodable {
    let receiptNumber: String
    let formType: String
    let submittedDate: String
    let modifiedDate: String
    let current_case_status_text_en: String
    let current_case_status_desc_en: String
    let hist_case_status: [CaseHistory]?

    func getFormType() -> String {
        return formType
    }

    func getSubmittedDate() -> String {
        return submittedDate
    }

    func getModifiedDate() -> String {
        return modifiedDate
    }

    func getCurrentCaseStatusText() -> String {
        return current_case_status_text_en
    }

    func getCurrentCaseStatusDesc() -> String {
        return current_case_status_desc_en
    }

    func getCaseHistory() -> [CaseHistory]? {
        return hist_case_status // If null, return nil, else return the history array
    }
}
}
