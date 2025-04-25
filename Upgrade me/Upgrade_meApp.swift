//
//  Upgrade_meApp.swift
//  Upgrade me
//
//  Created by Hari's Mac on 16.04.2025.
//

import SwiftUI
import SwiftData
@main
struct Upgrade_meApp: App {
    @StateObject private var alarmManager = AlarmManager.shared
        
        init() {
            // Request permissions on app launch
            AlarmManager.shared.requestNotificationPermission()
        }
    var body: some Scene {
        WindowGroup {
          //  LocalNotificationsView()
            ContentView()
                .environmentObject(alarmManager)
        }
        .modelContainer(for: [Activity.self])
    }
}
