import NemIDKeycard

let placeholderKeycard = Keycard(id: "A123456789", keys: [
	"1111": "111111",
	"2222": "222222",
	"3333": "333333",
	"4444": "444444",
	"5555": "555555",
	"6666": "666666",
	"7777": "777777",
	"8888": "888888",
	"9999": "999999",
	"0000": "000000",
])
let placeholderIdentity = Identity(
	name: "Select identity",
	cpr: "1234567890",
	nemIDCredentials: .init(id: 0, password: "foobar", keycards: [placeholderKeycard]),
	mitIDCredentials: .init(username: "Foo", password: "Bar")
)

#if DEBUG
let exampleIdentities = [
	Identity(
		name: "User 1",
		cpr: "1234567890",
		nemIDCredentials: .init(
			id: 1,
			password: "foo",
			keycards: [
				Keycard(id: "A123456789", keys: [
					"1111": "111156",
					"2222": "222256",
					"3333": "333356",
					"4444": "444456",
					"5555": "555556",
					"6666": "666656",
					"1234": "123456",
					"1324": "132456",
					"1342": "134256",
					"3124": "312456",
					"3142": "314256",
					"3412": "341256",
					"2134": "213456",
					"2314": "231456",
					"2341": "234156",
				]),
			]
		),
		mitIDCredentials: .init(username: "Username", password: "pass")
	),
	Identity(name: "No credentials", cpr: "1234567891", nemIDCredentials: nil, mitIDCredentials: nil),
	Identity(name: "Only MitID", cpr: "1234567892", nemIDCredentials: nil, mitIDCredentials: .init(username: "foo", password: "bar")),
]
#endif
