//
//  FloatingActionButton.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 05/10/25.
//

import UIKit

@IBDesignable
class FloatingActionButton: UIButton {

    @IBInspectable var fabBackgroundColor: UIColor = .myYellow {
        didSet { backgroundColor = fabBackgroundColor }
    }

    @IBInspectable var symbolName: String = "plus" {
        didSet { updateImage() }
    }

    override var intrinsicContentSize: CGSize {
        return CGSize(width: 56, height: 56)
    }

    // Cuando se crea una instancia desde codigo
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    // Cuando lo usamos con la ui del storyboard
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        backgroundColor = fabBackgroundColor
        
        updateImage()
        tintColor = .white
        titleLabel?.text = ""
    }
    
    

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    private func updateImage() {
        // withRenderingMode -> always template
        // sirve para forzar al icono utilizar el color del tintColor
        let image = UIImage(systemName: symbolName)?.withRenderingMode(
            .alwaysTemplate
        )
        setImage(image, for: .normal)
    }

}
