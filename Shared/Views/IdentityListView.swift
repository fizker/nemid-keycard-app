import SwiftUI
import NemIDKeycard

struct IdentityListView: View {
	@Binding var identities: [Identity]

	var body: some View {
		List {
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
		.navigationTitle("Identities")
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
