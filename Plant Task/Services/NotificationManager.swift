//
//  NotificationManager.swift
//  Plant Task
//
//  Created by HANAN ABDALLAH on 11/11/2026.
//

import UserNotifications

final class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    static let shared = NotificationManager()

    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }

    // 1. طلب إذن إرسال الإشعارات من المستخدم
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Permission granted!")
            } else if let error = error {
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    // 2. جدولة إشعار تذكير ري النبتة (بعد 5 ثواني للتجربة)
    func schedulePlantNotification(plantName: String) {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your \(plantName)"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)

        let request = UNNotificationRequest(identifier: UUID().uuidString,
                                            content: content,
                                            trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully!")
            }
        }
    }

    // 3. يخلي الإشعار يظهر حتى لو التطبيق مفتوح
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }

    // رقم مميز لإشعار كل نبتة
    private func identifier(for plantID: UUID) -> String {
        "plant-reminder-\(plantID.uuidString)"
    }

    // إشعار متكرر حسب وقت سقي النبتة
    func scheduleRepeatingNotification(plantID: UUID, plantName: String, frequency: WateringFrequency) {
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your \(plantName)"
        content.sound = .default

        let interval = TimeInterval(frequency.days * 24 * 60 * 60)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: interval, repeats: true)

        let request = UNNotificationRequest(identifier: identifier(for: plantID),
                                            content: content,
                                            trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [identifier(for: plantID)])
        center.add(request) { error in
            if let error = error {
                print("Error scheduling repeating notification: \(error.localizedDescription)")
            } else {
                print("Repeating notification scheduled every \(frequency.days) day(s)")
            }
        }
    }

    // إلغاء إشعار نبتة (لما تنحذف)
    func cancelNotification(plantID: UUID) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [identifier(for: plantID)])
    }
}
