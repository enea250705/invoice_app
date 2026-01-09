# LedgerNest

A complete iOS app built with SwiftUI for organizing invoices and expenses by rental property.

## Features

- **Property Management**: Add, edit, and delete properties (houses/apartments)
- **Invoice Scanning**: Capture invoices using the camera
- **OCR Integration**: Automatically extract amount and date from invoices using Vision framework
- **Organized Storage**: All invoices are organized by property
- **Expense Tracking**: View total expenses and invoice count per property
- **Filtering**: Filter invoices by month and year
- **Local-First**: All data stored locally using SwiftData

## Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture:

### Models (`Models/`)
- `Property.swift`: SwiftData model for properties
- `Invoice.swift`: SwiftData model for invoices

### ViewModels (`ViewModels/`)
- `PropertyViewModel.swift`: Manages property CRUD operations
- `InvoiceViewModel.swift`: Manages invoice operations and OCR processing
- `OnboardingViewModel.swift`: Manages onboarding state

### Views (`Views/`)
- `OnboardingView.swift`: First launch onboarding screen
- `MainView.swift`: Main entry point after onboarding
- `PropertyListView.swift`: Dashboard showing all properties
- `AddEditPropertyView.swift`: Form for adding/editing properties
- `PropertyDetailView.swift`: Detail view showing invoices for a property
- `InvoiceScannerView.swift`: Camera interface for scanning invoices
- `InvoiceFormView.swift`: Form for entering invoice details after scanning
- `InvoiceDetailView.swift`: Detail view for a single invoice

### Services (`Services/`)
- `ImageStorageService.swift`: Manages invoice image storage in documents directory
- `OCRService.swift`: Handles OCR text extraction and invoice data parsing

## Requirements

- iOS 17.0+
- Xcode 15.0+
- Swift 5.9+

## Setup

1. Open `LedgerNest.xcodeproj` in Xcode
2. Build and run on a simulator or device
3. Camera permissions will be requested on first use

## Data Storage

- **SwiftData**: Used for property and invoice metadata
- **Documents Directory**: Invoice images are stored in `Documents/InvoiceImages/`
- Images are automatically deleted when invoices or properties are deleted

## Key Features Implementation

### Onboarding
- First launch shows a welcome screen
- Uses UserDefaults to track completion

### Property Management
- List view with swipe actions (edit/delete)
- Empty state when no properties exist
- Property cards show invoice count and total expenses

### Invoice Scanning
- Camera capture with preview
- OCR extracts amount and date automatically
- User can edit extracted data before saving
- Images stored locally with UUID filenames

### Filtering
- Filter invoices by month/year
- Clear filter to show all invoices

## Code Quality

- Clean separation of concerns (MVVM)
- Proper error handling
- SwiftData for modern persistence
- Native SwiftUI components
- SF Symbols for icons
- Production-ready code structure

## Future Enhancements

The codebase is structured to easily add:
- iCloud sync
- Export functionality
- Subscription features
- Advanced OCR with ML models
- Receipt categorization
- Expense reports

