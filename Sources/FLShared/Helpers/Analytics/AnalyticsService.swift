//
//  AnalyticsService.swift
//  AnalyticsCore
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

public protocol AnalyticsService {
	
	func logEvent(_ event: AnalyticsEvent)
	func setScreen(_ screen: AnalyticsScreen)
	func setProperty(_ property: AnalyticsProperty)
	func setUserId(_ id: String)
}
