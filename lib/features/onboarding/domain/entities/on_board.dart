class OnBoard {
  String image;
  String title;
  String desc;

  OnBoard({required this.image, required this.title, required this.desc});

  static List<OnBoard> list = [
    OnBoard(
      image: 'images/illustrations/illustration1.svg',
      title: 'Step into a world of Learning Excellence',
      desc:
          'Discover high-quality courses designed to help you learn, grow, and succeed at your own pace.',
    ),
    OnBoard(
      image: 'images/illustrations/illustration2.svg',
      title: 'Explore Endless Possibilities',
      desc:
          'Access a wide range of topics, skills, and resources tailored to your interests and goals.',
    ),
    OnBoard(
      image: 'images/illustrations/illustration3.svg',
      title: 'Empower your Education Journey',
      desc:
          'Track your progress, stay motivated, and build skills that matter for your future.',
    ),
    OnBoard(
      image: 'images/illustrations/illustration4.svg',
      title: 'Start Your LearnHub Journey Today',
      desc:
          'Join a learning community that supports you every step of the way toward success.',
    ),
    OnBoard(
      image: 'images/illustrations/illustration5.svg',
      title: 'Join your Journey Happily',
      desc:
          'Enjoy a smooth, engaging, and joyful learning experience anytime, anywhere.',
    ),
  ];
}
