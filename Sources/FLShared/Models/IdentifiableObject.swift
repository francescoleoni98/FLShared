//
//  IdentifiableObject.swift
//  FLShared
//
//  Copyright (c) 2025 Francesco Leoni
//  Written by Francesco Leoni <leoni.francesco98@gmail.com>, April 2025.
//

import Foundation

public class IdentifiableObject<T>: Identifiable {

	public var id = UUID()
	public var object: T

	public init(id: UUID = UUID(), _ object: T) {
		self.id = id
		self.object = object
	}
}
