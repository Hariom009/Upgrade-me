//
//  NotificationManager .swift
//  Upgrade me
//
//  Created by Hari's Mac on 19.04.2025.
//

import Foundation
import UserNotifications

class LocalNotificationManager {
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            print("Notification permission granted: \(granted)")
        }
    }

    func scheduleNotification(title: String, body: String, dateComponents: DateComponents, repeats: Bool = false) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeats)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(dateComponents)")
            }
        }
    }
}
