import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var petName = ""
    @State private var petSpecies = ""
    @State private var petAge = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case ownerName, ownerEmail, petName, petSpecies, petAge
    }

    var body: some View {
        List {
            Section(header: SectionHeader(title: "User Info")) {
                TextField("Name", text: $appState.ownerName)
                    .font(Typography.body)
                    .focused($focusedField, equals: .ownerName)
                TextField("Email", text: $appState.ownerEmail)
                    .font(Typography.body)
                    .focused($focusedField, equals: .ownerEmail)
            }
            .listRowBackground(Palette.surfaceAlt)

            Section(header: SectionHeader(title: "Add Pet")) {
                TextField("Pet Name", text: $petName)
                    .font(Typography.body)
                    .focused($focusedField, equals: .petName)
                TextField("Species", text: $petSpecies)
                    .font(Typography.body)
                    .focused($focusedField, equals: .petSpecies)
                TextField("Age", text: $petAge)
                    .font(Typography.body)
                    .focused($focusedField, equals: .petAge)
                Button("Add Pet") {
                    guard !petName.isEmpty, !petSpecies.isEmpty, let age = Int(petAge) else {
                        return
                    }
                    let pet = Pet(name: petName, species: petSpecies, age: age)
                    appState.pets.append(pet)
                    petName = ""
                    petSpecies = ""
                    petAge = ""
                    focusedField = nil
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
#if os(iOS)
        .scrollDismissesKeyboard(.interactively)
#endif
        .scrollContentBackground(.hidden)
        .background(Palette.surfaceAlt)
#if os(iOS)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") { focusedField = nil }
            }
        }
#endif
    }
}

#Preview {
    ProfileView().environmentObject(AppState())
}
