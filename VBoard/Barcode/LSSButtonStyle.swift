//
//  ButtonStyle.swift
//  fixStore
//
//  Created by Gyeongtae Nam on 2021/08/02.
//

import SwiftUI

public struct LSSButtonStyle<Content>: ButtonStyle where Content :View {
    var change :(Bool) -> Content
    public func makeBody(configuration: Configuration) -> some View {
        return change(configuration.isPressed)
    }
}
