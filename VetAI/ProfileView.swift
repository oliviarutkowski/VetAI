import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var editingProfile = false
    @State private var showAddPet = false
    @State private var petName = ""
    @State private var petSpecies = ""
    @State private var petAge = ""
    @FocusState private var focusedField: Field?

    enum Field {
        case ownerName, ownerEmail, petName, petSpecies, petAge
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.xl) {
                    profileCard

                    SectionHeader("Your Pets")

                    if appState.pets.isEmpty {
                        Text("No pets added yet")
                            .font(Typography.body)
                            .foregroundColor(.secondary)
                    } else {
                        VStack(spacing: Spacing.md) {
                            ForEach(appState.pets) { pet in
                                Card {
                                    HStack {
                                        VStack(alignment: .leading) {
                                            Text(pet.name).font(.headline)
                                            Text("\(pet.species), Age: \(pet.age)")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        Spacer()
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.secondary)
                                    }
                                }
                            }
                        }
                    }

                    Button("Add Pet") { showAddPet = true }
                        .buttonStyle(PrimaryButtonStyle())
                        .frame(maxWidth: .infinity)
                }
                .padding(Spacing.l)
            }
#if os(iOS)
            .scrollDismissesKeyboard(.interactively)
#endif
            .background(Palette.surfaceAlt)
            .navigationTitle("Profile")
        }
        .sheet(isPresented: $showAddPet) {
            NavigationStack {
                VStack(spacing: Spacing.md) {
                    TextField("Pet Name", text: $petName)
                        .font(Typography.body)
                        .focused($focusedField, equals: .petName)
                    TextField("Species", text: $petSpecies)
                        .font(Typography.body)
                        .focused($focusedField, equals: .petSpecies)
                    TextField("Age", text: $petAge)
                        .font(Typography.body)
#if os(iOS)
                        .keyboardType(.numberPad)
#endif
                        .focused($focusedField, equals: .petAge)

                    Button("Save") {
                        guard !petName.isEmpty,
                              !petSpecies.isEmpty,
                              let age = Int(petAge) else { return }
                        let pet = Pet(name: petName, species: petSpecies, age: age)
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.8)) {
                            appState.pets.append(pet)
                        }
#if os(iOS)
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
#endif
                        petName = ""
                        petSpecies = ""
                        petAge = ""
                        showAddPet = false
                        focusedField = nil
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .padding(.top, Spacing.md)

                    Spacer()
                }
                .padding(Spacing.l)
                .navigationTitle("Add Pet")
                .toolbar {
                    ToolbarItemGroup(placement: .keyboard) {
                        Spacer()
                        Button("Done") { focusedField = nil }
                    }
                }
            }
        }
    }

    private var profileCard: some View {
        Card {
            HStack(alignment: .top, spacing: Spacing.md) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 60))

                VStack(alignment: .leading, spacing: Spacing.sm) {
                    if editingProfile {
                        TextField("Name", text: $appState.ownerName)
                            .font(Typography.body)
                            .focused($focusedField, equals: .ownerName)
                        TextField("Email", text: $appState.ownerEmail)
                            .font(Typography.body)
                            .focused($focusedField, equals: .ownerEmail)
                    } else {
                        Text(appState.ownerName.isEmpty ? "Your Name" : appState.ownerName)
                            .font(Typography.body)
                        Text(appState.ownerEmail.isEmpty ? "you@example.com" : appState.ownerEmail)
                            .font(Typography.body)
                            .foregroundColor(.secondary)
                    }
                }

                Spacer()

                Button(editingProfile ? "Done" : "Edit") {
                    editingProfile.toggle()
                    if !editingProfile {
                        focusedField = nil
                    }
                }
                .font(Typography.body)
            }
        }
    }
}

#Preview {
    ProfileView().environmentObject(AppState())
}

