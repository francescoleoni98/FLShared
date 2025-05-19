//
//  AnalyticsProperty.swift
//  FLShared
//
//  Created by Francesco Leoni on 18/05/25.
//

import Foundation

public protocol AnalyticsProperty: Sendable {

	var name: String { get }
	var value: NSObject { get }
	var stringValue: String { get }
}
