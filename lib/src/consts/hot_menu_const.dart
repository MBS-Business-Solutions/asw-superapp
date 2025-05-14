// link จะโหลดใหม่ทุกครั้งที่เปิดแอปใหม่

const mHotMenuConfig = {
  'project': {
    'titleText_en': 'Project',
    'titleText_th': 'โครงการ',
    'iconAsset': 'assets/icons/Projects.svg',
    'link': '/projects',
    'mandatory': true,
  },
  'promotion': {
    'titleText_en': 'Promotion',
    'titleText_th': 'โปรโมชั่น',
    'iconAsset': 'assets/icons/Campaign.svg',
    'link': '/promotions',
    'mandatory': false,
  },
  'favorite': {
    'titleText_en': 'Favorite',
    'titleText_th': 'ชื่นชอบ',
    'iconAsset': 'assets/icons/Fav.svg',
    'link': '/favourites',
    'mandatory': false,
  }
};

const mDefaultMenuConfig = [
  'project',
  'promotion',
  'favorite',
];
