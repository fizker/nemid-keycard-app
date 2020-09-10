import SwiftUI
import NemIDKeycard

struct IdentityDetailsView: View {
	@Binding var identity: Identity
	@Environment(\.editMode) var editMode

	var isEditing: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Text("CPR: \(formatCPR(identity.cpr))")
				Text("Password: \(identity.password)")
				Divider()
			}
			.padding([.leading, .trailing])

			List {
				ForEach(identity.keycards) { keycard in
					NavigationLink(destination: KeycardDetailsView(keycard: keycard)) {
						Text(keycard.id)
					}
				}
				.onDelete { indexSet in
					identity.keycards.remove(atOffsets: indexSet)
				}

				if isEditing {
					Button {
						print("Add-button action should not be called because buttons are disabled in edit-mode")
					} label: {
						HStack {
							Image(systemName: "plus.circle.fill")
								.foregroundColor(.green)
								.font(.title2)
							Text("Add new card from clipboard")
						}
					}
					.highPriorityGesture(TapGesture().onEnded {
						let keycard = Keycard(id: "foo", keys: [:])
						identity.keycards.append(keycard)
					})
					.environment(\.editMode, .constant(.inactive))
				}
			}
			.listStyle(PlainListStyle())
		}
		.navigationTitle(identity.name)
		.navigationBarItems(trailing: EditButton())
	}
}

#if DEBUG
struct IdentityDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			IdentityDetailsView(identity: .constant(exampleIdentities[0]))
			IdentityDetailsView(identity: .constant(exampleIdentities[0]))
				.environment(\.editMode, .constant(.active))

			NavigationView {
				IdentityDetailsView(identity: .constant(exampleIdentities[0]))
			}
		}
	}
}
#endif
