//
//  Cards.swift
//  Cards
//
//  Created by Алексей Саблин on 11.01.2022.
//

import UIKit

// Протокол переворачиваемое View
protocol FlippableView: UIView {
    var isReturn: Bool { get set } // Карта возвращена на начальное положение
    var isFlipped: Bool { get set } // Карта перевернута
    var flipCompletionHandler: ((FlippableView) -> Void)? { get set } // Замыкание - обработка события после того как карта завершила переворот
    func flip() // Функция отвечающая за переворот
}

// Игральная карта
class CardView<ShapeType: ShapeLayerProtocol>: UIView, FlippableView {
    
    var maxBoardX: Int = 0
    var maxBoardY: Int = 0
    
    
    private var startTouchPoint: CGPoint!
    
    var isFlipped: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var isReturn: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    var flipCompletionHandler: ((FlippableView) -> Void)?
    func flip() {
        // определяем, между какими представлениями осуществить переход
        let fromView = isFlipped ? frontSideView : backSideView
        let toView = isFlipped ? backSideView : frontSideView
        // запускаем анимированный переход
        UIView.transition(from: fromView, to: toView, duration: 0.5, options:
                            [.transitionFlipFromRight], completion: { _ in
            // обработчик переворота
            self.flipCompletionHandler?(self)
        })
        isFlipped.toggle()
    }
    
    // цвет фигуры
    var color: UIColor!
    // радиус закругления
    var cornerRadius = 20
    
    init(frame: CGRect, color: UIColor, maxBoardX: Int, maxBoardY: Int) {
        super.init(frame: frame)
        self.color = color
        self.maxBoardX = maxBoardX
        self.maxBoardY = maxBoardY
        setupBorders()
    }
    
    override func draw(_ rect: CGRect) {
        // удаляем добавленные ранее дочерние представления
        backSideView.removeFromSuperview()
        frontSideView.removeFromSuperview()
        // добавляем новые представления
        if isFlipped {
            self.addSubview(backSideView)
            self.addSubview(frontSideView)
        } else {
            self.addSubview(frontSideView)
            self.addSubview(backSideView)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // внутренний отступ представления
    private let margin: Int = 10
    // представление с лицевой стороной карты
    lazy var frontSideView: UIView = self.getFrontSideView()
    // представление с обратной стороной карты
    lazy var backSideView: UIView = self.getBackSideView()
    
    // возвращает представление для лицевой стороны карточки
    private func getFrontSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        let shapeView = UIView(frame: CGRect(x: margin,
                                             y: margin,
                                             width: Int(self.bounds.width)-margin*2,
                                             height: Int(self.bounds.height)-margin*2))
        view.addSubview(shapeView)
        // создание слоя с фигурой
        let shapeLayer = ShapeType(size: shapeView.frame.size, fillColor: color.cgColor)
        shapeView.layer.addSublayer(shapeLayer)
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    // возвращает вью для обратной стороны карточки
    private func getBackSideView() -> UIView {
        let view = UIView(frame: self.bounds)
        view.backgroundColor = .white
        //выбор случайного узора для рубашки
        switch ["circle", "line"].randomElement()! {
        case "circle":
            let layer = BackSideCircle(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        case "line":
            let layer = BackSideLine(size: self.bounds.size, fillColor: UIColor.black.cgColor)
            view.layer.addSublayer(layer)
        default:
            break
        }
        // скругляем углы корневого слоя
        view.layer.masksToBounds = true
        view.layer.cornerRadius = CGFloat(cornerRadius)
        return view
    }
    
    // настройка границ
    private func setupBorders(){
        self.clipsToBounds = true
        self.layer.cornerRadius = CGFloat(cornerRadius)
        self.layer.borderWidth = 2
        self.layer.borderColor = UIColor.black.cgColor
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if self.frame.origin == startTouchPoint {
        flip()
        }
        //анимировано возвращаем карточку в исходную позицию
        if ((Int(self.frame.origin.x) < 0) || (Int(self.frame.origin.x) > self.maxBoardX)) ||
            ((Int(self.frame.origin.y) < 0) || (Int(self.frame.origin.y) > self.maxBoardY)){
                self.isReturn = true
                UIView.animate(withDuration: 0.5) {
                    self.frame.origin = self.startTouchPoint
                    self.transform = .identity
                }
            self.isReturn.toggle()
        }
    }
    
    // точка привязки
    private var anchorPoint: CGPoint = CGPoint(x: 10, y: 10)
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        anchorPoint.x = touches.first!.location(in: window).x - frame.minX
        anchorPoint.y = touches.first!.location(in: window).y - frame.minY
        // сохраняем исходные координаты
        startTouchPoint = frame.origin
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.frame.origin.x = touches.first!.location(in: window).x -
        anchorPoint.x
        self.frame.origin.y = touches.first!.location(in: window).y -
        anchorPoint.y
    }
}
