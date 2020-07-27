import SwiftUI

struct ContentView: View {
	@Binding var document: KeycardDocument

	var body: some View {
		ForEach(document.identities) {
			Text($0.name)
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
