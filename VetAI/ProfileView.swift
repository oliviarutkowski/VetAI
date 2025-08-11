import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var petName = ""
    @State private var petSpecies = ""
    @State private var petAge = ""

    var body: some View {
        List {
            Section(header: Text("User Info")) {
                TextField("Name", text: $appState.ownerName)
                TextField("Email", text: $appState.ownerEmail)
            }

            Section(header: Text("Add Pet")) {
                TextField("Pet Name", text: $petName)
                TextField("Species", text: $petSpecies)
                TextField("Age", text: $petAge)
                Button("Add Pet") {
                    if let age = Int(petAge) {
                        let pet = Pet(name: petName, species: petSpecies, age: age)
                        appState.pets.append(pet)
                        petName = ""
                        petSpecies = ""
                        petAge = ""
                    }
                }
            }

            Section(header: Text("Pets")) {
                if appState.pets.isEmpty {
                    Text("No pets added yet")
                } else {
                    ForEach(appState.pets) { pet in
                        VStack(alignment: .leading) {
                            Text(pet.name).font(.headline)
                            Text("\(pet.species), Age: \(pet.age)")
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete { indexSet in
                        appState.pets.remove(atOffsets: indexSet)
                    }
                }
            }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AppState())
}
