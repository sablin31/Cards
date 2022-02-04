//
//  Card.swift
//  Card
//
//  Created by Алексей Саблин on 11.01.2022.
//

import Foundation

// типы фигуры карт
enum CardType: CaseIterable {
    case circle
    case cross
    case square
    case fill
}

// цвета карт
enum CardColor: CaseIterable {
    case red
    case green
    case black
    case gray
    case brown
    case yellow
    case purple
    case orange
}

// игральная карточка
typealias Card = (type: CardType, color: CardColor)
