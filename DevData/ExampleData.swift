import NemIDKeycard

let placeholderKeycard = Keycard(id: "Placeholder", keys: [
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
let placeholderIdentity = Identity(id: 0, name: "Select identity", cpr: "1234567890", password: "foobar", keycards: [placeholderKeycard])

#if DEBUG
let exampleIdentities = [
	Identity(id: 1, name: "User 1", cpr: "1234567890", password: "foo", keycards: [
		Keycard(id: "some id", keys: [
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
	]),
]
#endif
