//
//  ProgressRing.swift
//  Fasting Timer
//
//  Created by Azizbek Asadov on 28/10/22.
//

import SwiftUI

struct ProgressRing: View {
    @EnvironmentObject var fastingManager: FastingManager
    
    var timer = Timer
        .publish(every: 1, on: .main, in: .common)
        .autoconnect()
    
    var angularGradient = AngularGradient(
        gradient: Gradient(colors: [
            Color(red: 103/255, green: 132/255, blue: 243/255),
            Color(red: 235/255, green: 121/255, blue: 178/255),
            Color(red: 203/255, green: 172/255, blue: 207/255),
            Color(red: 160/255, green: 210/255, blue: 218/255),
            Color(red: 102/255, green: 129/255, blue: 238/255)
        ]),
        center: .center
    )
    
    var body: some View {
        ZStack {
            // MARK: Placeholder ring
            Circle()
                .stroke(lineWidth: 20)
                .foregroundColor(Color.gray)
                .opacity(0.1)
            
            // MARK: Color ring
            Circle()
                .trim(from: 0.0, to: min(fastingManager.progress, 1.0))
                .stroke(
                    angularGradient,
                    style: StrokeStyle(
                        lineWidth: 15.0,
                        lineCap: CGLineCap.round
                    )
                )
                .rotationEffect(Angle(degrees: 270))
                .animation(.easeInOut(duration: 1.0), value: fastingManager.progress)
            
            VStack(spacing: 30) {
                if fastingManager.fastingState == .notStarted {
                    // MARK: Upcoming fast
                    VStack(spacing: 5) {
                        Text("Upcoming Fast")
                            .opacity(0.7)
                        Text("\(fastingManager.fastingPlan.fastingPeriod.formatted()) Hours")
                            .font(.title)
                            .fontWeight(.bold)
                    }
                } else {
                    // MARK: Elapsed Time
                    VStack(spacing: 5) {
                        Text("Elapsed Time  \(fastingManager.progress.formatted(.percent))")
                            .opacity(0.7)
                        Text(fastingManager.startTime, style: .timer)
                            .font(.title)
                            .fontWeight(.bold)
                    }
                    .padding(.top)
                    
                    // MARK: Remaining Time
                    VStack(spacing: 5) {
                        if !fastingManager.isElapsed {
                            Text("Remaining Time \((1.0 - fastingManager.progress).formatted(.percent))")
                                .opacity(0.7)
                        } else {
                            Text("Extra Time")
                                .opacity(0.7)
                        }
                        Text(fastingManager.endTime, style: .timer)
                            .font(.title2)
                            .fontWeight(.bold)
                    }
                }
            }
        }
        .frame(width: 250, height: 250)
        .padding()
        .onReceive(timer) { _ in
            fastingManager.track()
        }
    }
}

struct ProgressRing_Previews: PreviewProvider {
    static var previews: some View {
        ProgressRing()
            .environmentObject(FastingManager())
    }
}
