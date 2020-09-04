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

	init(configuration: ReadConfiguration) throws {
		let decoder = JSONDecoder()
		guard let data = configuration.file.regularFileContents
		else {
			throw CocoaError(.fileReadCorruptFile)
		}
		identities = try decoder.decode([Identity].self, from: data)
	}

	func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
		let encoder = JSONEncoder()
		encoder.outputFormatting = [ .prettyPrinted, .sortedKeys, .withoutEscapingSlashes ]
		let data = try encoder.encode(identities)
		return FileWrapper(regularFileWithContents: data)
	}
}
