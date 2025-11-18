//
//  OnboardingViewController.swift
//  mantente-en-contacto
//
//  Created by Erick :) Vazquez on 08/11/25.
//

import UIKit

class OnboardingViewController: UIPageViewController {

    var pages = [UIViewController]()
    let pageControl = UIPageControl()
    let buttonNext: UIButton = {
        let button = UIButton()
        button.setTitle("Next >", for: .normal)
        button.backgroundColor = .myYellow
        return button
    }()

    let buttonSkip: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.backgroundColor = .myLightYellow
        return button
    }()

    private let footer: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 16
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    let initialPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()

        let viewHeight = view.bounds.height
        let safeBottom = view.safeAreaInsets.bottom

        let pageControlTop = pageControl.frame.minY

        let additionalBottom = max(0, viewHeight - safeBottom - pageControlTop)
        for page in pages {
            (page as? OnboardingPageContent)?.bottomContentInset =
                additionalBottom
        }
    }

    func setup() {
        dataSource = self
        delegate = self

        pageControl.addTarget(
            self,
            action: #selector(pageControlTapped(_:)),
            for: .valueChanged
        )

        let page1 = WelcomePageViewController()
        let page2 = PlacesAndContactsPageViewController()
        let page3 = PrivacyPageViewController()
        let page4 = GetStartedPageViewController()

        pages.append(contentsOf: [page1, page2, page3, page4])

        setViewControllers(
            [pages[initialPage]],
            direction: .forward,
            animated: true,
            completion: nil
        )

        buttonNext.addTarget(
            self,
            action: #selector(nextButtonTapped),
            for: .touchUpInside
        )

        buttonSkip.addTarget(
            self,
            action: #selector(skipButtonTapped),
            for: .touchUpInside
        )
    }

    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .myYellow
        pageControl.pageIndicatorTintColor = .myLightYellow
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage

        buttonNext.translatesAutoresizingMaskIntoConstraints = false
        buttonNext.setTitleColor(.black, for: .normal)
        buttonNext.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        buttonNext.layer.cornerRadius = 12
        buttonNext.layer.masksToBounds = false
        buttonNext.layer.shadowColor = UIColor.black.cgColor
        buttonNext.layer.shadowOpacity = 0.1
        buttonNext.layer.shadowRadius = 4
        buttonNext.layer.shadowOffset = CGSize(width: 0, height: 2)

        buttonSkip.translatesAutoresizingMaskIntoConstraints = false
        buttonSkip.setTitleColor(.darkGray, for: .normal)
        buttonSkip.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        buttonSkip.layer.cornerRadius = 12

    }

    func layout() {
        footer.addArrangedSubview(buttonSkip)
        footer.addArrangedSubview(buttonNext)

        pageControl.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(pageControl)
        view.addSubview(footer)

        let safe = view.safeAreaLayoutGuide

        NSLayoutConstraint.activate([
            footer.leadingAnchor.constraint(
                equalTo: safe.leadingAnchor,
                constant: 24
            ),
            footer.trailingAnchor.constraint(
                equalTo: safe.trailingAnchor,
                constant: -24
            ),
            footer.bottomAnchor.constraint(
                equalTo: safe.bottomAnchor,
                constant: -16
            ),
            footer.heightAnchor.constraint(equalToConstant: 48),

            pageControl.centerXAnchor.constraint(equalTo: safe.centerXAnchor),
            pageControl.bottomAnchor.constraint(
                equalTo: footer.topAnchor,
                constant: -12
            ),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    private func updateUIForPage(at index: Int) {
        pageControl.currentPage = index
        buttonNext.isHidden = (index == pages.count - 1)
        buttonSkip.isHidden = (index == pages.count - 1)
    }


    //MARK: Acciones
    @objc func pageControlTapped(_ sender: UIPageControl) {
        setViewControllers(
            [pages[sender.currentPage]],
            direction: .forward,
            animated: true,
            completion: nil
        )
    }

    @objc func nextButtonTapped() {
        guard
            let currentViewController = self.viewControllers?
                .first,
            let currentIndex = pages.firstIndex(
                of: currentViewController
            )
        else { return }

        let nextIndex = currentIndex + 1
        if nextIndex < pages.count {
            let nextViewController = pages[nextIndex]
            self.setViewControllers(
                [nextViewController],
                direction: .forward,
                animated: true,
                completion: nil
            )

            updateUIForPage(at: nextIndex)
        }
    }

    @objc func skipButtonTapped() {
        guard
            let currentViewController = self.viewControllers?
                .first,
            let currentIndex = pages.firstIndex(
                of: currentViewController
            )
        else { return }

        if currentIndex < pages.count {
            let last = pages[pages.count - 1]
            self.setViewControllers([last], direction: .forward, animated: true)
            updateUIForPage(at: pages.count - 1)
        }
    }

}

// MARK: Protocolos
extension OnboardingViewController: UIPageViewControllerDataSource,
    UIPageViewControllerDelegate
{
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        if currentIndex > 0 {
            return pages[currentIndex - 1]
        }

        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController) else {
            return nil
        }

        if currentIndex < pages.count - 1 {
            return pages[currentIndex + 1]
        }

        return nil
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers else {
            return
        }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0]) else {
            return
        }

        updateUIForPage(at: currentIndex)
    }
}
