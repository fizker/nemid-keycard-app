#if DEBUG
import NemIDKeycard

let exampleIdentities = [
	Identity(id: 1, name: "User 1", cpr: "123456-7890", password: "foo", keycards: [
		Keycard(id: "some id", keys: [
			"1234": "123456",
		]),
	]),
]
#endif
