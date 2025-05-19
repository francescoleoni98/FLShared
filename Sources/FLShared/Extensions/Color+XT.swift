//
//  SwiftUIView.swift
//  FLShared
//
//  Created by Francesco Leoni on 18/05/25.
//

import SwiftUI

public extension Color {

	#if canImport(UIKit)
	init(hex: String) {
		self.init(UIColor(hex: hex))
	}
	#else
	init(hex: String) {
		self.init(NSColor(hex: hex))
	}
	#endif

	var hexString: String {
		#if canImport(UIKit)
		UIColor(self).hexString
		#else
		NSColor(self).hexString
		#endif
	}
}

#if canImport(UIKit)
public extension UIColor {

	convenience init(hex: String) {
		let trimHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		let hexString = trimHex.replacingOccurrences(of: "#", with: "")
		let ui64 = UInt64(hexString, radix: 16)
		let value = ui64 != nil ? Int(ui64!) : 0
		// #RRGGBB
		var components = (
			R: CGFloat((value >> 16) & 0xff) / 255,
			G: CGFloat((value >> 08) & 0xff) / 255,
			B: CGFloat((value >> 00) & 0xff) / 255,
			a: CGFloat(1)
		)

		if String(hexString).count == 8 {
			// #RRGGBBAA
			components = (
				R: CGFloat((value >> 24) & 0xff) / 255,
				G: CGFloat((value >> 16) & 0xff) / 255,
				B: CGFloat((value >> 08) & 0xff) / 255,
				a: CGFloat((value >> 00) & 0xff) / 255
			)
		}

		self.init(red: components.R, green: components.G, blue: components.B, alpha: components.a)
	}

	var hexString: String {
			guard let components = self.cgColor.components else { return "ffffff" }

			let red = Float(components[0])
			let green = Float(components[1])
			let blue = Float(components[2])
			return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
	}
}
#else
public extension NSColor {

	convenience init(hex: String) {
		let trimHex = hex.trimmingCharacters(in: .whitespacesAndNewlines)
		let hexString = trimHex.replacingOccurrences(of: "#", with: "")
		let ui64 = UInt64(hexString, radix: 16)
		let value = ui64 != nil ? Int(ui64!) : 0
		// #RRGGBB
		var components = (
			R: CGFloat((value >> 16) & 0xff) / 255,
			G: CGFloat((value >> 08) & 0xff) / 255,
			B: CGFloat((value >> 00) & 0xff) / 255,
			a: CGFloat(1)
		)

		if String(hexString).count == 8 {
			// #RRGGBBAA
			components = (
				R: CGFloat((value >> 24) & 0xff) / 255,
				G: CGFloat((value >> 16) & 0xff) / 255,
				B: CGFloat((value >> 08) & 0xff) / 255,
				a: CGFloat((value >> 00) & 0xff) / 255
			)
		}

		self.init(red: components.R, green: components.G, blue: components.B, alpha: components.a)
	}

	var hexString: String {
			guard let components = self.cgColor.components else { return "ffffff" }

			let red = Float(components[0])
			let green = Float(components[1])
			let blue = Float(components[2])
			return String(format: "#%02lX%02lX%02lX", lroundf(red * 255), lroundf(green * 255), lroundf(blue * 255))
	}
}
#endif
