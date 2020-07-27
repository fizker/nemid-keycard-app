import SwiftUI

@main
struct KeycardApp: App {
	var body: some Scene {
		DocumentGroup(newDocument: KeycardDocument()) { file in
			ContentView(document: file.$document)
		}
	}
}
