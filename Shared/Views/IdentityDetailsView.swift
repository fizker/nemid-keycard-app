import SwiftUI
import NemIDKeycard

struct IdentityDetailsView: View {
	@Binding var identity: Identity
	@Environment(\.editMode) var editMode

	var isEditing: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}

	private var pb: UIPasteboard { UIPasteboard.general }
	@State var errorMessage: ErrorMessage?

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
					AddItemButton("Add new card from clipboard") {
						guard pb.hasStrings
						else {
							errorMessage = ErrorMessage("No pasteboard content")
							return
						}
						guard
							let clipboardContent = pb.string,
							let keycard = Keycard(string: clipboardContent)
						else {
							errorMessage = ErrorMessage("Invalid content in clipboard")
							return
						}

						identity.keycards.append(keycard)
					}
					.alert(item: $errorMessage) { message in
						Alert(
							title: message.text,
							dismissButton: .cancel(Text("OK")) {
								self.errorMessage = nil
							}
						)
					}
					.disabled(!pb.hasStrings)
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
