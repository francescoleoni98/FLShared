//
//  AppError.swift
//  FLShared
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import SwiftUI

public struct AppError: LocalizedError {

	public var title: String
	public var message: String?
	public var errorDescription: String? { message ?? title }

	public init(title: String, message: String? = nil) {
		self.title = title
		self.message = message
	}
}

public extension View {

	func showErrorAlert(for error: Binding<Error?>, buttonTitle: String = "Ok") -> some View {
		let appError = error.wrappedValue

		var title: String = "Unknown error"
		var message: String?

		if let error = appError as? AppError {
			title = error.title
			message = error.message
		} else {
			title = appError?.localizedDescription ?? "Unknown error"
		}

		return alert(isPresented: .constant(appError != nil)) {
			Alert(
				title: Text(title),
				message: message == nil ? nil : Text(message ?? ""),
				dismissButton: Alert.Button.cancel(Text(buttonTitle), action: {
					error.wrappedValue = nil
				})
			)
		}
	}
}
