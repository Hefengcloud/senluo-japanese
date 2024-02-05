enum DistributionChannel {
  none(text: 'None', aspectRatio: 3 / 4),
  weChat(text: 'WeChat', aspectRatio: 3 / 4),
  zhiHu(text: 'ZhiHu', aspectRatio: 3 / 4),
  xiaoHongShu(text: 'RedBook', aspectRatio: 3 / 4);

  final String text;
  final double aspectRatio;

  const DistributionChannel({
    required this.text,
    required this.aspectRatio,
  });
}
