//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Esma Koçak on 11.08.2024.
//

import SwiftUI
import CoreData
import UserNotifications

class HabitViewModel: ObservableObject {
    // MARK: New Habit Properties
    @Published var addNewHabit: Bool = false
    @Published var title: String = ""
    @Published var habitColor: String = "Card-1"
    @Published var weekDays: [String] = []
    @Published var isRemainderOn: Bool = false
    @Published var remainderText: String = ""
    @Published var remainderDate: Date = Date()
    
    // MARK: Remainder Time Picker
    @Published var showTimePicker: Bool = false
    
    // MARK: Edit Habit
    @Published var editHabit: Habit?
    
    // MARK: Notification Access Status
    @Published var notificationAccess: Bool = false
    
    init(){
        requestNotificationAccess()
    }
    
    func requestNotificationAccess(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.sound, .alert]) { status, _ in
            DispatchQueue.main.async {
                self.notificationAccess = status
            }
        }
    }
    
    // MARK: Adding Habit to Database
    func addHabit(context: NSManagedObjectContext) async -> Bool {
        // MARK: Editing Data
        var habit: Habit!
        if let editHabit = editHabit{
            habit = editHabit
            // removing the notifications belong to habit
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notificationIDs ?? [])
        } else {
            habit = Habit(context: context)
        }
        habit.title = title
        habit.color = habitColor
        habit.weekDays = weekDays
        habit.isRemainderOn = isRemainderOn
        habit.remainderText = remainderText
        habit.notificationDate = remainderDate
        habit.notificationIDs = []
        if isRemainderOn{
            // MARK: Scheduling Notifications
            if let ids = try? await scheduleNotification(){
                habit.notificationIDs =  ids
                if let _ = try? context.save(){
                    return true
                }
            }
        } else{
            // MARK: Adding Data
            if let _ = try? context.save(){
                return true
            }
        }
        return false
    }
    
    // MARK: Adding Notifications
    func scheduleNotification() async throws -> [String] {
        let content = UNMutableNotificationContent()
        content.title = "Habit Remainder"
        content.subtitle = remainderText
        content.sound = UNNotificationSound.default
        
        // Scheduled Ids
        var notificationIDs: [String] = []
        let calendar = Calendar.current
        let weekdaySymbols: [String] = calendar.weekdaySymbols
        
        // MARK: Scheduling Notification
        for weekDay in weekDays {
            // unique id for each notification
            let id = UUID().uuidString
            let hour = calendar.component(.hour, from: remainderDate)
            let min = calendar.component(.minute, from: remainderDate)
            let day = weekdaySymbols.firstIndex { currentDay in
                return currentDay == weekDay
            } ?? -1
            
            // MARK: Since Week Day Starts from 1-7
            // Thus Adding +1 to Index
            if day != -1 {
                var components = DateComponents()
                components.hour = hour
                components.minute = min
                components.weekday = day + 1
                
                // MARK: Thus this will Trigger Notification on Each Selected Day
                let trigger = UNCalendarNotificationTrigger (dateMatching: components, repeats: true)
                
                // MARK: Notification Request
                let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                
                try await UNUserNotificationCenter.current().add(request)
                
                // adding ID
                notificationIDs.append(id)
            }
        }
        
        return notificationIDs
    }
    
    // MARK: Clear Content
    func resetData(){
        title = ""
        habitColor = "Card-1"
        weekDays = []
        isRemainderOn = false
        remainderDate = Date()
        remainderText = ""
        editHabit = nil
    }
    
    // MARK: Delete Habit
    func deleteHabit(context: NSManagedObjectContext) -> Bool {
        if let editHabit = editHabit {
            if editHabit.isRemainderOn{
                UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: editHabit.notificationIDs ?? [])
            }
            context.delete(editHabit)
            if let _ = try? context.save(){
                return true
            }
        }
        return false
    }
    
    
    // MARK: Restoring Edit Data
    func restoreEditData(){
        if let editHabit = editHabit {
            title = editHabit.title ?? ""
            habitColor = editHabit.color ?? "Card-1"
            weekDays = editHabit.weekDays ?? []
            isRemainderOn = editHabit.isRemainderOn
            remainderDate = editHabit.notificationDate ?? Date()
            remainderText = editHabit.remainderText ?? ""
        }
    }
    
    // MARK: Done Button Status
    func doneStatus()-> Bool {
        let remainderStatus = isRemainderOn ? remainderText == "" : false
        
        if title == "" || weekDays.isEmpty || remainderStatus{
            return false
        }
        return true
    }
}
