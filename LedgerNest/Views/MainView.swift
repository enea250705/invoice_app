//
//  MainView.swift
//  LedgerNest
//
//  Main view that hosts the property list
//

import SwiftUI
import SwiftData

struct MainView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var propertyViewModel: PropertyViewModel
    
    init() {
        // Create a temporary in-memory container for initialization
        // This will be replaced with the actual context in onAppear
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        if let tempContainer = try? ModelContainer(for: Property.self, Invoice.self, configurations: config) {
            _propertyViewModel = StateObject(wrappedValue: PropertyViewModel(modelContext: tempContainer.mainContext))
        } else {
            // Fallback: create a basic container
            let fallbackContainer = try! ModelContainer(for: Property.self, Invoice.self)
            _propertyViewModel = StateObject(wrappedValue: PropertyViewModel(modelContext: fallbackContainer.mainContext))
        }
    }
    
    var body: some View {
        PropertyListView(viewModel: propertyViewModel)
            .onAppear {
                // Update view model with environment model context
                propertyViewModel.modelContext = modelContext
                propertyViewModel.loadProperties()
            }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Property.self, Invoice.self, configurations: config)
    
    return MainView()
        .modelContainer(container)
}
