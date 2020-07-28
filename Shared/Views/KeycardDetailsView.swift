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
				.unredacted()
			ScrollView {
				LazyVGrid(columns: [GridItem(.adaptive(minimum: 120, maximum: 200))]) {
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
			.padding()
			.navigationTitle("Keycard \(keycard.id)")
	}
}

#if DEBUG
struct KeycardDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			KeycardDetailsView(keycard: exampleIdentities[0].keycards[0])
				.redacted(reason: .placeholder)
			NavigationView {
				KeycardDetailsView(keycard: placeholderKeycard)
			}
				.navigationViewStyle(StackNavigationViewStyle())
		}
	}
}
#endif
