import AppKit

extension NSPasteboard: Pasteboard {
	var hasStrings: Bool {
		let bestType = availableType(from: [.string])
		return bestType == .string
	}

	var string: String? {
		get {
			string(forType: .string)
		}
		set {
			if let v = newValue {
				setString(v, forType: .string)
			} else {
			}
		}
	}
}

func getPasteboard() -> Pasteboard { NSPasteboard.general }
