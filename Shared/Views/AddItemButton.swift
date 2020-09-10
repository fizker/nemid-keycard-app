import SwiftUI

struct AddItemButton: View {
	var action: () -> Void
	var label: Text

	var body: some View {
		Button {
			print("Add-button action should not be called because buttons are disabled in edit-mode")
		} label: {
			HStack {
				Image(systemName: "plus.circle.fill")
					.foregroundColor(.green)
					.font(.title2)
				label
			}
		}
		.highPriorityGesture(TapGesture().onEnded(action))
	}
}
extension AddItemButton {
	init(_ content: LocalizedStringKey, action: @escaping () -> Void) {
		self.init(action: action, label: Text(content))
	}
}
