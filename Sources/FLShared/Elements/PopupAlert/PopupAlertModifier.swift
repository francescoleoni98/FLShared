//
//  PopupAlert.swift
//  FLShared
//
//  Copyright (c) 2025 Francesco Leoni
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import SwiftUI

public extension View {

	func showAlertPopup(_ alert: Binding<PopupAlert?>) -> some View {
		let appAlert = alert.wrappedValue

		return self.alert(isPresented: .constant(appAlert != nil)) {
			if let action = appAlert?.primaryAction {
				action.completion = {
					alert.wrappedValue = nil
				}

				if let cancelAction = appAlert?.cancelAction {
					cancelAction.completion = {
						alert.wrappedValue = nil
					}

					return Alert(
						title: Text(appAlert?.title ?? ""),
						message: Text(appAlert?.message ?? ""),
						primaryButton: action.createButton(),
						secondaryButton: cancelAction.createButton()
					)
				} else {
					return Alert(
						title: Text(appAlert?.title ?? ""),
						message: Text(appAlert?.message ?? ""),
						dismissButton: action.createButton()
					)
				}
			} else if let cancelAction = appAlert?.cancelAction {
				cancelAction.completion = {
					alert.wrappedValue = nil
				}

				return Alert(
					title: Text(appAlert?.title ?? ""),
					message: Text(appAlert?.message ?? ""),
					dismissButton: cancelAction.createButton()
				)
			} else {
				return Alert(
					title: Text(appAlert?.title ?? ""),
					message: Text(appAlert?.message ?? ""),
					dismissButton: Alert.Button.cancel {
						alert.wrappedValue = nil
					}
				)
			}
		}
	}
}
