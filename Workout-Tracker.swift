//
//  Workout-Tracker.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/21/25.
//

import SwiftUI

struct Workout_Tracker: View {
    @State private var workouts: [Exercise] = [
        Exercise(name: "Bench Press", date: Date(), weight: 135, reps: 10),
    ]
    @State private var newWorkout: String = ""
    @State private var newWeight: String = ""
    @State private var newReps: String = ""
    @State private var workoutOptions = ["Bench Press","Incline Bench Press","Pec Dec Flys","High to Low Cable Flys","Tricep Cable Pushdown","Tricep Cable Overhead Extension","Skullcrushers","Tricep Cable Kickbacks","Chest Press","Machine Shoulder Press","Lateral Raises","Cable Lateral Raises","Lateral Raise Machine","Dumbbell Shoulder Press","Incline Dumbbell Press","Flat Dumbbell Press","Dips"]
    var body: some View {
        VStack{
            Text("Workouts").padding().font(.largeTitle)
            Picker("Workout Name", selection: $newWorkout){
                ForEach(workoutOptions , id: \.self) { workout in
                    Text(workout)
                }
            }
            .pickerStyle(MenuPickerStyle())
            .padding(10)
            .cornerRadius(0)
            .background(Color(UIColor.systemGray6))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
            )
                        
                    
                    TextField("Weight (lbs)", text: $newWeight)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    
                    TextField("Reps", text: $newReps)
                        .keyboardType(.numberPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())

                    Button("Add Workout") {
                        guard let weight = Double(newWeight),
                              let reps = Int(newReps) else {
                            print("Invalid input")
                            return
                        }

                        let newWorkoutAdd = Exercise(
                            name: newWorkout,
                            date: Date(),
                            weight: weight,
                            reps: reps
                        )

                        workouts.append(newWorkoutAdd)
                        saveWorkouts(workouts)

                        // Clear input fields
                        newWorkout = ""
                        newWeight = ""
                        newReps = ""
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            VStack {
                List {
                    ForEach(workouts) { item in
                        Text("\(item.name): \(item.reps) at \(String(format: "%g", item.weight)) lbs")
                    }
                    .onDelete { indexSet in
                        workouts.remove(atOffsets: indexSet)
                        saveWorkouts(workouts)
                    }
                }
            }

        }
        .onAppear{
            workouts = loadWorkouts()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    func deleteWorkout(at offsets: IndexSet) {
        workouts.remove(atOffsets: offsets)
    }
}

struct Workout_Tracker_Previews: PreviewProvider {
    static var previews: some View {
        Workout_Tracker()
    }
}

struct Exercise: Identifiable, Codable{
    var id = UUID()
    var name: String
    var date: Date
    var weight: Double
    var reps: Int
}

func saveWorkouts(_ workouts: [Exercise]){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(workouts) {
        UserDefaults.standard.set(encoded, forKey: "SavedWorkouts")
    }
}

func loadWorkouts() -> [Exercise] {
    if let savedData = UserDefaults.standard.data(forKey: "SavedWorkouts"){
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Exercise].self, from: savedData){
            return decoded
        }
    }
    return []
}
