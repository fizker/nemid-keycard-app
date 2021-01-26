import UIKit

extension UIPasteboard: Pasteboard {
}

func getPasteboard() -> Pasteboard { UIPasteboard.general }
