//
//  PlantViewModel.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 12/11/2026.
//


import SwiftUI
import Combine

final class PlantViewModel: ObservableObject {
    @Published var plants: [PlantItem] = []
    @Published var hasAddedPlant = false   // عشان نعرف نعرض StartView أو NoReminders

    var wateredCount: Int { plants.filter { $0.isWatered }.count }
    var allWatered: Bool { !plants.isEmpty && wateredCount == plants.count }
    var progressRatio: Double {
        guard !plants.isEmpty else { return 0 }
        return Double(wateredCount) / Double(plants.count)
    }

    func addPlant(name: String, room: Room, light: LightLevel, water: WaterAmount, frequency: WateringFrequency) {
        let plant = PlantItem(name: name.isEmpty ? "Plant" : name,
                              room: room, light: light,
                              waterAmount: water, frequency: frequency)
        plants.append(plant)
        hasAddedPlant = true

        // جديد: جدولة إشعار متكرر حسب خيار الأيام
        NotificationManager.shared.scheduleRepeatingNotification(plantID: plant.id,
                                                                 plantName: plant.name,
                                                                 frequency: plant.frequency)
    }

    // تعديل نبتة موجودة (يحافظ على حالة السقي)
    func updatePlant(id: UUID, name: String, room: Room, light: LightLevel, water: WaterAmount, frequency: WateringFrequency) {
        guard let index = plants.firstIndex(where: { $0.id == id }) else { return }
        plants[index].name = name.isEmpty ? "Plant" : name
        plants[index].room = room
        plants[index].light = light
        plants[index].waterAmount = water
        plants[index].frequency = frequency

        // جديد: نحدّث الإشعار بالاسم والأيام الجديدة
        NotificationManager.shared.scheduleRepeatingNotification(plantID: id,
                                                                 plantName: plants[index].name,
                                                                 frequency: frequency)
    }

    func deletePlant(at offsets: IndexSet) {
        // جديد: نلغي إشعارات النباتات المحذوفة
        for index in offsets {
            NotificationManager.shared.cancelNotification(plantID: plants[index].id)
        }
        plants.remove(atOffsets: offsets)
    }

    // حذف نبتة معينة (من شاشة التعديل)
    func deletePlant(id: UUID) {
        // جديد: نلغي إشعار النبتة المحذوفة
        NotificationManager.shared.cancelNotification(plantID: id)
        plants.removeAll { $0.id == id }
    }

    // يحوّل التطبيق لشاشة NoReminders بدون إضافة نبتة (عند الضغط على X)
    func skipToEmptyState() {
        hasAddedPlant = true
    }
}
