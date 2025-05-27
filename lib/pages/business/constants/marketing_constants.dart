
import '../data/marketing_channel.dart';

enum CustomerPersona {
  newbies('日语初学者'),
  jlptCandidates('JLPT备考者');

  final String name;

  const CustomerPersona(this.name);
}

const kEverjapanChannles = [
  MarketingChannel(
    name: "日系生活家",
    type: "小红书",
    url: "https://www.xiaohongshu.com/user/profile/642b0b6f000000001400eda2",
  ),
  MarketingChannel(
    name: "日系生活家",
    type: "Bibibili",
    url: "https://space.bilibili.com/481782510",
  ),
  MarketingChannel(
    name: "日系生活家",
    type: "喜马拉雅",
    url: "https://www.ximalaya.com/zhubo/210189066",
  ),
  MarketingChannel(
    name: "日系生活家",
    type: "Bibibili",
    url: "https://space.bilibili.com/481782510",
  ),
  MarketingChannel(
    name: "日系生活家",
    type: "Bibibili",
    url: "https://space.bilibili.com/481782510",
  ),
];

enum SocialMedia {
  douyin(
    '抖音',
    'https://www.douyin.com/user/MS4wLjABAAAA1ZxYZLzx2yD9HCxvA5fLQSmA_L2AntzHulU2RfMsDOM',
  ),
  weibo(
    '微博',
    'https://weibo.com/u/7861984943',
  ),
  zhihu(
    '知乎',
    'https://www.zhihu.com/column/everjapan',
  ),

  gongzhonghao('微信公众号', '');

  const SocialMedia(this.name, this.url);

  final String url;
  final String name;
}

enum StoryBrandSevenPart {
  character(
    'character',
    [
      'What does your customer need from your small business?',
    ],
  ),
  problem(
    'the problem',
    [
      'What are some of the problems your products help your customers overcome?',
    ],
  ),
  guide(
    'guide',
    [
      '1) Express Empathy',
      '2) Demonstrate Authority',
    ],
  ),
  plan(
    'the plan',
    [
      'What three or four steps do your customers need to take in order to buy your product and solve their problem?',
    ],
  ),
  callToAction(
    'call to action',
    [
      'What will the call to action be on your website and in your marketing collateral?'
    ],
  ),
  failure(
    'failure',
    [
      'What negative consequence does my product help my customers avoid',
      'What will people continue to experience if they do not buy my product or service?',
    ],
  ),
  success(
    'success',
    [
      "What will my customer's life look like if they buy my product or service",
      "What benefits will my product or service provide that would add value to my customer's life?",
    ],
  );

  const StoryBrandSevenPart(this.name, this.questions);
  final String name;
  final List<String> questions;
}
