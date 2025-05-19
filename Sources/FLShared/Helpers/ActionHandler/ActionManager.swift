//
//  ActionManager.swift
//  BrainDump
//
//  Created by Francesco Leoni on 18/05/25.
//

import Foundation

public protocol ActionManager {

	var handlers: [any ActionHandler] { get }

	func setUserIsNotAuthenticated()
	func setUserIsAuthenticated()

	@MainActor
	@discardableResult
	func handleCurrentActionIfAble() -> Bool
}

public extension ActionManager {

	func setUserIsNotAuthenticated() {
		handlers.forEach { handler in
			handler.authenticationLevel = .nonAuthenticated
		}
	}

	func setUserIsAuthenticated() {
		handlers.forEach { handler in
			handler.authenticationLevel = .authenticated
		}
	}

	@MainActor
	@discardableResult
	func handleCurrentActionIfAble() -> Bool {
		for handler in handlers {
			if handler.handleIfAble() {
				return true
			}
		}

		return false
	}
}
