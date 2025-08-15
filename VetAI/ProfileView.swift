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
                    .font(Typography.body)
                TextField("Email", text: $appState.ownerEmail)
                    .font(Typography.body)
            }

            Section(header: Text("Add Pet")) {
                TextField("Pet Name", text: $petName)
                    .font(Typography.body)
                TextField("Species", text: $petSpecies)
                    .font(Typography.body)
                TextField("Age", text: $petAge)
                    .font(Typography.body)
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
