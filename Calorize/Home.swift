//
//  Untitled.swift
//  Calorize
//
//  Created by J Family on 9/11/24.
//
import SwiftUI

struct HomeView: View {
    @State private var showLogsheet = false
    var body: some View {
    Text("Home")
    }
}

struct Logsheet: View {
    @Environment(\.dismiss) var dismiss
    var body: some View {
      
        Button("Save") {
            dismiss()
        }
    }
}
#Preview {
    HomeView()
}
