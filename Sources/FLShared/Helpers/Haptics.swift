//
//  Haptics.swift
//  FLShared
//
//  Created by Francesco Leoni on 20/04/25.
//

#if canImport(UIKit)
import UIKit
#endif

public enum Haptics {

	public static func success() {
#if os(iOS)
		UINotificationFeedbackGenerator().notificationOccurred(.success)
#endif
	}
	
	public static func error() {
#if os(iOS)
		UINotificationFeedbackGenerator().notificationOccurred(.error)
#endif
	}

	public static func selection() {
#if os(iOS)
		UIImpactFeedbackGenerator().impactOccurred(intensity: 0.8)
#endif
	}
}
