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
    var body: some Scene {
        WindowGroup {
          //  LocalNotificationsView()
            ContentView()
        }
        .modelContainer(for: [Activity.self])
    }
}
