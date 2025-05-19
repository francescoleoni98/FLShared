//
//  ActionHandler.swift
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

public protocol ActionHandler: AnyObject {

	associatedtype Action: PerformableAction

	var authenticationLevel: AuthenticationLevel { get set }

	var action: Action? { get set }
	var actionDate: Date? { get set }

	/// After this many seconds, the action is considered expired.
	var validDuration: TimeInterval { get }

	func setAction(_ action: Action?)

	@MainActor
	func handleIfAble() -> Bool

	@MainActor
	func handle(action: Action)
}

public extension ActionHandler {

	func setAction(_ action: Action?) {
		self.action = action
		self.actionDate = .now
	}

	@MainActor
	func handleIfAble() -> Bool {
		guard let action,
					let actionDate,
					actionDate < (.now + validDuration) else {
			reset()
			return false
		}

		switch authenticationLevel {
		case .none:
			return false

		case .nonAuthenticated:
			if !action.mustBeAuthenticated {
				handle(action: action)
				reset()
				return true
			} else {
				return false
			}

		case .authenticated:
			handle(action: action)
			reset()
			return true
		}
	}

	func reset() {
		action = nil
		actionDate = nil
	}
}
