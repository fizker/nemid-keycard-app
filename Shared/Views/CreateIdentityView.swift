import SwiftUI
import NemIDKeycard

struct CreateIdentityView: View {
	var onCreate: (Identity) -> Void

	@State var name: String = ""
	@State var cpr: String = ""
	@State var error: String?
	@FocusState var hasFocus: Bool

	var body: some View {
		Form {
			TextField("Name", text: $name)
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

			TextField("CPR", text: $cpr)
			.keyboardType(.numberPad)

			Button("Create identity") {
				if name.isEmpty || cpr.isEmpty {
					error = "Both fields must be filled"
				} else {
					onCreate(.init(name: name, cpr: cpr, nemIDCredentials: nil, mitIDCredentials: nil))
				}
			}

			if let error {
				Text(error)
				.foregroundColor(.red)
			}
		}
	}
}
