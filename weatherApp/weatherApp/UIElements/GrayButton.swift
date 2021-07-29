//
//  GrayButton.swift
//  weatherApp
//
//  Created by Mix174 on 27.07.2021.
//
import UIKit

final class GrayButton: UIButton {
    // свойства
    var color = UIColor(displayP3Red: 250, green: 250, blue: 250, alpha: 1)
    var shadowColor = UIColor.gray
    let touchDownAlpha: CGFloat = 0.6
    // функция настройки
    func setup() {
        // цвет при нажатии
        backgroundColor = .clear
        // основной цвет
        layer.backgroundColor = color.cgColor
        // радиус
        layer.cornerRadius = 10
        // настройка тени
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowOpacity = 0.75
        layer.shadowRadius = 2
    }
    // автонастройка кнопки
    override func awakeFromNib() {
        super.awakeFromNib()

        if let backgroundColor = backgroundColor {
            color = backgroundColor
        }
        setup()
    }
    // условие нажатия кнопки
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                touchDown()
            } else {
                cancelTracking(with: nil)
                touchUp()
            }
        }
    }
    // отжатие кнопки
    func touchDown() {
        stopTimer()
        layer.backgroundColor = color.withAlphaComponent(touchDownAlpha).cgColor
        layer.shadowColor = shadowColor.withAlphaComponent(touchDownAlpha).cgColor // доп для тени
    }
    // свойства таймера
    weak var timer: Timer?
    let timerStep: TimeInterval = 0.01
    let animateTime: TimeInterval = 0.4
    lazy var alphaStep: CGFloat = {
        return (1 - touchDownAlpha) / CGFloat(animateTime / timerStep)
    }()
    // функция остановки таймера
    func stopTimer() {
        timer?.invalidate()
    }
    // деинициализатор
    deinit {
        stopTimer()
    }
    // нажатие кнопки
    func touchUp() {
        timer = Timer.scheduledTimer(timeInterval: timerStep,
                                     target: self,
                                     selector: #selector(animation),
                                     userInfo: nil,
                                     repeats: true)
    }
    // функция анимации
    @objc func animation() {
        guard let backgroundAlpha = layer.backgroundColor?.alpha else {
            stopTimer()
            return
        }
        let newAlpha = backgroundAlpha + alphaStep
        if newAlpha < 1 {
            layer.backgroundColor = color.withAlphaComponent(newAlpha).cgColor
            layer.shadowColor = shadowColor.withAlphaComponent(newAlpha).cgColor // доп для тени
        } else {
            layer.backgroundColor = color.cgColor
            layer.shadowColor = shadowColor.cgColor // доп для тени
            stopTimer()
        }
    }
}
