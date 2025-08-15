import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var petName = ""
    @State private var petSpecies = ""
    @State private var petAge = ""

    var body: some View {
        List {
            Section(header: SectionHeader(title: "User Info")) {
                TextField("Name", text: $appState.ownerName)
                    .font(Typography.body)
                TextField("Email", text: $appState.ownerEmail)
                    .font(Typography.body)
            }
            .listRowBackground(Palette.surfaceAlt)

            Section(header: SectionHeader(title: "Add Pet")) {
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
                .buttonStyle(PrimaryButtonStyle())
            }
            .listRowBackground(Palette.surfaceAlt)

            Section(header: SectionHeader(title: "Pets")) {
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
            .listRowBackground(Palette.surfaceAlt)
        }
        .scrollContentBackground(.hidden)
        .background(Palette.surfaceAlt)
    }
}

#Preview {
    ProfileView().environmentObject(AppState())
}
