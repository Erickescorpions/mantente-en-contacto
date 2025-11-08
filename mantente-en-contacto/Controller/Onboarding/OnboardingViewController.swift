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
    let initialPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        style()
        layout()
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
    }

    func style() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = initialPage
    }

    func layout() {
        view.addSubview(pageControl)
        NSLayoutConstraint.activate([
            pageControl.widthAnchor.constraint(equalTo: view.widthAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 40),
            view.bottomAnchor.constraint(
                equalToSystemSpacingBelow: pageControl.bottomAnchor,
                multiplier: 1
            ),
        ])
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
}

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

        pageControl.currentPage = currentIndex
    }
}
