//
//  DLTSideMenuCategory.swift
//  myBook
//
//  Created by dongliang on 2025/1/12.
//

import UIKit

struct DLTSideMenuCategory {
    let id: Int
    let name: String
    let subTitle: String
    let iconName: String
    let iconColor: UIColor
    let bookCount: Int

    static let categories: [DLTSideMenuCategory] = [
        DLTSideMenuCategory(
            id: 1,
            name: "文学",
            subTitle: "小说 / 散文 / 诗歌",
            iconName: "book.open",
            iconColor: UIColor.hex("#2563EB") ?? .systemBlue,
            bookCount: 24
        ),
        DLTSideMenuCategory(
            id: 2,
            name: "历史",
            subTitle: "中国史 / 世界史",
            iconName: "landmark",
            iconColor: UIColor.hex("#F59E0B") ?? .orange,
            bookCount: 18
        ),
        DLTSideMenuCategory(
            id: 3,
            name: "科技",
            subTitle: "编程 / AI / 产品",
            iconName: "cpu",
            iconColor: UIColor.hex("#10B981") ?? .systemGreen,
            bookCount: 36
        ),
        DLTSideMenuCategory(
            id: 4,
            name: "心理",
            subTitle: "认知 / 情绪 / 成长",
            iconName: "brain",
            iconColor: UIColor.hex("#EC4899") ?? .systemPink,
            bookCount: 21
        ),
        DLTSideMenuCategory(
            id: 5,
            name: "商业",
            subTitle: "管理 / 营销 / 创业",
            iconName: "briefcase",
            iconColor: UIColor.hex("#8B5CF6") ?? .purple,
            bookCount: 29
        )
    ]

    static var totalBooks: Int {
        categories.reduce(0) { $0 + $1.bookCount }
    }

    static var totalSubCategories: Int {
        36
    }
}
