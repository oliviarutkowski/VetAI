import SwiftUI

struct ProfileView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var petName = ""
    @State private var petSpecies = ""
    @State private var petAge = ""
    @State private var pets: [Pet] = []

    var body: some View {
        Form {
            Section(header: Text("User Info")) {
                TextField("Name", text: $name)
                TextField("Email", text: $email)
            }

            Section(header: Text("Add Pet")) {
                TextField("Pet Name", text: $petName)
                TextField("Species", text: $petSpecies)
                TextField("Age", text: $petAge)
                Button("Add Pet") {
                    if let age = Int(petAge) {
                        let pet = Pet(name: petName, species: petSpecies, age: age)
                        pets.append(pet)
                        petName = ""
                        petSpecies = ""
                        petAge = ""
                    }
                }
            }

            Section(header: Text("Pets")) {
                if pets.isEmpty {
                    Text("No pets added yet")
                } else {
                    ScrollView {
                        VStack(alignment: .leading) {
                            ForEach(pets) { pet in
                                VStack(alignment: .leading) {
                                    Text(pet.name).font(.headline)
                                    Text("\(pet.species), Age: \(pet.age)")
                                        .font(.subheadline)
                                }
                                .padding(.vertical, 4)
                            }
                        }
                    }
                    .frame(maxHeight: 200)
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
