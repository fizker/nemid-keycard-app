import SwiftUI
import UniformTypeIdentifiers
import NemIDKeycard

extension UTType {
	static var keycards: UTType {
		UTType(importedAs: "dk.fizkerinc.keycards")
	}
}

struct KeycardDocument: FileDocument {
	var identities: [Identity]

	init(identities: [Identity] = []) {
		self.identities = identities
	}

	static var readableContentTypes: [UTType] { [.keycards] }

	init(fileWrapper: FileWrapper, contentType: UTType) throws {
		let decoder = JSONDecoder()
		guard let data = fileWrapper.regularFileContents
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		identities = try decoder.decode([Identity].self, from: data)
	}

	func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [ .prettyPrinted, .sortedKeys, .withoutEscapingSlashes ]
		let data = try encoder.encode(identities)
		fileWrapper = FileWrapper(regularFileWithContents: data)
	}
}
