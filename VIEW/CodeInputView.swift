import UIKit

open class CodeInputView: UIView, UIKeyInput {
  open var delegate: CodeInputViewDelegate?
  private var nextTag = 1

  // MARK: - UIResponder

  open override var canBecomeFirstResponder : Bool {
    return true
  }

  // MARK: - UIView

  public override init(frame: CGRect) {
    super.init(frame: frame)
    
    var x:CGFloat = 10 / 375 * 100
    x = x * UIScreen.main.bounds.width / 100
    
    var y:CGFloat = 10 / 667 * 100
    y = y * UIScreen.main.bounds.height / 100
    
    var x1:CGFloat = x
    
    print("X FRAME = \(x), Y FRAME = \(y)", self.frame.width, self.frame.height, UIScreen.main.bounds.width, UIScreen.main.bounds.height)

    // Add six digitLabels
    var frame = CGRect(x: x1, y: y, width: (5.08 * x), height: (7 * y))
    for index in 1...6 {
      let digitLabel = UILabel(frame: CGRect(x: x1, y: y, width: (5.08 * x), height: (7 * y)))
        digitLabel.layer.borderWidth = 1
        digitLabel.layer.borderColor = UIColor.black.cgColor
        digitLabel.backgroundColor = UIColor.white
      digitLabel.font = .systemFont(ofSize: 42)
      digitLabel.tag = index
      digitLabel.text = "."
      digitLabel.textAlignment = .center
      addSubview(digitLabel)
      frame.origin.x += 35 + 15
        
        x1 = digitLabel.frame.maxX + x
    }
  }
    
  required public init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") } // NSCoding

  // MARK: - UIKeyInput

  public var hasText : Bool {
    return nextTag > 1 ? true : false
  }

  open func insertText(_ text: String) {
    if nextTag < 7 {
      (viewWithTag(nextTag)! as! UILabel).text = text
      nextTag += 1

      if nextTag == 7 {
        var code = ""
        for index in 1..<nextTag {
          code += (viewWithTag(index)! as! UILabel).text!
        }
        delegate?.codeInputView(self, didFinishWithCode: code)
      }
    }
  }

  open func deleteBackward() {
    if nextTag > 1 {
      nextTag -= 1
      (viewWithTag(nextTag)! as! UILabel).text = "."
    }
  }

  open func clear() {
    while nextTag > 1 {
      deleteBackward()
    }
  }

  // MARK: - UITextInputTraits

  open var keyboardType: UIKeyboardType { get { return .numberPad } set { } }
}

public protocol CodeInputViewDelegate {
  func codeInputView(_ codeInputView: CodeInputView, didFinishWithCode code: String)
}
