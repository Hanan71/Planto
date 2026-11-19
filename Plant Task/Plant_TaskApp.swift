//
//  Plant_TaskApp.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 30/05/1448 AH.
//

import SwiftUI

@main
struct Plant_Plant_TaskApp: App { // ملاحظة: الكود الأصلي عندك Plant_TaskApp
    @StateObject private var viewModel = PlantViewModel()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(viewModel)
                .preferredColorScheme(.dark) // 👈 هذا السطر يفرض الوضع الليلي على التطبيق بالكامل
        }
    }
}
