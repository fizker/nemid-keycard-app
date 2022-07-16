import SwiftUI
import NemIDKeycard

protocol Pasteboard: AnyObject {
	var hasStrings: Bool { get }
	var string: String? { get set }
}

extension View {
	func editButton() -> some View {
		#if os(iOS)
		return navigationBarItems(trailing: EditButton())
		#else
		return self
		#endif
	}
}

struct EditableLabel: View {
	#if os(macOS)
	private var isEditing: Bool = true
	#else
	@Environment(\.editMode) private var editMode

	private var isEditing: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}
	#endif

	var title: String
	@Binding var value: String
	var image: String

	var body: some View {
		Label(title: {
			if isEditing {
				TextField(title, text: $value)
			} else {
				Text(value)
			}
		}, icon: { Image(systemName: image).frame(minWidth: 20) })
	}
}

struct MitIDCredentialsView: View {
	@Binding var credentials: MitIDCredentials

	#if os(macOS)
	var isEditing: Bool = true
	#else
	@Environment(\.editMode) var editMode

	var isEditing: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}
	#endif

	var body: some View {
		VStack(alignment: .leading) {
			EditableLabel(title: "Username", value: $credentials.username, image: "person")
			EditableLabel(title: "Password", value: $credentials.password, image: "key")
		}
	}
}

struct NemIDCredentialsView: View {
	@Binding var credentials: NemIDCredentials

	#if os(macOS)
	var isEditing: Bool = true
	#else
	@Environment(\.editMode) var editMode

	var isEditing: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}
	#endif

	private var pb: Pasteboard { getPasteboard() }
	@State var errorMessage: ErrorMessage?

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Text("DanID ID: \(credentials.id)")
				Text("Password: \(credentials.password)")
			}
			.padding([.leading, .trailing])

			List {
				ForEach(credentials.keycards) { keycard in
					NavigationLink(destination: KeycardDetailsView(keycard: keycard)) {
						Text(formatKeycardID(keycard.id))
					}
				}
				.onDelete { indexSet in
					credentials.keycards.remove(atOffsets: indexSet)
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

						credentials.keycards.append(keycard)
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
	}
}

struct IdentityDetailsView: View {
	@Binding var identity: Identity

	#if os(macOS)
	var isEditing: Bool = true
	#else
	@Environment(\.editMode) var editMode

	var isEditing: Bool {
		editMode?.wrappedValue.isEditing ?? false
	}
	#endif

	var body: some View {
		VStack(alignment: .leading) {
			Text("CPR: \(formatCPR(identity.cpr))")
			.padding([.leading, .trailing])

			Text("MitID Test Login")
			.font(.title)
			.padding([ .leading, .trailing, .top ])

			if let credentials = identity.mitIDCredentials {
				MitIDCredentialsView(credentials: Binding(get: { credentials }, set: { identity.mitIDCredentials = $0 }))
				.padding([ .leading, .trailing ])

				if isEditing {
					Button("Remove MitID credentials") {
						identity.mitIDCredentials = nil
					}
					.padding([ .leading, .trailing ])
				}
			} else if isEditing {
				Button("Add MitID credentials") {
					identity.mitIDCredentials = .init(username: "", password: "")
				}
				.padding([ .leading, .trailing ])
			}

			if let credentials = identity.nemIDCredentials {
				Text("NemID")
				.font(.title)
				.padding([ .leading, .trailing, .top ])

				NemIDCredentialsView(credentials: Binding(get: { credentials }, set: { identity.nemIDCredentials = $0 }))
			}
		}
		.navigationTitle(identity.name)
		.editButton()
	}
}

#if DEBUG
struct IdentityDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			IdentityDetailsView(identity: .constant(exampleIdentities[0]))
			#if os(iOS)
			IdentityDetailsView(identity: .constant(exampleIdentities[0]))
				.environment(\.editMode, .constant(.active))
			#endif

			NavigationView {
				IdentityDetailsView(identity: .constant(exampleIdentities[0]))
			}
		}
	}
}
#endif
