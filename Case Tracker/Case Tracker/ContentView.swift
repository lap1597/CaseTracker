import SwiftUI

struct ContentView: View {
    @State private var selectedIndex: Int? = nil
    @StateObject var caseManager = CaseManager()
    @State private var isSortAscending: Bool = true
    let icons = [
        "arrow.up.arrow.down",
        "plus",
        "arrow.clockwise",
        "folder",
        "newspaper"
    ]
  
    var body: some View {
        NavigationStack {
            VStack {
                // TOP BAR
                Divider()
                HStack {
                    
                    Button(action: {
                        self.buttonAction(for: 0)
                    }, label: {
                        Image(systemName: icons[0])
                            .font(.system(size: 25, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                    })
                    
                    Text("Cases")
                        .frame(maxWidth: .infinity)
                    
                    // Middle Bar with more buttons
                    
                    Button(action: {
                        self.selectedIndex = 1
                    }, label: {
                        Image(systemName: icons[1])
                            .font(.system(size: 25, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .frame(maxWidth: 60)
                    })
                    
                    Button(action: {
                        self.buttonAction(for: 2)
                    }, label: {
                        Image(systemName: icons[2])
                            .font(.system(size: 25, weight: .regular, design: .default))
                            .foregroundColor(.black)
                            .frame(maxWidth: 60)
                    })
                    
                } // HStack ends here
                
                Spacer()
                

                List {
                        ForEach(caseManager.cases, id: \.caseNumber) { caseData in
                            NavigationLink(destination: CaseView(caseData: caseData)) {
                            VStack(alignment: .leading) {
                                Text("Case Number: \(caseData.getCaseNumber())")
                                    .font(.headline)
                                Text("Owner: \(caseData.getCaseOwner())")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                }
                                .padding()
                            }
                        }
                        .onDelete(perform: removeCases)
                    }
//Test
                Spacer()
                
                // BOTTOM BAR
                HStack {
                    Button(action: {
                    }, label: {
                        Image(systemName: icons[3])
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 60)
                    })
                    
                    Button(action: {
                        self.selectedIndex = 4
                    }, label: {
                        Image(systemName: icons[4])
                            .font(.system(size: 25))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity, maxHeight: 60)
                    })
                } // HStack ends here
                
                // Navigation destination logic
                .navigationDestination(item: $selectedIndex) { index in
                    getDestinationView(for: index)
                }
            } // VStack ends here
        } // NavigationStack ends here
    } // body ends here
    
    func buttonAction(for index: Int) {
        switch index {
        case 0:
            isSortAscending.toggle()
            caseManager.sortCasesByOwner(ascending: isSortAscending)
                     //   print("Sorting by caseOwner \(isSortAscending ? "ASC" : "DESC")")
        case 2:
            Task {
                await caseManager.refreshCases()
            }
        default:
            break
        }
    } // buttonAction ends here
    func removeCases(at offsets: IndexSet) {
        caseManager.deleteCase(at: offsets)
    }

    @ViewBuilder
    func getDestinationView(for index: Int) -> some View {
        switch index {
        case 1:
            AddCaseView()
                .environmentObject(caseManager)
        case 4:
            CheckNews()
        default:
            ContentView()
        }
    }

}

#Preview {
    ContentView()
}
