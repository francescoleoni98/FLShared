//
//  AnalyticsEvent.swift
//  FLShared
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import Foundation

/// Protocol representing a generic analytics event.
public protocol AnalyticsEvent {

	/// The event name to be logged.
	var name: String { get }
	
	/// Optional parameters associated with the event.
	var parameters: [String: Any]? { get }
}
