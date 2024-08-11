//
//  HabitViewModel.swift
//  HabitTracker
//
//  Created by Esma Koçak on 11.08.2024.
//

import SwiftUI
import CoreData

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
}

