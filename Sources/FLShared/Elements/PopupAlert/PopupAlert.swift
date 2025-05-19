//
//  PopupAlert.swift
//  FLShared
//
//  Created by Francesco Leoni on 17/05/25.
//

import SwiftUI

public class PopupAlert: Identifiable {

	public var id = UUID()
	public var title: String
	public var message: String?
	public var primaryAction: ActionButton?
	public var cancelAction: ActionButton?

	public init(id: UUID = UUID(), title: String.LocalizationValue, message: String.LocalizationValue? = nil, showCancel: Bool = true, action: ActionButton? = nil) {
		self.id = id
		self.title = String(localized: title)
		if let message {
			self.message = String(localized: message)
		}
		self.primaryAction = action
		self.cancelAction = showCancel ? .cancel : nil
	}

	public init(id: UUID = UUID(), title: String.LocalizationValue, message: String.LocalizationValue? = nil, cancelAction: ActionButton? = nil) {
		self.id = id
		self.title = String(localized: title)
		if let message {
			self.message = String(localized: message)
		}
		self.primaryAction = nil
		self.cancelAction = cancelAction
	}

	public init(id: UUID = UUID(), title: String.LocalizationValue, message: String.LocalizationValue? = nil, action: ActionButton? = nil, cancelAction: ActionButton? = nil) {
		self.id = id
		self.title = String(localized: title)
		if let message {
			self.message = String(localized: message)
		}
		self.primaryAction = action
		self.cancelAction = cancelAction
	}

	public init(id: UUID = UUID(), _ title: String.LocalizationValue, message: String? = nil, showCancel: Bool = true, action: ActionButton? = nil) {
		self.id = id
		self.title = String(localized: title)
		self.message = message
		self.primaryAction = action
		self.cancelAction = showCancel ? .cancel : nil
	}

	public init(id: UUID = UUID(), _ title: String.LocalizationValue, message: String? = nil, cancelAction: ActionButton? = nil) {
		self.id = id
		self.title = String(localized: title)
		self.message = message
		self.primaryAction = nil
		self.cancelAction = cancelAction
	}
}

extension PopupAlert {

	public final class ActionButton {

		public let title: String
		public let destructive: Bool
		public let action: () -> Void
		public var completion: () -> Void

		public static let ok = PopupAlert.ActionButton(title: "Ok")
		public static let cancel = PopupAlert.ActionButton(title: "Cancel")

		public init(title: String, destructive: Bool = false, action: @escaping () -> Void = { }, completion: @escaping () -> Void = { }) {
			self.title = title
			self.destructive = destructive
			self.action = action
			self.completion = completion
		}

		func createButton() -> Alert.Button {
			if destructive {
				return Alert.Button.destructive(Text(title)) {
					self.action()
					self.completion()
				}
			} else {
				return Alert.Button.default(Text(title)) {
					self.action()
					self.completion()
				}
			}
		}
	}
}
