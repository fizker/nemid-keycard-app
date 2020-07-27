import SwiftUI
import NemIDKeycard

struct IdentityDetailsView: View {
	let identity: Identity

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Text("CPR: \(formatCPR(identity.cpr))")
				Text("Password: \(identity.password)")
			}
			.padding([.leading, .trailing])

			List(identity.keycards) { keycard in
				NavigationLink(destination: KeycardDetailsView(keycard: keycard)) {
					Text(keycard.id)
				}
			}
			.listStyle(PlainListStyle())
		}
		.navigationTitle(identity.name)
	}
}

#if DEBUG
struct IdentityDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			IdentityDetailsView(identity: exampleIdentities[0])

			NavigationView {
				IdentityDetailsView(identity: exampleIdentities[0])
			}
		}
	}
}
#endif
