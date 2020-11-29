//
//  checkoutTableCell.swift
//  BDS
//
//  Created by INVISION on 12/10/2563 BE.
//  Copyright © 2563 Chindanai Peerapattanapaiboon. All rights reserved.
//

import Foundation

protocol checkoutTableCell {
}

struct checkoutListTableCell: checkoutTableCell {
    var productName: String
    var price: Double
    var qty: Int
    var image: String
    var orderId: String
}

struct checkoutTableHeader: checkoutTableCell {
    var itemLabel: String
    var qtyLabel: String
}

struct checkoutSeparator: checkoutTableCell {
    var orderNumber: String
    var isSelected: Bool
}
