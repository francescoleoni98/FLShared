//
//  Toast.swift
//  BrainDump
//
//  Created by Francesco Leoni on 20/04/25.
//

import SwiftUI

public struct Toast: Identifiable, Equatable {

	public var id: UUID
	var icon: String
	var title: String
	var message: String?

	public init(id: UUID = UUID(), icon: String, title: String, message: String? = nil) {
		self.id = id
		self.icon = icon
		self.title = title
		self.message = message
	}
}

struct ToastViewModifier: ViewModifier {

	@Binding var showToast: Toast?

	func body(content: Content) -> some View {
		ZStack(alignment: .top) {
			content

			if showToast != nil {
				ToastNotification(isShowing: $showToast)
			}
		}
	}
}

public extension View {

	@ViewBuilder
	func show(toast: Binding<Toast?>) -> some View {
		modifier(ToastViewModifier(showToast: toast))
	}
}

struct ToastNotification: View {

	@Binding var isShowing: Toast?
	@State private var offset: CGFloat = -150

	var body: some View {
		HStack(spacing: 0) {
			Image(systemName: isShowing?.icon ?? "")
				.foregroundColor(.secondary)
				.font(.title)

			VStack(spacing: 0) {
				Text(isShowing?.title ?? "")
					.font(.subheadline.bold())
					.foregroundStyle(.primary)

				if let message = isShowing?.message {
					Text(message)
						.font(.subheadline)
						.foregroundStyle(.secondary)
				}
			}
			.multilineTextAlignment(.center)
			.foregroundColor(Color("black"))
			.padding(.horizontal, 12)
		}
		.padding(.horizontal, 20)
		.padding(.vertical, 8)
		.background(Color("white"), in: .capsule)
		.offset(y: offset)
		.shadow(color: .black.opacity(0.3), radius: 20)
//		.padding(.top, 10)
//		.frame(maxWidth: .infinity)
		.onTapGesture {
			startDismissal()
		}
		.onAppear {
			withAnimation(.easeOut(duration: 0.25)) {
				offset = 20
			}

			DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
				startDismissal()
			}
		}
	}

	private func startDismissal() {
		withAnimation(.easeIn(duration: 0.25)) {
			offset = -150
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
			isShowing = nil
		}
	}
}
