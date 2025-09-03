import SwiftUI

struct PetDetailView: View {
    let pet: Pet

    var body: some View {
        Form {
            Section("Pet Info") {
                HStack { Text("Name"); Spacer(); Text(pet.name) }
                HStack { Text("Species"); Spacer(); Text(pet.species) }
                HStack { Text("Age"); Spacer(); Text("\(pet.age)") }
            }
        }
        .navigationTitle(pet.name)
    }
}

#Preview {
    PetDetailView(pet: Pet(name: "Buddy", species: "dog", age: 5))
        .environmentObject(AppState())
}
