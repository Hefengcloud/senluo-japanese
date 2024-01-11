enum DistributionChannel {
  none(text: '无', aspectRatio: 3 / 4),
  weChat(text: '微信', aspectRatio: 3 / 4),
  zhiHu(text: '知乎', aspectRatio: 3 / 4),
  xiaoHongShu(text: '小红书', aspectRatio: 3 / 4);

  final String text;
  final double aspectRatio;

  const DistributionChannel({
    required this.text,
    required this.aspectRatio,
  });
}
