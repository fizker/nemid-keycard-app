import SwiftUI

func formatCPR(_ cpr: String) -> String {
	return "\(cpr.dropLast(4))-\(cpr.dropFirst(6))"
}

func formatKeycardID(_ id: String) -> String {
	guard id.count == 10
	else { return id }

	let regex = /\D|\d{3}/
	let matches = id.matches(of: regex)

	guard matches.count == 4
	else { return id }

	let substrings = matches.map(\.output)
	return "\(substrings[0])\(substrings[1...].joined(separator: "-"))"
}

struct ContentView: View {
	@Binding var document: KeycardDocument

	var body: some View {
		NavigationSplitView {
			IdentityListView(identities: $document.identities)
		} detail: {
			if !document.identities.isEmpty {
				IdentityDetailsView(identity: $document.identities[0])
			} else {
				IdentityDetailsView(identity: .constant(placeholderIdentity))
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
