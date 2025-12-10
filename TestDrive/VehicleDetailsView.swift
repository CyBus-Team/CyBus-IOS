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
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    VStack(spacing: 8) {
                        Image(systemName: "car.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text("\(vehicle.year) \(vehicle.make) \(vehicle.model)")
                            .font(.title)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                    }
                    .padding(.top)
                    
                    // Form
                    VStack(alignment: .leading, spacing: 16) {
                        SectionHeader(title: "Basic Information")
                        
                        InfoRow(label: "Make", value: vehicle.make)
                        InfoRow(label: "Model", value: vehicle.model)
                        InfoRow(label: "Year", value: "\(vehicle.year)")
                        
                        if let vin = vehicle.vin {
                            InfoRow(label: "VIN", value: vin)
                        }
                        
                        if let licensePlate = vehicle.licensePlate {
                            InfoRow(label: "License Plate", value: licensePlate)
                        }
                        
                        if let color = vehicle.color {
                            InfoRow(label: "Color", value: color)
                        }
                    }
                    .padding()
                    .background(Color(.systemBackground))
                    .cornerRadius(12)
                    .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    
                    // Technical Details
                    if vehicle.engine != nil || vehicle.transmission != nil || vehicle.fuelType != nil || vehicle.mileage != nil {
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Technical Details")
                            
                            if let engine = vehicle.engine {
                                InfoRow(label: "Engine", value: engine)
                            }
                            
                            if let transmission = vehicle.transmission {
                                InfoRow(label: "Transmission", value: transmission)
                            }
                            
                            if let fuelType = vehicle.fuelType {
                                InfoRow(label: "Fuel Type", value: fuelType)
                            }
                            
                            if let mileage = vehicle.mileage {
                                InfoRow(label: "Mileage", value: "\(mileage.formatted(.number.grouping(.automatic))) miles")
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    
                    // Price
                    if let price = vehicle.price {
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Pricing")
                            
                            HStack {
                                Text("Price")
                                    .font(.headline)
                                    .foregroundColor(.secondary)
                                Spacer()
                                Text("$\(price, specifier: "%.2f")")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                            }
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    
                    // Description
                    if let description = vehicle.description {
                        VStack(alignment: .leading, spacing: 16) {
                            SectionHeader(title: "Description")
                            
                            Text(description)
                                .font(.body)
                                .foregroundColor(.primary)
                        }
                        .padding()
                        .background(Color(.systemBackground))
                        .cornerRadius(12)
                        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
                    }
                    
                    // Action Buttons
                    VStack(spacing: 12) {
                        Button(action: {
                            // Action for test drive
                        }) {
                            HStack {
                                Image(systemName: "car.circle.fill")
                                Text("Schedule Test Drive")
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
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
}

struct SectionHeader: View {
    let title: String
    
    var body: some View {
        Text(title)
            .font(.headline)
            .foregroundColor(.secondary)
            .textCase(.uppercase)
    }
}

struct InfoRow: View {
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
                .foregroundColor(.primary)
        }
        .padding(.vertical, 4)
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

