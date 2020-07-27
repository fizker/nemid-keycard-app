import SwiftUI
import NemIDKeycard

struct KVPair<K: Hashable, V>: Identifiable {
	let key: K
	let value: V

	var id: K { key }
}

struct KeycardDetailsView: View {
	let keycard: Keycard
	let items: [KVPair<String, String>]

	@State var searchValue = ""

	init(keycard: Keycard) {
		self.keycard = keycard
		items = keycard.keys.map(KVPair.init).sorted(by: { $0.key < $1.key })
	}

	var body: some View {
		VStack {
			TextField("Search", text: $searchValue)
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 100, maximum: 300))]) {
					ForEach(searchValue.isEmpty ? items : items.filter { $0.key.contains(searchValue) }) { pair in
						HStack {
							Text(pair.key)
							Text(pair.value)
						}
							.padding([.top, .bottom], 8)
							.font(Font.body.monospacedDigit())
							.lineLimit(1)
							.onTapGesture(perform: {
								UIPasteboard.general.string = pair.value
							})
					}
				}
			}
		}
			.navigationTitle("Keycard \(keycard.id)")
	}
}

#if DEBUG
struct KeycardDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		KeycardDetailsView(keycard: exampleIdentities[0].keycards[0])
	}
}
#endif
