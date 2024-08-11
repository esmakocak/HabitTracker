//
//  addNewHabit.swift
//  HabitTracker
//
//  Created by Esma Koçak on 11.08.2024.
//

import SwiftUI

struct addNewHabit: View {
    @EnvironmentObject var habitModel: HabitViewModel
    // MARK: Environment Values
    var body: some View {
        NavigationView{
            VStack(spacing: 15){
                TextField("Title", text: $habitModel.title)
                    .padding(.horizontal)
                    .padding(.vertical, 10)
                    .background(Color("TFBG").opacity(0.6), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
                
                // MARK: Habit Color Picker
                HStack(spacing: 0){
                    ForEach(1...7, id: \.self) { index in
                        let color = "Card-\(index)"
                        Circle()
                            .fill(Color(color))
                            .frame(width: 30, height: 30)
                            .frame(maxWidth: .infinity)
                            .overlay {
                                if color == habitModel.habitColor{
                                    Image(systemName: "checkmark")
                                        .font(.caption.bold())
                                }
                            }
                    }
                }

            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add Habit")
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        
                    } label: {
                        Image(systemName: "xmark.circle")
                    }
                    .tint(.white)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        
                    }
                    .tint(.white)
                }
            }
        }
    }
}

#Preview {
    addNewHabit()
        .environmentObject(HabitViewModel())
        .preferredColorScheme(.dark)
}
