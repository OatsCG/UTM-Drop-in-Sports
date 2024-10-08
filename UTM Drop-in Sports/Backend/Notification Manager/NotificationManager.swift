//
//  NotificationManager.swift
//  UTM Drop-in Sports
//
//  Created by Charlie Giannis on 2024-09-13.
//

import SwiftUI
import UserNotifications
import UIKit
import Combine

class NotificationManager: NSObject, UNUserNotificationCenterDelegate, ObservableObject {
    
    /// A list of currently scheduled event IDs.
    @Published var currentlyScheduledEvents: [Int] = []
    
    override init() {
        super.init()
        // Set the delegate and request authorization
        UNUserNotificationCenter.current().delegate = self
        requestAuthorization()
        // Update scheduled events upon initialization
        updateScheduledEvents()
    }
    
    /// Requests authorization to display notifications.
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Notification permission denied: \(error.localizedDescription)")
            } else {
                print("Notification permission denied.")
            }
        }
    }
    
    /// Updates the list of currently scheduled events by fetching pending notification requests.
    func updateScheduledEvents() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let eventIDs = requests.compactMap { request -> Int? in
                // Assuming the identifier is the string representation of the event ID
                return Int(request.identifier)
            }
            print("Good schedule ids: \(eventIDs)")
            DispatchQueue.main.async {
                withAnimation {
                    self.currentlyScheduledEvents = eventIDs
                }
                print("Updated scheduled events: \(self.currentlyScheduledEvents)")
            }
        }
    }
    
    /// Checks if an event is already scheduled for notification.
    /// - Parameter event: The event to check.
    /// - Returns: `true` if the event is scheduled; `false` otherwise.
    func isScheduled(event: Event) -> Bool {
        return currentlyScheduledEvents.contains(event.id)
    }
    
    /// Schedules a local notification for a specific event, ensuring it's not already scheduled.
    /// - Parameters:
    ///   - event: The `Event` object for the notification.
    ///   - date: The date and time when the notification should be delivered.
    func scheduleNotification(event: Event) {
        // Guard against scheduling if the event is already scheduled
        if isScheduled(event: event) {
            print("Event \(event.id) is already scheduled.")
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = event.title
        content.subtitle = event.venue
        content.body = "Starting in 30 Minutes"
        content.sound = .default
        
        // Increment the badge number
        DispatchQueue.main.async {
            let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
            let newBadgeNumber = currentBadgeNumber + 1
            content.badge = NSNumber(value: newBadgeNumber)
        }
        
        // Create trigger based on the specified date minus 30 minutes
        let triggerDate = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute, .second],
            from: eventDateMinus30Minutes(date: event.relativeTimeDate.startDate) // 30 minutes before the event
        )
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
        // Use the event ID as the identifier
        let identifier = String(event.id)
        let request = UNNotificationRequest(
            identifier: identifier,
            content: content,
            trigger: trigger
        )
        
        // Schedule the notification
        UNUserNotificationCenter.current().add(request) { error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Error scheduling notification: \(error.localizedDescription)")
                } else {
                    print("Notification scheduled with identifier: \(identifier)")
                    // Update the list of scheduled events
                    self.updateScheduledEvents()
                }
            }
        }
    }
    
    /// Cancels the scheduled notification for a specific event.
    /// - Parameter event: The `Event` object whose notification should be canceled.
    func cancelNotification(event: Event) {
        let identifier = String(event.id)
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
        print("Canceled notification with identifier: \(identifier)")
        // Update the list of scheduled events
        updateScheduledEvents()
    }
    
    /// Clears the app icon badge number.
    func clearNotificationBadges() {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    // MARK: - UNUserNotificationCenterDelegate Methods
    
    /// Ensures that notifications display banners and sounds even when the app is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Reset the badge number to 0 since the app is in the foreground
        clearNotificationBadges()
        // Present the notification as a banner with sound
        completionHandler([.banner, .sound])
    }
    
    /// Handles user interaction with the notification and updates scheduled events.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        // Clear the badge number
        clearNotificationBadges()
        // Update the list of scheduled events
        updateScheduledEvents()
        completionHandler()
    }
}

func getCurrentDatePlusFiveSeconds() -> Date {
    return Date().addingTimeInterval(4)
}


func eventDateMinus30Minutes(date: Date) -> Date {
    return date.addingTimeInterval(-1800)
}
