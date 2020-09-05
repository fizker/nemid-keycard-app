import SwiftUI
import NemIDKeycard

struct IdentityDetailsView: View {
	@Binding var identity: Identity

	var body: some View {
		VStack(alignment: .leading) {
			VStack(alignment: .leading) {
				Text("CPR: \(formatCPR(identity.cpr))")
				Text("Password: \(identity.password)")
				Divider()
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
			IdentityDetailsView(identity: .constant(exampleIdentities[0]))

			NavigationView {
				IdentityDetailsView(identity: .constant(exampleIdentities[0]))
			}
		}
	}
}
#endif
