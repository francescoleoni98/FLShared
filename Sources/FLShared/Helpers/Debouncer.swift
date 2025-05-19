//
//  Debouncer.swift
//  FLShared
//
//  Copyright (c) 2025 Francesco Leoni
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import Foundation

public class Debouncer {

	private let delay: TimeInterval
	private var workItem: DispatchWorkItem?
	private let queue: DispatchQueue
	private var isFirstCall: Bool = true

	// MARK: Init

	public init(
		delay: TimeInterval,
		queue: DispatchQueue = DispatchQueue.main
	) {
		self.delay = delay
		self.queue = queue
	}

	// MARK: Methods

	public func debounce(action: @escaping () -> Void) {
		workItem?.cancel()
		workItem = DispatchWorkItem { [weak self] in
			action()
			self?.workItem = nil
		}

		if let workItem {
			if isFirstCall {
				queue.async(execute: workItem)
				isFirstCall = false
			} else {
				queue.asyncAfter(deadline: .now() + delay, execute: workItem)
			}
		}

//		if isFirstCall {
//			isFirstCall = false
//		}
	}
}
