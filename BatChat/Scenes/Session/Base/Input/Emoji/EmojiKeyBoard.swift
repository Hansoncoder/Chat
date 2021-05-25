//
//  EmojiKeyBoard.swift
//  SoMi
//
//  Created by design on 2019/10/9.
//  Copyright © 2019 liuchendi. All rights reserved.
//

import Dollar
import UIKit

public protocol EmojiInputViewProtocol: NSObjectProtocol {
    func onKeyBoardInputText(text: String)
    func onKeyBoardDeleteText()
    func onKeyBoardSendAction()
}

enum EmotionType: Int {
    case normal, custom, delete, empty
}

/**
 *  表情的 Model
 */
class EmotionModel: NSObject {
    // 表情标题
    var title: String!
    // 表情名称
    var name: String!
    var image: UIImage?
    // 表情文字
    var text: String!
    // 表情地址
    var path: String!
    // 类型
    var type: EmotionType!

    func delModel() -> EmotionModel {
        let model = EmotionModel()
        model.type = .delete
        model.name = "emotion_delete"
        return model
    }
}

class EmojiCell: UICollectionViewCell {
    var emotionImageView: UIImageView!
    var titleLabel: UILabel!
    var emotionModel: EmotionModel!
    override init(frame: CGRect) {
        super.init(frame: frame)

        emotionImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: width * 0.7, height: height * 0.7))
        emotionImageView.centerX = width / 2
        emotionImageView.centerY = height / 2
        emotionImageView.contentMode = .scaleAspectFit
        addSubview(emotionImageView)

        titleLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: 20))

        titleLabel.textColor = UIColor(hexString: "888888")
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        titleLabel.textAlignment = .center
        addSubview(titleLabel)
    }

    func setCellContnet(_ model: EmotionModel? = nil) {
        guard let model = model else {
            emotionImageView.image = nil
            return
        }
        emotionModel = model
        titleLabel.isHidden = true

        if model.type == .normal {
            emotionImageView.image = UIImage(contentsOfFile: model.path)
        } else if model.type == .empty {
            emotionImageView.image = nil
        } else if model.type == .delete {
            emotionImageView.image = UIImage(named: model.name)
        } else if model.type == .custom {
            emotionImageView.image = UIImage(named: model.name)
            titleLabel.isHidden = false
            titleLabel.text = model.title
            emotionImageView.top = 5
            titleLabel.top = emotionImageView.bottom + 5
        }
        if let text = model.text {
            model.image = emotionImageView.image
            emojiMap[text] = model
        }
    }

    func setDeleteCellContnet() {
        emotionModel = nil
        emotionImageView.image = UIImage(named: "emotion_delete")
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

fileprivate var emojiMap: [String: EmotionModel] = [:]
class EmojiContainView: UIView {
    weak var delegate: EmojiInputViewProtocol?
    var mainCollectionView: UICollectionView!
    var emotionPageControl: UIPageControl!
    var bottomBarView: UIView!
    var bottomItem: [UIButton]!
    var sendButton: UIButton!
    private var dataList: [[EmotionModel]]!

    var row = 1
    var column = 1
    var itemCountOfPage = 0

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupUI()

        loadDefaultEmoji()
    }

    private func setupUI() {
        backgroundColor = UIColor(hexString: "f5f5f5")
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)

        mainCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: width, height: height - 30), collectionViewLayout: layout)
        mainCollectionView.showsHorizontalScrollIndicator = false
        mainCollectionView.delegate = self
        mainCollectionView.dataSource = self
        mainCollectionView.backgroundColor = UIColor(hexString: "f5f5f5")
        mainCollectionView.isPagingEnabled = true
        mainCollectionView.register(EmojiCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        mainCollectionView.alwaysBounceHorizontal = true
        addSubview(mainCollectionView)

        emotionPageControl = UIPageControl(frame: CGRect(x: 0, y: height - 40, width: width, height: 40))
        emotionPageControl.currentPageIndicatorTintColor = UIColor(hexString: "8B8B8B")
        emotionPageControl.pageIndicatorTintColor = UIColor(hexString: "D6D6D6")
        addSubview(emotionPageControl)
        
        let sendFrame = CGRect(x: width - 75, y: height - 40, width: 50, height: 30)
        sendButton = UIButton(frame: sendFrame)
        sendButton.addTarget(self, action: #selector(sendPress), for: .touchUpInside)
        sendButton.setTitle("发送", for: .normal)
        sendButton.backgroundColor = UIColor(hex: 0xFF7E90)
        sendButton.layer.cornerRadius = 5
        addSubview(sendButton)
    }
    
    @objc func deletePress() {
        self.delegate?.onKeyBoardDeleteText()
    }
    
    @objc func sendPress() {
        self.delegate?.onKeyBoardSendAction()
    }
    
    private func setDataSource(data: [String: Any]) {
        row = data["row"] as? Int ?? 1
        column = data["column"] as? Int ?? 1
        // max count emojie one page
        itemCountOfPage = row * column

        let list = data["list"] as? [EmotionModel] ?? [EmotionModel]()

        if list.count == 0 {
            return
        }
        dataList = Dollar.chunk(list, size: itemCountOfPage)
        emotionPageControl.numberOfPages = dataList.count
        mainCollectionView.reloadData()
    }

    private func loadDefaultEmoji() {
        // init dataSource
        let emojiExpressSet = [
            "plist": "Expression.plist",
            "bundle": "Expression.bundle",
        ]
        var emotionsDataSouce = [EmotionModel]()
        let plistPath = Bundle.main.path(forResource: emojiExpressSet["plist"], ofType: nil)
        let bundlePath = Bundle.main.path(forResource: emojiExpressSet["bundle"], ofType: nil)
        let emojiArray = NSArray(contentsOfFile: plistPath!) as! [[String: Any]]
        var appendDelIndex = 22
        let pointCount = emojiArray.count + (23 - emojiArray.count % 23)

        for i in 0 ..< pointCount {
            let model = EmotionModel()
            if i < emojiArray.count {
                let item = emojiArray[i]
                model.type = .normal
                let imageName = item["image"] as! String
                model.path = bundlePath! + "/" + imageName
                model.text = item["text"] as? String
                model.title = item["title"] as? String
            } else {
                model.type = .empty
            }
            emotionsDataSouce.append(model)

            // 添加删除
            if i > 0 && i == appendDelIndex {
                emotionsDataSouce.append(EmotionModel().delModel())
                appendDelIndex = appendDelIndex + 22 + 1
            }
        }
        setDataSource(data: ["row": 3, "column": 8, "list": emotionsDataSouce])
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - @protocol UIScrollViewDelegate

extension EmojiContainView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = mainCollectionView.width
        emotionPageControl.currentPage = Int(mainCollectionView.contentOffset.x / pageWidth)
    }
}

extension EmojiContainView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! EmojiCell
        guard let model = cell.emotionModel else {
            return
        }

        if model.type == .delete {
            delegate?.onKeyBoardDeleteText()
        } else if model.type == .normal {
            delegate?.onKeyBoardInputText(text: model.text)
        }
    }
}

extension EmojiContainView: UICollectionViewDataSource {
//    //transpose line/row
    fileprivate func emoticonForIndexPath(_ indexPath: IndexPath) -> Int {
        let ii = indexPath.row % itemCountOfPage // 重新计算的所在 index
        let reIndex = (ii % row) * Int(column) + (ii / row) // 最终在数据源里的 Index
        return reIndex
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return dataList.count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataList[section].count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! EmojiCell
        cell.setCellContnet(dataList[indexPath.section][emoticonForIndexPath(indexPath)])
        return cell
    }
}

extension EmojiContainView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.width - 30) / CGFloat(column)
        let itemHeight = (collectionView.height - 30) / CGFloat(row)
        return CGSize(width: floor(itemWidth), height: floor(itemHeight))
    }
}

// MARK: - 表情添加到属性字符串处理

extension NSAttributedString.Key {
    public static var emojiName: NSAttributedString.Key {
        return NSAttributedString.Key("emojiName")
    }
}

extension NSAttributedString {
    /// 从属性字符串中取出表情的name
    /// - Parameter inputRange: 需要提取的范围
    /// - Returns: 返回字符串，上传服务器
    func textDecodEmoji(range inputRange: NSRange? = nil) -> String {
        var range = NSRange(location: 0, length: 0)
        if let inRange = inputRange {
            range = inRange
        } else {
            range = self.string.allRange()
        }

        guard range.location != NSNotFound, range.length != NSNotFound else {
            return ""
        }
        let result = NSMutableString()
        if range.length == 0 {
            return result as String
        }

        let string = self.string as NSString
        enumerateAttribute(.emojiName, in: range, options: .init(rawValue: 0)) { value, range, _ in
            if let text = value as? String {
                for _ in 0 ..< range.length {
                    result.append(text)
                }
            } else {
                result.append(string.substring(with: range))
            }
        }
        return result as String
    }
}



extension String {
    /// 解析表情
    /// - Parameter inputRange: 需要解析范围
    /// - Returns: 属性字符串
    func textToEmoji(range inputRange: NSRange? = nil) -> NSMutableAttributedString {
        var range = NSRange(location: 0, length: 0)
        if let inRange = inputRange {
            range = inRange
        } else {
            range = self.allRange()
        }

        guard range.location != NSNotFound, range.length != NSNotFound else {
            return NSMutableAttributedString()
        }
        let regularExpression = try! NSRegularExpression(pattern: "\\[[^\\[\\]]+?\\]", options: [.caseInsensitive])
        let emoticonResults = regularExpression.matches(
            in: self,
            options: [.reportProgress],
            range: range
        )
        var emoClipLength: Int = 0
        let attributedText = mutableAttributedString
        for emotion: NSTextCheckingResult in emoticonResults {
            if emotion.range.location == NSNotFound && emotion.range.length <= 1 {
                continue
            }
            var range: NSRange = emotion.range
            range.location -= emoClipLength
            let imageRange = attributedText.string.range(from: range)!
            let imageName = String(attributedText.string[imageRange])
            let emojiText = imageName.emojiText()
            attributedText.replaceCharacters(in: range, with: emojiText)
            emoClipLength += range.length - 1
        }
        return attributedText
    }
    
    public func emojiText(_ font: UIFont = UIFont.systemFont(ofSize: 16)) -> NSAttributedString {
        guard let image = emojiMap[self]?.image else {
            return NSAttributedString()
        }
        let attachment = NSTextAttachment()
        attachment.image = image
        let lineHeight = font.lineHeight
        let size = CGSize(width: lineHeight, height: lineHeight)
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: -5), size: size)
        let attrText = NSMutableAttributedString(attachment: attachment)
        attrText.addAttributes([.font: font, .emojiName: self], range: attrText.string.allRange())
        return attrText
    }
}

let ExpressionList = [
    ["[微笑]": "Expression_1"],
    ["[撇嘴]": "Expression_2"],
    ["[色]": "Expression_3"],
    ["[发呆]": "Expression_4"],
    ["[得意]": "Expression_5"],
    ["[流泪]": "Expression_6"],
    ["[害羞]": "Expression_7"],
    ["[闭嘴]": "Expression_8"],
    ["[睡]": "Expression_9"],
    ["[大哭]": "Expression_10"],
    ["[尴尬]": "Expression_11"],
    ["[发怒]": "Expression_12"],
    ["[调皮]": "Expression_13"],
    ["[呲牙]": "Expression_14"],
    ["[惊讶]": "Expression_15"],
    ["[难过]": "Expression_16"],
    ["[酷]": "Expression_17"],
    ["[冷汗]": "Expression_18"],
    ["[抓狂]": "Expression_19"],
    ["[吐]": "Expression_20"],
    ["[偷笑]": "Expression_21"],
    ["[愉快]": "Expression_22"],
    ["[白眼]": "Expression_23"],
    ["[傲慢]": "Expression_24"],
    ["[饥饿]": "Expression_25"],
    ["[困]": "Expression_26"],
    ["[惊恐]": "Expression_27"],
    ["[流汗]": "Expression_28"],
    ["[憨笑]": "Expression_29"],
    ["[悠闲]": "Expression_30"],
    ["[奋斗]": "Expression_31"],
    ["[咒骂]": "Expression_32"],
    ["[疑问]": "Expression_33"],
    ["[嘘]": "Expression_34"],
    ["[晕]": "Expression_35"],
    ["[疯了]": "Expression_36"],
    ["[衰]": "Expression_37"],
    ["[骷髅]": "Expression_38"],
    ["[敲打]": "Expression_39"],
    ["[再见]": "Expression_40"],
    ["[擦汗]": "Expression_41"],
    ["[抠鼻]": "Expression_42"],
    ["[鼓掌]": "Expression_43"],
    ["[糗大了]": "Expression_44"],
    ["[坏笑]": "Expression_45"],
    ["[左哼哼]": "Expression_46"],
    ["[右哼哼]": "Expression_47"],
    ["[哈欠]": "Expression_48"],
    ["[鄙视]": "Expression_49"],
    ["[委屈]": "Expression_50"],
    ["[快哭了]": "Expression_51"],
    ["[阴险]": "Expression_52"],
    ["[亲亲]": "Expression_53"],
    ["[吓]": "Expression_54"],
    ["[可怜]": "Expression_55"],
    ["[菜刀]": "Expression_56"],
    ["[西瓜]": "Expression_57"],
    ["[啤酒]": "Expression_58"],
    ["[篮球]": "Expression_59"],
    ["[乒乓]": "Expression_60"],
    ["[咖啡]": "Expression_61"],
    ["[饭]": "Expression_62"],
    ["[猪头]": "Expression_63"],
    ["[玫瑰]": "Expression_64"],
    ["[凋谢]": "Expression_65"],
    ["[嘴唇]": "Expression_66"],
    ["[爱心]": "Expression_67"],
    ["[心碎]": "Expression_68"],
    ["[蛋糕]": "Expression_69"],
    ["[闪电]": "Expression_70"],
    ["[炸弹]": "Expression_71"],
    ["[刀]": "Expression_72"],
    ["[足球]": "Expression_73"],
    ["[瓢虫]": "Expression_74"],
    ["[便便]": "Expression_75"],
    ["[月亮]": "Expression_76"],
    ["[太阳]": "Expression_77"],
    ["[礼物]": "Expression_78"],
    ["[拥抱]": "Expression_79"],
    ["[强]": "Expression_80"],
    ["[弱]": "Expression_81"],
    ["[握手]": "Expression_82"],
    ["[胜利]": "Expression_83"],
    ["[抱拳]": "Expression_84"],
    ["[勾引]": "Expression_85"],
    ["[拳头]": "Expression_86"],
    ["[差劲]": "Expression_87"],
    ["[爱你]": "Expression_88"],
    ["[NO]": "Expression_89"],
    ["[OK]": "Expression_90"],
]
