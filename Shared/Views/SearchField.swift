import SwiftUI

struct SearchField: View {
	var placeholder: LocalizedStringKey
	@Binding var text: String

	init(_ placeholder: LocalizedStringKey, text: Binding<String>) {
		self.placeholder = placeholder
		self._text = text
	}

	var body: some View {
		HStack(spacing: 4) {
			Image(systemName: "magnifyingglass")
			TextField(placeholder, text: $text)
			if !text.isEmpty {
				Button {
					text = ""
				} label: {
					Image(systemName: "multiply.circle.fill")
					.foregroundColor(.gray)
					.padding(.trailing, 8)
				}
			}
		}
			.padding([ .top, .bottom ], 6)
			.padding([ .leading, .trailing ], 8)
			.foregroundColor(.secondary)
			.background(Color.secondaryBackground)
			.cornerRadius(8)
			.keyboardType(.asciiCapableNumberPad)
	}
}
