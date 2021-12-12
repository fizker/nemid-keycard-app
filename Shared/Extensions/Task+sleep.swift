import Foundation

extension Task where Success == Never, Failure == Never {
	static func sleep(interval: TimeInterval) async throws {
		let ns = interval * 1_000_000_000
		try await sleep(nanoseconds: UInt64(ns))
	}
}
