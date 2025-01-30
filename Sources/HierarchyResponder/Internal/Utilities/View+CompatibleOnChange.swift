//
//  View+CompatibleOnChange.swift
//  HierarchyResponder
//
//  Created by Emilio Peláez on 12/7/24.
//

import SwiftUI

//	Removed because it caused a crash on visionOS in Release mode 🤷🏽‍♂️
//extension View {
//	func onAppearAndChange<V: Equatable>(of value: V, perform: @escaping (V) -> Void) -> some View {
//		if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
//			return onChange(of: value, initial: true) { oldValue, newValue in
//				perform(newValue)
//			}
//		} else {
//			return onAppear { perform(value) }
//				.onChange(of: value) { perform($0) }
//		}
//	}
//}
