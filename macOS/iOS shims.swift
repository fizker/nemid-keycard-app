import SwiftUI

enum KeyboardType {
	case asciiCapableNumberPad
	case numberPad
}
extension View {
	func keyboardType(_ k: KeyboardType) -> Self {
		self
	}
}
