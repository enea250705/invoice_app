# LedgerNest - User Experience Walkthrough

## First Time User Experience

### 1. App Launch & Onboarding
When you first open LedgerNest, you're greeted with a clean, welcoming onboarding screen:
- **Welcome Screen**: A beautiful building icon with "LedgerNest" title
- **Message**: "Organize invoices for all your properties in one place."
- **Get Started Button**: Tap to begin your journey

### 2. Your First Property
After tapping "Get Started", you see an empty state with:
- A friendly message: "No properties yet"
- An "Add Property" button

**Adding Your First Property:**
- Tap the "+" button in the top right (or the "Add Property" button)
- Fill in the property form:
  - **Property Name** (required): e.g., "Downtown Apartment" or "123 Main Street"
  - **Address** (optional): Full address if you want it
  - **Notes** (optional): Any additional information
- Tap "Add" to save
- The property appears in your list with:
  - Building icon
  - Property name and address
  - Invoice count: "0 invoices"
  - Total expenses: "$0.00"

### 3. Scanning Your First Invoice
Tap on your property to see its detail view:
- Empty state shows: "No invoices yet" with a "Scan Invoice" button
- Tap "Scan Invoice" (or use the menu in top right)

**Scanning Process:**
1. **Camera Opens**: Point your camera at the invoice
2. **Capture**: Take a photo of the invoice
3. **Processing**: You see a loading indicator: "Processing invoice..."
4. **Auto-Fill Magic**: The app automatically extracts:
   - **Amount**: Detected from the invoice (e.g., "$150.00")
   - **Date**: Extracted from the invoice text
   - **Vendor**: You can add this manually
5. **Review & Edit**: The invoice form appears with:
   - Preview of the scanned image
   - Pre-filled amount (you can edit)
   - Pre-filled date (you can change)
   - Vendor field (optional, you can type)
   - Property selector (already set to current property)
6. **Save**: Tap "Save" button
7. **Success**: The invoice is saved and appears in your list!

### 4. Viewing Your Invoices
Back in the property detail view, you now see:
- **Invoice List**: All invoices for this property
- Each invoice shows:
  - Thumbnail of the scanned image
  - Amount in bold (e.g., "$150.00")
  - Vendor name (if added)
  - Date (e.g., "Jan 15, 2024")
- Invoices are sorted by date (newest first)

**Viewing Invoice Details:**
- Tap any invoice to see:
  - Full-size invoice image
  - All details (Amount, Date, Vendor, Property)
  - "Edit" button in the top right

### 5. Editing an Invoice
You can edit invoices in two ways:

**Method 1: From Detail View**
- Open an invoice
- Tap the "Edit" button (pencil icon)
- Modify any field:
  - Change amount
  - Update date
  - Edit vendor
  - Change property assignment
- Tap "Save"

**Method 2: From List View**
- Swipe left on any invoice in the list
- Tap "Edit"
- Make your changes and save

**Note**: If the original image is missing, you'll see a warning but can still edit other details. You'll need to re-scan the image if you want to update it.

### 6. Filtering Invoices
To find invoices from a specific month:
- Tap the menu (three dots) in the property detail view
- Select "Filter by Month"
- Choose:
  - **Month**: January, February, etc.
  - **Year**: Select from the list
- Tap "Apply" to filter
- Tap "Clear" to show all invoices again

### 7. Managing Multiple Properties
**Adding More Properties:**
- From the main properties list, tap "+"
- Add as many properties as you need
- Each property tracks its own invoices independently

**Property Management:**
- **View**: Tap any property to see its invoices
- **Edit**: Swipe left on a property → "Edit"
- **Delete**: Swipe left on a property → "Delete" (removes property and all its invoices)

**Property Overview:**
Each property card shows:
- Total number of invoices
- Total expenses across all invoices
- Quick visual summary

### 8. Error Handling & Feedback
The app provides clear feedback throughout:

**When Things Go Wrong:**
- **Validation Errors**: If you try to save invalid data:
  - "Invoice amount must be greater than zero"
  - "Invoice date cannot be in the future"
  - "Property name cannot be empty"
- **Save Errors**: If saving fails, you see:
  - Clear error message explaining what went wrong
  - Option to try again
- **Image Errors**: If an invoice image is missing:
  - Warning message appears
  - You can still edit other details
  - Form remains functional

**Loading States:**
- **OCR Processing**: "Processing invoice..." with spinner
- **Saving**: "Saving invoice..." with spinner
- Visual indicators show the app is working

### 9. Daily Usage Flow
**Typical Workflow:**
1. Open LedgerNest
2. Select the property you're working with
3. Tap "Scan Invoice" from the menu
4. Take photo of invoice
5. Review auto-filled data
6. Make any corrections
7. Save invoice
8. Invoice appears in list immediately

**Quick Actions:**
- **Delete Invoice**: Swipe right on any invoice → Delete
- **Edit Invoice**: Swipe left → Edit
- **View Details**: Tap any invoice
- **Filter**: Menu → Filter by Month

### 10. Visual Design & Polish
The app features:
- **Clean Interface**: Modern SwiftUI design
- **Intuitive Navigation**: Clear navigation paths
- **SF Symbols**: Native iOS icons throughout
- **Responsive Feedback**: Loading states, error alerts, success animations
- **Empty States**: Helpful messages when lists are empty
- **Color Coding**: Blue accents for primary actions
- **Card Design**: Property cards with visual hierarchy

## Key User Benefits

1. **Time Saving**: OCR automatically extracts amount and date
2. **Organization**: All invoices organized by property
3. **Quick Access**: Filter by month to find specific invoices
4. **Error Prevention**: Validation prevents invalid data entry
5. **Flexibility**: Edit invoices anytime, change property assignments
6. **Visual Tracking**: See invoice images and totals at a glance
7. **Reliability**: Error handling ensures data integrity

## User Tips

- **Best Practice**: Always review OCR-extracted data before saving
- **Image Quality**: Better photos = better OCR accuracy
- **Regular Updates**: Edit invoices immediately if you spot errors
- **Property Organization**: Use clear, descriptive property names
- **Monthly Reviews**: Use filters to review monthly expenses per property

## Accessibility

- All buttons have clear labels
- Error messages are descriptive
- Loading states provide feedback
- Forms validate before submission
- Swipe actions are discoverable

---

**LedgerNest** makes property invoice management simple, fast, and reliable. Whether you manage one property or many, the app helps you stay organized and in control of your expenses.

