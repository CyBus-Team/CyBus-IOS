//
//  ActiveTripView.swift
//  CyBus
//
//  Created by Vadim Popov on 24/05/2025.
//

import SwiftUI

struct ActiveTripView: View {
    let title: String
    let arrivalTime: Date
    let onFinish: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center, spacing: 12) {
                Image(systemName: "bus.fill")
                    .foregroundColor(.white)
                    .padding(8)
                    .background(Circle().fill(Color.blue))
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                    Text("Expected arrival time: \(arrivalTime.formatted(date: .omitted, time: .shortened))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
            }
            
            Button(action: onFinish) {
                Text("Finish")
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .padding()
        .cornerRadius(14)
    }
    
    private var formattedArrivalTime: String {
        arrivalTime.formatted(date: .omitted, time: .shortened)
    }
}

#Preview {
    ActiveTripView(
        title: "Central Station → Airport",
        arrivalTime: Calendar.current.date(bySettingHour: 14, minute: 32, second: 0, of: .now)!,
        onFinish: {}
    )
}
