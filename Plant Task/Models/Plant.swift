//
//  Plant.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 12/11/2026.
//

import Foundation

// MARK: - Enums (Data Modeling)
enum Room: String, CaseIterable, Identifiable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"

    var id: String { rawValue }
}

enum LightLevel: String, CaseIterable, Identifiable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case lowLight = "Low Light"

    var id: String { rawValue }

    // أيقونة كل خيار إضاءة (شمس، شمس جزئية، قمر)
    var icon: String {
        switch self {
        case .fullSun: return "sun.max"
        case .partialSun: return "sun.haze"
        case .lowLight: return "moon"
        }
    }
}

enum WaterAmount: String, CaseIterable, Identifiable {
    case ml20to50 = "20-50 ml"
    case ml50to100 = "50-100 ml"
    case ml100to200 = "100-200 ml"
    case ml200to300 = "200-300 ml"

    var id: String { rawValue }
}

enum WateringFrequency: String, CaseIterable, Identifiable {
    case everyDay = "Every day"
    case every2Days = "Every 2 days"
    case every3Days = "Every 3 days"
    case onceAWeek = "Once a week"
    case every10Days = "Every 10 days"
    case every2Weeks = "Every 2 weeks"

    var id: String { rawValue }

    // عدد الأيام بين كل سقاية
    var days: Int {
        switch self {
        case .everyDay: return 1
        case .every2Days: return 2
        case .every3Days: return 3
        case .onceAWeek: return 7
        case .every10Days: return 10
        case .every2Weeks: return 14
        }
    }
}

// MARK: - Struct
struct PlantItem: Identifiable {
    let id = UUID()
    var name: String
    var room: Room
    var light: LightLevel
    var waterAmount: WaterAmount
    var frequency: WateringFrequency
    var isWatered: Bool = false
}
