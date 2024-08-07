//
//  HeightPreferenceKey.swift
//  BudgetPlan
//
//  Created by Tamara Barišić on 07.08.2024..
//

import Foundation

struct HeightPreferenceKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}
