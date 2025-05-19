//
//  AnalyticsManagerInterface.swift
//  BrainDump
//
//  Copyright (c) 2025 Francesco Leoni
//
//  This file is part of the Brain Dump project.
//  Unauthorized copying of this file, via any medium, is strictly prohibited.
//  Proprietary and confidential.
//
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import Foundation

public protocol AnalyticsManagerInterface {

	var services: [AnalyticsService] { get set }

	func logEvent(_ event: AnalyticsEvent)
	func setScreen(_ screen: AnalyticsScreen)
	func setProperty(_ property: AnalyticsProperty)
	func setUserId(_ id: String)
}

public extension AnalyticsManagerInterface {

	func logEvent(_ event: AnalyticsEvent) {
		services.forEach { $0.logEvent(event) }
	}

	func setScreen(_ screen: AnalyticsScreen) {
		services.forEach { $0.setScreen(screen) }
	}

	func setProperty(_ property: AnalyticsProperty) {
		services.forEach { $0.setProperty(property) }
	}

	func setUserId(id: String) {
		services.forEach { $0.setUserId(id) }
	}
}
