import SwiftUI

func formatCPR(_ cpr: String) -> String {
	return "\(cpr.dropLast(4))-\(cpr.dropFirst(6))"
}

struct ContentView: View {
	@Binding var document: KeycardDocument

	var body: some View {
		NavigationView {
			IdentityListView(identities: $document.identities)

			if !document.identities.isEmpty {
				IdentityDetailsView(identity: $document.identities[0])
			} else {
				IdentityDetailsView(identity: .constant(placeholderIdentity))
					.redacted(reason: .placeholder)
			}
		}.navigationViewStyle(DoubleColumnNavigationViewStyle())
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(document: .constant(KeycardDocument(identities: exampleIdentities)))
	}
}
#endif
