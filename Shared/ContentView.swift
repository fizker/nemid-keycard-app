import SwiftUI

struct ContentView: View {
	@Binding var document: KeycardDocument

	var body: some View {
		TextEditor(text: $document.text)
	}
}

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		ContentView(document: .constant(KeycardDocument()))
	}
}
