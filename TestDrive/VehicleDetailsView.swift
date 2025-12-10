//
//  VehicleDetailsView.swift
//  TestDrive
//
//  Created by Vadim Popov on 10/12/2025.
//

import SwiftUI

struct VehicleDetailsView: View {
    let vehicle: Vehicle
    @Environment(\.dismiss) var dismiss
    @State private var showMoreDetails = false
    @State private var fullName = ""
    @State private var phone = ""
    @State private var isSubmitting = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Short Vehicle Information
                    VStack(spacing: 16) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.blue)
                        
                        VStack(spacing: 8) {
                            Text("\(vehicle.year) \(vehicle.make) \(vehicle.model)")
                                .font(.title2)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            if let price = vehicle.price {
                                Text("$\(price, specifier: "%.0f")")
                                    .font(.title3)
                                    .foregroundColor(.green)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        // Show More Button
                        Button(action: {
                            withAnimation {
                                showMoreDetails.toggle()
                            }
                        }) {
                            HStack {
                                Text(showMoreDetails ? "Show Less" : "Show More")
                                Image(systemName: showMoreDetails ? "chevron.up" : "chevron.down")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                        }
                        
                        // Expanded Details
                        if showMoreDetails {
                            VStack(alignment: .leading, spacing: 12) {
                                Divider()
                                
                                if let vin = vehicle.vin {
                                    DetailRow(label: "VIN", value: vin)
                                }
                                
                                if let licensePlate = vehicle.licensePlate {
                                    DetailRow(label: "License Plate", value: licensePlate)
                                }
                                
                                if let color = vehicle.color {
                                    DetailRow(label: "Color", value: color)
                                }
                                
                                if let mileage = vehicle.mileage {
                                    DetailRow(label: "Mileage", value: "\(mileage.formatted(.number.grouping(.automatic))) miles")
                                }
                                
                                if let engine = vehicle.engine {
                                    DetailRow(label: "Engine", value: engine)
                                }
                                
                                if let transmission = vehicle.transmission {
                                    DetailRow(label: "Transmission", value: transmission)
                                }
                                
                                if let fuelType = vehicle.fuelType {
                                    DetailRow(label: "Fuel Type", value: fuelType)
                                }
                                
                                if let description = vehicle.description {
                                    Divider()
                                    Text(description)
                                        .font(.body)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.top, 8)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                    
                    // Request Test Drive Form
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Request Test Drive")
                            .font(.title3)
                            .fontWeight(.bold)
                            .padding(.bottom, 4)
                        
                        // Full Name Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Full Name")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter your full name", text: $fullName)
                                .textFieldStyle(.roundedBorder)
                                .autocapitalization(.words)
                        }
                        
                        // Phone Field
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Phone")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                            
                            TextField("Enter your phone number", text: $phone)
                                .textFieldStyle(.roundedBorder)
                                .keyboardType(.phonePad)
                        }
                        
                        // Request Test Drive Button
                        Button(action: {
                            requestTestDrive()
                        }) {
                            HStack {
                                if isSubmitting {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Image(systemName: "car.circle.fill")
                                    Text("Request Test Drive")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(isFormValid ? Color.blue : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                            .fontWeight(.semibold)
                        }
                        .disabled(!isFormValid || isSubmitting)
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(16)
                    .shadow(color: Color.black.opacity(0.1), radius: 8, x: 0, y: 2)
                }
                .padding()
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Vehicle Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var isFormValid: Bool {
        !fullName.trimmingCharacters(in: .whitespaces).isEmpty &&
        !phone.trimmingCharacters(in: .whitespaces).isEmpty
    }
    
    private func requestTestDrive() {
        isSubmitting = true
        
        // Simulate API call
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isSubmitting = false
            
            // Show success message or handle submission
            // You can add an alert or navigation here
        }
    }
}

struct DetailRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.body)
                .fontWeight(.medium)
        }
    }
}

#Preview {
    VehicleDetailsView(vehicle: Vehicle(
        id: "1",
        make: "Tesla",
        model: "Model 3",
        year: 2023,
        vin: "5YJ3E1EA1KF123456",
        licensePlate: "ABC-1234",
        color: "Pearl White",
        mileage: 15000,
        engine: "Electric",
        transmission: "Single Speed",
        fuelType: "Electric",
        price: 45000.00,
        description: "Excellent condition, one owner, fully loaded with autopilot."
    ))
}
