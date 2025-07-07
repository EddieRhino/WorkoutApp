//
//  Workout-Tracker.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/21/25.
//

import SwiftUI

struct UpperWorkoutTracker: View {
    @State private var workouts: [Exercise] = [
        Exercise(name: "Rows", date: Date(), weight: 135, reps: 10),
    ]
    @State private var newWorkout: String = "Bench Press"
    @State private var newWeight: String = ""
    @State private var newReps: String = ""
    @State private var workoutOptions = ["Add New Workout"]
    @State private var brandNewWorkout: String = ""
    
    private var custDate: Date? = nil
    
    private var workoutDate: Date{
        custDate ?? Date()
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Text("Upper Body Workout\non \(dateFormatter.string(from: workoutDate))").font(.largeTitle)
                HStack{
                    Picker("Workout Name", selection: $newWorkout){
                        ForEach(workoutOptions , id: \.self) { workout in
                            Text(workout)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                    .padding(10)
                    .cornerRadius(0)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 5,
                            style: .continuous
                        )
                        .stroke(.gray, lineWidth: 2)

                    )
                    NavigationLink(destination: EditWorkouts(
                        workoutOptions: $workoutOptions, workoutType: "Upper"
                    )){
                        Text("Edit Workouts")
                            .padding(1)
                    }
                    .padding()
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .background(
                        RoundedRectangle(
                            cornerRadius: 5,
                            style: .continuous
                        )
                        .stroke(.gray, lineWidth: 2)

                    )
                }
                
                if newWorkout == "Add New Workout" {
                    TextField("Enter New Workout Name",text: $brandNewWorkout)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical)
                }
                
                
                TextField("Weight (lbs)", text: $newWeight)
                    .keyboardType(.decimalPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(5)
                
                TextField("Reps", text: $newReps)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(5)
                Button("Add Workout") {
                    guard let weight = Double(newWeight),
                          let reps = Int(newReps) else {
                        print("Invalid input")
                        return
                    }
                    
                    if newWorkout == "Add New Workout" {
                        brandNewWorkout = brandNewWorkout.trimmingCharacters(in: .whitespacesAndNewlines)
                        if !brandNewWorkout.isEmpty && !workoutOptions.contains(where: {option in
                            option.caseInsensitiveCompare(brandNewWorkout) == .orderedSame
                        }){
                            workoutOptions.insert(brandNewWorkout, at: workoutOptions.count - 1)
                            saveWorkoutOptionsUpper(workoutOptions)
                            newWorkout = brandNewWorkout
                            brandNewWorkout = ""
                        }
                        
                    }
                    
                    let newWorkoutAdd = Exercise(
                        name: newWorkout,
                        date: Date(),
                        weight: weight,
                        reps: reps
                    )
                    
                    workouts.append(newWorkoutAdd)
                    saveWorkoutsUpper(workouts)
                    
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
                            saveWorkoutsUpper(workouts)
                        }
                    }
                }
                Button("Complete Workout"){
                    guard !workouts.isEmpty else {return}
                    
                    let newPast = PastWorkout(
                        date: Date(),
                        title: "Upper Body Day",
                        exercises: workouts
                    )
                    var savedPast = loadPastWorkouts()
                    savedPast.append(newPast)
                    savePastWorkouts(savedPast)
                    workouts.removeAll()
                    saveWorkoutsUpper(workouts)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(.white)
                .cornerRadius(10)
            }
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing){
                    NavigationLink(destination: MainScreen()){
                        Image(systemName: "house")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear{
                workouts = loadWorkoutsUpper()
                workoutOptions = loadWorkoutOptionsUpper()
                if workoutOptions.isEmpty {
                    workoutOptions = ["Add New Workout"]
                    saveWorkoutOptionsUpper(workoutOptions)
                }
                var sorted = workoutOptions.filter { $0 != "Add New Workout"}.sorted()
                sorted.append("Add New Workout")
                workoutOptions = sorted
                if !workoutOptions.contains(newWorkout) {
                    newWorkout = workoutOptions.first ?? ""
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct UpperWorkoutTracker_Previews: PreviewProvider {
    static var previews: some View {
        UpperWorkoutTracker()
    }
}

func saveWorkoutsUpper(_ workouts: [Exercise]){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(workouts) {
        UserDefaults.standard.set(encoded, forKey: "SavedWorkoutsUpper")
    }
}

func loadWorkoutsUpper() -> [Exercise] {
    if let savedData = UserDefaults.standard.data(forKey: "SavedWorkoutsUpper"){
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Exercise].self, from: savedData){
            return decoded
        }
    }
    return []
}

func saveWorkoutOptionsUpper(_ workoutOptions: [String]){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(workoutOptions) {
        UserDefaults.standard.set(encoded, forKey: "SavedWorkoutOptionsUpper")
    }
}

func loadWorkoutOptionsUpper() -> [String] {
    if let savedData = UserDefaults.standard.data(forKey: "SavedWorkoutOptionsUpper"){
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([String].self, from: savedData){
            return decoded
        }
    }
    return []
}
