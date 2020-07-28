import SwiftUI

func formatCPR(_ cpr: String) -> String {
	return "\(cpr.dropLast(4))-\(cpr.dropFirst(6))"
}

struct ContentView: View {
	@Binding var document: KeycardDocument

	var body: some View {
		NavigationView {
			IdentityListView(identities: document.identities)

			if let ident = document.identities.first {
				IdentityDetailsView(identity: ident)
			} else {
				IdentityDetailsView(identity: placeholderIdentity)
					.redacted(reason: .placeholder)
			}
		}
	}
}

#if DEBUG
struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(document: .constant(KeycardDocument(identities: exampleIdentities)))
	}
}
#endif
