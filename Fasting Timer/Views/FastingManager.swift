//
//  FastingManager.swift
//  Fasting Timer
//
//  Created by Azizbek Asadov on 28/10/22.
//

import Foundation
import Combine

enum FastingState {
    case notStarted
    case fasting
    case eating
}

enum FastingPlan: String {
    case beginner = "12:12"
    case intermediate = "16:8"
    case advanced = "20:4"
    
    var fastingPeriod: Double {
        switch self {
        case .beginner:
            return 12
        case .intermediate:
            return 16
        case .advanced:
            return 20
        }
    }
}

class FastingManager: ObservableObject {
    @Published private(set) var fastingState: FastingState = .notStarted
    @Published private(set) var fastingPlan: FastingPlan = .intermediate
    @Published private(set) var startTime: Date {
        didSet {
            if fastingState == .fasting {
                endTime = startTime.addingTimeInterval(fastingTime)
            } else {
                endTime = startTime.addingTimeInterval(feedingTime)
            }
        }
    }
    @Published private(set) var endTime: Date
    @Published private(set) var isElapsed: Bool = false
    @Published private(set) var elapsedTime: Double = 0.0
    @Published private(set) var progress: Double = 0.0
    
    var fastingTime: Double {
        fastingPlan.fastingPeriod * 60 * 60
    }
    
    var feedingTime: Double {
        (24 - fastingPlan.fastingPeriod) * 60 * 60
    }
    
    init() {
        let calendar = Calendar.autoupdatingCurrent
//        var components = calendar.dateComponents([.year, .month, .day, .hour], from: Date())
//        components.hour = 20
//        print(components)
//
//        let scheduledTime = calendar.date(from: components) ?? Date.now
//        print(scheduledTime)
        
        let components = DateComponents(hour: 20)
        let scheduledTime = calendar.nextDate(
            after: .now,
            matching: components,
            matchingPolicy: .nextTime
        ) ?? Date.now
        
        startTime = scheduledTime
        endTime = scheduledTime.addingTimeInterval(FastingPlan.intermediate.fastingPeriod * 60 * 60)
    }
    
    func toggleFastingState() {
        fastingState = fastingState == .fasting ? .eating : .fasting
        startTime = Date()
        elapsedTime = 0.0
    }
    
    func track() {
        guard fastingState != .notStarted else { return }
        isElapsed = endTime < Date()
        elapsedTime += 1
        
        let totalTime = fastingState == .fasting ? fastingTime : feedingTime
        progress = (elapsedTime / totalTime * 100).rounded() / 100
    }
}
