//
//  Utilities.swift
//  FLShared
//
//  Created by Francesco Leoni on 18/04/25.
//

import SwiftUI

public enum Utilities {

	public static func copy(text: String) {
#if os(iOS) || os(visionOS)
		UIPasteboard.general.string = text
#else
			NSPasteboard.general.declareTypes([.string], owner: nil)
			let pasteboard = NSPasteboard.general
			pasteboard.setString(text, forType: .string)
#endif
	}

	public static func copy(url: URL?) {
#if os(iOS) || os(visionOS)
		UIPasteboard.general.url = url
#else
		if let url {
			NSPasteboard.general.declareTypes([.string], owner: nil)
			let pasteboard = NSPasteboard.general
			pasteboard.setString(url.absoluteString, forType: .string)
		}
#endif
	}

	public static func openURL(url: URL?) -> Bool {
		guard let url else { return false }

#if os(iOS) || os(visionOS)
		Task {
			if await UIApplication.shared.canOpenURL(url) {
				return await UIApplication.shared.open(url)
			} else {
				return false
			}
		}
		return true
#else
		return NSWorkspace.shared.open(url)
#endif
	}
}
