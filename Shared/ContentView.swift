import SwiftUI

struct ContentView: View {
	@Binding var document: KeycardDocument

	var body: some View {
		NavigationView {
			IdentityListView(identities: document.identities)
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
