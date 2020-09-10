import Foundation
import SwiftUI

struct ErrorMessage: Identifiable {
	let id = UUID()
	let text: Text

	init<S>(_ message: S) where S: StringProtocol {
		self.init(verbatim: String(message))
	}
	init(verbatim message: String) {
		text = Text(message)
	}
	init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil) {
		text = Text(key, tableName: tableName, bundle: bundle, comment: comment)
	}
}
