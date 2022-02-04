//
//  CardViewFactory.swift
//  Cards
//
//  Created by Алексей Саблин on 12.01.2022.
//

import UIKit
class CardViewFactory {
    func get(_ shape: CardType, withSize size: CGSize, andColor color: CardColor, maxBoardX boardX: Int, maxBoardY boardY: Int) -> UIView {
        // на основе размеров определяем фрейм
        let frame = CGRect(origin: .zero, size: size)
        // определяем UI-цвет на основе цвета модели
        let viewColor = getViewColorBy(modelColor: color)
        // генерируем и возвращаем карточку
        switch shape {
        case .circle:
            return CardView<CircleShape>(frame: frame, color: viewColor, maxBoardX: boardX, maxBoardY: boardY)
        case .cross:
            return CardView<CrossShape>(frame: frame, color: viewColor, maxBoardX: boardX, maxBoardY: boardY)
        case .square:
            return CardView<SquareShape>(frame: frame, color: viewColor, maxBoardX: boardX, maxBoardY: boardY)
        case .fill:
            return CardView<FillShape>(frame: frame, color: viewColor, maxBoardX: boardX, maxBoardY: boardY)
        }
    }
    // преобразуем цвет Модели в цвет Представления
    private func getViewColorBy(modelColor: CardColor) -> UIColor {
        switch modelColor {
        case .black:
            return .black
        case .red:
            return .red
        case .green:
            return .green
        case .gray:
            return .gray
        case .brown:
            return .brown
        case .yellow:
            return .yellow
        case .purple:
            return .purple
        case .orange:
            return .orange
        }
    }
}
