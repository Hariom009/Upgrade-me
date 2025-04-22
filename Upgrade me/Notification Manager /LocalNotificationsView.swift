//
//  LocalNotificationsView.swift
//  Upgrade me
//
//  Created by Hari's Mac on 19.04.2025.
//

import SwiftUI
import UserNotifications
class NotifyManager{
    static let instance = NotifyManager() // singleton
    
    func requestAuthorization(){
        let options: UNAuthorizationOptions = [.alert, .sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { (success, error ) in
            if let error = error{
                print("Error : \(error)")
            }else{
                print("Success")
            }
        }
    }
    func scheduleNotification(){
        let content = UNMutableNotificationContent()
        content.title =  "This is my first Notification"
        content.subtitle = "This was so easy !!!"
        content.sound = .default
        content.badge = 1
        
            // time
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        
            // calendar
//        var dateComponents = DateComponents()
//        dateComponents.hour = 15
//        dateComponents.minute = 43
//        dateComponents.weekday = 7
    //    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // location
        
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request)
    }
    func cancelNotifications(){
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
struct LocalNotificationsView: View {
    var body: some View {
        VStack{
            Button("Request Permission"){
                NotifyManager.instance.requestAuthorization()
            }
            Button("Schedule Notification"){
                NotifyManager.instance.scheduleNotification()
            }
            Button("Cancel Notification"){
                NotifyManager.instance.cancelNotifications()
            }
        }
        .onAppear{
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
    }
}

#Preview {
    LocalNotificationsView()
}
