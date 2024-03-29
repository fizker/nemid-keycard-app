import SwiftUI
import NemIDKeycard

struct KVPair<K: Hashable, V>: Identifiable {
	let key: K
	let value: V

	var id: K { key }
}

private extension View {
	func h() -> some View {
		#if os(iOS)
		return hoverEffect()
		#else
		return self
		#endif
	}
}

func withAnimation(
	_ animation: @escaping (Double) -> Animation,
	delay: TimeInterval = 0.2,
	body: @escaping () -> (),
	afterAnimation body2: @escaping () -> ()
) {
	withAnimation(animation(delay), body)
	Timer.scheduledTimer(withTimeInterval: delay, repeats: false) { _ in
		body2()
	}
}

struct KeycardValueView: View {
	var key: String
	var value: String
	var onCopy: () -> ()

	@State var isClicked = false

	var body: some View {
		HStack {
			Text(key)
			Text(value)
		}
			.padding(8)
			.font(Font.body.monospacedDigit())
			.lineLimit(1)
			.onTapGesture {
				onCopy()
				withAnimation(Animation.easeInOut) {
					isClicked = true
				} afterAnimation: {
					isClicked = false
				}
			}
			.background(isClicked ? Color.secondaryBackground : Color.clear)
	}
}

struct KeycardDetailsView: View {
	let keycard: Keycard
	let items: [KVPair<String, String>]

	@State var searchValue = ""
	@FocusState var hasFocus: Bool

	init(keycard: Keycard) {
		self.keycard = keycard
		items = keycard.keys.map(KVPair.init).sorted(by: { $0.key < $1.key })
	}

	var body: some View {
		VStack {
			SearchField("Search", text: $searchValue)
				.focused($hasFocus)
				.task {
					// Set default focus
					while !hasFocus {
						hasFocus = true
						do {
							try await Task.sleep(interval: 0.05)
						} catch {
							break
						}
					}
				}
				.unredacted()
			ScrollView {
				LazyVGrid(
					columns: [
						GridItem(.adaptive(minimum: 120, maximum: 200)),
					],
					alignment: .leading
				) {
					ForEach(searchValue.isEmpty ? items : items.filter { $0.key.contains(searchValue) }) { pair in
						KeycardValueView(key: pair.key, value: pair.value) {
							getPasteboard().string = pair.value
						}
							.h()
					}
				}
			}
		}
			.padding()
			.navigationTitle("\(formatKeycardID(keycard.id))")
	}
}

#if DEBUG
struct KeycardDetailsView_Previews: PreviewProvider {
	static var previews: some View {
		Group {
			KeycardDetailsView(keycard: exampleIdentities[0].nemIDCredentials!.keycards[0])
				.redacted(reason: .placeholder)
			NavigationStack {
				KeycardDetailsView(keycard: placeholderKeycard)
			}
		}
	}
}
#endif
