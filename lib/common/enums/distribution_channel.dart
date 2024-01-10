enum DistributionChannel {
  none(text: '无'),
  weChat(text: '微信'),
  zhiHu(text: '知乎'),
  xiaoHongShu(text: '小红书');

  final String text;

  const DistributionChannel({required this.text});
}
