//
//  MainView.swift
//  Fasting Timer
//
//  Created by Azizbek Asadov on 28/10/22.
//

import SwiftUI

struct MainView: View {
    @StateObject var fastingManager: FastingManager = .init()
    
    var title: String {
        switch fastingManager.fastingState {
        case .notStarted:
            return "Let's get started!"
        case .eating:
            return "You are now feeding!"
        case .fasting:
            return "You are now fasting!"
        }
    }
    
    var body: some View {
        content
    }
    
    var content: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 40) {
                // MARK: Title
                Text(title)
                    .font(.headline)
                    .foregroundColor(Color(red: 103/255, green: 132/255, blue: 243/255))
                // MARK: Fasting plan
                Text(fastingManager.fastingPlan.rawValue)
                    .fontWeight(.semibold)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(.thinMaterial)
                    .cornerRadius(20)
                
                Spacer()
                
            }
            .padding()
            
            VStack(spacing: 40) {
                // MARK: Progress Ring
                ProgressRing()
                    .environmentObject(fastingManager)
                
                HStack(spacing: 60) {
                // MARK: Start Time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "Start" : "Started")
                            .opacity(0.7)
                        Text(fastingManager.startTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                    // MARK: End Time
                    VStack(spacing: 5) {
                        Text(fastingManager.fastingState == .notStarted ? "End" : "Ends")
                            .opacity(0.7)
                        Text(fastingManager.endTime, format: .dateTime.weekday().hour().minute().second())
                            .fontWeight(.bold)
                    }
                }
                
                // MARK: Button
                Button {
                    fastingManager.toggleFastingState()
                } label: {
                    Text(fastingManager.fastingState == .fasting ? "End Fasting" : "Start Fasting")
                        .font(.title3)
                        .fontWeight(.bold)
                        .padding(.horizontal, 24)
                        .padding(.vertical, 8)
                        .background(.thinMaterial)
                        .cornerRadius(20)
                }
            }
            .padding()
        }
        .foregroundColor(.white)
    }
}
