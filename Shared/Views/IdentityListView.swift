import SwiftUI
import NemIDKeycard

struct IdentityListView: View {
	let identities: [Identity]
	var body: some View {
		List(identities) { identity in
			NavigationLink(destination: IdentityDetailsView(identity: identity)) {
				VStack(alignment: .leading) {
					Text(identity.name)
					Text(formatCPR(identity.cpr))
						.font(.caption)
				}
			}
		}
		.navigationTitle("Identities")
	}
}

#if DEBUG
struct IdentityListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationView {
			IdentityListView(identities: exampleIdentities)
		}
	}
}
#endif
