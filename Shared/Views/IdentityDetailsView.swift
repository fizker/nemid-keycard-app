import SwiftUI
import NemIDKeycard

struct ErrorMessage: Identifiable {
	let id = UUID()
	let text: Text

	init<S>(_ message: S) where S: StringProtocol {
		self.init(verbatim: String(message))
	}
	init(verbatim message: String) {
		self.text = Text(message)
	}
	init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil) {
		text = Text(key, tableName: tableName, bundle: bundle, comment: comment)
	}
}

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
					})
					.alert(item: $errorMessage) { message in
						Alert(
							title: message.text,
							dismissButton: .cancel(Text("OK")) {
								self.errorMessage = nil
							}
						)
					}
					.disabled(!pb.hasStrings)
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
