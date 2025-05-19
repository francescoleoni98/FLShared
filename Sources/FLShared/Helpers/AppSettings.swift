//
//  AppSettings.swift
//  FLShared
//
//  Created by Francesco Leoni on 17/05/25.
//

import SwiftUI

public enum AppSettings {

#if os(macOS)
	public static let settingsURL = "x-apple.systempreferences:com.apple.notifications"
#else
	public static let settingsURL = UIApplication.openSettingsURLString
#endif

	/// Opens the app settings.
	public static func openAppSettings() {
		if let url = URL(string: settingsURL) {
#if os(macOS)
			NSWorkspace.shared.open(url)
#else
			if UIApplication.shared.canOpenURL(url) {
				UIApplication.shared.open(url, options: [:], completionHandler: nil)
			}
#endif
		}
	}
}

public extension View {

	/// Opens the app settings.
	func openAppSettings() {
		AppSettings.openAppSettings()
	}
}
