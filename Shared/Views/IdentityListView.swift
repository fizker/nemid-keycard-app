import SwiftUI
import NemIDKeycard

struct IdentityListView: View {
	@Binding var identities: [Identity]

	var body: some View {
		let keycards = identities
			.flatMap { ident in ident.keycards.map { (identity: ident, keycard: $0) } }
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
				ForEach(keycards.indices) { index in
					NavigationLink(destination: KeycardDetailsView(keycard: keycards[index].keycard)) {
						VStack(alignment: .leading) {
							Text(formatKeycardID(keycards[index].keycard.id))
							Text(keycards[index].identity.name)
							.font(.caption)
							Text(formatCPR(keycards[index].identity.cpr))
							.font(.caption)
						}
					}
				}
			}
		}
		.navigationTitle("NemID")
		.editButton()
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
