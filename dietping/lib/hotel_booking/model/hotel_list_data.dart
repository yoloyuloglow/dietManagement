class HotelListData {
  HotelListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.subTxt = '',
    this.calories = 0, // 칼로리 필드 추가
  });

  String imagePath;
  String titleTxt;
  String subTxt;
  int calories; // 칼로리 정보 필드

  static List<HotelListData> hotelList = <HotelListData>[
    HotelListData(
      imagePath: 'assets/hotel/food (1).jpg',
      titleTxt: '브런치',
      subTxt: '아침 식사와 점심 식사를 겸한 식사로, 보통 오전 늦게부터 오후 이른 시간에 걸쳐 즐기는 간편하고 다양한 음식들로 구성된 식사',
      calories: 800, // 브런치 칼로리
    ),
    HotelListData(
      imagePath: 'assets/hotel/food (2).jpg',
      titleTxt: '크림 파스타',
      subTxt: '부드럽고 진한 크림 소스에 면을 버무려 풍미를 더한 이탈리아식 요리',
      calories: 950, // 크림 파스타 칼로리
    ),
    HotelListData(
      imagePath: 'assets/hotel/food (3).jpg',
      titleTxt: '채소 전골',
      subTxt: '다양한 신선한 채소와 육수를 넣고 끓여내는 한국식 전골 요리로, 따뜻하고 담백한 맛이 특징',
      calories: 400, // 채소 전골 칼로리
    ),
    HotelListData(
      imagePath: 'assets/hotel/food (4).jpg',
      titleTxt: '비지 찌개',
      subTxt: '콩을 갈아 만든 비지에 돼지고기와 김치, 채소 등을 넣고 끓인 한국 전통 찌개로, 고소하고 담백한 맛이 특징',
      calories: 350, // 비지 찌개 칼로리
    ),
    HotelListData(
      imagePath: 'assets/hotel/food (5).jpg',
      titleTxt: '비빔밥',
      subTxt: '밥 위에 다양한 나물, 고기, 고추장 등을 올려 섞어 먹는 한국의 대표적인 혼합 요리로, 신선한 재료의 조화로운 맛이 특징',
      calories: 700, // 비빔밥 칼로리
    ),
  ];
}
