//
//  Home.swift
//  HabitTracker
//
//  Created by Esma Koçak on 10.08.2024.
//

import SwiftUI

struct Home: View {
    @FetchRequest(entity: Habit.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Habit.dateAdded, ascending: false)], predicate: nil, animation: .easeInOut) var
        habits: FetchedResults<Habit>
    
    var body: some View {
        VStack {
            Text("Habits")
                .font(.title2.bold())
                .frame(maxWidth: .infinity)
                .overlay(alignment: .trailing) {
                    Button {
                        
                    } label: {
                        Image(systemName: "gearshape")
                            .font(.title3)
                            .foregroundColor(.white)
                    }
            }
            
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15){
                    
                    // MARK: Add Habit Button
                    Button {
                        
                    } label: {
                        Label {
                            Text("New habit")
                        } icon: {
                            Image(systemName: "plus.circle")
                        }
                        .font(.callout.bold())
                        .foregroundColor(.white)
                    }
                    .padding(.top, 15)
                }
                .padding(.vertical)
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .padding()
    }
}

#Preview {
    ContentView()
}
