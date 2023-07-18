import SwiftUI

struct CPRGeneratorView: View {
	@State var birthday: Date = .now

	var validCPRs: [String] {
		(0...9999)
		.filter { checkCPR(date: birthday, digits: $0) }
		.map { format(date: birthday, digits: $0) }
	}

	var body: some View {
		VStack {
			DatePicker(selection: $birthday, displayedComponents: .date) {
				Text("Birthday")
			}

			List(validCPRs, id: \.self) {
				Text($0)
			}
		}
	}

	private func format(date: Date, digits: Int) -> String {
		let calendar = Calendar(identifier: .gregorian)
		let components: (day: Int, month: Int, year: Int) = (
			calendar.component(.day, from: date),
			calendar.component(.month, from: date),
			calendar.component(.year, from: date)
		)

		var year = "\(components.year)"
		year = String(year[year.index(year.endIndex, offsetBy: -2)...])

		return "\(pad(components.day, to: 2))\(pad(components.month, to: 2))\(year)\(pad(digits, to: 4))"
	}

	private func checkCPR(date: Date, digits: Int) -> Bool {
		guard digits < 10_000
		else { return false }

		let factors = [4, 3, 2, 7, 6, 5, 4, 3, 2, 1]

		let cpr = format(date: date, digits: digits)

		var ciffer = 0
		let mainInt = cpr
		.map {
			defer { ciffer += 1 }
			return Int(String($0))! * factors[ciffer]
		}
		.reduce(0, +)

		return mainInt % 11 == 0
	}

	private func pad(_ number: Int, to padding: Int) -> String {
		String(String("\(number)".reversed()).padding(toLength: padding, withPad: "0", startingAt: 0).reversed())
	}

	private func getDigits(_ number: Int, padding: Int = 0) -> [Int] {
		var number = number
		var digits: [Int] = []

		while number > 0 {
			let a = number
			let b = a / 10
			let c = a - (b*10)
			digits.append(c)
			number = b
		}

		while digits.count < padding {
			digits.append(0)
		}

		return digits.reversed()
	}
}

#if DEBUG
struct CPRGeneratorView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			CPRGeneratorView()
		}
	}
}
#endif
