import UIKit
import QuartzCore

enum CustomAlertConfig {
    case oneButton
    case twoButton
}

enum CustomAlertType {
    case negative
    case neutral
    case positive
}

final class CustomAlertViewController: UIViewController {
    private let transitioner = CAVTransitioner()
    private let alertTitle: String
    var message: String
    private let config: CustomAlertConfig
    private let alertType: CustomAlertType = .negative
    
    var okButtonAction: (() -> Void)?
    var cancelButtonAction: (() -> Void)?
    
    init(
        title alertTitle: String,
        message: String,
        config: CustomAlertConfig = .oneButton,
        okButtonPressed: ( () -> Void)? = nil,
        cancelButtonPressed: ( () -> Void)? = nil
    ) {
        self.alertTitle = alertTitle
        self.message = message
        self.config = config
        self.okButtonAction = okButtonPressed
        self.cancelButtonAction = cancelButtonPressed
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .custom
        self.transitioningDelegate = self.transitioner
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var image: UIImageView = {
        let view = UIImageView()
        switch alertType {
        case .negative:
            view.image = UIImage(systemName: "x.square")
        case .neutral:
            view.image = UIImage(systemName: "questionmark.square")
        case .positive:
            view.image = UIImage(systemName: "checkmark.square")
        }
        view.tintColor = .triviaGreen
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = alertTitle
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.text = message
        label.textColor = .black
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var okButton: UIButton = {
        let button = UIButton()
        button.setTitle("OK", for: .normal)
        button.addTarget(self, action: #selector(okButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .triviaGreen
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.triviaGreen, for: .normal)
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .white
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.triviaGreen.cgColor
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(contentView)
        contentView.addSubview(image)
        contentView.addSubview(titleLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(okButton)
        
        if config == .twoButton {
            contentView.addSubview(cancelButton)
        }
        
        var constraintArray = [
            contentView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 250),
            contentView.widthAnchor.constraint(equalToConstant: 250),
            
            image.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            image.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -90),
            image.heightAnchor.constraint(equalToConstant: 50),
            image.widthAnchor.constraint(equalToConstant: 50),
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -30),
            titleLabel.heightAnchor.constraint(equalToConstant: 50),
            titleLabel.widthAnchor.constraint(equalToConstant: 200),
            
            messageLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            messageLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 30),
            messageLabel.heightAnchor.constraint(equalToConstant: 50),
            messageLabel.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        switch config {
        case .oneButton:
            constraintArray += [
                okButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
                okButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 100),
                okButton.heightAnchor.constraint(equalToConstant: 50),
                okButton.widthAnchor.constraint(equalToConstant: 250)
            ]
        case .twoButton:
            constraintArray += [
                okButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 62.5),
                okButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 100),
                okButton.heightAnchor.constraint(equalToConstant: 50),
                okButton.widthAnchor.constraint(equalToConstant: 125),
                
                cancelButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: -62.5),
                cancelButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 100),
                cancelButton.heightAnchor.constraint(equalToConstant: 50),
                cancelButton.widthAnchor.constraint(equalToConstant: 125)
            ]
        }
        
        NSLayoutConstraint.activate(constraintArray)
    }
    
    @objc private func okButtonPressed() {
        okButtonAction?()
        dismiss(animated: true)
    }
    
    @objc private func cancelButtonPressed() {
        cancelButtonAction?()
        dismiss(animated: true)
    }
}



class CAVTransitioner : NSObject, UIViewControllerTransitioningDelegate {
    func presentationController(
        forPresented presented: UIViewController,
        presenting: UIViewController?,
        source: UIViewController)
        -> UIPresentationController? {
            return MyPresentationController(
                presentedViewController: presented, presenting: presenting)
    }
}

class MyPresentationController : UIPresentationController {
    
    func decorateView(_ v:UIView) {
        v.layer.cornerRadius = 8
        
        let m1 = UIInterpolatingMotionEffect(
            keyPath:"center.x", type:.tiltAlongHorizontalAxis)
        m1.maximumRelativeValue = 10.0
        m1.minimumRelativeValue = -10.0
        let m2 = UIInterpolatingMotionEffect(
            keyPath:"center.y", type:.tiltAlongVerticalAxis)
        m2.maximumRelativeValue = 10.0
        m2.minimumRelativeValue = -10.0
        let g = UIMotionEffectGroup()
        g.motionEffects = [m1,m2]
        v.addMotionEffect(g)
    }
    
    override func presentationTransitionWillBegin() {
        self.decorateView(self.presentedView!)
        
        let vc = self.presentingViewController
        let v = vc.view!
        let con = self.containerView!
        let shadow = UIView(frame: con.bounds)
        shadow.backgroundColor = UIColor(white:0, alpha:0.4)
        shadow.alpha = 0
        con.insertSubview(shadow, at: 0)
        shadow.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        let tc = vc.transitionCoordinator!
        tc.animate(alongsideTransition: { _ in
            shadow.alpha = 1
        }) { _ in
            v.tintAdjustmentMode = .dimmed
        }
    }
    
    override func dismissalTransitionWillBegin() {
        let vc = self.presentingViewController
        let v = vc.view!
        let con = self.containerView!
        let shadow = con.subviews[0]
        let tc = vc.transitionCoordinator!
        tc.animate(alongsideTransition: { _ in
            shadow.alpha = 0
        }) { _ in
            v.tintAdjustmentMode = .automatic
        }
    }
    
    override var frameOfPresentedViewInContainerView : CGRect {
        // we want to center the presented view at its "native" size
        // I can think of a lot of ways to do this,
        // but here we just assume that it *is* its native size
        let v = self.presentedView!
        let con = self.containerView!
        v.center = CGPoint(x: con.bounds.midX, y: con.bounds.midY)
        return v.frame.integral
    }
    
    override func containerViewWillLayoutSubviews() {
        // deal with future rotation
        // again, I can think of more than one approach
        let v = self.presentedView!
        v.autoresizingMask = [
            .flexibleTopMargin, .flexibleBottomMargin,
            .flexibleLeftMargin, .flexibleRightMargin
        ]
        v.translatesAutoresizingMaskIntoConstraints = true
    }
    
}

extension CAVTransitioner { // UIViewControllerTransitioningDelegate
    func animationController(
        forPresented presented:UIViewController,
        presenting: UIViewController,
        source: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return self
    }
    
    func animationController(
        forDismissed dismissed: UIViewController)
        -> UIViewControllerAnimatedTransitioning? {
            return self
    }
}

extension CAVTransitioner : UIViewControllerAnimatedTransitioning {
    func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?)
        -> TimeInterval {
            return 0.25
    }
    
    func animateTransition(
        using transitionContext: UIViewControllerContextTransitioning
    ) {
        
        let con = transitionContext.containerView
        
        let v1 = transitionContext.view(forKey: .from)
        let v2 = transitionContext.view(forKey: .to)
        
        // we are using the same object (self) as animation controller
        // for both presentation and dismissal
        // so we have to distinguish the two cases
        
        if let v2 = v2 { // presenting
            con.addSubview(v2)
            let scale = CGAffineTransform(scaleX: 1.2, y: 1.2)
            v2.transform = scale
            v2.alpha = 0
            UIView.animate(withDuration: 0.25, animations: {
                v2.alpha = 1
                v2.transform = .identity
            }) { _ in
                transitionContext.completeTransition(true)
            }
        } else if let v1 = v1 { // dismissing
            UIView.animate(withDuration: 0.25, animations: {
                v1.alpha = 0
            }) { _ in
                transitionContext.completeTransition(true)
            }
        }
    }
}
