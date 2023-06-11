import SwiftUI

func formatCPR(_ cpr: String) -> String {
	return "\(cpr.dropLast(4))-\(cpr.dropFirst(6))"
}

func formatKeycardID(_ id: String) -> String {
	guard id.count == 10
	else { return id }

	let nsStr = id as NSString

	let regex = try! NSRegularExpression(pattern: #"(\D|\d{3})"#, options: [])
	let matches = regex.matches(in: id, options: [], range: NSRange(location: 0, length: nsStr.length))

	guard matches.count == 4
	else { return id }

	var substrings = matches.map { nsStr.substring(with: $0.range) }
	let first = substrings.removeFirst()
	return "\(first)\(substrings.joined(separator: "-"))"
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
