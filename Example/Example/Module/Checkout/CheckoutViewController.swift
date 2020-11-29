//
//  CheckoutViewController.swift
//  BDS
//
//  Created by INVISION on 16/9/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import CoreLocation
import UIKit

class CheckoutViewController: UIViewController, StoryboardLoadable, CLLocationManagerDelegate {
    var presenter: CheckoutPresenterInterface?

    @IBOutlet weak var productDetailView: UIView!
    
    @IBOutlet weak var checkoutListTableView: UITableView!
    
    @IBOutlet weak var discountTableView: UITableView!
    @IBOutlet weak var discountTableWrap: UIView!
    
    private let cartCellFactory = CartCellFactory()

    @IBOutlet weak var priceDetailView: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var shipmentPriceLabel: UILabel!
    @IBOutlet weak var totalDiscountLabel: UILabel!
    @IBOutlet weak var grandTotalLabel: UILabel!

    @IBOutlet weak var choosePaymentView: UIView!
    @IBOutlet weak var choosePaymentButton: UIButton!
    
    @IBOutlet weak var siteChangeView: UIView!
    @IBOutlet weak var siteChangeNameLabel: UILabel!
    @IBOutlet weak var siteChangeDistanceLabel: UILabel!
    @IBOutlet weak var siteChangeButtonView: UIView!

    @IBOutlet weak var checkoutButtonView: UIButton!

    var cartOrder: Order?
    var locationManager = CLLocationManager()
    var paymentType = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        checkoutListTableView.delegate = self
        checkoutListTableView.dataSource = self
        checkoutListTableView.tag = 0
        cartCellFactory.registerCellsForTableView(tableView: checkoutListTableView)
        
        discountTableView.delegate = self
        discountTableView.dataSource = self
        discountTableView.tag = 1
        cartCellFactory.registerCellsForTableView(tableView: discountTableView)

        getCurrentLocation()
        setupUI()
        setupNavigationBar()
        presenter?.willFetchOrder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Bug in 8.0+ where need to call the following three methods in order to get the tableView to correctly size the tableViewCells on the initial load.
        self.checkoutListTableView.setNeedsLayout()
        self.checkoutListTableView.layoutIfNeeded()
        
        self.discountTableView.setNeedsLayout()
        self.discountTableView.layoutIfNeeded()
//        self.checkoutListTableView.reloadData()
    }

    func getCurrentLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                print("No access")
                presenter?.currentLocation = locationManager.location
            case .authorizedAlways, .authorizedWhenInUse:
                print("Access")
                presenter?.currentLocation = locationManager.location
//                presenter?.createChatRoom(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude)
            @unknown default:
                break
            }
        } else {
            print("Location services are not enabled")
        }
    }

    @IBAction func goSiteChange(_ sender: Any) {
        print("go SiteChange")
        presenter?.goSiteChange()
    }

    @IBAction func goPaymentButton(_ sender: Any) {
        if paymentType != "" {
            print("go Payment")
            presenter?.onSubmitCheckout(withPaymentType: paymentType)
        } else {
            let alert = UIAlertController(title: "แจ้งเตือน", message: "กรุณาเลือกวิธีชำระเงิน", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    @IBAction func choosePaymentButton(_ sender: Any) {
//        presenter?.goChoose()
        
        let alertController = UIAlertController(title: "เลือกวิธีชำระเงิน", message: nil, preferredStyle: .actionSheet)
        let creditCard = UIAlertAction(title: "ชำระด้วยบัตรเครดิต/เดบิต", style: .default) { [weak self] _ in
            self?.savePayment(payment: "1")
            self?.choosePaymentButton.setTitle("ชำระด้วยบัตรเครดิต/เดบิต", for: .normal)
            self?.choosePaymentButton.setTitleColor(UIColor.apBlue, for: .normal)
        }
        let qrCode = UIAlertAction(title: "ชำระผ่าน QR Code", style: .default) { [weak self] _ in
            self?.savePayment(payment: "2")
            self?.choosePaymentButton.setTitle("ชำระผ่าน QR Code", for: .normal)
            self?.choosePaymentButton.setTitleColor(UIColor.apBlue, for: .normal)
        }
        let cancelAction = UIAlertAction(title: "ยกเลิก", style: .cancel) { [weak self] _ in
            self?.savePayment(payment: "")
            self?.choosePaymentButton.setTitle("เลือกวิธีชำระเงิน", for: .normal)
            self?.choosePaymentButton.setTitleColor(UIColor.apGray, for: .normal)
        }
        alertController.addAction(cancelAction)
        alertController.addAction(creditCard)
        alertController.addAction(qrCode)
        
        present(alertController, animated: true, completion: nil)
    }

    private func setupUI() {
        checkoutListTableView.separatorStyle = .none
        siteChangeButtonView.isHidden = true
        
        // MARK: checkoutButtonView button style
        checkoutButtonView.setCornerRadius(22, borderWidth: 0, borderColor: .apBlue)
        checkoutButtonView.layer.shadowColor = UIColor.apGray.cgColor
        checkoutButtonView.layer.shadowOpacity = 0.8
        checkoutButtonView.layer.shadowOffset = .zero
        checkoutButtonView.layer.shadowRadius = 3
        //        checkoutButtonView.layer.shadowPath = UIBezierPath(rect: checkoutButtonView.bounds).cgPath
        checkoutButtonView.layer.shouldRasterize = true
        checkoutButtonView.layer.rasterizationScale = UIScreen.main.scale
        checkoutButtonView.layer.masksToBounds = false
    }

    private func setupNavigationBar() {
        navigationItem.title = "สรุปการซื้อสินค้า"
        let attributes = [
            NSAttributedString.Key.font: UIFont(name: "Prompt-Medium", size: 15)!,
            .foregroundColor: UIColor(red: 255 / 255, green: 255 / 255, blue: 255 / 255, alpha: 1)
        ]
        UINavigationBar.appearance().titleTextAttributes = attributes

        navigationController?.navigationBar.setBackgroundImage(UIImage(named: "nav_bar_bg")?.resizableImage(withCapInsets: UIEdgeInsets.zero, resizingMode: .stretch), for: .default)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = UIColor.white
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    func renderFromSiteChange(siteName: String, siteDistance: Double) {
        siteChangeNameLabel.text = siteName
        siteChangeDistanceLabel.text = "ระยะทาง \(String.currencyString(with: siteDistance)) กิโลเมตร"
    }
    
    func savePayment(payment: String) {
        paymentType = payment
    }
}

extension CheckoutViewController: CheckoutViewInterface {
    func updateUI() {
        var totalPrice: Double = 0
        var totalDisc: Double = 0
        var grandTotal: Double = 0
        var shippingFee: Double = 0
        
        if let order = presenter?.order {
            if let orderDetail = order.orderDetail {
                for item in orderDetail {
                    let itemTotalPrice = item.itemPrice * Double(item.itemQty)
                    totalPrice += itemTotalPrice
                    totalDisc += item.itemDiscount
                }
            }
            shippingFee = order.shippingFee ?? 0
            grandTotal = order.totalPrice ?? 0
            /// Setup site change view
            if order.cartType == "1" {
                siteChangeButtonView.isHidden = false
                siteChangeNameLabel.text = presenter?.siteName
                siteChangeDistanceLabel.text = String(format: "ระยะทาง %.2f กิโลเมตร", presenter?.siteDistance ?? 0)
            }
        }
        //        grandTotal = totalPrice - totalDisc + shippingFee
        totalPriceLabel.text = String.currencyString(with: totalPrice) + " บาท"
        shipmentPriceLabel.text = String.currencyString(with: shippingFee) + " บาท"
        totalDiscountLabel.text = String.currencyString(with: totalDisc) + " บาท"
        grandTotalLabel.text = String.currencyString(with: grandTotal) + " บาท"
        
        checkoutListTableView.reloadData()
        discountTableView.reloadData()

        if presenter?.order?.getItemsWithDiscount().count ?? 0 > 0 {
            discountTableWrap.isHidden = false

            let totalDiscount = presenter?.order?.getItemsWithDiscount().count ?? 0

            discountTableWrap.translatesAutoresizingMaskIntoConstraints = false
            discountTableWrap.heightAnchor.constraint(equalToConstant: CGFloat(totalDiscount * 20)).isActive = true

            discountTableView.frame = CGRect(x: discountTableView.frame.origin.x,
                                             y: discountTableView.frame.origin.y,
                                             width: discountTableView.frame.size.width,
                                             height: discountTableView.contentSize.height)
        } else {
            discountTableWrap.isHidden = true
        }
        
    }

    func updateSiteLabel() {
        siteChangeNameLabel.text = presenter?.siteName
        if let distance = presenter?.siteDistance {
            siteChangeDistanceLabel.text = "ระยะทาง \(distance > 20 ? " - " : String.currencyString(with: distance)) กิโลเมตร"
        }
    }
}

extension CheckoutViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == checkoutListTableView {
            return 2
        }
        if tableView == discountTableView {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == discountTableView {
            return presenter?.order?.getItemsWithDiscount().count ?? 0
        }
        if tableView == checkoutListTableView {
            if section == 0 {
                return presenter?.order?.getPharmacistItems().count ?? 0
            }
            return presenter?.order?.getCustomerItems().count ?? 0
        }
        
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = UITableViewCell()
        
        if tableView == discountTableView {
            cell = cartCellFactory.discountCellFor(orderDetail: presenter?.order?.getItemsWithDiscount()[indexPath.row], tableView: tableView, for: indexPath, controller: self, delegate: nil)
        }
        else if tableView == checkoutListTableView {
            if indexPath.section == 0 {
                cell = cartCellFactory.plainCellFor(orderDetail: presenter?.order?.getPharmacistItems()[indexPath.row], tableView: tableView, for: indexPath, controller: self, delegate: nil)
            } else {
                cell = cartCellFactory.plainCellFor(orderDetail: presenter?.order?.getCustomerItems()[indexPath.row], tableView: tableView, for: indexPath, controller: self, delegate: nil)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let wrapView = UIView(), emptyWrapView = UIView()
        wrapView.backgroundColor = .white
        emptyWrapView.backgroundColor = .white
        
        if tableView == checkoutListTableView {
            let label = UILabel()
            label.font = FontUtils.apFont(ofSize: 14, weight: .medium)
            label.textColor = .apBlue
            
            wrapView.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            label.centerYAnchor.constraint(equalTo: wrapView.centerYAnchor).isActive = true
            label.leadingAnchor.constraint(equalTo: wrapView.leadingAnchor, constant: 4).isActive = true
            
            if section == 0 {
                label.text = "สินค้าและยาที่เลือกโดยเภสัชกร"
                return presenter?.order?.getPharmacistItems().count ?? 0 > 0 ? wrapView : emptyWrapView
            }
            else {
                label.text = "สินค้าที่เลือกเอง"
                return presenter?.order?.getCustomerItems().count ?? 0 > 0 ? wrapView : emptyWrapView
            }
        }
        
        if tableView == discountTableView {
            return emptyWrapView
        }
        
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == checkoutListTableView {
            return 28
        }
        
        if tableView == discountTableView {
            return 20
        }
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = .white
        return footer
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        
        if tableView == discountTableView {
            return 0
        }
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if tableView == discountTableView {
            return 0
        }
        
        if tableView == checkoutListTableView {
            switch section {
            case 0:
                return presenter?.order?.getPharmacistItems().count ?? 0 > 0 ? 8 : 0
            default:
                return presenter?.order?.getCustomerItems().count ?? 0 > 0 ? 8 : 0
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if tableView == checkoutListTableView {
            addDashedBottomBorder(to: cell)
        }
    }

    func addDashedBottomBorder(to cell: UITableViewCell) {
        let color = UIColor.apGray.cgColor

        let shapeLayer: CAShapeLayer = CAShapeLayer()
        let frameSize = cell.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)

        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width / 2, y: frameSize.height)
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 0.5
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [2, 3]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 5, y: shapeRect.height, width: shapeRect.width - 10, height: 0), cornerRadius: 0).cgPath

        cell.layer.addSublayer(shapeLayer)
    }
}
