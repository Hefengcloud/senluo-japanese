enum CustomerPersona {
  newbies('日语初学者'),
  jlptCandidates('JLPT备考者');

  final String name;

  const CustomerPersona(this.name);
}

enum SocialMedia {
  everjapanWebsite(
    'everjapan.com',
    'https://www.everjapan.com',
    'https://www.everjapan.com',
  ),
  xiaohongshu(
    '小红书',
    'https://www.xiaohongshu.com/user/profile/642b0b6f000000001400eda2',
    '',
  ),
  bilibili('B站', '', ''),
  ximalaya('喜马拉雅', '', ''),
  douyin('抖音', '', ''),
  weibo('微博', '', ''),
  zhihu('知乎', '', '');

  const SocialMedia(this.name, this.url, this.mobileUrl);

  final String url;
  final String mobileUrl;
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
