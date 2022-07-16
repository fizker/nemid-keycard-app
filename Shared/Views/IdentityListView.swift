import SwiftUI
import NemIDKeycard

private struct KeycardWithIdentity: Identifiable {
	let id: String
	let identity: Identity
	let keycard: Keycard

	init(identity: Identity, keycard: Keycard) {
		self.id = "\(identity.id)-\(keycard.id)"
		self.identity = identity
		self.keycard = keycard
	}
}

struct IdentityListView: View {
	@Binding var identities: [Identity]

	var body: some View {
		let keycards = identities
			.compactMap { x in x.nemIDCredentials.map { (x, $0) } }
			.flatMap { (ident: Identity, cred: NemIDCredentials) in cred.keycards.map { KeycardWithIdentity(identity: ident, keycard: $0) } }
			.sorted { $0.keycard.id < $1.keycard.id }

		List {
			Section(header: Text("Identities")) {
				ForEach(identities.indices) { index in
					NavigationLink(destination: IdentityDetailsView(identity: $identities[index])) {
						VStack(alignment: .leading) {
							Text(identities[index].name)
							Text(formatCPR(identities[index].cpr))
								.font(.caption)
						}
					}
				}
			}
			Section(header: Text("Keycards")) {
				ForEach(keycards) { k in
					NavigationLink(destination: KeycardDetailsView(keycard: k.keycard)) {
						VStack(alignment: .leading) {
							Text(formatKeycardID(k.keycard.id))
							Text(k.identity.name)
							.font(.caption)
							Text(formatCPR(k.identity.cpr))
							.font(.caption)
						}
					}
				}
			}
		}
		.listStyle(SidebarListStyle())
		.navigationTitle("NemID")
	}
}

#if DEBUG
struct IdentityListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			IdentityListView(identities: .constant(exampleIdentities))
		}
	}
}
#endif
