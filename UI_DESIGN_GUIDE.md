# LedgerNest - UI Design Guide

## Current Visual Design

### 🎨 Design System

**Color Palette:**
- **Primary Blue**: Soft, modern blue gradient (`#3366E6` to `#4D80FF`)
- **Accent**: Light blue accent (`#19B3E6`)
- **Background**: Subtle gradient from light blue-white to pure white
- **Cards**: System background with soft shadows
- **Text**: Primary black with secondary gray for hierarchy

**Design Principles:**
- Modern iOS design language
- Gradient accents throughout
- Elevated cards with shadows
- Smooth spring animations
- Clean typography hierarchy
- Generous spacing and padding

---

## 📱 Screen-by-Screen Visual Breakdown

### 1. Onboarding Screen

**Visual Elements:**
```
┌─────────────────────────────┐
│                             │
│     [Gradient Background]   │
│     Light blue → White      │
│                             │
│         🏢 (120x120)        │
│    [Animated, pulsing]      │
│   Gradient icon container   │
│                             │
│      LedgerNest             │
│   [Gradient text effect]    │
│   Bold, rounded font        │
│                             │
│  Organize invoices for all  │
│  your properties in one     │
│         place.              │
│                             │
│                             │
│  ┌───────────────────────┐  │
│  │   Get Started         │  │
│  │ [Gradient button]     │  │
│  │ Blue → Light Blue     │  │
│  │ Shadow + Animation    │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

**Features:**
- **Background**: Subtle gradient from light blue-white (`#F2F7FF`) to pure white
- **Icon**: Large building icon (120x120) in gradient container
  - Blue gradient background with opacity
  - Rounded corners (30% radius)
  - Subtle border
  - Gentle pulsing animation
- **Title**: "LedgerNest" in gradient text (blue to light blue)
  - Large, bold, rounded font (42pt)
- **Button**: Full-width gradient button
  - Blue to light blue gradient
  - 16pt corner radius
  - Shadow with blue tint
  - Press animation (scales to 97%)
  - Spring animation on tap

---

### 2. Properties List Screen

**Visual Elements:**
```
┌─────────────────────────────┐
│ Your Properties        [+]   │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │ 🏢  Downtown Apt      │  │
│  │     123 Main St       │  │
│  │     📄 5  💵 $1,250   │  │
│  └───────────────────────┘  │
│      [Card with shadow]      │
│                             │
│  ┌───────────────────────┐  │
│  │ 🏢  Beach House       │  │
│  │     456 Ocean Ave    │  │
│  │     📄 12  💵 $3,450  │  │
│  └───────────────────────┘  │
│      [Card with shadow]      │
│                             │
└─────────────────────────────┘
```

**Property Card Design:**
- **Icon Container**: 60x60 rounded square
  - Gradient background (blue with opacity)
  - Building icon in blue
  - Rounded corners (18pt radius)
  - Subtle border stroke
- **Card**: Elevated design
  - White background
  - 16pt corner radius
  - Multi-layer shadow:
    - Main shadow: 10pt radius, 4pt offset
    - Subtle shadow: 1pt radius, 1pt offset
  - 8pt padding top/bottom
  - 16pt padding left/right
- **Typography**:
  - Property name: Headline font, bold
  - Address: Subheadline, secondary color
  - Stats: Caption font with icons
  - Expense amount: Semibold, blue color
- **Interaction**:
  - Smooth spring animation on tap
  - Swipe actions: Edit (blue) and Delete (red)

**Empty State:**
- Large icon container (100x100)
- Centered layout
- Modern button with gradient
- Helpful messaging

---

### 3. Property Detail Screen (Invoice List)

**Visual Elements:**
```
┌─────────────────────────────┐
│ Downtown Apartment      ⋯   │
├─────────────────────────────┤
│                             │
│  ┌───────────────────────┐  │
│  │ [Invoice Image]       │  │
│  │   64x64 rounded       │  │
│  │   $150.00             │  │
│  │   Vendor Name         │  │
│  │   📅 Jan 15, 2024     │  │
│  └───────────────────────┘  │
│      [Card with shadow]      │
│                             │
│  ┌───────────────────────┐  │
│  │ [Invoice Image]       │  │
│  │   $89.50              │  │
│  │   Another Vendor      │  │
│  │   📅 Dec 20, 2023     │  │
│  └───────────────────────┘  │
│                             │
└─────────────────────────────┘
```

**Invoice Row Design:**
- **Thumbnail**: 64x64 rounded square
  - Invoice image or gradient placeholder
  - 12pt corner radius
  - Subtle border
  - Small shadow
- **Card**: Elevated list item
  - 14pt corner radius
  - Soft shadow (3pt radius)
  - 6pt padding top/bottom
  - 16pt padding left/right
- **Layout**:
  - Image on left (64x64)
  - Amount in headline font
  - Vendor in subheadline
  - Date with calendar icon
- **Swipe Actions**:
  - Edit: Blue tint
  - Delete: Red (swipe right)

**Loading Overlay:**
- Blur background (30% black opacity)
- Centered card with:
  - Ultra-thin material background
  - Large progress indicator (blue tint)
  - "Processing..." text
  - 20pt corner radius
  - Shadow

---

### 4. Invoice Form Screen

**Visual Elements:**
```
┌─────────────────────────────┐
│ Invoice Details      Cancel  │
├─────────────────────────────┤
│                             │
│ Invoice Image               │
│ ┌───────────────────────┐   │
│ │                       │   │
│ │   [Invoice Preview]   │   │
│ │   Max height: 200pt   │   │
│ │   Rounded: 8pt        │   │
│ └───────────────────────┘   │
│                             │
│ Invoice Details             │
│ Amount          $150.00     │
│ Date        [Date Picker]   │
│ Vendor (optional)            │
│                             │
│ Property                     │
│ [Picker: Downtown Apt ▼]    │
│                             │
│                    [Save]    │
└─────────────────────────────┘
```

**Form Design:**
- **Sections**: Native iOS Form style
- **Image Preview**: 
  - Rounded corners (8pt)
  - Max height 200pt
  - Maintains aspect ratio
- **Input Fields**:
  - Native TextField styling
  - Currency formatting for amount
  - Compact date picker
- **Save Button**: 
  - Disabled state when invalid
  - Shows loading overlay when saving

---

### 5. Invoice Detail Screen

**Visual Elements:**
```
┌─────────────────────────────┐
│ Invoice Details      ✏️ Edit│
├─────────────────────────────┤
│                             │
│ ┌───────────────────────┐   │
│ │                       │   │
│ │   [Full Invoice]      │   │
│ │      Image            │   │
│ │                       │   │
│ └───────────────────────┘   │
│   12pt corner radius         │
│                             │
│ Amount                       │
│ $150.00                      │
│                             │
│ Date                         │
│ January 15, 2024             │
│                             │
│ Vendor                       │
│ Vendor Name                  │
│                             │
│ Property                     │
│ Downtown Apartment            │
│                             │
└─────────────────────────────┘
```

**Design:**
- Full-width invoice image
- Clean detail rows
- Edit button in toolbar
- Scrollable content

---

## 🎯 Key Visual Features

### Gradients
- **Buttons**: Blue to light blue gradient
- **Icons**: Gradient backgrounds with opacity
- **Text**: Gradient effect on app title
- **Backgrounds**: Subtle gradients for depth

### Shadows & Elevation
- **Cards**: Multi-layer shadows
  - Main shadow: 10pt radius, 4pt Y offset
  - Subtle shadow: 1pt radius, 1pt Y offset
- **Buttons**: Colored shadows matching button color
- **List Items**: Soft shadows (3pt radius)

### Animations
- **Button Press**: Scale to 97% with spring animation
- **Icon Pulse**: Gentle scale animation (1.0 to 1.05)
- **Navigation**: Spring animations (0.3s response, 0.7 damping)
- **Loading**: Smooth progress indicators

### Typography Hierarchy
- **Large Titles**: 42pt, bold, rounded
- **Headlines**: System headline font
- **Body**: System body font
- **Captions**: System caption font
- **Secondary Text**: Gray color for hierarchy

### Spacing
- **Card Padding**: 16pt horizontal, 12pt vertical
- **List Item Spacing**: 6-8pt between items
- **Section Spacing**: 24-40pt for major sections
- **Icon Sizes**: 60pt (cards), 64pt (invoices), 100-120pt (empty states)

### Color Usage
- **Primary Actions**: Blue gradient
- **Destructive Actions**: System red
- **Secondary Text**: System secondary color
- **Backgrounds**: System background with gradients
- **Accents**: Blue for highlights and important info

---

## 📐 Component Specifications

### Modern Button
- **Height**: 56pt (16pt padding top/bottom)
- **Corner Radius**: 16pt
- **Shadow**: 8pt radius, 4pt Y offset (when not pressed)
- **Animation**: Spring (0.3s response, 0.6 damping)
- **Gradient**: Primary blue to secondary blue

### Icon Container
- **Size**: 60pt (cards), 64pt (invoices), 100-120pt (empty states)
- **Corner Radius**: 30% of size
- **Background**: Gradient with 20% and 10% opacity
- **Border**: 1pt stroke with 30% opacity
- **Icon**: 50% of container size

### Card
- **Corner Radius**: 14-20pt
- **Padding**: 16pt (adjustable)
- **Shadow**: Multi-layer
- **Background**: System background color

### Loading View
- **Background**: 30% black opacity blur
- **Card**: Ultra-thin material
- **Corner Radius**: 20pt
- **Padding**: 30pt
- **Shadow**: 20pt radius

---

## 🌈 Visual Style Summary

**Overall Feel:**
- ✨ Modern and polished
- 🎨 Clean with gradient accents
- 📱 Native iOS design language
- 🎯 Professional and trustworthy
- 💫 Smooth and responsive
- 🎪 Delightful interactions

**Color Mood:**
- Calm and professional (blues)
- Clean and fresh (white backgrounds)
- Warm and inviting (gradients)
- Clear hierarchy (text colors)

**Interaction Feel:**
- Responsive (spring animations)
- Smooth (no janky transitions)
- Delightful (subtle animations)
- Clear feedback (loading states, shadows)

---

The UI now has a **modern, professional appearance** that feels native to iOS while standing out with thoughtful design details and smooth interactions! 🚀

