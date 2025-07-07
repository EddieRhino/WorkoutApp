//
//  Workout-Tracker.swift
//  Fitness App
//
//  Created by Eddie Reinhardt on 6/21/25.
//

import SwiftUI

struct LegsWorkoutTracker: View {
    @State private var workouts: [Exercise] = [
        Exercise(name: "Squats", date: Date(), weight: 135, reps: 10),
    ]
    @State private var newWorkout: String = "Squats"
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
                Text("Legs Workout\non \(dateFormatter.string(from: workoutDate))").font(.largeTitle)
                HStack{
                    Picker("", selection: $newWorkout){
                        ForEach(workoutOptions , id: \.self) { workout in
                            Text(workout).tag(workout)
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
                        workoutOptions: $workoutOptions, workoutType: "Legs"
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
                            saveWorkoutOptionsLegs(workoutOptions)
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
                    saveWorkoutsLegs(workouts)
                    
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
                            saveWorkoutsLegs(workouts)
                        }
                    }
                }
                Button("Complete Workout"){
                    guard !workouts.isEmpty else {return}
                    
                    let newPast = PastWorkout(
                        date: Date(),
                        title: "Leg Day",
                        exercises: workouts
                    )
                    var savedPast = loadPastWorkouts()
                    savedPast.append(newPast)
                    savePastWorkouts(savedPast)
                    workouts.removeAll()
                    saveWorkoutsLegs(workouts)
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
                workouts = loadWorkoutsLegs()
                workoutOptions = loadWorkoutOptionsLegs()
                if workoutOptions.isEmpty {
                    workoutOptions = ["Add New Workout"]
                    saveWorkoutOptionsLegs(workoutOptions)
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

struct LegsWorkoutTracker_Previews: PreviewProvider {
    static var previews: some View {
        LegsWorkoutTracker()
    }
}

func saveWorkoutsLegs(_ workouts: [Exercise]){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(workouts) {
        UserDefaults.standard.set(encoded, forKey: "SavedWorkoutsLegs")
    }
}

func loadWorkoutsLegs() -> [Exercise] {
    if let savedData = UserDefaults.standard.data(forKey: "SavedWorkoutsLegs"){
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([Exercise].self, from: savedData){
            return decoded
        }
    }
    return []
}

func saveWorkoutOptionsLegs(_ workoutOptions: [String]){
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(workoutOptions) {
        UserDefaults.standard.set(encoded, forKey: "SavedWorkoutOptionsLegs")
    }
}

func loadWorkoutOptionsLegs() -> [String] {
    if let savedData = UserDefaults.standard.data(forKey: "SavedWorkoutOptionsLegs"){
        let decoder = JSONDecoder()
        if let decoded = try? decoder.decode([String].self, from: savedData){
            return decoded
        }
    }
    return []
}
